import { spawn } from 'node:child_process';
import { getIOInstance, isWebSocketActive } from '../config/socketConfig.js';

const users = new Map(); // To store user-specific Python processes and state

// Function to handle a user's frame processing
const processFrame = (socketId, frameData) => {
  const user = users.get(socketId);
  if (!user || user.frameProcessing) {
    console.log(`Socket ${socketId}: Ignoring frame, already in process.`);
    return; // Ignore if user not found or frame is already in process
  }

  if (user.pythonProcess.killed || user.pythonProcess.exitCode !== null) {
    console.log(`Socket ${socketId}: Python process already killed or exited, cannot process frame.`);
    return;
  }

  console.log(`Socket ${socketId}: Processing frame...`);
  user.frameProcessing = true; // Set processing flag

  try {
    user.pythonProcess.stdin.write(`${frameData}\n`, (err) => {
      if (err) {
        console.error(`Socket ${socketId}: Error writing to Python process: ${err.message}`);
        cleanupUser(socketId); // Cleanup if there's an error writing to Python
        return;
      }
    });
  } catch (error) {
    console.error(`Socket ${socketId}: Error during frame processing: ${error.message}`);
    cleanupUser(socketId);
    return;
  }

  user.pythonProcess.stdout.once('data', (data) => {
    console.log(`Socket ${socketId}: Received data from Python process.`);
    try {
      const jsonResponse = JSON.parse(data.toString().trim());
      const io = getIOInstance();
      if (isWebSocketActive() && io) {
        io.to(socketId).emit('result', jsonResponse); // Send result back to the specific user
        console.log(`Socket ${socketId}: Sent result back to client.`);
      }
    } catch (error) {
      console.error(`Socket ${socketId}: Error parsing Python output:`, error);
    }

    user.frameProcessing = false; // Reset processing flag

    // Process the latest frame if one arrived during processing
    if (user.latestFrame) {
      const latestFrame = user.latestFrame;
      user.latestFrame = null; // Clear the latest frame after processing
      console.log(`Socket ${socketId}: Processing the latest frame.`);
      processFrame(socketId, latestFrame);
    } else {
      console.log(`Socket ${socketId}: No more frames to process.`);
    }
  });
};

// Function to handle client disconnection
const cleanupUser = (socketId) => {
  const user = users.get(socketId);
  if (user) {
    console.log(`Socket ${socketId}: Cleaning up user, terminating Python process.`);
    user.pythonProcess.kill(); // Terminate the Python process
    users.delete(socketId); // Remove the user from the map
  } else {
    console.log(`Socket ${socketId}: User not found during cleanup.`);
  }
};

export const startWebSocket = (req, res) => {
  const io = getIOInstance(req.app.get('server'));

  io.on('connection', (socket) => {
    console.log(`Client connected: ${socket.id}`);

    // Spawn a new Python process for each user
    const pythonProcess = spawn('python', ['./gesture_recognition.py']);
    users.set(socket.id, {
      pythonProcess,
      frameProcessing: false,
      latestFrame: null, // Store the most recent frame while processing
    });

    console.log(`Socket ${socket.id}: Python process started.`);

    // Log stderr from Python process
    pythonProcess.stderr.on('data', (data) => {
      console.error(`Python stderr [${socket.id}]: ${data.toString()}`);
    });

    // Handle Python process exit
    pythonProcess.on('exit', (code, signal) => {
      console.log(`Python process for socket ${socket.id} exited with code ${code} and signal ${signal}`);
      cleanupUser(socket.id); // Clean up the user resources when the Python process exits
    });

    pythonProcess.on('error', (err) => {
      console.error(`Python process for socket ${socket.id} encountered an error:`, err);
      cleanupUser(socket.id); // Ensure cleanup happens if an error occurs in the Python process
    });

    socket.on('videoFrame', (frameData) => {
      const user = users.get(socket.id);
      if (!user) return;

      if (user.frameProcessing) {
        // Discard any older frames and keep only the most recent one
        console.log(`Socket ${socket.id}: Frame received, replacing previous unprocessed frame.`);
        user.latestFrame = frameData;
      } else {
        // Process the frame immediately if not processing
        console.log(`Socket ${socket.id}: Frame received, starting immediate processing.`);
        processFrame(socket.id, frameData);
      }
    });

    socket.on('disconnect', () => {
      console.log(`Client disconnected: ${socket.id}`);
      cleanupUser(socket.id); // Clean up resources when a user disconnects
    });
  });

  res.send('WebSocket connection is now active.');
};

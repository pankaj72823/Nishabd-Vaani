import { spawn } from 'node:child_process';
import { getIOInstance, isWebSocketActive } from '../config/socketConfig.js';

const users = new Map(); // To store user-specific frame queues and Python processes

// Function to handle a user's frame queue processing
const processFrameQueue = (socketId) => {
  const user = users.get(socketId);
  if (!user || user.frameQueue.length === 0 || user.frameProcessing) {
    return;
  }

  user.frameProcessing = true;
  const frameData = user.frameQueue.shift(); // Get the next frame from the queue
  user.pythonProcess.stdin.write(`${frameData}\n`);

  user.pythonProcess.stdout.once('data', (data) => {
    try {
      const jsonResponse = JSON.parse(data.toString().trim());
      const io = getIOInstance();
      if (isWebSocketActive() && io) {
        io.to(socketId).emit('result', jsonResponse); // Send result back to the specific user
      }
    } catch (error) {
      console.error('Error parsing Python output:', error);
    }

    user.frameProcessing = false;
    processFrameQueue(socketId); // Continue processing if more frames are queued
  });
};

// Function to handle client disconnection
const cleanupUser = (socketId) => {
  const user = users.get(socketId);
  if (user) {
    user.pythonProcess.kill(); // Terminate the Python process
    users.delete(socketId); // Remove the user from the map
  }
};

export const startWebSocket = (req, res) => {
  const io = getIOInstance(req.app.get('server'));

  io.on('connection', (socket) => {
    console.log('Client connected:', socket.id);

    // Spawn a new Python process for each user
    const pythonProcess = spawn('python', ['./gesture_recognition.py']);
    users.set(socket.id, {
      pythonProcess,
      frameQueue: [],
      frameProcessing: false,
    });

    socket.on('videoFrame', (frameData) => {
      const user = users.get(socket.id);
      if (!user) return;

      user.frameQueue.push(frameData); // Add the frame to the queue
      processFrameQueue(socket.id); // Start processing if not already
    });

    socket.on('disconnect', () => {
      console.log('Client disconnected:', socket.id);
      cleanupUser(socket.id); // Clean up resources when a user disconnects
    });
  });

  res.send('WebSocket connection is now active.');
};

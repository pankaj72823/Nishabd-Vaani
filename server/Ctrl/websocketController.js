import { spawn } from 'node:child_process';
import fs from 'fs';
import path from 'path';
import { getIOInstance, isWebSocketActive } from '../config/socketConfig.js';

const __dirname = import.meta.dirname;
const filePath = path.join(__dirname, './temp_image.jpeg');

let pythonOutputBuffer = '';
let frameProcessing = false;

// Spawn the persistent Python process
const pythonProcess = spawn('python', ['./gesture_recognition.py']);

pythonProcess.stdout.on('data', (data) => {
  pythonOutputBuffer += data.toString();

  try {
    const jsonResponse = JSON.parse(pythonOutputBuffer.trim());
    const io = getIOInstance();
    if (isWebSocketActive() && io) {
      io.emit('result', jsonResponse);
    }
    pythonOutputBuffer = ''; // Clear the buffer for the next message
    frameProcessing = false; // Reset the flag, allowing new frames to be processed
  } catch (error) {
    // If parsing fails, keep accumulating data until a full JSON string is received
  }
});

pythonProcess.stderr.on('data', (data) => {
  console.error(`Python script error: ${data}`);
});

export const startWebSocket = (req, res) => {
  if (isWebSocketActive()) {
    res.status(400).send('WebSocket is already active.');
    return;
  }

  const io = getIOInstance(req.app.get('server'));

  io.on('connection', (socket) => {
    console.log('Client connected');

    socket.on('videoFrame', (frameData) => {
      console.log('Received frame data');

      if (frameProcessing) {
        console.log('Frame processing in progress. Discarding new frame.');
        return;
      }

      const base64Data = frameData.replace(/^data:image\/jpeg;base64,/, "");
      fs.writeFileSync(filePath, base64Data, 'base64');

      frameProcessing = true;
      pythonProcess.stdin.write('true\n');
    });

    socket.on('disconnect', () => {
      console.log('Client disconnected');
    });
  });

  res.send('WebSocket connection is now active.');
};

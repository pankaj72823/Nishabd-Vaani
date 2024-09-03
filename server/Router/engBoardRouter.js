import { Router } from 'express';
import { spawn } from 'child_process';

const router = Router();

let pythonOutputBuffer = '';
let frameProcessing = false;

// Spawn the Python process once
const process = spawn('python', ['./guj_board_model.py']);

process.stdout.on('data', (data) => {
    pythonOutputBuffer += data.toString();
    try {
        // Attempt to parse the accumulated buffer as JSON
        const jsonResponse = JSON.parse(pythonOutputBuffer.trim());
        router.response.json({ prediction: jsonResponse.replace(/"/g, '').trim() });
        pythonOutputBuffer = ''; // Clear the buffer for the next message
        frameProcessing = false; // Reset the flag, allowing new frames to be processed
    } catch (error) {
        // If parsing fails, keep accumulating data until a full JSON string is received
    }
});

process.stderr.on('data', (data) => {
    console.error(`Python script error: ${data}`);
});

router.post('/', (req, res) => {
    if (frameProcessing) {
        return res.status(429).json({ error: 'Frame is already being processed' });
    }

    const { pixels } = req.body;

    if (!pixels) {
        return res.status(400).json({ error: 'Pixels data is required' });
    }

    frameProcessing = true;
    router.response = res; // Store the response object for use in the callback
    process.stdin.write(pixels + '\n'); // Ensure the input ends with a newline
});

export default router;

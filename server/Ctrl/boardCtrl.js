import { spawn } from 'node:child_process';
import path from 'path';

// Define the function to predict the alphabet using a Python script
async function predictAlphabet(pixels) {
    return new Promise((resolve, reject) => {


        // Spawn a child process to run the Python script
        const pythonProcess = spawn('python', ['./board_Model.py']);

        // Prepare the input data as a JSON string
        const inputData = JSON.stringify({ pixels });
        console.log(inputData)
        // Send input data to the Python process
        pythonProcess.stdin.write(inputData);
        pythonProcess.stdin.end();

        // Collect the output from the Python script
        let outputData = '';
        pythonProcess.stdout.on('data', (data) => {
            outputData += data.toString();
        });

        // Handle any errors
        pythonProcess.stderr.on('data', (data) => {
            console.error(`Python script error: ${data}`);
            reject(`Error: ${data.toString()}`);
        });

        // Resolve the promise with the JSON output
        pythonProcess.stdout.on('end', () => {
            try {
                const result = JSON.parse(outputData);
                resolve(result);
            } catch (error) {
                reject(`Failed to parse JSON: ${error.message}`);
            }
        });

        // Handle the process exit event
        pythonProcess.on('exit', (code) => {
            if (code !== 0) {
                reject(`Python script exited with code ${code}`);
            }
        });
    });
}

// Define the route for alphabet prediction
export const boardCtrl = async (req, res) => {
    try {
        // Extract pixels from the request body
        const { pixels } = req.body;

        if (!pixels) {
            return res.status(400).json({ error: 'Pixels data is required' });
        }
        
        // Call the predictAlphabet function and wait for the result
        const result = await predictAlphabet(pixels);

        // Send the prediction result as a JSON response
        res.json(result);
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: 'Failed to predict the alphabet' });
    }
};

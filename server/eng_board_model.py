import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # Suppress all messages (INFO, WARNING, ERROR)
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'  # Disable oneDNN optimizations
import warnings
warnings.filterwarnings('ignore')

import os
import numpy as np
import tensorflow as tf
from bidict import bidict
import json
import sys

# Load gesture names from CSV file
script_dir = os.path.dirname(__file__)
model_path = os.path.join(script_dir, 'model_english.tflite')

ENCODER = bidict({
    'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6,
    'G': 7, 'H': 8, 'I': 9, 'J': 10, 'K': 11, 'L': 12,
    'M': 13, 'N': 14, 'O': 15, 'P': 16, 'Q': 17, 'R': 18,
    'S': 19, 'T': 20, 'U': 21, 'V': 22, 'W': 23, 'X': 24,
    'Y': 25, 'Z': 26
})

def predict_alphabet(pixels):
    img = np.array(pixels.split(',')).astype(np.float32).reshape(1, 50, 50, 1)

    interpreter = tf.lite.Interpreter(model_path)
    interpreter.allocate_tensors()

    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    interpreter.set_tensor(input_details[0]['index'], img)
    interpreter.invoke()

    output_data = interpreter.get_tensor(output_details[0]['index'])
    pred_letter = np.argmax(output_data, axis=-1)
    return ENCODER.inverse[pred_letter[0]]

if __name__ == '__main__':
    while True:
        try:
            # Read input from stdin
            pixels = input()
            # Predict and output result
            prediction = predict_alphabet(pixels)
            print(json.dumps(prediction))
        except EOFError:
            break

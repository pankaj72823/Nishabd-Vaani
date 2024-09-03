import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # Suppress all messages (INFO, WARNING, ERROR)
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'  # Disable oneDNN optimizations
import warnings
warnings.filterwarnings('ignore')
import numpy as np
import tensorflow as tf
from bidict import bidict
import json
import sys


# Load gesture names from CSV file
script_dir = os.path.dirname(__file__)
model_path = os.path.join(script_dir, 'model_gujarati.tflite')
ENCODER = bidict({
    'અ': 1, 'આ': 2, 'ઇ': 3, 'ઈ': 4, 'ઉ': 5, 'ઊ': 6,
    'ઋ': 7, 'એ': 8, 'ઐ': 9, 'ઓ': 10, 'ઔ': 11, 'ક': 12,
    'ખ': 13, 'ગ': 14, 'ઘ': 15, 'ઙ': 16, 'ચ': 17, 'છ': 18,
    'જ': 19, 'ઝ': 20, 'ઞ': 21, 'ટ': 22, 'ઠ': 23, 'ડ': 24,
    'ઢ': 25, 'ણ': 26, 'ત': 27, 'થ': 28, 'દ': 29, 'ધ': 30,
    'ન': 31, 'પ': 32, 'ફ': 33, 'બ': 34, 'ભ': 35, 'મ': 36,
    'ય': 37, 'ર': 38, 'લ': 39, 'વ': 40, 'શ': 41, 'ષ': 42,
    'સ': 43, 'હ': 44, 'ળ': 45, 'ક્ષ': 46, 'જ્ઞ': 47
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

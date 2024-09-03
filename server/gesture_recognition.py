import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # Suppress all messages (INFO, WARNING, ERROR)
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'  # Disable oneDNN optimizations
import warnings
import logging
warnings.filterwarnings('ignore')
logging.getLogger('tensorflow').setLevel(logging.ERROR)
import sys
import json
import cv2 as cv
import numpy as np
import mediapipe as mp
import pandas as pd
from model.keypoint_classifier import KeyPointClassifier
from collections import deque
import copy
import itertools

# Load gesture names from CSV file
script_dir = os.path.dirname(__file__)
gesture_names_path = os.path.join(script_dir, 'model/keypoint_classifier_label.csv')
gesture_names_df = pd.read_csv(gesture_names_path, header=None)
gesture_names = {i: name for i, name in enumerate(gesture_names_df[0])}

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=True, max_num_hands=2, min_detection_confidence=0.7, min_tracking_confidence=0.5)
keypoint_classifier = KeyPointClassifier()

history_length = 16
point_history = deque(maxlen=history_length)

def predict(image_bytes):
    try:
        nparr = np.frombuffer(image_bytes, np.uint8)
        img = cv.imdecode(nparr, cv.IMREAD_COLOR)

        if img is None:
            return {'error': 'Failed to decode image. Ensure the image data is valid and properly formatted.'}

        image = cv.cvtColor(img, cv.COLOR_BGR2RGB)
        results = hands.process(image)

        response = {'gesture_name': "No gesture detected"}
        if results.multi_hand_landmarks is not None:
            for hand_landmarks in results.multi_hand_landmarks:
                landmark_list = calc_landmark_list(img, hand_landmarks)
                pre_processed_landmark_list = pre_process_landmark(landmark_list)

                hand_sign_id = keypoint_classifier(pre_processed_landmark_list)
                response['gesture_name'] = gesture_names.get(hand_sign_id, "Unknown Gesture")

        return response
    except Exception as e:
        return {'error': str(e)}

def calc_landmark_list(image, landmarks):
    image_width, image_height = image.shape[1], image.shape[0]
    landmark_point = []
    for _, landmark in enumerate(landmarks.landmark):
        landmark_x = min(int(landmark.x * image_width), image_width - 1)
        landmark_y = min(int(landmark.y * image_height), image_height - 1)
        landmark_point.append([landmark_x, landmark_y])
    return landmark_point

def pre_process_landmark(landmark_list):
    temp_landmark_list = copy.deepcopy(landmark_list)
    base_x, base_y = 0, 0
    for index, landmark_point in enumerate(temp_landmark_list):
        if index == 0:
            base_x, base_y = landmark_point[0], landmark_point[1]
        temp_landmark_list[index][0] = temp_landmark_list[index][0] - base_x
        temp_landmark_list[index][1] = temp_landmark_list[index][1] - base_y

    temp_landmark_list = list(itertools.chain.from_iterable(temp_landmark_list))
    max_value = max(list(map(abs, temp_landmark_list)))

    def normalize_(n):
        return n / max_value

    temp_landmark_list = list(map(normalize_, temp_landmark_list))
    return temp_landmark_list

def image_to_bytes(image_path):
    with open(image_path, 'rb') as image_file:
        image_bytes = image_file.read()
    return image_bytes

if __name__ == "__main__":
    # Fixed image path
    fixed_image_path = os.path.join(script_dir, './Ctrl/temp_image.jpeg')

    while True:
        # Listen for input from the Express route
        signal = sys.stdin.readline().strip()

        # If the input signal is 'true', process the image
        if signal.lower() == 'true':
            try:
                # Convert the image to byte code
                image_bytes = image_to_bytes(fixed_image_path)

                # Call the predict function with the image bytes
                output = predict(image_bytes)

                # Send the output back to the Express route
                print(json.dumps(output))
                sys.stdout.flush()

            except Exception as e:
                # Handle any potential errors
                print(json.dumps({'error': str(e)}))
                sys.stdout.flush()
        else:
            # Optional: Handle cases where the signal is not 'true'
            print(json.dumps({'error': 'Invalid signal received'}))
            sys.stdout.flush()


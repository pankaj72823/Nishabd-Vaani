import os
import csv
import cv2 as cv
import numpy as np
import mediapipe as mp
from collections import deque
import copy
import itertools
from model_twohand import KeyPointClassifier as TwoHandClassifier
from model_onehand import KeyPointClassifier as OneHandClassifier

# Set up MediaPipe Hands
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=False, max_num_hands=2, min_detection_confidence=0.7, min_tracking_confidence=0.5)

# Load models
two_hand_classifier = TwoHandClassifier()
one_hand_classifier = OneHandClassifier()

# Load gesture names from label.csv
def load_gesture_labels(csv_path):
    gesture_labels = []
    with open(csv_path, mode='r') as file:
        reader = csv.reader(file)
        for row in reader:
            gesture_labels.append(row[0])  # Directly append the label name
    return gesture_labels


gesture_names_onehand = load_gesture_labels(r'model_onehand\keypoint_classifier\keypoint_classifier_label.csv')
gesture_names_twohand = load_gesture_labels(r'model_twohand\keypoint_classifier\keypoint_classifier_label.csv')

# Helper functions for processing landmarks
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
    base_x, base_y = temp_landmark_list[0][0], temp_landmark_list[0][1]
    for index, point in enumerate(temp_landmark_list):
        temp_landmark_list[index][0] -= base_x
        temp_landmark_list[index][1] -= base_y
    temp_landmark_list = list(itertools.chain.from_iterable(temp_landmark_list))
    max_value = max(list(map(abs, temp_landmark_list))) or 1
    return [x / max_value for x in temp_landmark_list]

# Main function to detect hands and run the appropriate model
def main():
    cap = cv.VideoCapture(0)  # Use webcam as input
    while cap.isOpened():
        success, image = cap.read()
        if not success:
            break

        image = cv.flip(image, 1)
        image_rgb = cv.cvtColor(image, cv.COLOR_BGR2RGB)
        results = hands.process(image_rgb)

        if results.multi_hand_landmarks:
            hand_landmarks_list = results.multi_hand_landmarks
            num_hands = len(hand_landmarks_list)

            if num_hands == 1:
                # Process with one-hand model
                for hand_landmarks in hand_landmarks_list:
                    landmarks = calc_landmark_list(image, hand_landmarks)
                    processed_landmarks = pre_process_landmark(landmarks)
                    hand_sign_id = one_hand_classifier(processed_landmarks)
                    if 0 <= hand_sign_id < len(gesture_names_onehand):
                        gesture_name = gesture_names_onehand[hand_sign_id]
                    else:
                        gesture_name = "Unknown Gesture"

                    
                    print(f"One Hand Gesture: {gesture_name}")
            elif num_hands == 2:
                # Process with two-hand model
                landmark_list = []
                for hand_landmarks in hand_landmarks_list:
                    landmarks = calc_landmark_list(image, hand_landmarks)
                    processed_landmarks = pre_process_landmark(landmarks)
                    landmark_list.append(processed_landmarks)

                if len(landmark_list) == 2:
                    combined_landmarks = np.concatenate(landmark_list).flatten()
                    hand_sign_id = two_hand_classifier(combined_landmarks)
                    if 0 <= hand_sign_id < len(gesture_names_twohand):
                        gesture_name = gesture_names_twohand[hand_sign_id]
                    else:
                        gesture_name = "Unknown Gesture"

                    print(f"Two Hand Gesture: {gesture_name}")

        cv.imshow('Hand Gesture Recognition', image)

        if cv.waitKey(10) & 0xFF == 27:  # ESC to exit
            break

    cap.release()
    cv.destroyAllWindows()

if __name__ == "__main__":
    main()

import cv2
import mediapipe as mp
import numpy as np

# Initialize MediaPipe hands module
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=2,  # Set to 2 to detect both hands
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5,
)

# Initialize MediaPipe drawing module for visualization
mp_drawing = mp.solutions.drawing_utils

# Open the camera
cap = cv2.VideoCapture(0)

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    # Convert the image to RGB
    image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    # Perform hand detection
    results = hands.process(image)

    # Convert the image color back to BGR
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

    if results.multi_hand_landmarks:
        # Initialize list to hold landmark positions
        hand_landmarks_list = []

        # Iterate over detected hands
        for hand_landmarks in results.multi_hand_landmarks:
            # Append hand landmarks to the list
            hand_landmarks_list.append(hand_landmarks)

            # Draw landmarks on the frame
            mp_drawing.draw_landmarks(image, hand_landmarks, mp_hands.HAND_CONNECTIONS)

        # Check if two hands are detected
        if len(hand_landmarks_list) == 2:
            # Step 2: Calculate Distance between two specific landmarks
            # Extract wrist landmarks (index 0 in landmarks)
            hand1_wrist = hand_landmarks_list[0].landmark[0]
            hand2_wrist = hand_landmarks_list[1].landmark[0]

            # Get image dimensions
            image_height, image_width, _ = image.shape

            # Convert landmark positions to pixel coordinates
            hand1_wrist_pixel = (int(hand1_wrist.x * image_width), int(hand1_wrist.y * image_height))
            hand2_wrist_pixel = (int(hand2_wrist.x * image_width), int(hand2_wrist.y * image_height))

            # Step 3: Calculate Euclidean Distance
            distance = np.linalg.norm(np.array(hand1_wrist_pixel) - np.array(hand2_wrist_pixel))

            # Display the distance on the image
            cv2.putText(image, f"Distance: {int(distance)}", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

    # Display the resulting frame
    cv2.imshow('MediaPipe Hands', image)

    # Exit loop on 'q' key press
    if cv2.waitKey(5) & 0xFF == ord('q'):
        break

# Release resources
cap.release()
cv2.destroyAllWindows()

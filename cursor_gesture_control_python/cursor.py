import cv2                              #for webcam
import mediapipe as mp                  #for hand detection
import pyautogui                        #for cursor follower

cap = cv2.VideoCapture(0)                                   #set webcam
hand_detector = mp.solutions.hands.Hands()                  #mediapipe hand detector
drawing_utils = mp.solutions.drawing_utils
screen_width, screen_height = pyautogui.size()              #get the monitor screen size

index_y = 0

print("cursor program running")

while True:
    _, frame = cap.read()                                   #get the frame by frame from webcam
    frame = cv2.flip(frame,1)                               #no mirroring webcam
    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    frame_height, frame_width, _ = frame.shape

    output = hand_detector.process(rgb_frame)
    hands = output.multi_hand_landmarks
    
    if hands:
        for hand in hands:
            drawing_utils.draw_landmarks(frame, hand)
            landmarks = hand.landmark
            for id, landmarks in enumerate(landmarks):
                x=int(landmarks.x*frame_width)
                y=int(landmarks.y*frame_height)
                # print(x,y)
                if id==8:                                                                       #draw circle on index finger
                    cv2.circle(img=frame, center=(x,y), radius=10, color=(0, 255, 255))
                    index_x = screen_width/frame_width*x                                #resizing the scale of webcam to scale of real screen monitor
                    index_y = screen_height/frame_height*y
                    pyautogui.moveTo(index_x,index_y)
                if id==4:                                                                       #draw circle on index finger
                    cv2.circle(img=frame, center=(x,y), radius=10, color=(0, 255, 255))
                    thumb_x = screen_width/frame_width*x                                #resizing the scale of webcam to scale of real screen monitor
                    thumb_y = screen_height/frame_height*y 
                    print('left button',abs(index_y-thumb_y))                              #check condition when cursor is left clicked
                    if abs(index_y-thumb_y)<75:
                        print("left click")
                        pyautogui.click(button='left')
                        pyautogui.sleep(1)
                # if id==12:                                                                       #draw circle on middle finger
                #     cv2.circle(img=frame, center=(x,y), radius=10, color=(0, 255, 255))
                #     middle_x = screen_width/frame_width*x                                #resizing the scale of webcam to scale of real screen monitor
                #     middle_y = screen_height/frame_height*y 
                #     print('right button',abs(middle_y-index_y))                              #check condition when cursor is right clicked
                #     if abs(middle_y-index_y)<45:
                #         print("right click")
                #         pyautogui.click(button='right')
                #         pyautogui.sleep(1)

    cv2.imshow("Virtual Mouse (Press 'a' to exit)", frame)
    
    if cv2.waitKey(1)==ord('a'):                            #to exit from the program loop press 'a'
        break
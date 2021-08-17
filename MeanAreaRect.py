#from picamera.array import PiRGBArray
#from picamera import PiCamera
import time
import cv2
import numpy as np
'''
camera = PiCamera()
camera.resolution = (640, 360)
camera.rotation = 180
rawCapture = PiRGBArray(camera, size=(640, 360))
time.sleep(0.1)
'''
camera = cv2.VideoCapture(0) #카메라 생성

if not camera.isOpened(): #카메라 생성 확인
    print ('Can\'t open the CAM(0)')
    exit()


#for frame in camera.capture_continuous(frame, format="bgr", use_video_port=True):
while True:
    #ret, image = camera.read()
    image = cv2.imread("/Users/leejinwoo/Desktop/0002.jpg", cv2.IMREAD_ANYCOLOR)
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

    YellowLine = cv2.inRange(hsv, (20, 100, 100), (30, 255, 255))
    kernel = np.ones((3, 3), np.uint8)
    YellowLine = cv2.erode(YellowLine, kernel, iterations=5)
    YellowLine = cv2.dilate(YellowLine, kernel, iterations=9)
    contours_blk, hierarchy_blk = cv2.findContours(YellowLine.copy(), cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    if len(contours_blk) > 0:
        yellowbox = cv2.minAreaRect(contours_blk[0])
        (x_min, y_min), (w_min, h_min), ang = yellowbox
        if ang < -45:
            ang = 90 + ang
        if w_min < h_min and ang > 0:
            ang = (90 - ang) * -1
        if w_min > h_min and ang < 0:
            ang = 90 + ang
        setpoint = 320
        error = int(x_min - setpoint)
        ang = int(ang)
        box = cv2.boxPoints(yellowbox)
        box = np.int0(box)
        cv2.drawContours(image, [box], 0, (0, 0, 255), 3)
        cv2.putText(image, str(ang), (10, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
        cv2.putText(image, str(error), (10, 320), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 0), 2)
        cv2.line(image, (int(x_min), 200), (int(x_min), 250), (255, 0, 0), 3)

    cv2.imshow("orginal with line", image)

    key = cv2.waitKey(1) & 0xFF
    if key == ord("q"):
        break
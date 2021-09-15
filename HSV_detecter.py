import cv2
import numpy as np
import os


W_View_size = 640
H_View_size = 480
FPS = 90  # PI CAMERA: 320 x 240 = MAX 90


def onChange(x):
    pass

def setting_bar():
    cv2.namedWindow('HSV')

    cv2.createTrackbar('H_MAX', 'HSV', 0, 255, onChange)
    cv2.createTrackbar('H_MIN', 'HSV', 0, 255, onChange)
    cv2.createTrackbar('S_MAX', 'HSV', 0, 255, onChange)
    cv2.createTrackbar('S_MIN', 'HSV', 0, 255, onChange)
    cv2.createTrackbar('V_MAX', 'HSV', 0, 255, onChange)
    cv2.createTrackbar('V_MIN', 'HSV', 0, 255, onChange)
    cv2.setTrackbarPos('H_MAX', 'HSV', 255)
    cv2.setTrackbarPos('H_MIN', 'HSV', 0)
    cv2.setTrackbarPos('S_MAX', 'HSV', 255)
    cv2.setTrackbarPos('S_MIN', 'HSV', 0)
    cv2.setTrackbarPos('V_MAX', 'HSV', 255)
    cv2.setTrackbarPos('V_MIN', 'HSV', 0)

if __name__ == '__main__':

    setting_bar()

    try:
        cap = cv2.VideoCapture(0)  # 카메라 켜기  # 카메라 캡쳐 (사진만 가져옴)

        cap.set(3, W_View_size)
        cap.set(4, H_View_size)
        cap.set(5, FPS)

    except:
        print('cannot load camera!')

    while True:
        ret, frame = cap.read()  # 무한루프를 돌려서 사진을 동영상으로 변경   # ret은 true/false

        blur = cv2.GaussianBlur(frame, (3, 3), 0)

        if ret:  # 사진 가져오는것을 성공할 경우
            #cv2.imshow('Original', frame)

            H_MAX = cv2.getTrackbarPos('H_MAX', 'HSV')
            H_MIN = cv2.getTrackbarPos('H_MIN', 'HSV')
            S_MAX = cv2.getTrackbarPos('S_MAX', 'HSV')
            S_MIN = cv2.getTrackbarPos('S_MIN', 'HSV')
            V_MAX = cv2.getTrackbarPos('V_MAX', 'HSV')
            V_MIN = cv2.getTrackbarPos('V_MIN', 'HSV')

            lower = np.array([H_MIN, S_MIN, V_MIN])
            higher = np.array([H_MAX, S_MAX, V_MAX])

            hsv = cv2.cvtColor(blur, cv2.COLOR_BGR2HSV)
            Gmask = cv2.inRange(hsv, lower, higher)

            G = cv2.bitwise_and(frame, frame, mask=Gmask)

            cv2.imshow('frame', frame)
            cv2.imshow('hsv', G)

        else:
            print('cannot load camera!')
            break

        k = cv2.waitKey(25)
        if k == 27:
            break

    cap.release()
    cv2.destroyAllWindows()




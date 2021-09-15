import cv2
import numpy as np
import os


W_View_size = 640
H_View_size = 480
FPS = 90  # PI CAMERA: 320 x 240 = MAX 90



def onChange(x):
    pass

def setting_bar():
    cv2.namedWindow('YCrCb')

    cv2.createTrackbar('Y_MAX', 'YCrCb', 0, 255, onChange)
    cv2.createTrackbar('Y_MIN', 'YCrCb', 0, 255, onChange)
    cv2.createTrackbar('Cr_MAX', 'YCrCb', 0, 255, onChange)
    cv2.createTrackbar('Cr_MIN', 'YCrCb', 0, 255, onChange)
    cv2.createTrackbar('Cb_MAX', 'YCrCb', 0, 255, onChange)
    cv2.createTrackbar('Cb_MIN', 'YCrCb', 0, 255, onChange)
    cv2.setTrackbarPos('Y_MAX', 'YCrCb', 255)
    cv2.setTrackbarPos('Y_MIN', 'YCrCb', 0)
    cv2.setTrackbarPos('Cr_MAX', 'YCrCb', 255)
    cv2.setTrackbarPos('Cr_MIN', 'YCrCb', 0)
    cv2.setTrackbarPos('Cb_MAX', 'YCrCb', 255)
    cv2.setTrackbarPos('Cb_MIN', 'YCrCb', 0)

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
            # #cv2.imshow('Original', frame)

            Y_MAX = cv2.getTrackbarPos('Y_MAX', 'YCrCb')
            Y_MIN = cv2.getTrackbarPos('Y_MIN', 'YCrCb')
            Cr_MAX = cv2.getTrackbarPos('Cr_MAX', 'YCrCb')
            Cr_MIN = cv2.getTrackbarPos('Cr_MIN', 'YCrCb')
            Cb_MAX = cv2.getTrackbarPos('Cb_MAX', 'YCrCb')
            Cb_MIN = cv2.getTrackbarPos('Cb_MIN', 'YCrCb')

            lower = np.array([Y_MIN, Cr_MIN, Cb_MIN])
            higher = np.array([Y_MAX, Cr_MAX, Cb_MAX])

            YCrCb = cv2.cvtColor(blur, cv2.COLOR_BGR2YCR_CB)
            Gmask = cv2.inRange(YCrCb, lower, higher)

            G = cv2.bitwise_and(frame, frame, mask=Gmask)

            cv2.imshow('frame', frame)
            cv2.imshow('YCrCb', G)

        else:
            print('cannot load camera!')
            break

        k = cv2.waitKey(25)
        if k == 27:
            break

    cap.release()
    cv2.destroyAllWindows()






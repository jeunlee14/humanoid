
import cv2
import numpy as np
import os

lower_green = np.array([0, 0, 0])
upper_green = np.array([255, 91, 149])

lower_red = np.array([0, 156, 0])
upper_red = np.array([255, 255, 100])

lower_yellow = np.array([0, 0, 0])
upper_yellow = np.array([255, 255, 100])


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

    image = cv2.imread('D://shots_2021-10-06 161217.615331.png', cv2.IMREAD_COLOR)
    frame = cv2.GaussianBlur(image, (3, 3), 0)

    setting_bar()

    while True:
        Y_MAX = cv2.getTrackbarPos('Y_MAX', 'YCrCb')
        Y_MIN = cv2.getTrackbarPos('Y_MIN', 'YCrCb')
        Cr_MAX = cv2.getTrackbarPos('Cr_MAX', 'YCrCb')
        Cr_MIN = cv2.getTrackbarPos('Cr_MIN', 'YCrCb')
        Cb_MAX = cv2.getTrackbarPos('Cb_MAX', 'YCrCb')
        Cb_MIN = cv2.getTrackbarPos('Cb_MIN', 'YCrCb')

        lower = np.array([Y_MIN, Cr_MIN, Cb_MIN])
        higher = np.array([Y_MAX, Cr_MAX, Cb_MAX])

        YCrCb = cv2.cvtColor(frame, cv2.COLOR_BGR2YCR_CB)
        Gmask = cv2.inRange(YCrCb, lower, higher)

        G = cv2.bitwise_and(frame, frame, mask=Gmask)

        cv2.imshow('YCrCb', G)

        k = cv2.waitKey(1) & 0xFF
        if k == 27:
            break

import cv2
import numpy as np
import sys
import math
import timeit
import serial

serial_use = 1

serial_port = None
Read_RX = 0
receiving_exit = 1
threading_Time = 0.01

# YCbCr
lower_red = np.array([0, 0, 155])
upper_red = np.array([255, 255, 255])
# lower_blue = np.array([0, 0, 110])
# upper_blue = np.array([255, 255, 255])
lower_yellow = np.array([0, 133, 0])
upper_yellow = np.array([255, 255, 122])

# HSV
# lower_red = np.array([150, 50, 15])
# upper_red = np.array([180, 255, 255])
lower_blue = np.array([96, 90, 22])
upper_blue = np.array([255, 255, 255])
lower_green = np.array([50, 60, 30])
upper_green = np.array([80, 255, 255])


# lower_yellow = np.array([10, 100, 20])
# upper_yellow = np.array([30, 255, 255])

cMOTION_MILK_LOST = 0xC0
cMOTION_MILK_POSION_FRONT_BIG = 0xC1
cMOTION_MILK_POSION_FRONT_SMALL = 0xC2
cMOTION_MILK_POSION_LEFT = 0xC3
cMOTION_MILK_POSION_RIGHT = 0xC4
cMOTION_MILK_CATCH = 0xC5

# ----------------------------------------------------------------------------------------------------
def find_milk(blur, frame): # frame은 임시로 전달
    res = cMOTION_MILK_LOST
    hsv = cv2.cvtColor(blur, cv2.COLOR_BGR2HSV)  # BGR을 HSV모드로 전환
    # ycbcr = cv2.cvtColor(blur, cv2.COLOR_BGR2YCR_CB)  # BGR을 YCbCr모드로 전환

    # cv2.imshow('hsv', hsv)
    #res_alphacolor = 128 ############ 임시
    binary_milk = cv2.inRange(hsv, lower_blue, upper_blue)
    #binary_milk = cv2.inRange(ycbcr, lower_blue, upper_blue)

    # binary_milk = cv2.inRange(ycbcr, lower_red, upper_red)

    cv2.imshow('binary_milk', binary_milk)
    pixels = cv2.countNonZero(binary_milk)
    # print("pixels=", pixels)
    if pixels > 500:
        contours, hierarchy = cv2.findContours(binary_milk, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)  # 컨투어

        # 컨투어된 영역중에서 제일 큰 부분만 선택 (배경 제거)
        max_contour = None
        max_area = -1

        for contour in contours:
            area = cv2.contourArea(contour)
            if area > max_area:
                max_area = area
                max_contour = contour

        x, y, w, h = cv2.boundingRect(max_contour)
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 3)

        xpos = x + (w / 2)  # x좌표 중점
        ypos = y + (h / 2)

        print(" xpos = {}, ypos = {}".format(xpos, ypos))

        if xpos == 0:
            res = cMOTION_MILK_LOST
            print("우유곽 없음")

        elif xpos < 120:
            res = cMOTION_MILK_POSION_LEFT
            print('왼쪽으로 이동')

        elif xpos > 200:
            res = cMOTION_MILK_POSION_RIGHT
            print('오른쪽으로 이동')

        else:
            if ypos == 0:
                res = cMOTION_MILK_LOST
                print("우유곽 없음")

            elif ypos >= 170:
                res = cMOTION_MILK_CATCH
                print("우유곽 잡기")

            else:
                res = cMOTION_MILK_POSION_FRONT_SMALL
                print('앞쪽으로 이동')

    return res


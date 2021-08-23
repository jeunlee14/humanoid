# -*- coding: utf-8 -*-
import cv2
import numpy as np
import sys
import math
import timeit
import serial

import time
import capture

serial_use = 1

serial_port = None
Read_RX = 0
receiving_exit = 1
threading_Time = 0.01

lower_red = np.array([0, 155, 0])
upper_red = np.array([255, 255, 255])
lower_blue = np.array([0, 0, 152])
upper_blue = np.array([255, 255, 255])

lower_green = np.array([50, 60, 80])
upper_green = np.array([80, 255, 255])
lower_yellow = np.array([0, 80, 110])
upper_yellow = np.array([30, 255, 255])


# ------------------------------------------

# img_list=[]
# path = 'C:\\Users\\inwoo\\Desktop\\data3\\'
# target = 'C:\\Users\\inwoo\\Desktop\\data2\\'
# count = 1
# for i in os.listdir(path):
#     img_path = path + i
#     target_path = target + i
#     if(count%2==0):
#         shutil.move(img_path,target_path)
#
#     count+=1
#
#
# file_list = os.listdir(path)
# print(len(file_list))


# ------------------------------------------

def mode_abcd(binary_mask):
    abcd = 129

    k = cv2.getStructuringElement(cv2.MORPH_OPEN, (5, 5))

    opening = cv2.dilate(binary_mask, k)
    cv2.imshow('opening', opening)
    # ret1, _ = cv.threshold(blur, 100, 255, cv.THRESH_BINARY)
    contours, hierarchy = cv2.findContours(opening, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)  # 컨투어

    if len(contours) == 0:
        print("물체를 감지할 수 없습니다")
        return abcd

    print(len(contours))

    contr = contours[0]
    x, y, w, h = cv2.boundingRect(contr)
    cv2.rectangle(binary_mask, (x, y), (x + w, y + h), (0, 255, 0), 3)
    frame2 = binary_mask[y:y + h, x:x + w]
    #
    # cv.drawContours(resize_img, contours, -1, (0, 255, 0), 4)

    blue_area = cv2.contourArea(contr, False)
    total_size = frame2.size
    per = blue_area / total_size
    print(per)
    print(len(contours))
    if len(contours) == 1:
        abcd = 112
        print('c')  # a 2 b 3 c1 d2
    elif len(contours) == 2:
        if (per > 0.7):
            abcd = 1110823
            print('d')
        else:
            abcd = 113
            print('a')
    else:
        abcd = 114
        print('b')

    cv2.drawContours(opening, contours, -1, (0, 255, 0), 3)
    cv2.imshow('opening', opening)

    return abcd  # D B          A C


def mode_area_color(mask_green):
    areaColor = 129

    pixels = cv2.countNonZero(mask_green)

    if pixels > 10000:
        areaColor = 130  # 초록
        print('green')
    else:
        areaColor = 128  # 검정
        print('black')

    print("영역색상 :", areaColor)
    return areaColor


def mode_milk_save(binary_area):
    save = 129

    pixels_area = cv2.countNonZero(binary_area)

    if pixels_area > 1000:
        test_frame = binary_area[241:480, :]
        pixels = cv2.countNonZero(test_frame)
        cv2.imshow("milk", test_frame)

        if pixels > 69120:  # =240*640*0.45
            save = 130
            print('성공')

        else:
            save = 128
            print('실패')

    print("안전구역우유결과 :", save)
    return save


# ---------------------------------------

def mode_milk_escape(binary_area):
    escape = 129

    pixels_area = cv2.countNonZero(binary_area)

    if pixels_area > 1000:
        test_frame = binary_area[0:240, :]
        pixels = cv2.countNonZero(test_frame)
        cv2.imshow("milk", test_frame)

        if pixels <= 9216:  # =240*640*0.08
            escape = 130
            print('성공')

        else:
            escape = 128
            print('실패')

    print("확진구역우유결과 :", escape)
    return escape


def mode_alpha_color(mask_blue):
    color = 129

    pixels = cv2.countNonZero(mask_blue)

    if pixels > 500:
        color = 128  # 파랑
        print('blue')
    else:
        color = 130  # 빨강
        print('red')

    print("알파벳색상 :", color)
    return color


# ----------------------------------------------------------------------------------------------------
def TX_data_py2(ser, one_byte):  # one_byte= 0~255

    # ser.write(chr(int(one_byte)))          #python2.7
    ser.write(serial.to_bytes([one_byte]))  # python3


def RX_data(ser):
    if ser.inWaiting() > 0:
        result = ser.read(1)
        RX = ord(result)
        return RX
    else:
        return 0


if __name__ == '__main__':
    BPS = 4800  # 4800,9600,14400, 19200,28800, 57600, 115200

    serial_port = serial.Serial('/dev/ttyS0', BPS, timeout=0.01)
    serial_port.flush()  # serial cls

    # First -> Start Code Send
    TX_data_py2(serial_port, 128)
    print("\nserial_port.readline = ", serial_port.readline())

    # TX_data_py2(serial_port, 1)
    # print("Return DATA 첫번째: " + str(RX_data(serial_port)))
    print("통신 시작\n")
    print("-------------------------------------\n")

    # exit(1)

W_View_size = 320
H_View_size = 240
FPS = 80  # PI CAMERA: 320 x 240 = MAX 90

try:
    cap = cv2.VideoCapture(0)  # 카메라 켜기  # 카메라 캡쳐 (사진만 가져옴)

    cap.set(3, W_View_size)
    cap.set(4, H_View_size)
    cap.set(5, FPS)

    ftp = capture.FtpClient(ip_address="192.168.0.5", user="Jeun", passwd="4140")


except:
    print('cannot load camera!')

while True:
    start_time = timeit.default_timer()  # 시작 시간 체크
    ret, frame = cap.read()  # 무한루프를 돌려서 사진을 동영상으로 변경   # ret은 true/false

    # gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    blur = cv2.GaussianBlur(frame, (5, 5), cv2.BORDER_DEFAULT)
    # hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)  # BGR을 HSV모드로 전환

    if ret:  # 사진 가져오는것을 성공할 경우
        cv2.imshow('Original', frame)

    else:
        print('cannot load camera!')
        break

    k = cv2.waitKey(25)
    if k == 27:
        break

    elif k == ord('z'):
        ftp.store_image(frame)

    data = str(RX_data(serial_port))

    # --------------------------------------------------

    if data == '204':  # ABCD 검출
        print("\n********** ABCD 검출 **********")
        print("Return DATA: " + data)

        hsv = cv2.cvtColor(blur, cv2.COLOR_BGR2YCrCb)

        res_alphacolor = 130

        if res_alphacolor == 128:  # 파랑
            mask_blueOrRed = cv2.inRange(hsv, lower_blue, upper_blue)
        elif res_alphacolor == 130:  # 빨강
            mask_blueOrRed = cv2.inRange(hsv, lower_red, upper_red)

        res_abcd = mode_abcd(mask_blueOrRed)

    # data = str(RX_data(serial_port))
    # print("Return DATA: " + data)

# ----------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------
cap.release()
cv2.destroyAllWindows()




# -*- coding: utf-8 -*-
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
lower_red = np.array([0, 155, 0])
upper_red = np.array([255, 255, 255])
lower_blue = np.array([0, 0, 152])
upper_blue = np.array([255, 255, 255])
lower_yellow = np.array([0, 133, 0])
upper_yellow = np.array([255, 255, 122])

# HSV
# lower_red = np.array([150, 50, 15])
# upper_red = np.array([180, 255, 255])
# lower_blue = np.array([90, 70, 40])
# upper_blue = np.array([120, 255, 255])
lower_green = np.array([50, 60, 30])
upper_green = np.array([80, 255, 255])


# lower_yellow = np.array([10, 100, 20])
# upper_yellow = np.array([30, 255, 255])


# ----------------------------------------------------------------------------------------------------


def mode_linetracer(blur):
    line = 'error'
    res = 129

    ycbcr = cv2.cvtColor(blur, cv2.COLOR_BGR2YCrCb)
    mask_yellow = cv2.inRange(ycbcr, lower_yellow, upper_yellow)

    pixels = cv2.countNonZero(mask_yellow)
    print(pixels)

    if pixels < 2000:
        return res

    kernel = np.ones((5, 5), np.uint8)
    binary_line_dil = cv2.dilate(mask_yellow, kernel, iterations=2)

    cv2.imshow('binary_line_mor', binary_line_dil)

    contours, hierarchy = cv2.findContours(binary_line_dil, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    # 컨투어된 영역중에서 제일 큰 부분만 선택 (배경 제거)
    max_contour = None
    max_area = -1

    for contour in contours:
        area = cv2.contourArea(contour)
        if area > max_area:
            max_area = area
            max_contour = contour

    if len(max_contour) <= 0:
        return res

    yellowbox = cv2.minAreaRect(max_contour)
    (x, y), (w, h), ang = yellowbox

    if w > h:
        ang = ang + 90

    ang = int(ang)
    box = cv2.boxPoints(yellowbox)
    box = np.int0(box)

    print('w= {}, h={}'.format(w, h))
    print('x= {}, y={}'.format(x, y))
    print('x-w/2 ={}, y-h/2={}'.format(x - w / 2, y - h / 2))

    cv2.circle(blur, (int(x), int(y)), 3, (255, 0, 0), 10)
    cv2.circle(blur, (int(x - w / 2), int(y - h / 2)), 3, (0, 0, 255), 10)
    for i in box:
        # cv2.circle(blur, (i[0], i[1]), 3, (255, 255, 255), 10)

        if h < 55 or w < 55:  # 직선
            line = 'straight '

            if abs(ang) > 10:
                if ang > 0:
                    line += 'small right turn'
                    res = 235
                else:
                    line += 'small left turn'
                    res = 240

            else:
                if x < 120:
                    line += 'go left'
                    res = 220
                elif 120 <= x < 200:
                    line += 'go'
                    res = 225
                else:
                    line += 'go right'
                    res = 230

            '''elif ang > 0:
                if ang < 15:
                    line += 'small right turn'
                    res = 235
                else:
                    line += 'big right turn'
                    res = 245

            else:
                if ang > -15:
                    line += 'small left turn'
                    res = 240
                else:
                    line += 'big left turn'
                    res = 250'''

        else:  # x >= 50:   # 코너
            res = 100
            line = 'corner'

            if 85 < abs(ang) < 95 or abs(ang) < 5:
                # if w > 215:
                #   res += 10
                # line += 'go'
                # res += 10
                if x - w / 2 < 160:
                    line += 'left corner'
                    res = 150
                else:
                    line += 'right corner'
                    res = 145

            elif ang > 0:
                line += 'small right turn'
                res += 35

                # if ang < 15:
                #     line += 'small right turn'
                #     res += 35
                # else:
                #     line += 'big right turn'
                #     res += 45

            else:
                line += 'small left turn'
                res += 40

                # if ang > -15:
                #     line += 'small left turn'
                #     res += 40
                # else:
                #     line += 'big left turn'
                #     res += 50

    print('line = {}, angle = {}'.format(line, ang))
    print()

    cv2.drawContours(blur, [box], 0, (0, 0, 255), 3)
    cv2.putText(blur, str(ang), (10, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
    # cv2.putText(blur, str(error), (10, 120), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 0), 2)
    # cv2.line(image, (int(x_min), 150), (int(x_min), 102), (255, 0, 0), 3)

    cv2.imshow('blur', blur)
    return res


# ----------------------------------------------------------------------------------------------------
def mode_ewsn(blur):
    ewsn = 129

    gray = cv2.cvtColor(blur, cv2.COLOR_BGR2GRAY)
    gray2 = cv2.add(gray, 200)
    # cv2.imshow("gray", gray)
    ret, mask_black = cv2.threshold(gray2, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)  # 이진화

    ret, mask_black2 = cv2.threshold(gray, 60, 255, cv2.THRESH_BINARY_INV)  # 이진화

    # cv2.imshow("mask_black", mask_black)
    # cv2.imshow("mask_black2", mask_black2)
    # 모폴로지 연산(열림연산) 후 컨투어
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 5))
    binary_ero = cv2.erode(mask_black, kernel)
    contours, _ = cv2.findContours(binary_ero, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    if len(contours) == 0:
        return ewsn

    pixels = cv2.countNonZero(mask_black)
    print(pixels)

    if pixels < 5000:
        return ewsn

    # 컨투어된 영역중에서 제일 큰 부분만 선택 (배경 제거)
    max_contour = None
    max_area = -1

    for contour in contours:
        area = cv2.contourArea(contour)
        if area > max_area:
            max_area = area
            max_contour = contour

    # 각 컨투어에 근사 컨투어로 단순화
    approx = cv2.approxPolyDP(max_contour, 0.01 * cv2.arcLength(max_contour, True), True)
    # 꼭짓점의 개수
    vertices = len(approx)
    print("ver=", vertices)
    # 사각형으로 컨투어
    x, y, w, h = cv2.boundingRect(max_contour)

    cv2.drawContours(blur, approx, -1, (0, 0, 255), 3)
    cv2.imshow('ewsn_blur', blur)
    if vertices < 8:
        ewsn = 129
    elif vertices >= 18:
        ewsn = 112
        print('남')
    elif vertices <= 12:
        ewsn = 111
        print('북')
    else:
        if abs(w - h) >= 60:
            ewsn = 113
            print('동')
        else:
            ewsn = 114
            print('서')

    print("방위 :", ewsn)
    return ewsn


# ----------------------------------------------------------------------------------------------------

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

    # ------------------------------------------------------------------------------------
    #####################################################################################

    try:
        cap = cv2.VideoCapture(0)  # 카메라 켜기  # 카메라 캡쳐 (사진만 가져옴)

        cap.set(3, 320)
        cap.set(4, 240)
        cap.set(5, 80)

        # ftp = capture.FtpClient(ip_address="192.168.0.4", user="simkyuwon", passwd="Mil18-76061632")
        # ftp = capture.FtpClient(ip_address="192.168.0.9", user="Jeun", passwd="4140")

    except:
        print('cannot load camera!')

    while True:
        start_time = timeit.default_timer()  # 시작 시간 체크
        ret, frame1 = cap.read()  # 무한루프를 돌려서 사진을 동영상으로 변경   # ret은 true/false

        blur = cv2.GaussianBlur(frame1, (3, 3), 0)
        # gray = cv2.cvtColor(blur, cv2.COLOR_BGR2GRAY)

        # hsv = cv2.cvtColor(blur, cv2.COLOR_BGR2HSV)  # BGR을 HSV모드로 전환
        # ycbcr = cv2.cvtColor(blur, cv2.COLOR_BGR2YCrCb)  # BGR을 YCbCr모드로 전환

        if ret:  # 사진 가져오는것을 성공할 경우
            cv2.imshow('Original1', frame1)

        else:
            print('cannot load camera!')
            break

        k = cv2.waitKey(25)
        if k == 27:
            break

        data = str(RX_data(serial_port))
        # print("Return DATA: " + data)

        # ----------------------------------------------------------------------------------------------------

        if data == '201':  # 동서남북 검출
            print("\n********** 동서남북 검출 **********")
            print("Return DATA: " + data)

            res_ewsn = mode_ewsn(blur)
            TX_data_py2(serial_port, res_ewsn)

        # --------------------------------------------------

        elif data == '202':  # 라인트레이싱
            print("\n********** 라인트레이싱 **********")
            print("Return DATA: " + data)
            res_line = mode_linetracer(blur)
            print("Send DATA: ", res_line)
            TX_data_py2(serial_port, res_line)

    # ----------------------------------------------------------------------------------------------------

    # ----------------------------------------------------------------------------------------------------
    cap.release()
    cv2.destroyAllWindows()

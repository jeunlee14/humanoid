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

# YCbCr
lower_red = np.array([0, 155, 0])
upper_red = np.array([255, 255, 255])
lower_blue = np.array([0, 0, 152])
upper_blue = np.array([255, 255, 255])

# HSV
# lower_red = np.array([150, 50, 15])
# upper_red = np.array([180, 255, 255])
# lower_blue = np.array([90, 70, 40])
# upper_blue = np.array([120, 255, 255])
lower_green = np.array([50, 60, 30])
upper_green = np.array([80, 255, 255])
lower_yellow = np.array([10, 100, 20])
upper_yellow = np.array([30, 255, 255])


# ----------------------------------------------------------------------------------------------------
def mode_corner_x(xpos):
    if xpos < 320:
        xpos = 320 - xpos

        if xpos > 70:
            res_x = int(xpos) / 70
        else:
            res_x = 0

        print('왼쪽으로 이동', int(res_x), '회')
        res_x = 10 + int(res_x)

    else:
        xpos = xpos - 320

        if xpos > 70:
            res_x = int(xpos / 70)
        else:
            res_x = 0

        print('오른쪽으로 이동', res_x, '회')
        res_x = 20 + int(res_x)

    return res_x


def mode_corner_y(ypos):
    res_y = int((480 - ypos) / 40)
    print('앞쪽으로 이동', res_y, '회')

    return res_y


# ----------------------------------------------------------------------------------------------------
def mode_corner(binary_line):
    corner = 199

    pixels = cv2.countNonZero(binary_line)

    if pixels > 5000:
        # 모폴로지 연산(흰색영역 확장) 후 컨투어
        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3))
        binary_line_dil = cv2.dilate(binary_line, kernel)

        contours, hierarchy = cv2.findContours(binary_line_dil, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)  # 컨투어

        max_contour = None
        max_area = -1

        for contour in contours:
            area = cv2.contourArea(contour)
            if area > max_area:
                max_area = area
                max_contour = contour

        mask_corner = np.zeros((480, 640), dtype=np.uint8)
        cv2.drawContours(mask_corner, [max_contour], 0, 255, -1)

        # 시-토마스의 코너 검출 메서드
        corners = cv2.goodFeaturesToTrack(mask_corner, 50, 0.01, 80, 10)
        # 실수 좌표를 정수 좌표로 변환
        corners = np.int32(corners)
        big = 0
        find = 0

        # 제일 아래에 있는 코너 찾기
        for i in corners:
            nump = np.array(i)
            c = nump[0][1]
            if c > big:
                big = c
                find = i[0]
            else:
                continue

        print(find)
        cv2.circle(frame, tuple(find), 1, (0, 0, 255), 5)
        cv2.imshow("frame", frame)

        if find[0] > 10 and find[0] < 630:
            res_x = mode_corner_x(find[0])
            res_y = mode_corner_y(find[1])

            corner = (res_x * 10) + res_y

    print("corner", corner)
    return corner


# ----------------------------------------------------------------------------------------------------
def mode_xpos(binary_milk):
    res_x = 199

    pixels = cv2.countNonZero(binary_milk)

    if pixels > 1000:
        contours, hierarchy = cv2.findContours(binary_milk, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)  # 컨투어
        # cv2.imshow('binary_milk', binary_milk)

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
        print(" a = %d" % xpos)

        if xpos == 0:
            res_x = 199
            print("우유곽 없음")

        elif xpos < 320:
            xpos = 320 - xpos

            if xpos > 90:
                res_x = int(xpos / 90)

            else:
                res_x = 0

            print('왼쪽으로 이동', res_x, '회')
            res_x = 100 + res_x


        else:
            xpos = xpos - 320

            if xpos > 90:
                res_x = int(xpos / 90)
            else:
                res_x = 0

            print('오른쪽으로 이동', res_x, '회')
            res_x = 200 + res_x

    return int(res_x)


# ----------------------------------------------------------------------------------------------------
def mode_ypos(binary_milk):
    res_y = 199

    pixels = cv2.countNonZero(binary_milk)

    if pixels > 1000:
        contours, hierarchy = cv2.findContours(binary_milk, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)  # 컨투어
        # cv2.imshow('cam_binary', binary_milk)

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
        ypos = y + (h / 2)

        print(" b = %d" % ypos)
        # print("s = %d\n\n`" % (w * h))

        if ypos == 0:
            res_y = 199
            print("우유곽 없음")

        else:

            if ypos >= 320:
                res_y = 189
                print("우유곽 잡기")

            else:
                res_y = int((480 - ypos) / 100)
                print('앞쪽으로 이동', res_y, '회')

    return res_y


# ----------------------------------------------------------------------------------------------------


def mode_linetracer(mask_yellow):
    res = 129

    pixels = cv2.countNonZero(mask_yellow)

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

    for i in box:
        cv2.circle(blur, (i[0], i[1]), 3, (255, 255, 255), 10)

        if h < 52 or w < 52:  # 직선
            line = 'straight '

            if 0 <= abs(ang) <= 10:
                if x < 150:
                    line += 'go left'
                    res = 220
                elif 150 <= x < 200:
                    line += 'go'
                    res = 225
                else:
                    line += 'go right'
                    res = 230

            # elif ang > 0:
            #     if ang < 15:
            #         line += 'small right turn'
            #         res = 235
            #     else:
            #         line += 'big right turn'
            #         res = 245
            #
            # else:
            #     if ang > -15:
            #         line += 'small left turn'
            #         res = 240
            #     else:
            #         line += 'big left turn'
            #         res = 250

        elif x >= 50:  # 코너
            line = 'corner '
            res = 100
            # line = 'corner '

            if x < 150:
                line += 'go left'
                res += 25
            elif 150 <= x < 200:
                line += 'go'

                if 0 <= abs(ang) <= 10:
                    if w > 215:
                        res += 10

                elif ang > 0:
                    if ang < 15:
                        line += 'small right turn'
                        res += 35
                    else:
                        line += 'big right turn'
                        res += 45

                else:
                    if ang > -15:
                        line += 'small left turn'
                        res += 40
                    else:
                        line += 'big left turn'
                        res += 50
            else:
                line += 'go right'
                res += 30

    print('line = {}, angle = {}'.format(line, ang))
    print()
    cv2.imshow('blur', blur)

    cv2.drawContours(blur, [box], 0, (0, 0, 255), 3)
    cv2.putText(blur, str(ang), (10, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
    # cv2.putText(blur, str(error), (10, 120), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 0), 2)
    # cv2.line(image, (int(x_min), 150), (int(x_min), 102), (255, 0, 0), 3)

    return res


# ----------------------------------------------------------------------------------------------------
def mode_ewsn(binary):
    ewsn = 129

    cv2.imshow("ewsn", binary)
    # 모폴로지 연산(열림연산) 후 컨투어
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 5))
    binary_ero = cv2.erode(binary, kernel)
    contours, _ = cv2.findContours(binary_ero, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    if len(contours) == 0:
        return ewsn

    pixels = cv2.countNonZero(binary)
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
    # 사각형으로 컨투어
    x, y, w, h = cv2.boundingRect(max_contour)

    # imshow("ewsn", max_contour)
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
def mode_arrow(binary):
    arrow = 129

    # 모폴로지 연산(흰색영역 확장) 후 컨투어
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 5))
    binary_dil = cv2.dilate(binary, kernel)
    contours, hierarchy = cv2.findContours(binary_dil, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)

    # 컨투어된 영역중에서 제일 큰 부분만 선택 (배경 제거)
    max_contour = None
    max_area = -1

    for contour in contours:
        area = cv2.contourArea(contour)
        if area > max_area:
            max_area = area
            max_contour = contour

    # 윤곽선 따고 결함 찾기
    hull = cv2.convexHull(max_contour, returnPoints=False)
    defects = cv2.convexityDefects(max_contour, hull)

    left, right = 0, 0
    x, y = 10, 10

    # 결함의 주변 좌표가 컨투어 영역 안에 있는지 밖에 있는지 확인
    for i in range(defects.shape[0]):
        s, e, f, d = defects[i, 0]
        fx, fy = tuple(max_contour[f][0])

        if d > 1000:
            if cv2.pointPolygonTest(max_contour, (fx + x, fy + y), False) == 1:
                right += 1
            if cv2.pointPolygonTest(max_contour, (fx + x, fy - y), False) == 1:
                right += 1
            if cv2.pointPolygonTest(max_contour, (fx - x, fy + y), False) == 1:
                left += 1
            if cv2.pointPolygonTest(max_contour, (fx - x, fy - y), False) == 1:
                left += 1

    if left < right:
        arrow = 113
        print('오른쪽')
    else:
        arrow = 114
        print('왼쪽')

    print("화살표방향 :", arrow)
    return arrow


# ----------------------------------------------------------------------------------------------------
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
def mode_abcd(binary_mask):
    abcd = 129

    # 모폴로지 열림연산
    k = cv2.getStructuringElement(cv2.MORPH_OPEN, (5, 5))
    opening = cv2.dilate(binary_mask, k)

    contours, hierarchy = cv2.findContours(binary_mask, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)  # 컨투어

    if len(contours) == 0:
        print("물체를 감지할 수 없습니다")
        return abcd

    else:
        contr = contours[0]
        x, y, w, h = cv2.boundingRect(contr)
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 3)
        frame2 = frame[y:y + h, x:x + w]

        cv2.drawContours(frame, contours, -1, (0, 255, 0), 4)

        blue_area = cv2.contourArea(contr, False)
        total_size = frame2.size
        per = blue_area / total_size

        if per < 0.145:
            abcd = 112
            print('c')
        elif per > 0.15 and per < 0.2:
            abcd = 113
            print('a')
        else:
            if len(contours) == 2:
                abcd = 111
                print('d')
            else:
                abcd = 114
                print('b')

    return abcd


# ----------------------------------------------------------------------------------------------------
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


# ----------------------------------------------------------------------------------------------------
def mode_mission_save(binary_area, binary_milk):
    mission = 129

    pixels_area = cv2.countNonZero(binary_area)
    pixels_milk = cv2.countNonZero(binary_milk)

    cv2.imshow('binary_area', binary_area)
    cv2.imshow('binary_milk', binary_milk)
    print('pixels_area = ', pixels_area, '  pixels_milk =  ', pixels_milk)

    if pixels_milk > 1000:
        # 모폴로지 연산(흰색영역 확장) 후 컨투어

        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 5))
        binary_milk_dil = cv2.dilate(binary_milk, kernel)
        binary_area_dil = cv2.dilate(binary_area, kernel)
        cv2.imshow('binary_area_dil', binary_area_dil)
        cv2.imshow('binary_milk_dil', binary_milk_dil)

        # result = cv2.bitwise_and(binary_area_dil, binary_milk)
        # pixels_result = cv2.countNonZero(result)
        # cv2.imshow('result', result)

        contours, hierarchy = cv2.findContours(binary_milk_dil, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)  # 컨투어

        if len(contours) == 0:
            print("물체를 감지할 수 없습니다")

        else:
            # 컨투어된 영역중에서 제일 큰 부분만 선택 (배경 제거)
            max_contour = None
            max_area = -1

            for contour in contours:
                area = cv2.contourArea(contour)
                if area > max_area:
                    max_area = area
                    max_contour = contour

            x, y, w, h = cv2.boundingRect(max_contour)
            # cv2.rectangle(binary_milk, (x, y), (x + w, y + h), (0, 255, 0), 3)
            result = binary_area_dil[y:y + h, x:x + w]

            pixels_result = cv2.countNonZero(result)

            cv2.imshow('result', result)
            print("pixels_result =", pixels_result)
            print("pixels_rect * 0.02 =", w * h * 0.02)

            if pixels_result > w * h * 0.02:
                mission = 130  # 성공
                print('성공')

            else:
                mission = 128  # 실패
                print('실패')

        '''
        if pixels_result > pixels_milk * 0.5:
            mission = 130  # 성공
            print('성공')

        elif pixels_result < pixels_milk * 0.5:
            mission = 128  # 실패
            print('실패')

        print('pixels_result = ', pixels_result, '  pixels_milk * 0.5 = ', pixels_milk * 0.5)  
        '''
    cv2.imshow('frame', frame)
    print("안전구역미션수행결과 :", mission)
    return mission


# ----------------------------------------------------------------------------------------------------
def mode_mission_escape(binary_area, binary_milk):
    mission = 129

    pixels_area = cv2.countNonZero(binary_area)
    pixels_milk = cv2.countNonZero(binary_milk)

    # cv2.imshow('binary_area', binary_area)
    # cv2.imshow('binary_milk', binary_milk)
    print('pixels_area = ', pixels_area, '  pixels_milk =  ', pixels_milk)

    if pixels_milk > 1000:
        # 모폴로지 연산(흰색영역 확장) 후 컨투어

        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 5))
        binary_milk_dil = cv2.dilate(binary_milk, kernel)
        binary_area_dil = cv2.dilate(binary_area, kernel)
        cv2.imshow('binary_area_dil', binary_area_dil)
        cv2.imshow('binary_milk_dil', binary_milk_dil)

        contours, hierarchy = cv2.findContours(binary_milk_dil, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)  # 컨투어

        if len(contours) == 0:
            print("물체를 감지할 수 없습니다")

        else:
            # 컨투어된 영역중에서 제일 큰 부분만 선택 (배경 제거)
            max_contour = None
            max_area = -1

            for contour in contours:
                area = cv2.contourArea(contour)
                if area > max_area:
                    max_area = area
                    max_contour = contour

            x, y, w, h = cv2.boundingRect(max_contour)
            result = binary_area_dil[y:y + h, x:x + w]

            pixels_result = cv2.countNonZero(result)

            cv2.imshow('result', result)
            print("pixels_result =", pixels_result)
            print("pixels_rect * 0.2 =", w * h * 0.2)

            if pixels_result > w * h * 0.2:
                mission = 128  # 실패
                print('실패')

            else:
                mission = 130  # 성공
                print('성공')

    cv2.imshow('frame', frame)
    print("안전구역미션수행결과 :", mission)
    return mission


# ---------------------------------------------------------------------------------------------------
def mode_milk_save(binary_area):
    save = 129

    pixels_area = cv2.countNonZero(binary_area)

    if pixels_area > 1000:
        test_frame = binary_area[250:480, :]
        pixels = cv2.countNonZero(test_frame)
        cv2.imshow('test_frame', test_frame)
        cv2.imshow("binary_area", binary_area)
        print('pixels = ', pixels)

        if pixels > 110000:  # =240*640*0.45
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
    cv2.imshow('frame', frame)

    pixels_area = cv2.countNonZero(binary_area)
    cv2.imshow('binary_area', binary_area)
    print('pixels_area = ', pixels_area)

    # if 640*480 - pixels_area > 150:   #검정색이 150 픽셀 이상일경우

    test_frame = binary_area[0:240, :]
    pixels = cv2.countNonZero(test_frame)
    pixels_white = 240 * 640 - pixels
    cv2.imshow("test_frame", test_frame)
    print('pixels_white = ', pixels_white)

    if pixels_white > 100000:  # =240*640*0.08
        escape = 130
        print('성공')

    else:
        escape = 128
        print('실패')

    print("확진구역우유결과 :", escape)
    return escape


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
    cap1 = cv2.VideoCapture(0)  # 카메라 켜기  # 카메라 캡쳐 (사진만 가져옴)

    cap1.set(3, 320)
    cap1.set(4, 240)
    cap1.set(5, 80)

    # ftp = capture.FtpClient(ip_address="192.168.0.4", user="simkyuwon", passwd="Mil18-76061632")
    # ftp = capture.FtpClient(ip_address="192.168.0.9", user="Jeun", passwd="4140")

except:
    print('cannot load camera!')

while True:
    start_time = timeit.default_timer()  # 시작 시간 체크
    ret, frame1 = cap1.read()  # 무한루프를 돌려서 사진을 동영상으로 변경   # ret은 true/false

    blur = cv2.GaussianBlur(frame1, (3, 3), 0)
    gray = cv2.cvtColor(blur, cv2.COLOR_BGR2GRAY)
    hsv = cv2.cvtColor(blur, cv2.COLOR_BGR2HSV)  # BGR을 HSV모드로 전환
    ycbcr = cv2.cvtColor(blur, cv2.COLOR_BGR2YCrCb)  # BGR을 YCbCr모드로 전환

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
        ret, mask_black = cv2.threshold(gray, 60, 255, cv2.THRESH_BINARY_INV)  # 이진화

        res_ewsn = mode_ewsn(mask_black)
        TX_data_py2(serial_port, res_ewsn)

    # --------------------------------------------------
    if data == '203':  # 화살표 검출
        print("\n********** 화살표 검출 **********")
        print("Return DATA: " + data)

        ret, mask_black = cv2.threshold(gray, 90, 255, cv2.THRESH_BINARY_INV)  # 이진화

        res_arrow = mode_arrow(mask_black)
        TX_data_py2(serial_port, res_arrow)

    # --------------------------------------------------
    elif data == '204':  # 알파벳색상 검출
        print("\n********** 알파벳색상 검출 **********")
        print("Return DATA: " + data)
        mask_blue = cv2.inRange(ycbcr, lower_blue, upper_blue)

        res_alphacolor = mode_alpha_color(mask_blue)
        TX_data_py2(serial_port, res_alphacolor)

    # --------------------------------------------------
    elif data == '205':  # ABCD 검출
        print("\n********** ABCD 검출 **********")
        print("Return DATA: " + data)
        res_alphacolor = 128  # 임시!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        if res_alphacolor == 128:  # 파랑
            mask_blueOrRed = cv2.inRange(ycbcr, lower_blue, upper_blue)
        elif res_alphacolor == 130:  # 빨강
            mask_blueOrRed = cv2.inRange(ycbcr, lower_red, upper_red)

        res_abcd = mode_abcd(mask_blueOrRed)
        TX_data_py2(serial_port, res_abcd)

    # --------------------------------------------------
    elif data == '206':  # 구역색상 검출
        print("\n********** 구역색상 검출 **********")
        print("Return DATA: " + data)
        mask_green = cv2.inRange(hsv, lower_green, upper_green)

        res_area = mode_area_color(mask_green)
        TX_data_py2(serial_port, res_area)

    # --------------------------------------------------

    elif data == '210':  # 라인트레이싱
        print("\n********** 라인트레이싱 **********")
        print("Return DATA: " + data)
        # ftp.store_image(blur)
        mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)

        res_line = mode_linetracer(mask_yellow)
        print("Send DATA: ", res_line)
        TX_data_py2(serial_port, res_line)

    # --------------------------------------------------
    elif data == '206':  # 안전구역미션수행 확인
        # res_alphacolor = 128  ###############################################################임시!!!!
        print("\n********** 안전구역미션수행 확인 **********")
        print("Return DATA: " + data)
        mask_green = cv2.inRange(hsv, lower_green, upper_green)

        if res_alphacolor == 128:
            mask_blueOrRed = cv2.inRange(hsv, lower_blue, upper_blue)
        elif res_alphacolor == 130:
            mask_blueOrRed = cv2.inRange(hsv, lower_red, upper_red)

        res_mission = mode_mission_save(mask_green, mask_blueOrRed)
        TX_data_py2(serial_port, res_mission)



    # --------------------------------------------------

    elif data == '216':  # 확진구역미션수행 확인
        # res_alphacolor = 128  ###############################################################임시!!!!
        print("\n********** 확진구역미션수행 확인 **********")
        print("Return DATA: " + data)
        ret, mask_black = cv2.threshold(gray, 30, 255, cv2.THRESH_BINARY_INV)  # 이진화

        if res_alphacolor == 128:
            mask_blueOrRed = cv2.inRange(hsv, lower_blue, upper_blue)
        elif res_alphacolor == 130:
            mask_blueOrRed = cv2.inRange(hsv, lower_red, upper_red)

        res_mission = mode_mission_escape(mask_black, mask_blueOrRed)
        TX_data_py2(serial_port, res_mission)

    # --------------------------------------------------
    elif data == '207':  # 우유곽 x좌표 찾기
        res_alphacolor = 128  ###############################################################임시!!!!
        print("\n********** 우유곽 x좌표 찾기 **********")
        print("Return DATA: " + data)
        if res_alphacolor == 128:
            mask_blueOrRed = cv2.inRange(ycbcr, lower_blue, upper_blue)
        elif res_alphacolor == 130:
            mask_blueOrRed = cv2.inRange(ycbcr, lower_red, upper_red)

        res_xpos = mode_xpos(mask_blueOrRed)
        TX_data_py2(serial_port, res_xpos)

    # --------------------------------------------------
    elif data == '217':  # 우유곽 y좌표 찾기
        # res_alphacolor = 128  ###############################################################임시!!!!
        print("\n********** 우유곽 y좌표 찾기 **********")
        print("Return DATA: " + data)
        if res_alphacolor == 128:
            mask_blueOrRed = cv2.inRange(ycbcr, lower_blue, upper_blue)
        elif res_alphacolor == 130:
            mask_blueOrRed = cv2.inRange(ycbcr, lower_red, upper_red)

        res_ypos = mode_ypos(mask_blueOrRed)
        TX_data_py2(serial_port, res_ypos)

    # --------------------------------------------------
    elif data == '208':  # 안전구역에 들어가기
        print("\n********** 안전구역에 들어가기 **********")
        print("Return DATA: " + data)
        mask_green = cv2.inRange(hsv, lower_green, upper_green)

        res_save = mode_milk_save(mask_green)
        TX_data_py2(serial_port, res_save)

    # --------------------------------------------------
    elif data == '218':  # 확진구역에서 나가기
        print("\n********** 확진구역에서 나가기 **********")
        print("Return DATA: " + data)
        ret, mask_black = cv2.threshold(gray, 60, 255, cv2.THRESH_BINARY_INV)  # 이진화

        res_escape = mode_milk_escape(mask_black)
        TX_data_py2(serial_port, res_escape)

    # --------------------------------------------------
    elif data == '209':  # 미션완료 후 코너 좌표 찾기
        print("\n********** 미션완료 후 코너 찾기 **********")
        print("Return DATA: " + data)
        mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)  # 노랑최소최대값을 이용해서 maskyellow값지정

        res_corner = mode_corner(mask_yellow)
        TX_data_py2(serial_port, res_corner)

# ----------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------
cap1.release()
cv2.destroyAllWindows()

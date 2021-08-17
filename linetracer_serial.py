import cv2
import numpy as np
import sys
import math
import timeit
import serial
import capture


serial_use = 1

serial_port = None
Read_RX = 0
receiving_exit = 1
threading_Time = 0.01

W_View_size = 320
H_View_size = 240
FPS = 90  # PI CAMERA: 320 x 240 = MAX 90


lower_yellow = np.array([0, 58, 50])
upper_yellow = np.array([255, 180, 116])


def mode_linetracer(blur):

    res = 129

    YCrCb = cv2.cvtColor(blur, cv2.COLOR_BGR2YCR_CB)
    mask_yellow = cv2.inRange(YCrCb, lower_yellow, upper_yellow)

    pixels = cv2.countNonZero(mask_yellow)

    if pixels < 5000:
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
        ang = ang - 90

    ang = int(ang)
    box = cv2.boxPoints(yellowbox)
    box = np.int0(box)

    print('w= {}, h={}'.format(w, h))

    for i in box:
        cv2.circle(blur, (i[0], i[1]), 3, (255, 255, 255), 10)

        if h < 50 or w < 50:  # 직선
            line = 'straight '

            if 0 <= abs(ang) <= 5:
                if x < 150:
                    line += 'go left'
                    res = 220
                elif 150 <= x < 171:
                    line += 'go'
                    res = 225
                else:
                    line += 'go right'
                    res = 230

            elif ang > 0:
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
                    res = 250

        elif x >= 50:   # 코너
            line = 100
            #line = 'corner '

    print('line = {}, angle = {}'.format(line, ang))
    print()
    cv2.imshow('blur', blur)

    cv2.drawContours(blur, [box], 0, (0, 0, 255), 3)
    cv2.putText(blur, str(ang), (10, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
    # cv2.putText(blur, str(error), (10, 120), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 0), 2)
    # cv2.line(image, (int(x_min), 150), (int(x_min), 102), (255, 0, 0), 3)

    return res

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

    TX_data_py2(serial_port, 1)
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
    ftp = capture.FtpClient(ip_address="192.168.0.3", user="Jeun", passwd="4140")

except:
    print('cannot load camera!')

while True:
    start_time = timeit.default_timer()  # 시작 시간 체크
    ret, frame = cap.read()  # 무한루프를 돌려서 사진을 동영상으로 변경   # ret은 true/false
    blur = cv2.GaussianBlur(frame, (3, 3), 0)

    if ret:  # 사진 가져오는것을 성공할 경우
        cv2.imshow('blur', blur)

    else:
        print('cannot load camera!')
        break

    k = cv2.waitKey(25)
    if k == 27:
        break

    data = str(RX_data(serial_port))

    # ***************************************************************************8

    if data == '210':  # 라인트레이싱
        print("\n********** 라인트레이싱 **********")
        print("Return DATA: " + data)
        ftp.store_image(blur)

        res_line = mode_linetracer(blur)
        TX_data_py2(serial_port, res_line)

cap.release()
cv2.destroyAllWindows()

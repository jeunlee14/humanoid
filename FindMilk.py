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

cMOTION_MILK_LOST = 101
cMOTION_MILK_POSION_FRONT_BIG = 102
cMOTION_MILK_POSION_FRONT_SMALL = 103
cMOTION_MILK_POSION_LEFT = 104
cMOTION_MILK_POSION_RIGHT = 105
cMOTION_MILK_CATCH = 106

# ----------------------------------------------------------------------------------------------------
def mode_xpos(blur):
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

except:
    print('cannot load camera!')

while True:
    start_time = timeit.default_timer()  # 시작 시간 체크
    ret, frame = cap.read()  # 무한루프를 돌려서 사진을 동영상으로 변경   # ret은 true/false

    blur = cv2.GaussianBlur(frame, (3, 3), 0)
    gray = cv2.cvtColor(blur, cv2.COLOR_BGR2GRAY)

    hsv = cv2.cvtColor(blur, cv2.COLOR_BGR2HSV)  # BGR을 HSV모드로 전환
    ycbcr = cv2.cvtColor(blur, cv2.COLOR_BGR2YCR_CB)  # BGR을 YCbCr모드로 전환

    if ret:  # 사진 가져오는것을 성공할 경우
        cv2.imshow('Original', frame)

    else:
        print('cannot load camera!')
        break

    k = cv2.waitKey(25)
    if k == 27:
        break

    data = str(RX_data(serial_port))
    res = mode_xpos(blur)
    print('res=', res)
    TX_data_py2(serial_port, res)


# ----------------------------------------------------------------------------------------------------
cap.release()
cv2.destroyAllWindows()

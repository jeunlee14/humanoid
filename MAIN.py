from EWSN import *
from LINE import *
from ARROW import *
from ABCD import *
from MISSION import *
import timeit
import serial
import cv2
import numpy as np

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

# hsv
# lower_red = np.array([150, 60, 60])
# upper_red = np.array([180, 255, 255])
# lower_blue = np.array([90, 70, 40])
# upper_blue = np.array([120, 255, 255])
lower_green = np.array([50, 60, 80])
upper_green = np.array([80, 255, 255])
# lower_yellow = np.array([0, 80, 110])
# upper_yellow = np.array([30, 255, 255])


W_View_size = 640
H_View_size = 480
FPS = 90  # PI CAMERA: 320 x 240 = MAX 90


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
    ycbcr = cv2.cvtColor(blur, cv2.COLOR_BGR2YCrCb)  # BGR을 YCbCr모드로 전환

    if ret:  # 사진 가져오는것을 성공할 경우
        cv2.imshow('Original', frame)

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
cap.release()
cv2.destroyAllWindows()

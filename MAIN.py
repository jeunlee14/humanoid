import cv2
import numpy as np
import timeit

from EWSN import *
from LINE import *
from ARROW import *
from ABCD import *
from MISSION import *

serial_use = 1

serial_port = None
Read_RX = 0
receiving_exit = 1
threading_Time = 0.01

lower_red = np.array([150, 60, 60])
upper_red = np.array([180, 255, 255])
lower_blue = np.array([90, 70, 40])
upper_blue = np.array([120, 255, 255])
lower_green = np.array([50, 60, 80])
upper_green = np.array([80, 255, 255])
lower_yellow = np.array([0, 80, 110])
upper_yellow = np.array([30, 255, 255])


W_View_size = 640
H_View_size = 480
FPS = 90  # PI CAMERA: 320 x 240 = MAX 90

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

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    blur = cv2.GaussianBlur(gray, (3, 3), 0)
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)  # BGR을 HSV모드로 전환

    if ret:  # 사진 가져오는것을 성공할 경우
        cv2.imshow('Original', frame)

    else:
        print('cannot load camera!')
        break

    k = cv2.waitKey(25)
    if k == 27:
        break


# ----------------------------------------------------------------------------------------------------
    if k == ord('a'):  # 동서남북 검출
        print("********** 동서남북 검출 **********")
        ret, mask_black = cv2.threshold(blur, 90, 255, cv2.THRESH_BINARY_INV)  # 이진화
        cv2.imshow("frame1", frame)
        res_ewsn = mode_ewsn(mask_black, frame)

    # --------------------------------------------------
    if k == ord('b'):  # 화살표 검출
        print("********** 화살표 검출 **********")
        cv2.imshow("framee", frame)
        ret, mask_black = cv2.threshold(blur, 90, 255, cv2.THRESH_BINARY_INV)  # 이진화
        res_arrow = mode_arrow(mask_black, frame)

    # --------------------------------------------------
    elif k == ord('c'):  # 알파벳색상 검출
        print("********** 알파벳색상 검출 **********")
        mask_blue = cv2.inRange(hsv, lower_blue, upper_blue)

        res_alphacolor = mode_alpha_color(mask_blue)

    # --------------------------------------------------
    elif k == ord('d'):  # ABCD 검출
        print("********** ABCD 검출 **********")
        if res_alphacolor == 128: # 파랑
            mask_blueOrRed = cv2.inRange(hsv, lower_blue, upper_blue)
        elif res_alphacolor == 130: # 빨강
            mask_blueOrRed = cv2.inRange(hsv, lower_red, upper_red)

        res_abcd = mode_abcd(mask_blueOrRed)

    # --------------------------------------------------
    elif k == ord('e'):  # 구역색상 검출
        print("********** 구역색상 검출 **********")
        mask_green = cv2.inRange(hsv, lower_green, upper_green)

        res_area = mode_area_color(mask_green)

    # --------------------------------------------------
    elif k == ord('f'):  # 안전구역미션수행 확인
        res_alphacolor = 128  ###############################################################임시!!!!
        print("********** 안전구역미션수행 확인 **********")
        mask_green = cv2.inRange(hsv, lower_green, upper_green)

        if res_alphacolor == 128:
            mask_blueOrRed = cv2.inRange(hsv, lower_blue, upper_blue)
        elif res_alphacolor == 130:
            mask_blueOrRed = cv2.inRange(hsv, lower_red, upper_red)

        mission = mode_mission_save(mask_green, mask_blueOrRed)

    # --------------------------------------------------
    elif k == ord('g'):  # 확진구역미션수행 확인
        res_alphacolor = 128  ###############################################################임시!!!!
        print("********** 확진구역미션수행 확인 **********")
        ret, mask_black = cv2.threshold(blur, 60, 255, cv2.THRESH_BINARY_INV)  # 이진화

        if res_alphacolor == 128:
            mask_blueOrRed = cv2.inRange(hsv, lower_blue, upper_blue)
        elif res_alphacolor == 130:
            mask_blueOrRed = cv2.inRange(hsv, lower_red, upper_red)

        mission = mode_mission_escape(mask_black, mask_blueOrRed)

    # --------------------------------------------------
    elif k == ord('h'):  # 라인트레이싱
        print("********** 라인트레이싱 **********")
        mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)  # 노랑최소최대값을 이용해서 maskyellow값지정

        res_line = mode_linetracer(mask_yellow, frame)

    # --------------------------------------------------
    elif k == ord('i'):  # 우유곽 x좌표 찾기
        res_alphacolor = 128  ###############################################################임시!!!!
        print("********** 우유곽 x좌표 찾기 **********")
        if res_alphacolor == 128:
            mask_blueOrRed = cv2.inRange(hsv, lower_blue, upper_blue)
        elif res_alphacolor == 130:
            mask_blueOrRed = cv2.inRange(hsv, lower_red, upper_red)

        res_xpos = mode_xpos(mask_blueOrRed)

    # --------------------------------------------------
    elif k == ord('j'):  # 우유곽 y좌표 찾기
        res_alphacolor = 128  ###############################################################임시!!!!
        print("********** 우유곽 y좌표 찾기 **********")
        if res_alphacolor == 128:
            mask_blueOrRed = cv2.inRange(hsv, lower_blue, upper_blue)
        elif res_alphacolor == 130:
            mask_blueOrRed = cv2.inRange(hsv, lower_red, upper_red)

        res_ypos = mode_ypos(mask_blueOrRed)

    # --------------------------------------------------
    elif k == ord('k'):  # 안전구역에 들어가기
        print("********** 안전구역에 들어가기 **********")
        mask_green = cv2.inRange(hsv, lower_green, upper_green)

        res_save = mode_milk_save(mask_green)

    # --------------------------------------------------
    elif k == ord('l'):  # 확진구역에서 나가기
        print("********** 확진구역에서 나가기 **********")
        ret, mask_black = cv2.threshold(blur, 60, 255, cv2.THRESH_BINARY_INV)  # 이진화

        res_escape = mode_milk_escape(mask_black)

    # --------------------------------------------------
    elif k == ord('m'): #미션완료 후 코너 찾기
        print("********** 미션완료 후 코너 찾기 **********")
        mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)  # 노랑최소최대값을 이용해서 maskyellow값지정

        res_corner = mode_corner(mask_yellow)



# ----------------------------------------------------------------------------------------------------
cap.release()
cv2.destroyAllWindows()
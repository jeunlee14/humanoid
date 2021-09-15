import cv2
import numpy as np
import os
from MISSION import *

serial_use = 1

serial_port = None
Read_RX = 0
receiving_exit = 1
threading_Time = 0.01

lower_yellow = np.array([10, 50, 80])
upper_yellow = np.array([30, 255, 255])

def mode_linetracer(binary_line, frame):
    line ='인식안됨'
    add = ''
    x,w,y,h,x_center, y_center,lu,ld,ru,rd = -1,-1,-1,-1,-1,-1,-1,-1,-1,-1

    pixels = cv2.countNonZero(binary_line)
    # print('pixel = ', pixels)

    if pixels > 5000:
        # 모폴로지 연산(흰색영역 확장) 후 컨투어
        #kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (1, 1))
        kernel = np.ones((5, 5), np.uint8)

        binary_line_dil = cv2.dilate(binary_line, kernel, iterations=2)
        cv2.imshow('binary_line_mor', binary_line_dil)
        #binary_line_mor = cv2.morphologyEx(binary_line_temp, cv2.MORPH_OPEN, kernel)
        #binary_line_dil = cv2.dilate(binary_line, kernel)
        # cv2.imshow('binary_line_dil', binary_line_dil)

        contours, hierarchy = cv2.findContours(binary_line_dil, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)  # 컨투어

        # 컨투어된 영역중에서 제일 큰 부분만 선택 (배경 제거)
        max_contour = None
        max_area = -1

        for contour in contours:
            area = cv2.contourArea(contour)
            if area > max_area:
                max_area = area
                max_contour = contour

        x, y, w, h = cv2.boundingRect(max_contour)
        x_center = x + (w / 2)
        y_center = y + (h / 2)
        cv2.rectangle(frame, (x, y), (x + w, y + h), 255, 3)

        print(" \nx = %d, w = %d, y = %d, h = %d" % (x, w, y, h))
        print(' x_center = %d, y_center = %d' % (x_center, y_center))

        frame_lu = binary_line_dil[y:y + 40, x:x + 40]  # 왼쪽 상단
        frame_ld = binary_line_dil[y + h - 40:y + h, x:x + 40] # 왼쪽 하단
        frame_ru = binary_line_dil[y:y + 40, x + w - 40:x + w] # 오른쪽 상단
        frame_rd = binary_line_dil[y + h - 40:y + h, x + w - 40:x + w]  # 오른쪽 하단

        cv2.rectangle(frame, (x, y), (x + 40, y + 40), (0, 0, 255), 2)
        cv2.rectangle(frame, (x, y + h - 40), (x + 40, y + h), (0, 0, 255), 2)
        cv2.rectangle(frame, (x + w - 40, y), (x + w, y + 40), (0, 0, 255), 2)
        cv2.rectangle(frame, (x + w - 40, y + h - 40), (x + w, y + h), (0, 0, 255), 2)

        lu, ld, ru, rd = 0, 0, 0, 0
        if cv2.countNonZero(frame_lu) >= 100: lu = 1
        if cv2.countNonZero(frame_ld) >= 100: ld = 1
        if cv2.countNonZero(frame_ru) >= 100: ru = 1
        if cv2.countNonZero(frame_rd) >= 100: rd = 1
        print('lu = ', cv2.countNonZero(frame_lu), ', ld = ', cv2.countNonZero(frame_ld), ', ru = ',cv2.countNonZero(frame_ru), ', rd = ', cv2.countNonZero(frame_rd))

        if lu == 1 and ld == 1 and ru == 1 and rd == 1:  # 직선
            line = 'straight'
            if w < 61:
                line += '직진'
                if x_center >= 480:  # 오른쪽

                    add = 'To the left'
                elif x_center >= 160:  # 직진

                    add = 'go!'
                else:  # 왼쪽

                    add = 'To the right!'

        elif lu == 1 and ld == 1 and ru == 1 and rd == 0:  # 우회전 코너
            line = 'Right turn corner'
            if x >= 480:  # 오른쪽

                print('오른쪽')
            elif x >= 160:
                if y >= 240:  # 코너

                    print('코너')
                else:  # 직진

                    print('직진')
            else:  # 왼쪽

                print('왼쪽')

        elif lu == 1 and ld == 0 and ru == 1 and rd == 1:  # 좌회전 코너
            line = 'Left turn corner'
            if (x + w) >= 480:  # 오른쪽

                print('오른쪽')
            elif (x + w) >= 160:
                if y >= 240:  # 코너

                    print('좌회전 코너')
                else:  # 직진

                    print('직진')
            else:   #왼쪽
                print('왼쪽')

        elif lu == 1 and ld == 1 and ru == 0 and rd == 0:  # 우회전 문 앞
            print('라인 우회전 문 앞')
            if x >= 480:  # 오른쪽
                line = 130
                print('오른쪽')
            elif x >= 160:
                frame_door = binary_line_dil[280:480, x + w - 40:x + w]
                if cv2.countNonZero(frame_door) >= 100:  # 문 앞

                    print('문 앞')
                else:  # 직진

                    print('직진')
            else:  # 왼쪽

                print('왼쪽')

        elif lu == 0 and ld == 0 and ru == 1 and rd == 1:  # 좌회전 문 앞
            print('라인 좌회전 문 앞')
            if (x + w) >= 480:  # 오른쪽

                print('오른쪽')
            elif (x + w) >= 160:
                frame_door = binary_line_dil[280:480, x:x + 40]
                if cv2.countNonZero(frame_door) >= 100:  # 문 앞

                    print('문 앞')
                else:  # 직진

                    print('직진')
            else:  # 왼쪽
                line = 128
                print('왼쪽')

        elif (lu == 0 and ld == 1 and ru == 1 and rd == 0) or (lu == 0 and ld == 1 and ru == 1 and rd == 1) \
                or (lu == 0 and ld == 1 and ru == 0 and rd == 0):  # 오른쪽으로 기울어진 경우
            line = 'Tilted to the right'
            if not (w >= 600 and h < 320):
                if x >= 480:  # 오른쪽

                    print('오른쪽')
                elif x >= 160:  # 오른쪽턴10

                    print('오른쪽턴10')
                else:  # 왼쪽

                    print('왼쪽')

        elif (lu == 1 and ld == 0 and ru == 0 and rd == 1) or (lu == 1 and ld == 1 and ru == 0 and rd == 1) \
                or (lu == 0 and ld == 0 and ru == 0 and rd == 1):  # 왼쪽으로 기울어진 경우
            line = 'Tilted to the left'
            if not (w >= 600 and h < 320):
                if (x + w) >= 480:  # 오른쪽

                    print('오른쪽')
                elif (x + w) >= 160:  # 왼쪽턴10

                    print('왼쪽턴10')
                else:  # 왼쪽

                    print('왼쪽')

        elif lu == 1 and ld == 0 and ru == 0 and rd == 0:  # 오른쪽으로 기울어진 코너
            line = 'Corner tilted to the right'

            print('오른쪽턴10')

        elif lu == 0 and ld == 0 and ru == 1 and rd == 0:  # 왼쪽으로 기울어진 코너
            line = 'Corner tilted to the left'

            print('왼쪽턴10')

    print('line = ', line)
    #print('add = ', add)
    #cv2.putText(frame, str(line), (100, 100), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (255, 0, 0), 1)
    #cv2.putText(frame, str(add) , (100, 120), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (255, 0, 0), 1)
    #cv2.putText(frame, str(' x,  w,  y,  h'), (120, 20), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (0, 0, 0), 1)
    #cv2.putText(frame, str((x, w, y, h)), (70,100), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (0, 0, 0), 1)
    #cv2.putText(frame, str((x_center, y_center)), (90, 130), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (0, 0, 0), 1)
    #cv2.putText(frame, str((lu, ld, ru, rd)), (100, 160), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (0, 0, 0), 1)

    cv2.imshow('line', frame)

    return frame


if __name__ == '__main__':

    cnt = 63
    for i in os.listdir('D:/corner/'): #C:/line/straight/
        path = 'D:/corner/' + i
        #print("i=", i)

        line_image = cv2.imread(path, cv2.IMREAD_COLOR)
        cv2.imshow("line",line_image)
        blur = cv2.GaussianBlur(line_image, (3, 3), 0)
        hsv = cv2.cvtColor(blur, cv2.COLOR_BGR2HSV)
        mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)  # 노랑최소최대값을 이용해서 maskyellow값지정

        res_line = mode_linetracer(mask_yellow, blur)
        # cv2.imshow("origin", blur)
        # cv2.imshow("mask_yellow", mask_yellow)

        name = 'D:/line/res' + str(cnt) + '.jpg'
        print(name)
        cv2.imwrite(name, res_line)
        cnt += 1
        k = cv2.waitKey(0)
        if k == 27:
            break
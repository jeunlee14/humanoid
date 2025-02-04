import cv2
import numpy as np
import os

lower_yellow = np.array([0, 58, 50])
upper_yellow = np.array([255, 180, 122])

def mode_linetracer(blur):
    line = 'error'
    res = 129

    YCrCb = cv2.cvtColor(blur, cv2.COLOR_BGR2YCR_CB)
    mask_yellow = cv2.inRange(YCrCb, lower_yellow, upper_yellow)

    pixels = cv2.countNonZero(mask_yellow)
    print(pixels)

    if pixels < 4000:
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


    cv2.drawContours(blur, [box], 0, (0, 0, 255), 3)
    cv2.putText(blur, str(ang), (10, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
    # cv2.putText(blur, str(error), (10, 120), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 0), 2)
    # cv2.line(image, (int(x_min), 150), (int(x_min), 102), (255, 0, 0), 3)

    cv2.imshow('blur', blur)
    return res

if __name__ == '__main__':

    for i in os.listdir('D:/data/'):  # C:/line/straight/
        path = 'D:/data/' + i
        # print("i=", i)

        image = cv2.imread(path, cv2.IMREAD_COLOR)
        print(i)
        blur = cv2.GaussianBlur(image, (3, 3), 0)

        # 함수 호출
        mode_linetracer(blur)

        k = cv2.waitKey(0)
        if k == 27:
            break

import cv2

def mode_linetracer(binary_line, frame):
    line = 129

    pixels = cv2.countNonZero(binary_line)
    # print('pixel = ', pixels)

    if pixels > 5000:
        # 모폴로지 연산(흰색영역 확장) 후 컨투어
        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3))
        binary_line_dil = cv2.dilate(binary_line, kernel)
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

        print(" x = %d, w = %d" % (x, w))
        #print(' y = %d, h = %d' % (y, h))
        #print(' x_center = %d, y_center = %d' % (x_center, y_center))

        frame_lu = binary_line_dil[y:y + 40, x:x + 40]
        frame_ld = binary_line_dil[y + h - 40:y + h, x:x + 40]
        frame_ru = binary_line_dil[y:y + 40, x + w - 40:x + w]
        frame_rd = binary_line_dil[y + h - 40:y + h, x + w - 40:x + w]

        cv2.rectangle(frame, (x, y), (x + 40, y + 40), (0, 0, 255), 2)
        cv2.rectangle(frame, (x, y + h - 40), (x + 40, y + h), (0, 0, 255), 2)
        cv2.rectangle(frame, (x + w - 40, y), (x + w, y + 40), (0, 0, 255), 2)
        cv2.rectangle(frame, (x + w - 40, y + h - 40), (x + w, y + h), (0, 0, 255), 2)


        lu, ld, ru, rd = 0, 0, 0, 0
        if cv2.countNonZero(frame_lu) >= 100:
            lu = 1
        if cv2.countNonZero(frame_ld) >= 100:
            ld = 1
        if cv2.countNonZero(frame_ru) >= 100:
            ru = 1
        if cv2.countNonZero(frame_rd) >= 100:
            rd = 1
        #print('lu = ', cv2.countNonZero(frame_lu), ', ld = ', cv2.countNonZero(frame_ld), ', ru = ',cv2.countNonZero(frame_ru), ', rd = ', cv2.countNonZero(frame_rd))

        if lu == 1 and ld == 1 and ru == 1 and rd == 1:  # 직선
            print('라인 직선')
            if w < 170:
                if x_center >= 480:  # 오른쪽
                    line = 130
                    print('왼쪽 옆으로 가기')
                elif x_center >= 160:  # 직진
                    line = 111
                    print('직진')
                else:  # 왼쪽
                    line = 128
                    print('오른쪽 옆으로 가기')

        elif lu == 1 and ld == 1 and ru == 1 and rd == 0:  # 우회전 코너
            print('라인 우회전 코너')
            if x >= 480:  # 오른쪽
                line = 130
                #print('오른쪽')
            elif x >= 160:
                if y >= 240:  # 코너
                    line = 126
                    #print('코너')
                else:  # 직진
                    line = 111
                    #print('직진')
            else:  # 왼쪽
                line = 128
                print('왼쪽')

        elif lu == 1 and ld == 0 and ru == 1 and rd == 1:  # 좌회전 코너
            print('라인 좌회전 코너')
            if (x + w) >= 480:  # 오른쪽
                line = 130
                #print('오른쪽')
            elif (x + w) >= 160:
                if y >= 240:  # 코너
                    line = 126
                    #print('좌회전 코너')
                else:  # 직진
                    line = 111
                    #print('직진')
            else:  # 왼쪽
                line = 128
                print('왼쪽')

        elif lu == 1 and ld == 1 and ru == 0 and rd == 0:  # 우회전 문 앞
            print('라인 우회전 문 앞')
            if x >= 480:  # 오른쪽
                line = 130
                print('오른쪽')
            elif x >= 160:
                frame_door = binary_line_dil[280:480, x + w - 40:x + w]
                if cv2.countNonZero(frame_door) >= 100:  # 문 앞
                    line = 112
                    print('문 앞')
                else:  # 직진
                    line = 111
                    print('직진')
            else:  # 왼쪽
                line = 128
                print('왼쪽')

        elif lu == 0 and ld == 0 and ru == 1 and rd == 1:  # 좌회전 문 앞
            print('라인 좌회전 문 앞')
            if (x + w) >= 480:  # 오른쪽
                line = 130
                print('오른쪽')
            elif (x + w) >= 160:
                frame_door = binary_line_dil[280:480, x:x + 40]
                if cv2.countNonZero(frame_door) >= 100:  # 문 앞
                    line = 112
                    print('문 앞')
                else:  # 직진
                    line = 111
                    print('직진')
            else:  # 왼쪽
                line = 128
                print('왼쪽')

        elif (lu == 0 and ld == 1 and ru == 1 and rd == 0) or (lu == 0 and ld == 1 and ru == 1 and rd == 1) \
                or (lu == 0 and ld == 1 and ru == 0 and rd == 0):  # 오른쪽으로 기울어진 경우
            print('오른쪽으로 기울어진 경우')
            if not (w >= 600 and h < 320):
                if x >= 480:  # 오른쪽
                    line = 130
                    #print('오른쪽')
                elif x >= 160:  # 오른쪽턴10
                    line = 119
                    #print('오른쪽턴10')
                else:  # 왼쪽
                    line = 128
                    #print('왼쪽')

        elif (lu == 1 and ld == 0 and ru == 0 and rd == 1) or (lu == 1 and ld == 1 and ru == 0 and rd == 1) \
                or (lu == 0 and ld == 0 and ru == 0 and rd == 1):  # 왼쪽으로 기울어진 경우
            print('왼쪽으로 기울어진 경우')
            if not (w >= 600 and h < 320):
                if (x + w) >= 480:  # 오른쪽
                    line = 130
                    #print('오른쪽')
                elif (x + w) >= 160:  # 왼쪽턴10
                    line = 125
                    #print('왼쪽턴10')
                else:  # 왼쪽
                    line = 128
                    #print('왼쪽')

        elif lu == 1 and ld == 0 and ru == 0 and rd == 0:  # 오른쪽으로 기울어진 코너
            print('오른쪽으로 기울어진 코너')
            line = 119
            #print('오른쪽턴10')

        elif lu == 0 and ld == 0 and ru == 1 and rd == 0:  # 왼쪽으로 기울어진 코너
            print('왼쪽으로 기울어진 코너')
            line = 125
            #print('왼쪽턴10')

    #print('line = ', line)
    cv2.imshow('line', frame)
    return line

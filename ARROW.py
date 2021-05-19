import cv2

def mode_arrow(binary, frame):
    arrow = 129

    # 모폴로지 연산(흰색영역 확장) 후 컨투어
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 5))
    binary_dil = cv2.dilate(binary, kernel)
    contours, hierarchy = cv2.findContours(binary_dil, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)

    if not (len(contours) == 0) :
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
        # cv2.drawContours(frame, [hull], 0, (255, 0, 100), 4)
        cv2.drawContours(frame, [max_contour], 0, (255, 255, 0), 3)
        defects = cv2.convexityDefects(max_contour, hull)

        left, right = 0, 0
        x, y = 10, 10

        print(defects)
        print(defects.shape)
        # 결함의 주변 좌표가 컨투어 영역 안에 있는지 밖에 있는지 확인
        for i in range(defects.shape[0]):
            s, e, f, d = defects[i, 0]
            fx, fy = map(int, tuple(max_contour[f][0]))

            if d > 1000:
                if cv2.pointPolygonTest(max_contour, (fx + x, fy + y), False) >= 0:
                    right += 1
                    cv2.circle(frame, (fx + x, fy + y), 5, (0, 0, 255), -1)

                if cv2.pointPolygonTest(max_contour, (fx + x, fy - y), False) >= 0:
                    right += 1
                    cv2.circle(frame, (fx + x, fy - y), 5, (0, 0, 255), -1)

                if cv2.pointPolygonTest(max_contour, (fx - x, fy + y), False) >= 0:
                    left += 1
                    cv2.circle(frame, (fx - x, fy + y), 5, (0, 0, 255), -1)

                if cv2.pointPolygonTest(max_contour, (fx - x, fy - y), False) >= 0:
                    left += 1
                    cv2.circle(frame, (fx - x, fy - y), 5, (0, 0, 255), -1)

                cv2.circle(frame, (d, d), 5, (255, 0, 0), -1)

        if left < right:
            arrow = 'Right Arrow'
            print('오른쪽')
        else:
            arrow = 'Left Arrow'
            print('왼쪽')

        print("화살표방향 :", arrow)
        cv2.putText(frame, arrow, (150, 100), cv2.FONT_HERSHEY_PLAIN, 4, (255, 255, 0), 5)
        cv2.imshow('frame2', frame)

    return arrow



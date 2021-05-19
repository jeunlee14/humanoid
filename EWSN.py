import cv2

def mode_ewsn(binary, frame):
    #cv2.imshow("binary", binary)
    ewsn = 129

    # 모폴로지 연산(열림연산) 후 컨투어
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 5))
    binary_ero = cv2.erode(binary, kernel)  #검은색 팽창연산
    cv2.imshow("binary_ero", binary_ero)
    contours, _ = cv2.findContours(binary_ero, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    #cv2.drawContours(frame, contours, -1, (255, 255, 0), -1) # 배경제거 전 컨투어
    #cv2.imshow("frame", frame)

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

    cv2.drawContours(frame, approx, -1, (255, 0, 0), 5)
    cv2.putText(frame, str(vertices), (100, 100), cv2.FONT_HERSHEY_COMPLEX_SMALL, 3, (255, 0, 0), 3)


    if vertices >= 18:
        ewsn = 'S'
        print('남')
    elif vertices <= 12:
        ewsn = 'N'
        print('북')
    else:
        # 사각형으로 컨투어
        x, y, w, h = cv2.boundingRect(max_contour)
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0,0,255), 1)
        if abs(w - h) >= 60:
            ewsn = 'E'
            print('동')
        else:
            ewsn = 'W'
            print('서')

    cv2.putText(frame, ewsn, (100,170), cv2.FONT_HERSHEY_COMPLEX_SMALL, 3, (0,0,255), 3)
    cv2.imshow("frame2", frame)
    print("방위 :", ewsn)
    return ewsn


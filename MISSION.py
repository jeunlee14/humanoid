import cv2

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

def mode_milk_save(binary_area):
    save = 129

    pixels_area = cv2.countNonZero(binary_area)

    if pixels_area > 1000:
        test_frame = binary_area[241:480, :]
        pixels = cv2.countNonZero(test_frame)
        cv2.imshow("milk", test_frame)

        if pixels > 69120:  # =240*640*0.45
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

    pixels_area = cv2.countNonZero(binary_area)

    if pixels_area > 1000:
        test_frame = binary_area[0:240, :]
        pixels = cv2.countNonZero(test_frame)
        cv2.imshow("milk", test_frame)

        if pixels <= 9216:  # =240*640*0.08
            escape = 130
            print('성공')

        else:
            escape = 128
            print('실패')

    print("확진구역우유결과 :", escape)
    return escape

def mode_mission_save(binary_area, binary_milk):
    mission = 129

    pixels_area = cv2.countNonZero(binary_area)
    pixels_milk = cv2.countNonZero(binary_milk)

    if pixels_area > 1000 and pixels_milk > 1000:
        # 모폴로지 연산(흰색영역 확장) 후 컨투어
        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 5))
        binary_area_dil = cv2.dilate(binary_area, kernel)

        contours, hierarchy = cv2.findContours(binary_area_dil, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)  # 컨투어

        for c in contours:
            hull = cv2.convexHull(c)
            cv2.drawContours(binary_area_dil, [hull], 0, (255, 255, 255), -1)
        cv2.imshow('area', binary_area_dil)

        result = cv2.bitwise_and(binary_area_dil, binary_milk)
        pixels_result = cv2.countNonZero(result)
        cv2.imshow('result', result)

        if pixels_result > pixels_milk * 0.5:
            mission = 130  # 성공
            print('성공')
        else:
            mission = 128  # 실패
            print('실패')

    print("안전구역미션수행결과 :", mission)
    return mission


# ----------------------------------------------------------------------------------------------------
def mode_mission_escape(binary_area, binary_milk):
    mission = 129

    pixels_area = cv2.countNonZero(binary_area)
    pixels_milk = cv2.countNonZero(binary_milk)

    if pixels_area > 1000 and pixels_milk > 1000:
        # 모폴로지 연산(흰색영역 확장) 후 컨투어
        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 5))
        binary_area_dil = cv2.dilate(binary_area, kernel)

        contours, hierarchy = cv2.findContours(binary_area_dil, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)  # 컨투어

        for c in contours:
            hull = cv2.convexHull(c)
            cv2.drawContours(binary_area_dil, [hull], 0, (255, 255, 255), -1)

        result = cv2.bitwise_and(binary_area_dil, binary_milk)
        pixels_result = cv2.countNonZero(result)

        if pixels_result < pixels_milk * 0.5:
            mission = 130  # 성공
            print('성공')
        else:
            mission = 128  # 실패
            print('성공')

    print("안전구역미션수행결과 :", mission)
    return mission


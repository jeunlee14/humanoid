import cv2

def onChange(x):
    pass

def bar():
    cv2.namedWindow('Grayscale_threshold_setting')

    cv2.createTrackbar('Threshold', 'Grayscale_threshold_setting', 0, 255, onChange)
    cv2.setTrackbarPos('Threshold', 'Grayscale_threshold_setting', 255)

bar()

def showcam():
    try:
        print('open cam')
        cap = cv2.VideoCapture(0)
    except:
        print('Not working')
        return
    cap.set(3, 350)
    cap.set(4, 350)
    while True:
        ret, frame = cap.read()
        Thres = cv2.getTrackbarPos('Threshold', 'Grayscale_threshold_setting')
        gray2 = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        ret, thr = cv2.threshold(gray2, Thres, 255, cv2.THRESH_BINARY)
        cv2.imshow('frame', frame)
        cv2.imshow('thr', thr)
        k = cv2.waitKey(1) & 0xFF
        if k == 27:
            break
    cap.release()
    cv2.destroyAllWindows()
showcam()
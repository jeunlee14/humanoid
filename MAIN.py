import cv2
import timeit
import serial
import FindMilk

serial_use = 1

serial_port = None
Read_RX = 0
receiving_exit = 1
threading_Time = 0.01
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
        res = FindMilk.find_milk(blur, frame)
        print('res=', res)
        TX_data_py2(serial_port, res)


    # ----------------------------------------------------------------------------------------------------
    cap.release()
    cv2.destroyAllWindows()

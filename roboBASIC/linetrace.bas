'******** 2족 보행로봇 초기 영점 프로그램 ********
'******** INIT 지정 ********
DIM 호출함수 AS BYTE
DIM 인식실패횟수 AS BYTE
DIM 화살표 AS BYTE

CONST 인식실패= 129
CONST 방위인식= 201
CONST 화살표인식= 202
CONST 문열고들어가기= 203
CONST 문열고들어가기2 = 204
CONST 알파벳색상인식= 205
CONST 알파벳인식= 206
CONST 구역색상인식= 207
CONST 라인트레이싱= 210
CONST 동쪽 = 113
CONST 서쪽 = 114
CONST 남쪽 = 112
CONST 북쪽 = 111
CONST 오른쪽 = 113
CONST 왼쪽 = 114

DIM 동작모드_old AS BYTE
DIM 동작모드 AS BYTE
DIM 이동방향 AS BYTE
DIM 확인구역수 AS BYTE
DIM 알파벳색상 AS BYTE
DIM 알파벳 AS BYTE
DIM 구역 AS BYTE
DIM 확진구역1 AS BYTE
DIM 확진구역2 AS BYTE
DIM 확진구역3 AS BYTE
DIM 확인 AS BYTE
DIM 회전수 AS BYTE
DIM cnt AS BYTE
DIM xcount AS BYTE
DIM ycount AS BYTE
DIM 결과 AS BYTE
'******** 기본 설정 *********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE
DIM 보행순서 AS BYTE
DIM 현재전압 AS BYTE
DIM 반전체크 AS BYTE
DIM 모터ONOFF AS BYTE
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER

DIM 곡선방향 AS BYTE

DIM 넘어짐확인 AS BYTE
DIM 기울기확인횟수 AS BYTE
DIM 보행횟수 AS BYTE
DIM 보행COUNT AS BYTE

DIM 적외선거리값  AS BYTE

DIM S11  AS BYTE
DIM S16  AS BYTE
'************************************************
DIM NO_0 AS BYTE
DIM NO_1 AS BYTE
DIM NO_2 AS BYTE
DIM NO_3 AS BYTE
DIM NO_4 AS BYTE

DIM NUM AS BYTE

DIM BUTTON_NO AS INTEGER
DIM SOUND_BUSY AS BYTE
DIM TEMP_INTEGER AS INTEGER

'**** 기울기센서포트 설정 ****
CONST 앞뒤기울기AD포트 = 0
CONST 좌우기울기AD포트 = 1
CONST 기울기확인시간 = 20  'ms

CONST 적외선AD포트  = 4


CONST min = 61	'뒤로넘어졌을때
CONST max = 107	'앞으로넘어졌을때
CONST COUNT_MAX = 3


CONST 머리이동속도 = 10
'************************************************

PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번
DIR G6D,0,1,1,0,1,1		'모터18~23번
DIR G6B,1,1,1,1,1,1		'모터6~11번
DIR G6C,0,0,0,0,1,0		'모터12~17번

'************************************************

OUT 52,0	'머리 LED 켜기
'***** 초기선언 '************************************************

보행순서 = 0
반전체크 = 0
기울기확인횟수 = 0
보행횟수 = 1
모터ONOFF = 0

'****초기위치 피드백*****************************


TEMPO 230
MUSIC "cdefg"


SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16

SERVO 16, 100


GOSUB 전원초기자세
GOSUB 기본자세


GOSUB 자이로INIT
GOSUB 자이로MID
GOSUB 자이로ON

PRINT "OPEN 20GongMo.mrs !"
PRINT "VOLUME 200 !"
PRINT "SOUND 12 !" '안녕하세요

GOSUB All_motor_Reset


'GOTO MAIN	'시리얼 수신 루틴으로 가기

GOTO MAIN
'************************************************


'****************************************************
시작음:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '****************************************
종료음:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '****************************************
에러음:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************


    '************************************************
Number_Play: '  BUTTON_NO = 숫자대입
    GOSUB NUM_TO_ARR

    PRINT "NPL "
    '*************
    NUM = NO_4
    GOSUB NUM_1_9
    '*************
    NUM = NO_3
    GOSUB NUM_1_9
    '*************
    NUM = NO_2
    GOSUB NUM_1_9
    '*************
    NUM = NO_1
    GOSUB NUM_1_9
    '*************
    NUM = NO_0
    GOSUB NUM_1_9
    PRINT " !"

    GOSUB SOUND_PLAY_CHK
    PRINT "SND 16 !"
    GOSUB SOUND_PLAY_CHK
    RETURN
    '************************************************
NUM_TO_ARR:
    NO_4 =  BUTTON_NO / 10000
    TEMP_INTEGER = BUTTON_NO MOD 10000	'MOD 나머지 연산자

    NO_3 =  TEMP_INTEGER / 1000
    TEMP_INTEGER = BUTTON_NO MOD 1000

    NO_2 =  TEMP_INTEGER / 100
    TEMP_INTEGER = BUTTON_NO MOD 100

    NO_1 =  TEMP_INTEGER / 10
    TEMP_INTEGER = BUTTON_NO MOD 10

    NO_0 =  TEMP_INTEGER

    RETURN
    '************************************************
NUM_1_9:
    IF NUM = 1 THEN
        PRINT "1"
    ELSEIF NUM = 2 THEN
        PRINT "2"
    ELSEIF NUM = 3 THEN
        PRINT "3"
    ELSEIF NUM = 4 THEN
        PRINT "4"
    ELSEIF NUM = 5 THEN
        PRINT "5"
    ELSEIF NUM = 6 THEN
        PRINT "6"
    ELSEIF NUM = 7 THEN
        PRINT "7"
    ELSEIF NUM = 8 THEN
        PRINT "8"
    ELSEIF NUM = 9 THEN
        PRINT "9"
    ELSEIF NUM = 0 THEN
        PRINT "0"
    ENDIF

    RETURN
    '************************************************
SOUND_PLAY_CHK:
    DELAY 60
    SOUND_BUSY = IN(46)
    IF SOUND_BUSY = 1 THEN GOTO SOUND_PLAY_CHK
    DELAY 50

    RETURN
    '************************************************


    '************************************************
    '**** 자이로감도 설정 ****
자이로INIT:
    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0
    RETURN
    '****************************************
    '**** 자이로감도 설정 ****
자이로MAX:
    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0
    RETURN
    '****************************************
자이로MID:
    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0
    RETURN
    '****************************************
자이로MIN:
    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '****************************************
자이로ON:
    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    자이로ONOFF = 1
    RETURN
    '****************************************
자이로OFF:
    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0

    자이로ONOFF = 0
    RETURN
    '************************************************


    '************************************************
    '전포트서보모터사용설정
MOTOR_ON:
    GOSUB MOTOR_GET
    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    모터ONOFF = 0
    GOSUB 시작음	
    RETURN

    '****************************************
    '전포트서보모터사용설정
MOTOR_OFF:
    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D

    모터ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB 종료음	
    RETURN
    '****************************************
    '위치값피드백
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN
    '****************************************
    '위치값피드백
MOTOR_SET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN
    '****************************************
All_motor_Reset:
    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1
    RETURN
    '****************************************
All_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2
    RETURN
    '****************************************
All_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3
    RETURN
    '****************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '****************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN
    '****************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '****************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '****************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '****************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1
    RETURN
    '****************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2
    RETURN
    '****************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3
    RETURN
    '************************************************


    '************************************************

머리오른쪽10도:
    SPEED 머리이동속도
    SERVO 11,110
    RETURN

머리오른쪽20도:
    SPEED 머리이동속도
    SERVO 11,120
    RETURN

머리오른쪽30도:
    SPEED 머리이동속도
    SERVO 11,130
    RETURN

머리오른쪽45도:
    SPEED 머리이동속도
    SERVO 11,145
    RETURN	

머리오른쪽60도:
    SPEED 머리이동속도
    SERVO 11,160
    RETURN

머리오른쪽70도:
    SPEED 머리이동속도
    SERVO 11,170
    RETURN	

머리오른쪽90도:
    SPEED 머리이동속도
    SERVO 11,190
    RETURN

    '****************************************

머리왼쪽10도:
    SPEED 머리이동속도
    SERVO 11,90
    RETURN

머리왼쪽30도:
    SPEED 머리이동속도
    SERVO 11,70
    RETURN

머리왼쪽45도:
    SPEED 머리이동속도
    SERVO 11,55
    RETURN

머리왼쪽60도:
    SPEED 머리이동속도
    SERVO 11,40
    RETURN

머리왼쪽70도:
    SPEED 머리이동속도
    SERVO 11,30
    RETURN

머리왼쪽90도:
    SPEED 머리이동속도
    SERVO 11,10
    RETURN

    '****************************************

머리좌우중앙:
    SPEED 머리이동속도
    SERVO 11,100
    RETURN

머리상하정면:
    SPEED 머리이동속도
    SERVO 11,100	
    SPEED 5
    GOSUB 기본자세
    GOTO MAIN

    '****************************************

전방하향100도:
    SPEED 3
    SERVO 16, 100
    RETURN

전방하향95도:
    SPEED 3
    SERVO 16, 95
    RETURN

전방하향90도:
    SPEED 3
    SERVO 16, 90
    RETURN

전방하향86도:
    SPEED 3
    SERVO 16, 86
    RETURN

전방하향85도:
    SPEED 3
    SERVO 16, 85
    RETURN

전방하향80도:
    SPEED 3
    SERVO 16, 80
    RETURN

전방하향70도:
    SPEED 3
    SERVO 16, 70
    RETURN

전방하향75도:
    SPEED 3
    SERVO 16, 75
    RETURN

전방하향67도:
    SPEED 3
    SERVO 16, 67
    RETURN

전방하향60도:
    SPEED 3
    SERVO 16, 65
    RETURN

전방하향50도:
    SPEED 3
    SERVO 16, 50
    RETURN

전방하향40도:
    SPEED 3
    SERVO 16, 40
    RETURN

전방하향35도:
    SPEED 3
    SERVO 16, 35
    RETURN

전방하향30도:
    SPEED 3
    SERVO 16, 30
    RETURN


전방하향20도:
    SPEED 3
    SERVO 16, 20
    RETURN

    '************************************************


    '************************************************
전원초기자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0
    RETURN
    '****************************************
안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0
    RETURN
    '****************************************
안정화자세_우유곽:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B, 190,  15,  55,  ,  ,
    MOVE G6C, 190,  15,  55,  ,  ,
    WAIT
    mode = 0
    RETURN
    '****************************************
기본자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    mode = 0
    RETURN
    '****************************************
기본자세_우유곽:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B, 190,  15,  55,  ,  ,
    MOVE G6C, 190,  15,  55,  ,  ,
    WAIT
    mode = 0
    RETURN
    '****************************************
기본자세_문열기:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B, 100, 100,  85,  ,  , '오른팔 조금 들고 왼팔 90도 들기
    MOVE G6C, 100,  50,  60,  ,  ,
    WAIT
    mode = 0
    RETURN
    '****************************************

차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    mode = 2
    RETURN
    '****************************************
앉은자세:
    GOSUB 자이로OFF
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    mode = 1
    RETURN
    '************************************************


    '************************************************
RX_EXIT:
    ERX 4800, A, MAIN

    GOSUB All_motor_Reset
    GOTO RX_EXIT
    '****************************************
GOSUB_RX_EXIT:
    ERX 4800, A, GOSUB_RX_EXIT2

    GOSUB All_motor_Reset
    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '************************************************


    '************************************************

적외선거리센서확인:
    ' Infrared_Distance = 60 ' About 20cm
    ' Infrared_Distance = 50 ' About 25cm
    ' Infrared_Distance = 40 ' About 35cm
    ' Infrared_Distance = 30 ' About 45cm
    ' Infrared_Distance = 20 ' About 65cm
    ' Infrared_Distance = 10 ' About 95cm

    적외선거리값 = AD(적외선AD포트)

    'IF 적외선거리값 > 60 THEN '60 = 적외선거리값 20cm
    '        'MUSIC "C"
    '        DELAY 400
    '    ELSEIF 적외선거리값 > 50 THEN '50 = 적외선거리값 = 25cm
    '        'MUSIC "C"
    '        DELAY 400
    '    ELSEIF 적외선거리값 > 40 THEN '30 = 적외선거리값  45cm
    '        'MUSIC "E"
    '        DELAY 600
    '    ELSEIF 적외선거리값 > 20 THEN '30 = 적외선거리값  45cm
    '        'MUSIC "C"
    '        DELAY 600
    '    ELSEIF 적외선거리값 > 18 THEN '30 = 적외선거리값  45cm
    '        'MUSIC "E"
    '        DELAY 500
    '    ELSEIF 적외선거리값 > 0 THEN '30 = 적외선거리값  45cm
    '        'MUSIC "G"
    '        DELAY 300
    '    ENDIF


    RETURN

    '********************************************
    '************************************************

앞뒤기울기측정:
    FOR i = 0 TO COUNT_MAX
        A = AD(앞뒤기울기AD포트)	'기울기 앞뒤
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF A < MIN THEN
        GOSUB 기울기앞
    ELSEIF A > MAX THEN
        GOSUB 기울기뒤
    ENDIF

    RETURN

    '****************************************

기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN
        ETX  4800,16
        GOSUB 뒤로일어나기
    ENDIF

    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN
        ETX  4800,15
        GOSUB 앞으로일어나기
    ENDIF

    RETURN

    '****************************************

좌우기울기측정:
    FOR i = 0 TO COUNT_MAX
        B = AD(좌우기울기AD포트)	'기울기 좌우
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB 기본자세	
    ENDIF

    RETURN

    '************************************************


    '************************************************

앞으로일어나기:
    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB 자이로OFF

    GOSUB All_motor_Reset

    SPEED 15
    MOVE G6A,100, 15,  70, 140, 100,
    MOVE G6D,100, 15,  70, 140, 100,
    MOVE G6B,20,  140,  15
    MOVE G6C,20,  140,  15
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 6
    MOVE G6A,100, 145,  45, 130, 100,
    MOVE G6D,100, 145,  45, 130, 100,
    WAIT

    SPEED 8
    GOSUB All_motor_mode2

    GOSUB 기본자세

    넘어짐확인= 1

    DELAY 200
    GOSUB 자이로ON


    ETX 4800, 호출함수


    GOTO MAIN_2

    '********************************************
    '************************************************

뒤로일어나기:
    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB 자이로OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB 기본자세

    MOVE G6A,90, 130, ,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 100, 100, 100
    WAIT

    MOVE G6B,170, 140,  10, 100, 100, 100
    MOVE G6C,170, 140,  10, 100, 100, 100
    WAIT

    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT

    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT

    GOSUB Leg_motor_mode3

    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT

    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    SPEED 10
    GOSUB 기본자세

    넘어짐확인= 1

    DELAY 200
    GOSUB 자이로ON


    ETX 4800, 호출함수


    GOTO MAIN_2

    '********************************************


    '************************************************

연속전진:
    보행속도 = 8
    좌우속도 = 4
    넘어짐확인 = 0
    보행COUNT= 0

    GOSUB Leg_motor_mode3


    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 3
        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 146,  93,  96
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 8
        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 147,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT

        GOTO 연속전진_1

    ELSE
        보행순서 = 0

        SPEED 3
        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 146,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 8
        MOVE G6D, 90, 90, 120, 105, 110,100
        MOVE G6A,110,  76, 147,  93,  96,100
        MOVE G6C,90
        MOVE G6B,110
        WAIT

        GOTO 연속전진_2

    ENDIF

    '************************************

연속전진_1:
    '전진 = 1

    'IF 동작모드 = 10 THEN '라인트레이싱
    ETX 4800, 호출함수

    'ENDIF


    SPEED 보행속도
    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode3
    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT


    SPEED 보행속도


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 연속전진_2
    IF A = 호출함수 THEN
        GOTO 연속전진_2
    ENDIF


    'IF 동작모드 = 2 THEN '화살표인식
    '        보행COUNT = 보행COUNT + 1
    '
    '        IF 보행COUNT = 3 THEN
    '            GOTO 연속전진_1_stop
    '        ELSE
    '            GOTO 연속전진_2
    '
    '        ENDIF
    '
    '    ELSEIF 동작모드 = 3 THEN '알파벳색상인식
    '        보행COUNT = 보행COUNT + 1
    '
    '        IF 보행COUNT = 4 THEN
    '            GOTO 연속전진_1_stop
    '        ELSE
    '            GOTO 연속전진_2
    '
    '        ENDIF
    '
    '    ELSEIF 동작모드 = 11 OR 동작모드 = 12 THEN '문열기
    '        IF 문열기 = 0 THEN '문열기 전
    '            GOTO 장애물감지_문_1
    '
    '        ELSEIF 문열기 = 1 THEN '문열기 후
    '            보행COUNT = 보행COUNT + 1
    '
    '            IF 보행COUNT = 8 THEN	
    '                문열기 = 0
    '
    '                GOTO 연속전진_1_stop
    '            ELSE
    '                GOTO 연속전진_2
    '
    '            ENDIF
    '
    '        ENDIF
    '
    '    ELSE '라인트레이싱
    '        ERX 4800,A, 연속전진_2
    '
    '        IF A <> 111 THEN
    '            GOTO 연속전진_1_stop
    '        ELSE
    '            GOTO 연속전진_2
    '
    '        ENDIF
    '
    '    ENDIF
    '

연속전진_1_stop:
    MOVE G6A,112,  76, 146,  93, 96,100
    MOVE G6D,90, 100, 100, 115, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 7
    MOVE G6A, 106,  76, 146,  93,  96,100
    MOVE G6D,  88,  71, 152,  91, 106,100
    MOVE G6B, 100
    MOVE G6C, 100
    WAIT

    SPEED 2
    GOSUB 기본자세
    DELAY 200


    RETURN

    '************************************

연속전진_2:
    '전진 = 2

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT


연속전진_3:
    'IF 동작모드 = 10 THEN '라인트레이싱
    ETX 4800, 호출함수

    'ENDIF


    SPEED 보행속도
    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT


    SPEED 보행속도


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 연속전진_4
    IF A = 호출함수 THEN
        GOTO 연속전진_4

    ENDIF


    'IF 동작모드 = 2 THEN '화살표인식
    '        보행COUNT = 보행COUNT + 1
    '
    '        IF 보행COUNT = 3 THEN
    '            GOTO 연속전진_3_stop
    '        ELSE
    '            GOTO 연속전진_4
    '
    '        ENDIF
    '
    '    ELSEIF 동작모드 = 3 THEN '알파벳색상인식
    '        보행COUNT = 보행COUNT + 1
    '
    '        IF 보행COUNT = 4 THEN
    '            GOTO 연속전진_3_stop
    '        ELSE
    '            GOTO 연속전진_4
    '
    '        ENDIF
    '
    '    ELSEIF 동작모드 = 11 OR 동작모드 = 12 THEN '문열기
    '        IF 문열기 = 0 THEN '문열기 전
    '            GOTO 장애물감지_문_2
    '
    '        ELSEIF 문열기 = 1 THEN '문열기 후
    '            보행COUNT = 보행COUNT + 1
    '
    '            IF 보행COUNT = 8 THEN
    '                문열기 = 0
    '
    '                GOTO 연속전진_3_stop
    '            ELSE
    '                GOTO 연속전진_4
    '
    '            ENDIF
    '
    '        ENDIF
    '
    '    ELSE '라인트레이싱
    '        ERX 4800,A, 연속전진_4
    '
    '        IF A <> 111 THEN
    '            GOTO 연속전진_3_stop
    '        ELSE
    '            GOTO 연속전진_4
    '
    '        ENDIF
    '
    '
    '    ENDIF


연속전진_3_stop:
    MOVE G6A, 90, 100, 100, 115, 110,100
    MOVE G6D,112,  76, 146,  93,  96,100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 7
    MOVE G6D, 106,  76, 146,  93,  96,100
    MOVE G6A,  88,  71, 152,  91, 106,100
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT

    SPEED 2
    GOSUB 기본자세
    DELAY 400


    RETURN


연속전진_4:
    '왼발들기10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO 연속전진_1

    '********************************************
    '************************************************

연속후진:
    보행속도 = 8
    좌우속도 = 4
    넘어짐확인 = 0
    보행COUNT= 0

    GOSUB Leg_motor_mode3


    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        MOVE G6A, 88,  71, 152,  91, 110
        MOVE G6D,108,  76, 145,  93,  96
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 10
        MOVE G6A, 90, 100, 100, 115, 110
        MOVE G6D,110,  76, 145,  93,  96
        MOVE G6B,90
        MOVE G6C,110
        WAIT

        GOTO 연속후진_1	

    ELSE
        보행순서 = 0

        SPEED 4
        MOVE G6D,  88,  71, 152,  91, 110
        MOVE G6A, 108,  76, 145,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 10
        MOVE G6D, 90, 100, 100, 115, 110
        MOVE G6A,110,  76, 145,  93,  96
        MOVE G6C,90
        MOVE G6B,110
        WAIT

        GOTO 연속후진_2

    ENDIF

    '************************************

연속후진_1:
    SPEED 보행속도
    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    '********************************오른발 시작

    SPEED 좌우속도
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, 연속후진_2

    IF A <> A_old THEN

        'IF 동작모드 = 4 THEN '알파벳인식
        '        보행COUNT = 보행COUNT + 1
        '
        '        IF 보행COUNT = 4 THEN
        '            GOTO 연속후진_1_stop
        '        ELSE
        '            GOTO 연속후진_2
        '
        '        ENDIF
        '
        '    ELSE
        '        ERX 4800,A, 연속후진_1
        '
        '        IF A <> 112 THEN
        '            GOTO 연속후진_1_stop
        '        ELSE
        '            GOTO 연속후진_2
        '
        '        ENDIF
        '
        '    ENDIF


연속후진_1_stop:
        SPEED 5
        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB 기본자세
        DELAY 200
    ENDIF

    RETURN

    '************************************

연속후진_2:
    ETX 4800,12 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED 좌우속도
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    MOVE G6B, 90
    MOVE G6C,110
    WAIT



    'IF 동작모드 = 4 THEN '알파벳인식
    '        보행COUNT = 보행COUNT + 1
    '
    '        IF 보행COUNT = 4 THEN
    '            GOTO 연속후진_2_stop
    '        ELSE
    '            GOTO 연속후진_1
    '
    '        ENDIF
    '
    '    ELSE
    '        ERX 4800,A, 연속후진_2
    '
    '        IF A <> 112 THEN
    '            GOTO 연속후진_2_stop
    '        ELSE
    '            GOTO 연속후진_1
    '
    '        ENDIF
    '
    '    ENDIF

    ERX 4800,A, 연속후진_1
    IF A <> A_old THEN

연속후진_2_stop:
        SPEED 5

        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT		

        SPEED 3
        GOSUB 기본자세
        DELAY 200
    ENDIF

    'GOTO 연속후진_1 '???????????????

    RETURN

    '********************************************	

    '************************************************

우유곽들고전진:
    보행속도 = 8
    좌우속도 = 4
    넘어짐확인 = 0

    GOSUB Leg_motor_mode3


    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        MOVE G6A,  88,  74, 144,  90, 110,
        MOVE G6D, 108,  76, 146,  83,  96,
        WAIT

        SPEED 8
        MOVE G6A,  90,  90, 120, 100, 110,
        MOVE G6D, 110,  76, 147,  86,  96,
        WAIT

        GOTO 우유곽들고전진_1

    ELSE
        보행순서 = 0

        SPEED 4
        MOVE G6D,  88,  74, 144,  90, 110,
        MOVE G6A, 108,  76, 146,  83,  96,
        WAIT

        SPEED 8
        MOVE G6D,  90,  90, 120, 100, 110,
        MOVE G6A, 110,  76, 147,  86,  96,
        WAIT

        GOTO 우유곽들고전진_2

    ENDIF

    '************************************

우유곽들고전진_1:
    ETX 4800,호출함수 '우유곽옮기기


    SPEED 보행속도
    MOVE G6A,  90,  56, 145, 103, 110,
    MOVE G6D, 108,  76, 147,  83,  96,
    WAIT

    SPEED 좌우속도
    MOVE G6A,110,  76, 142, 93,   96      '오른다리 들기
    MOVE G6D, 93,  90, 140,  69, 110
    WAIT




    SPEED 보행속도


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, 우유곽들고전진_2

    IF A <> 128 THEN
우유곽들고전진_1_stop:
        MOVE G6D,  90, 100, 100, 110, 118, '오른쪽 다리 더올리기
        MOVE G6A, 113,  76, 146,  86,  95, '여기 발 부딪힘 ''상관없음'
        WAIT

        SPEED 6
        MOVE G6D,  88,  71, 152,  81, 110, '오른쪽 다리 내리기
        MOVE G6A, 106,  76, 146,  83,  96,
        WAIT

        SPEED 2
        GOSUB 기본자세_우유곽


        RETURN


    ENDIF

    '************************************

우유곽들고전진_2:
    MOVE G6A, 110,  76, 147,  88,  96,
    MOVE G6D,  90,  90, 120,  95, 110,
    WAIT

우유곽들고전진_3:
    ETX 4800,호출함수 '우유곽옮기기


    SPEED 보행속도
    MOVE G6D,  90,  56, 145, 105, 110,
    MOVE G6A, 108,  76, 147,  83,  96,
    WAIT

    SPEED 좌우속도
    MOVE G6A,  86, 100, 140,  64, 110,
    MOVE G6D, 110,  76, 147,  88,  96,
    WAIT


    SPEED 보행속도


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, 우유곽들고전진_4

    IF A <> 128 THEN
우유곽들고전진_3_stop:
        MOVE G6A,  90, 100, 100, 107, 112, '왼쪽 다리 올리기
        MOVE G6D, 112,  76, 146,  85,  96,
        WAIT

        SPEED 6
        MOVE G6D, 106,  76, 146,  85,  96, '왼쪽 다리 더 올리기
        MOVE G6A,  88,  71, 152,  83, 106,
        WAIT

        SPEED 2
        GOSUB 기본자세_우유곽


        RETURN

    ENDIF

    '************************************

우유곽들고전진_4:
    MOVE G6A,  90,  90, 120,  97, 110, '왼발들기10
    MOVE G6D, 110,  76, 146,  85,  96,
    WAIT


    GOTO 우유곽들고전진_1

    '********************************************


    '************************************************

우유곽들고후진:
    보행속도 = 5
    좌우속도 = 4
    넘어짐확인 = 0


    GOSUB Leg_motor_mode3


    IF 보행순서 = 0 THEN
        보행순서 = 1

        '왼발 들기
        SPEED 4
        MOVE G6A, 88,  71, 144,  95, 110
        MOVE G6D,108,  76, 145,  93,  96
        WAIT


        SPEED 10
        MOVE G6A,  90,  98, 115,  89, 110,
        MOVE G6D, 110,  76, 147,  90,  96,
        WAIT

        GOTO 우유곽들고후진_1

    ELSE
        보행순서 = 0

        SPEED 4
        MOVE G6D, 88,  71, 144,  95, 110
        MOVE G6A,108,  76, 145,  93,  96
        WAIT


        SPEED 10
        MOVE G6D,  90,  98, 115,  89, 110,
        MOVE G6A, 110,  76, 147,  90,  96,
        WAIT

        GOTO 우유곽들고후진_2

    ENDIF

    '************************************

우유곽들고후진_1:
    ETX 4800,호출함수 '우유곽옮기기

    SPEED 보행속도
    MOVE G6A,  86, 100, 140,  64, 110,
    MOVE G6D, 110,  76, 147,  88,  96,
    WAIT

    '***************************오른다리 시작

    SPEED 좌우속도
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    SPEED 보행속도


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, 우유곽들고후진_2

    IF A <> 128 THEN
우유곽들고후진_1_stop:
        HIGHSPEED SETOFF
        SPEED 5
        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        WAIT

        SPEED 2
        GOSUB 기본자세_우유곽


        RETURN


    ENDIF

    '************************************
우유곽들고후진_2:
    MOVE G6D,  90,  90, 120, 100, 110,
    MOVE G6A, 110,  76, 147,  86,  96,
    WAIT

    '*********************


우유곽들고후진_3:
    ETX 4800,호출함수 '우유곽옮기기

    SPEED 보행속도
    MOVE G6D,  86, 100, 140,  64, 110,
    MOVE G6A, 110,  76, 147,  88,  96,
    WAIT


    SPEED 좌우속도
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107,  85, 137,  93,  96
    WAIT

    SPEED 보행속도


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, 우유곽들고후진_4

    IF A <> 128 THEN
우유곽들고후진_2_stop:

        HIGHSPEED SETOFF

        SPEED 5
        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        WAIT

        SPEED 2
        GOSUB 기본자세_우유곽


        RETURN

    ENDIF

우유곽들고후진_4:
    MOVE G6A,  90,  90, 120, 100, 110,
    MOVE G6D, 110,  76, 147,  86,  96,
    WAIT


    GOTO 우유곽들고후진_1

    '************************************************




    '************************************************

전진종종걸음:
    보행횟수 = 0
    보행속도 = 18

횟수_전진종종걸음:

    넘어짐확인 = 0
    보행COUNT = 0

    GOSUB All_motor_mode3

    SPEED 보행속도

    IF 보행순서 = 0 THEN
        보행순서 = 1

        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음_1

    ELSE
        보행순서 = 0

        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음_2

    ENDIF


    GOTO RX_EXIT

    '************************************	

전진종종걸음_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C, 115
    WAIT

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF


    보행COUNT = 보행COUNT + 1

    IF 보행COUNT > 보행횟수 THEN
        GOTO 전진종종걸음_1_stop

    ELSE
        GOTO 전진종종걸음_2

    ENDIF


전진종종걸음_1_stop:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT


    SPEED 12
    GOSUB 안정화자세

    SPEED 4
    GOSUB 기본자세


    RETURN

    '************************************

전진종종걸음_2:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT

    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF


    보행COUNT = 보행COUNT + 1

    IF 보행COUNT > 보행횟수 THEN
        GOTO 전진종종걸음_2_stop

    ELSE
        GOTO 전진종종걸음_1

    ENDIF


전진종종걸음_2_stop:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    SPEED 12
    GOSUB 안정화자세

    SPEED 4
    GOSUB 기본자세


    RETURN
    '*******************************************
    '************************************************

전진종종걸음_문:
    보행횟수 = 0
    
횟수_전진종종걸음_문:

	보행속도 = 18
    넘어짐확인 = 0
    보행COUNT = 0

    GOSUB All_motor_mode3

    SPEED 보행속도

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,  95,  76, 147,  83, 105,
        MOVE G6D,  95,  76, 147,  83, 105,
        MOVE G6B, 170,  15,  55,  ,  ,
        MOVE G6C, 170,  15,  55,  ,  ,

        MOVE G6A,  95,  76, 147,  83, 105,
        MOVE G6D,  95,  76, 147,  83, 105,


        WAIT

        GOTO 횟수_전진종종걸음_문_1

    ELSE
        보행순서 = 0

        MOVE G6A,  95,  76, 147,  83, 105,
        MOVE G6D,  95,  76, 147,  83, 105,
        MOVE G6B, 170,  15,  55,  ,  ,
        MOVE G6C, 170,  15,  55,  ,  ,

        WAIT

        GOTO 횟수_전진종종걸음_문_2

    ENDIF


    GOTO RX_EXIT

    '************************************	

횟수_전진종종걸음_문_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    WAIT

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF


    보행COUNT = 보행COUNT + 1
    DELAY 200

    IF 보행COUNT > 보행횟수 THEN
        GOTO 횟수_전진종종걸음_문_1_stop

    ELSE
        GOTO 횟수_전진종종걸음_문_2

    ENDIF


횟수_전진종종걸음_문_1_stop:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    WAIT


    SPEED 12
    GOSUB 안정화자세

    SPEED 4
    GOSUB 기본자세


    RETURN

    '************************************

횟수_전진종종걸음_문_2:
    MOVE G6D,  95,  95, 120,  95, 104,
    MOVE G6A, 104,  77, 147,  88, 102,

    WAIT

    MOVE G6D,103,    73, 140, 98,  100
    MOVE G6A, 95,  85, 147,  80, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF


    보행COUNT = 보행COUNT + 1
    DELAY 200

    IF 보행COUNT > 보행횟수 THEN
        GOTO 횟수_전진종종걸음_문_2_stop

    ELSE
        GOTO 횟수_전진종종걸음_문_1

    ENDIF


횟수_전진종종걸음_문_2_stop:

    MOVE G6A,  98,  90, 123,  90, 104,
    MOVE G6D, 101,  76, 142,  86, 100,


    WAIT

    SPEED 12
    GOSUB 안정화자세

    SPEED 4
    GOSUB 기본자세


    RETURN

    '********************************************	
    '************************************************





    '********************************************	
    '************************************************
후진종종걸음:
    보행횟수 = 0

횟수_후진종종걸음:
    보행속도 = 18
    넘어짐확인= 0
    보행COUNT = 0

    GOSUB All_motor_mode3

    SPEED 18

    IF 보행순서 = 0 THEN
        보행순서 = 1

        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 후진종종걸음_1

    ELSE
        보행순서 = 0

        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 후진종종걸음_2

    ENDIF


    GOTO RX_EXIT

    '************************************

후진종종걸음_1:
    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF


    보행COUNT = 보행COUNT + 1

    IF 보행COUNT > 보행횟수 THEN
        GOTO 후진종종걸음_1_stop

    ELSE
        GOTO 후진종종걸음_2

    ENDIF


후진종종걸음_1_stop:
    MOVE G6D,95,  85, 130, 100, 104
    MOVE G6A,104,  77, 146,  93,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT

    SPEED 12
    GOSUB 안정화자세

    SPEED 4
    GOSUB 기본자세


    RETURN

    '************************************

후진종종걸음_2:
    MOVE G6A,104,  76, 147,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6C,115
    MOVE G6B,85
    WAIT

    MOVE G6D, 103,  79, 147,  89, 100
    MOVE G6A,95,   65, 147, 103,  102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어짐확인 = 1 THEN
        넘어짐확인 = 0
        GOTO MAIN
    ENDIF


    보행COUNT = 보행COUNT + 1

    IF 보행COUNT > 보행횟수 THEN
        GOTO 후진종종걸음_2_stop

    ELSE
        GOTO 후진종종걸음_1

    ENDIF


후진종종걸음_2_stop:
    MOVE G6A,95,  85, 130, 100, 104
    MOVE G6D,104,  77, 146,  93,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT


    SPEED 12
    GOSUB 안정화자세

    SPEED 4
    GOSUB 기본자세


    RETURN

    '********************************************


    '************************************************

오른쪽옆으로20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세
    GOSUB All_motor_mode3

    RETURN
    '********************************************
    '************************************************

왼쪽옆으로20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT


    SPEED 8

    GOSUB 기본자세

    GOSUB All_motor_mode3


    RETURN

    '********************************************


    '************************************************

오른쪽옆으로70연속:
    보행COUNT= 0

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


오른쪽옆으로70연속_loop:
    DELAY  10


    SPEED 7
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 145,  93, 107, 100
    WAIT

    SPEED 7
    MOVE G6D, 102,  76, 145, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 6
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 5
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT


    ERX 4800,A, 오른쪽옆으로70연속_loop

    IF A <> 113 THEN
        GOTO 오른쪽옆으로70연속_stop
    ELSE
        GOTO 오른쪽옆으로70연속_loop

    ENDIF


오른쪽옆으로70연속_stop:
    GOSUB 기본자세


    RETURN

    '********************************************
    '************************************************

왼쪽옆으로70연속:
    보행COUNT= 0

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


왼쪽옆으로70연속_loop:
    DELAY  10


    SPEED 8
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 145,  93, 107, 100	
    WAIT

    SPEED 8
    MOVE G6A, 102,  76, 145, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 8
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT


    ERX 4800,A, 왼쪽옆으로70연속_loop

    IF A <> 114 THEN
        GOTO 왼쪽옆으로70연속_stop
    ELSE
        GOTO 왼쪽옆으로70연속_loop

    ENDIF


왼쪽옆으로70연속_stop:
    GOSUB 기본자세


    RETURN

    '********************************************


    '************************************************

오른쪽턴3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


오른쪽턴3_LOOP:
    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT

        SPEED 6
        MOVE G6A,100,  84, 145,  78, 100, 100
        MOVE G6D,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,90,  90, 145,  78, 102, 100
        MOVE G6D,104,  71, 145,  105, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,90,  80, 130, 102, 104
        MOVE G6D,105,  76, 146,  93,  100
        WAIT

    ELSE
        보행순서 = 0

        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT

        SPEED 6
        MOVE G6A,100,  88, 145,  78, 100, 100
        MOVE G6D,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,104,  86, 146,  80, 100, 100
        MOVE G6D,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,90,  85, 130, 98, 104
        MOVE G6A,105,  77, 146,  93,  100
        WAIT

    ENDIF


    SPEED 12
    GOSUB 기본자세


    RETURN

    '********************************************
    '************************************************

왼쪽턴3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


왼쪽턴3_LOOP:
    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT

        SPEED 6
        MOVE G6D,100,  84, 145,  78, 100, 100
        MOVE G6A,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,90,  90, 145,  78, 102, 100
        MOVE G6A,104,  71, 145,  105, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,90,  80, 130, 102, 104
        MOVE G6A,105,  76, 146,  93,  100
        WAIT

    ELSE
        보행순서 = 0

        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT

        SPEED 6
        MOVE G6D,100,  88, 145,  78, 100, 100
        MOVE G6A,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,104,  86, 146,  80, 100, 100
        MOVE G6A,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,90,  85, 130, 98, 104
        MOVE G6D,105,  77, 146,  93,  100
        WAIT

    ENDIF


    SPEED 12
    GOSUB 기본자세


    RETURN

    '********************************************

    '************************************************

오른쪽턴10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세


    RETURN

    '********************************************
    '************************************************

왼쪽턴10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    SPEED 5
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세


    RETURN

    '********************************************

    '************************************************

오른쪽턴20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세

    RETURN

    '********************************************
    '************************************************

왼쪽턴20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT
    GOSUB 기본자세

    RETURN

    '********************************************

    '************************************************

오른쪽턴45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


오른쪽턴45_LOOP:
    SPEED 10
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세

    ' DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어짐확인 = 1 THEN
    '        넘어짐확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,오른쪽턴45_LOOP
    '    IF A_old = A THEN GOTO 오른쪽턴45_LOOP


    RETURN

    '********************************************
    '************************************************

왼쪽턴45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


왼쪽턴45_LOOP:
    SPEED 10
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세

    'DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어짐확인 = 1 THEN
    '        넘어짐확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,왼쪽턴45_LOOP
    '    IF A_old = A THEN GOTO 왼쪽턴45_LOOP


    RETURN

    '********************************************

    '************************************************

오른쪽턴60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


오른쪽턴60_LOOP:
    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    MOVE G6B,90
    MOVE G6C,110

    WAIT

    SPEED 15
    MOVE G6A,80,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100
    WAIT

    SPEED 10
    GOSUB 기본자세

    ' DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어짐확인 = 1 THEN
    '        넘어짐확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,오른쪽턴60_LOOP
    '    IF A_old = A THEN GOTO 오른쪽턴60_LOOP


    RETURN

    '********************************************
    '************************************************

왼쪽턴60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 15
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,80,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB 기본자세

    '  DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어짐확인 = 1 THEN
    '        넘어짐확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,왼쪽턴60_LOOP
    '    IF A_old = A THEN GOTO 왼쪽턴60_LOOP


    RETURN

    '********************************************

    '************************************************

집고오른쪽턴10:
    SPEED 5
    MOVE G6A,97,  66, 145,  95, 103, 100
    MOVE G6D,97,  86, 145,  75, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  95, 101, 100
    MOVE G6D,94,  86, 145,  75, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOSUB 기본자세_우유곽


    RETURN

    '********************************************
    '************************************************

집고왼쪽턴10:
    SPEED 5
    MOVE G6A,97,  86, 145,  75, 103, 100
    MOVE G6D,97,  66, 145,  95, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  75, 101, 100
    MOVE G6D,94,  66, 145,  95, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOSUB 기본자세_우유곽


    RETURN

    '********************************************

    '************************************************

집고오른쪽턴20:
    GOSUB Leg_motor_mode2


    SPEED 8
    MOVE G6A,95,  56, 145,  105, 105, 100
    MOVE G6D,95,  96, 145,  65, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  105, 105, 100
    MOVE G6D,93,  96, 145,  65, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT


    GOSUB Leg_motor_mode1

    GOSUB 기본자세_우유곽


    RETURN

    '********************************************
    '************************************************

집고왼쪽턴20:
    GOSUB Leg_motor_mode2


    SPEED 8
    MOVE G6A,95,  96, 145,  65, 105, 100
    MOVE G6D,95,  56, 145,  105, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  65, 105, 100
    MOVE G6D,93,  56, 145,  105, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT


    GOSUB Leg_motor_mode1

    GOSUB 기본자세_우유곽


    RETURN

    '********************************************

    '************************************************

집고오른쪽턴45:
    GOSUB Leg_motor_mode2


    SPEED 8
    MOVE G6A,95,  46, 145,  115, 105, 100
    MOVE G6D,95,  106, 145,  55, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  115, 105, 100
    MOVE G6D,93,  106, 145,  55, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT


    GOSUB Leg_motor_mode1

    GOSUB 기본자세_우유곽


    RETURN

    '********************************************
    '************************************************

집고왼쪽턴45:
    GOSUB Leg_motor_mode2


    SPEED 8
    MOVE G6A,95,  106, 145,  55, 105, 100
    MOVE G6D,95,  46, 145,  115, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  106, 145,  55, 105, 100
    MOVE G6D,93,  46, 145,  115, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT


    GOSUB Leg_motor_mode1

    GOSUB 기본자세_우유곽


    RETURN

    '********************************************

    '************************************************

집고오른쪽턴60:
    SPEED 15
    MOVE G6A,95,  36, 145,  125, 105, 100
    MOVE G6D,95,  116, 145,  45, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  125, 105, 100
    MOVE G6D,90,  116, 145,  45, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOSUB 기본자세_우유곽


    RETURN

    '********************************************
    '************************************************

집고왼쪽턴60:
    SPEED 15
    MOVE G6A,95,  116, 145,  45, 105, 100
    MOVE G6D,95,  36, 145,  125, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  45, 105, 100
    MOVE G6D,90,  36, 145,  125, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOSUB 기본자세_우유곽


    RETURN

    '********************************************
    '************************************************

오른쪽턴80:
    FOR i = 1 TO 5
        GOSUB 오른쪽턴20
    NEXT i


    RETURN

오른쪽턴90:
    FOR i = 1 TO 6
        GOSUB 오른쪽턴20
    NEXT i


    RETURN

    '********************************************	
    '************************************************

왼쪽턴90:
    FOR i = 1 TO 6
        GOSUB 왼쪽턴20
    NEXT i


    RETURN

왼쪽턴80:
    FOR i = 1 TO 5
        GOSUB 왼쪽턴20
    NEXT i


    RETURN

    '********************************************
    '************************************************

기어가기:

    보행COUNT = 0

    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,180,  40,  85
    MOVE G6C,180,  40,  85
    WAIT

    SPEED 5	
    MOVE G6A, 100, 155,  53, 160, 100, 100
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,190,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    DELAY 300

    SPEED 8
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON

    'GOTO 기어가기왼쪽턴_LOOP

기어가기_LOOP:


    MOVE G6A, 100, 160,  55, 160, 100
    MOVE G6D, 100, 145,  75, 160, 100
    MOVE G6B, 175,  25,  70
    MOVE G6C, 190,  50,  40
    WAIT
    ERX 4800, A, 기어가기_1
    GOTO 기어가기_1
    'IF A = 8 THEN GOTO 기어가기_1
    'IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    'IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    'GOTO 기어가다일어나기

기어가기_1:
    MOVE G6A, 100, 150,  70, 160, 100
    MOVE G6D, 100, 140, 120, 120, 100
    MOVE G6B, 160,  25,  70
    MOVE G6C, 190,  25,  70
    WAIT

    MOVE G6D, 100, 160,  55, 160, 100
    MOVE G6A, 100, 145,  75, 160, 100
    MOVE G6C, 175,  25,  70
    MOVE G6B, 190,  50,  40
    WAIT

    ERX 4800, A, 기어가기_2

    GOTO 기어가기_2
    'IF A = 8 THEN GOTO 기어가기_2
    'IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    'IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    'GOTO 기어가다일어나기

기어가기_2:
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 160,  25,  70
    MOVE G6B, 190,  25,  70
    WAIT

    보행COUNT= 보행COUNT + 1

    IF 보행COUNT > 보행횟수 THEN
        GOTO 기어가다일어나기

    ELSE
        GOTO 기어가기_LOOP

    ENDIF

기어가다일어나기:
    PTP SETON		
    PTP ALLON
    SPEED 15
    HIGHSPEED SETOFF


    MOVE G6A, 100, 150,  80, 150, 100
    MOVE G6D, 100, 150,  80, 150, 100
    MOVE G6B,185,  40, 60
    MOVE G6C,185,  40, 60
    WAIT

    GOSUB Leg_motor_mode3
    DELAY 300

    SPEED 10	
    MOVE G6A,  100, 165,  25, 162, 100
    MOVE G6D,  100, 165,  25, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    SPEED 10	
    MOVE G6A,  100, 150,  25, 162, 100
    MOVE G6D,  100, 150,  25, 162, 100
    MOVE G6B,  140, 15, 90
    MOVE G6C,  140, 15, 90
    WAIT

    SPEED 6
    MOVE G6A,  100, 138,  25, 155, 100
    MOVE G6D,  100, 138,  25, 155, 100
    MOVE G6B, 113,  30, 80
    MOVE G6C, 113,  30, 80
    WAIT

    DELAY 100
    SPEED 8
    GOSUB Leg_motor_mode2

    SPEED 6
    MOVE G6A,100, 140,  37, 140, 100, 100
    MOVE G6D,100, 140,  37, 140, 100, 100
    WAIT

    GOSUB 기본자세

    RETURN	
    '********************************************
    '************************************************

모드_방위인식:
    '동작모드 = 방위인식'1

    호출함수 = 방위인식	'201
    인식실패횟수= 0

    GOSUB 머리오른쪽10도
    GOSUB 전방하향80도
    DELAY 2000


호출_방위인식:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, 호출함수
    DELAY 1000

    ERX 4800,A, 호출_방위인식


방위인식:
    IF A = 동쪽 THEN 'E
        GOSUB 방위인식_동쪽
    ELSEIF A = 서쪽 THEN 'W
        GOSUB 방위인식_서쪽
    ELSEIF A = 남쪽 THEN 'S
        GOSUB 방위인식_남쪽
    ELSEIF A = 북쪽 THEN 'N
        GOSUB 방위인식_북쪽
    ELSEIF A = 인식실패 AND 인식실패횟수< 2 THEN ' 129
        인식실패횟수= 인식실패횟수+ 1
        GOTO 호출_방위인식
    ELSE '두번 다 인식 못했을 경우 고개 반대로
        GOSUB 머리왼쪽10도
        DELAY 2000
        GOTO 호출_방위인식

    ENDIF

    GOSUB 기본자세
    GOTO 모드_문열고들어가기
    'GOTO MAIN

    '********************************************
    '************************************************

방위인식_동쪽:
    GOSUB Arm_motor_mode3


    SPEED 15
    MOVE G6B,100, 30, 80 '오른팔 앞으로 들기
    MOVE G6C,190, 10, 100
    DELAY 200

    PRINT "SND 0 !" '동쪽


    GOSUB Arm_motor_mode1
    RETURN

    '********************************************	

방위인식_서쪽:
    GOSUB Arm_motor_mode3


    SPEED 15
    MOVE G6B,190, 10, 100 '왼팔 앞으로 들기
    MOVE G6C,100, 30, 80
    DELAY 200

    PRINT "SND 1 !" '서쪽


    GOSUB Arm_motor_mode1
    RETURN

    '********************************************	

방위인식_남쪽:
    GOSUB Arm_motor_mode3


    SPEED 15
    MOVE G6B,10, 10, 100 '양손 뒤로 나란히
    MOVE G6C,10, 10, 100
    DELAY 200

    PRINT "SND 2 !" '남쪽


    GOSUB Arm_motor_mode1
    RETURN

    '********************************************	

방위인식_북쪽:
    GOSUB Arm_motor_mode3


    SPEED 15
    MOVE G6B,190, 10, 100 '양손 앞으로 나란히
    MOVE G6C,190, 10, 100
    DELAY 200

    PRINT "SND 3 !" '북쪽


    GOSUB Arm_motor_mode1

    RETURN

    '********************************************	
    '************************************************
모드_문열고들어가기:
    동작모드 = 문열고들어가기
    GOTO 모드_라인트레이싱

문열고들어가기:
    GOSUB 기본자세

    GOTO 모드_라인트레이싱

    '*******************************************
    '************************************************

모드_화살표인식:

    동작모드 = 화살표인식
    호출함수 = 화살표인식'202
    GOSUB 머리좌우중앙
    GOSUB 전방하향100도
    DELAY 2000


호출_화살표인식:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, 호출함수
    DELAY 1000

    ERX 4800,A, 호출_화살표인식


화살표인식:
    IF A = 오른쪽 THEN '113
        화살표 = 오른쪽
        MUSIC "C"
        DELAY 100

    ELSEIF A = 왼쪽 THEN '114
        화살표 = 왼쪽
        MUSIC "C"
        DELAY 100
        MUSIC "C"
        DELAY 100

    ELSE '인식실패 (A = 129)
        GOTO 호출_화살표인식

    ENDIF

    GOSUB Leg_motor_mode3

    보행속도 = 18
    보행횟수= 4
    GOSUB  횟수_전진종종걸음

    IF 화살표 = 오른쪽 THEN '113
        GOSUB 오른쪽턴60
        GOSUB 오른쪽턴60
    ELSEIF 화살표 = 왼쪽 THEN '114
        GOSUB 왼쪽턴60
        GOSUB 왼쪽턴60
    ENDIF

    GOTO 모드_라인트레이싱

    '********************************************

모드_라인트레이싱:

    GOSUB All_motor_mode3

    '동작모드_old = 동작모드
    '동작모드 = 10
    호출함수 = 라인트레이싱'210
    이동방향 = 0

    GOSUB 머리좌우중앙
    GOSUB 전방하향35도
    DELAY 2000


호출_라인트레이싱:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, 호출함수
    DELAY 500

    ERX 4800,A, 호출_라인트레이싱


라인트레이싱:

    IF A = 인식실패 THEN

        IF 동작모드= 문열고들어가기  THEN

            동작모드 = 문열고들어가기2
            GOSUB Arm_motor_mode3
            SPEED 17
            MOVE G6B,190, 10, 100
            MOVE G6C,190, 10, 100

            보행횟수 = 20
            GOSUB 횟수_전진종종걸음_문
  	
        ENDIF

        GOTO 호출_라인트레이싱

    ELSEIF A >= 200 THEN

        IF A = 220 THEN
            GOSUB 왼쪽옆으로20

        ELSEIF A = 225 THEN

            IF 동작모드 = 문열고들어가기 THEN
                보행횟수 = 4        		
            ELSE
                보행횟수 = 6
            ENDIF

            보행속도 = 18
            GOSUB 횟수_전진종종걸음

        ELSEIF A = 230 THEN
            GOSUB 오른쪽옆으로20

        ENDIF


    ELSE  ' CORNER
        GOTO 라인트레이싱_코너

    ENDIF
    DELAY 100

    GOTO 호출_라인트레이싱


호출_라인트레이싱_코너:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, 호출함수
    DELAY 500

    ERX 4800,A, 호출_라인트레이싱_코너


라인트레이싱_코너:

    IF A > 200 THEN
        GOTO 호출_라인트레이싱

    ENDIF

    IF A = 125 THEN
        GOSUB 왼쪽옆으로20

    ELSEIF A = 130 THEN
        GOSUB 오른쪽옆으로20

    ELSEIF A = 135 THEN
        GOSUB 오른쪽턴3

    ELSEIF A = 140 THEN
        GOSUB 왼쪽턴3

    ELSEIF A = 145 THEN
        GOSUB 오른쪽턴10

    ELSEIF A = 150 THEN
        GOSUB 왼쪽턴10

    ELSE
            IF 동작모드 = 문열고들어가기2 THEN
                	GOTO 모드_화살표인식
    		
            ELSE
                    보행횟수 = 5
                    보행속도 = 18
                    GOSUB 횟수_전진종종걸음

                    GOTO 모드_알파벳색상인식

            ENDIF

    ENDIF

    GOTO 호출_라인트레이싱_코너


    '********************************************

    '************************************************	

모드_알파벳색상인식:
    동작모드 = 알파벳색상인식
    호출함수 = 알파벳색상인식

    GOSUB 머리좌우중앙
    GOSUB 전방하향85도


호출_알파벳색상인식:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, 호출함수
    DELAY 1000

    ERX 4800,A, 호출_알파벳색상인식


알파벳색상인식:
    IF A = 130 THEN '빨강
        알파벳색상 = 1
        MUSIC "E"
    ELSEIF A = 128 THEN '파랑
        알파벳색상 = 2
        MUSIC "E"
        MUSIC "E"
    ELSE '인식실패 (A = 129)
        MUSIC "E"
        MUSIC "E"
        MUSIC "E"
        GOTO 호출_알파벳색상인식
    ENDIF


    GOTO 모드_알파벳인식

    '********************************************


    '************************************************	

모드_알파벳인식:
    동작모드 = 알파벳인식
    호출함수 = 알파벳인식


호출_알파벳인식:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, 호출함수
    DELAY 1000

    ERX 4800,A, 호출_알파벳인식


알파벳인식:
    IF A = 113 THEN 'A
        알파벳 = 1
        MUSIC "G"
        DELAY 100
    ELSEIF A = 114 THEN 'B
        알파벳 = 2
        MUSIC "G"
        DELAY 100
        MUSIC "G"
        DELAY 100
    ELSEIF A = 112 THEN 'C
        알파벳 = 3
        MUSIC "G"
        DELAY 100
        MUSIC "G"
        DELAY 100
        MUSIC "G"
        DELAY 100
    ELSEIF A = 111 THEN 'D
        알파벳 = 4
        MUSIC "G"
        DELAY 100
        MUSIC "G"
        DELAY 100
        MUSIC "G"
        DELAY 100
        MUSIC "G"
        DELAY 100
    ELSE '인식실패 (A = 129)
        GOTO 호출_알파벳인식

    ENDIF

    GOTO 모드_구역색상인식

    '********************************************


    '************************************************

모드_구역색상인식:
    동작모드 = 구역색상인식
    호출함수 = 구역색상인식

    IF 화살표 = 1 THEN '오른쪽
        GOSUB 머리오른쪽45도
    ELSEIF 화살표 = 2 THEN '왼쪽
        GOSUB 머리왼쪽45도

    ENDIF

    GOSUB 전방하향80도
    DELAY 2000


호출_구역색상인식:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, 호출함수
    DELAY 1000

    ERX 4800,A, 호출_구역색상인식


구역색상인식:
    IF A = 130 THEN '초록
        구역 = 1
        PRINT "SND 4 !" '안전지역

    ELSEIF A = 128 THEN '검정
        구역 = 2
        PRINT "SND 5 !" '확진구역
        ON 확인구역수 GOTO 구역판별1, 구역판별2, 구역판별3

    ELSE '인식실패 (A = 129)
        GOTO 호출_구역색상인식

    ENDIF

    GOTO 모드_미션수행확인

    '********************************************

    '************************************************

구역판별1:
    확진구역1 = 알파벳

    GOTO 모드_미션수행확인

    '********************************************
    '************************************************

구역판별2:
    확진구역2 = 알파벳

    GOTO 모드_미션수행확인

    '********************************************
    '************************************************

구역판별3:
    확진구역3 = 알파벳

    GOTO 모드_미션수행확인

    '********************************************


    '************************************************

모드_미션수행확인:
    동작모드 = 6
    IF 구역 = 1 THEN '안전구역
        호출함수 = 206
    ELSEIF 구역 = 2 THEN '확진구역
        호출함수 = 216

    ENDIF

    확인 = 0
    회전수 = 0

    GOSUB 머리좌우중앙
    GOSUB 전방하향40도
    DELAY 2000


호출_미션수행확인:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, 호출함수
    DELAY 1000

    ERX 4800,A, 호출_미션수행확인


미션수행확인:
    IF 화살표 = 1 THEN '오른쪽
        ON 확인 GOTO 미션수행확인_오른쪽40, 미션수행확인_오른쪽80
    ELSEIF 화살표 = 2 THEN '왼쪽
        ON 확인 GOTO 미션수행확인_왼쪽40, 미션수행확인_왼쪽80

    ENDIF


미션수행성공:
    알파벳 = 0
    알파벳색상 = 0
    구역 = 0
    확인구역수 = 확인구역수 + 1


    GOTO 모드_라인트레이싱

    '********************************************

    '************************************************

미션수행확인_오른쪽40:
    확인 = 1

    IF A = 130 THEN '성공 (타겟이 초록 안에 있거나 검정 밖에 있음)
        FOR i = 1 TO 회전수 '회전한만큼 반대로 회전
            GOSUB 왼쪽턴20
            DELAY 100

        NEXT i

        GOSUB 왼쪽턴20
        DELAY 100
        GOSUB 왼쪽턴45
        DELAY 100

        FOR i = 1 TO 5
            GOSUB 오른쪽옆으로20
        NEXT i

        GOTO 미션수행성공

    ELSEIF A = 128 THEN '실패 (타겟이 초록 밖에 있거나 검정 안에 있음)
        GOTO 모드_우유곽찾기

    ELSE '타겟이 없음 (A = 129) => 전방하향80 확인
        GOSUB 전방하향75도
        DELAY 2000

        GOTO 호출_미션수행확인

    ENDIF

    '********************************************
    '************************************************

미션수행확인_오른쪽80:
    확인 = 0

    IF A = 130 THEN '성공 (타겟이 초록 안에 있거나 검정 밖에 있음)

        FOR i = 1 TO 회전수 '회전한만큼 반대로 회전
            GOSUB 왼쪽턴20
            DELAY 100
        NEXT i

        GOSUB 왼쪽턴20
        DELAY 100
        GOSUB 왼쪽턴45
        DELAY 100

        FOR i = 1 TO 5
            GOSUB 오른쪽옆으로20
        NEXT i

        GOTO 미션수행성공

    ELSEIF A = 128 THEN '실패 (타겟이 초록 밖에 있거나 검정 안에 있음)
        GOTO 모드_우유곽찾기

    ELSE '타겟이 없음 (A = 129 => 20도 더 돌고 전방하향40 확인
        IF 회전수 > 6 THEN '90도 돌았는데도 타겟이 없으면 미션수행성공
            GOSUB 왼쪽턴90
            DELAY 100
            GOSUB 왼쪽턴20
            DELAY 100
            GOSUB 왼쪽턴45
            DELAY 100      		

            FOR i = 1 TO 5
                GOSUB 오른쪽옆으로20
            NEXT i

            GOTO 미션수행성공

        ELSE
            회전수 = 회전수 + 1

            GOSUB 오른쪽턴20
            DELAY 100
            GOSUB 전방하향40도
            DELAY 2000

            GOTO 호출_미션수행확인

        ENDIF

    ENDIF

    '********************************************
    '************************************************

미션수행확인_왼쪽40:
    확인 = 1

    IF A = 130 THEN '성공 (타겟이 초록 안에 있거나 검정 밖에 있음)
        FOR i = 1 TO 회전수 '회전한만큼 반대로 회전
            GOSUB 오른쪽턴20
        NEXT i

        GOSUB 오른쪽턴20
        GOSUB 오른쪽턴45

        FOR i = 1 TO 3
            GOSUB 왼쪽옆으로20
        NEXT i

        GOTO 미션수행성공

    ELSEIF A = 128 THEN '실패 (타겟이 초록 밖에 있거나 검정 안에 있음)
        GOTO 모드_우유곽찾기

    ELSE '타겟이 없음 (A = 129) => 전방하향80 확인
        GOSUB 전방하향75도
        DELAY 2000

        GOTO 호출_미션수행확인

    ENDIF

    '********************************************
    '************************************************

미션수행확인_왼쪽80:
    확인 = 0

    IF A = 130 THEN '성공 (타겟이 초록 안에 있거나 검정 밖에 있음)
        FOR i = 1 TO 회전수 '회전한만큼 반대로 회전
            GOSUB 오른쪽턴20
        NEXT i

        GOSUB 오른쪽턴20
        GOSUB 오른쪽턴45

        FOR i = 1 TO 3
            GOSUB 왼쪽옆으로20
        NEXT i

        GOTO 미션수행성공

    ELSEIF A = 128 THEN '실패 (타겟이 초록 밖에 있거나 검정 안에 있음)
        GOTO 모드_우유곽찾기

    ELSE '타겟이 없음 (A = 129 => 20도 더 돌고 전방하향40 확인
        IF 회전수 > 6 THEN '90도 돌았는데도 타겟이 없으면 미션수행성공
            GOSUB 오른쪽턴90
            GOSUB 오른쪽턴20
            GOSUB 오른쪽턴45

            FOR i = 1 TO 3
                GOSUB 왼쪽옆으로20
            NEXT i

            GOTO 미션수행성공

        ELSE
            회전수 = 회전수 + 1

            GOSUB 왼쪽턴20
            GOSUB 전방하향40도
            DELAY 2000

            GOTO 호출_미션수행확인

        ENDIF

    ENDIF

    '********************************************


    '************************************************

모드_우유곽찾기:
    동작모드 = 7
    호출함수 = 207
    cnt = 0
    GOTO 호출_우유곽x좌표찾기


우유곽찾기:
    cnt = 0
    GOSUB 전방하향40도
    확인 = 1
    WAIT
    DELAY 2000


호출_우유곽x좌표찾기:
    GOSUB GOSUB_RX_EXIT
    ETX  4800,207
    DELAY 1000

    ERX 4800, A, 호출_우유곽x좌표찾기


우유곽x좌표찾기_1:

    IF A = 199 AND cnt = 0 THEN
        cnt = 1
        GOTO 호출_우유곽x좌표찾기

    ELSEIF A = 199 AND cnt = 1 THEN
        IF 확인 = 1 THEN
            GOSUB 전방하향75도
            확인 = 0
        ENDIF

        WAIT
        DELAY 1000
        GOTO 우유곽x좌표찾기_2

    ELSEIF A = 100 OR A = 200 THEN
        GOTO 호출_우유곽y좌표찾기

    ELSEIF A > 200 THEN
        A = A - 200

        FOR i = 1 TO A
            GOSUB 오른쪽옆으로20
        NEXT i
        DELAY 100

        GOTO 호출_우유곽y좌표찾기

    ELSEIF A > 100 THEN
        A = A - 100

        FOR i = 0 TO A
            GOSUB 왼쪽옆으로20
        NEXT i
        DELAY 100

        GOTO 호출_우유곽y좌표찾기

    ELSE
        GOTO 호출_우유곽x좌표찾기

    ENDIF

우유곽x좌표찾기_2:
    GOSUB GOSUB_RX_EXIT
    ETX  4800,207
    DELAY 1000
    ERX 4800, A, 우유곽x좌표찾기_2

    IF A = 199 THEN

        IF 화살표 = 1 THEN '오른쪽
            GOSUB 오른쪽턴20
        ELSEIF 화살표 = 2 THEN '왼쪽
            GOSUB 왼쪽턴20
        ENDIF

        WAIT
        GOTO 우유곽찾기

    ELSE
        GOTO 우유곽x좌표찾기_1

    ENDIF

    '********************************************
    '************************************************

호출_우유곽y좌표찾기:
    GOSUB GOSUB_RX_EXIT
    ETX 4800,217
    DELAY 1000

    ERX 4800, A, 호출_우유곽y좌표찾기
    WAIT

우유곽y좌표찾기_0:

    IF A = 199 THEN       '전방하향 40 일경우 파란색 인식 못할경우
        보행횟수= 1
        GOSUB 횟수_전진종종걸음
        GOTO 우유곽찾기 ' 한발짜국 걸은 x_pos로 이동 후 찾기

    ELSEIF 확인 = 0 THEN      ''전방하향 80'
        보행횟수= 7
        GOSUB 횟수_전진종종걸음

        IF 화살표 = 1 THEN '오른쪽
            GOSUB 왼쪽턴10
        ELSEIF 화살표 = 2 THEN '왼쪽
            GOSUB 오른쪽턴10
        ENDIF

        GOTO 우유곽찾기  ''처음부터 다시 실행 -> x_pos 다시 정렬

    ELSE  '전방하향 40

        IF A = 189 THEN
            GOSUB GOSUB_RX_EXIT
            DELAY 100

            보행횟수= 2
            보행속도 = 12
            GOSUB 횟수_전진종종걸음
            DELAY 500

            GOTO 우유곽들기

        ELSE
            보행횟수= A
            GOSUB 횟수_전진종종걸음
            GOTO 호출_우유곽y좌표찾기

        ENDIF

    ENDIF

    '********************************************

    '************************************************

우유곽들기:

    '여기서 더 정밀하게 우유곽 위치 확인 필요!!!!!'

    GOSUB Leg_motor_mode3

    GOSUB 자이로OFF

    SPEED 6
    GOSUB 앉은자세
    WAIT

    GOSUB Arm_motor_mode3

    SPEED 12	
    MOVE G6B,165, 10, 100              '팔뻗기
    MOVE G6C,165, 10, 100
    WAIT	

    SPEED 6
    MOVE G6A,  87, 145,  28, 159, 115, '더 쭈구리기
    MOVE G6D,  87, 145,  28, 159, 115,
    WAIT

    '***************************************'
    '****************추가된코드***************'

    SPEED 9
    MOVE G6B, 145,  15,  55,  ,  ,     '우유곽 잡기
    MOVE G6C, 145,  15,  55,  ,  ,
    WAIT

    MOVE G6B,165, 30, 100              '팔뻗기
    MOVE G6C,165, 30, 100
    WAIT

    MOVE G6B, 145,  15,  55,  ,  ,     '우유곽 잡기
    MOVE G6C, 145,  15,  55,  ,  ,
    WAIT

    MOVE G6B,165, 30, 100              '팔뻗기
    MOVE G6C,165, 30, 100
    WAIT


    '***************************************'



    SPEED 2
    MOVE G6B, 153,  15,  55,  ,  ,     '우유곽 잡기
    MOVE G6C, 153,  15,  55,  ,  ,
    WAIT

    SPEED 6
    MOVE G6A, 100, 145,  28, 145, 100, '다리모으기
    MOVE G6D, 100, 145,  28, 145, 100,
    WAIT

    SPEED 5
    MOVE G6A,100, 76, 145,  93, 100, 100 '일어서기
    MOVE G6D,100, 76, 145,  93, 100, 100
    WAIT

    MOVE G6B, 190,  15,  55,  ,  ,     '우유곽 잡기 더 위로
    MOVE G6C, 190,  15,  55,  ,  ,
    WAIT


    '    MOVE G6A, 100,  76, 145,  83, 100,   '허리펴기
    '    MOVE G6D, 100,  76, 145,  83, 100,
    '    WAIT


    GOSUB All_motor_mode3

    GOTO 모드_우유곽옮기기

    '********************************************


    '************************************************

모드_우유곽옮기기:
    동작모드 = 8
    GOSUB 자이로ON

    IF 구역 = 1 THEN '안전구역
        호출함수 = 208

        IF 회전수 < 3   THEN
            회전수= 3 - 회전수+ 2

            IF 화살표 = 1 THEN '오른쪽
                FOR i = 1 TO 회전수 '회전한 절반+1 만큼 화살표 방향으로 회전
                    GOSUB 집고오른쪽턴20
                    WAIT
                NEXT i

            ELSEIF 화살표 = 2 THEN '왼쪽
                FOR i = 1 TO 회전수 '회전한 절반+1 만큼 화살표 방향으로
                    GOSUB 집고왼쪽턴20
                    WAIT
                NEXT i

            ENDIF

        ELSE
            회전수= 회전수- 3 + 2

            IF 화살표 = 1 THEN '오른쪽
                FOR i = 1 TO 회전수 '회전한 절반+1 만큼 반대로 회전
                    GOSUB 집고왼쪽턴20
                NEXT i

            ELSEIF 화살표 = 2 THEN '왼쪽
                FOR i = 1 TO 회전수 '회전한 절반+1 만큼 반대로 회전
                    GOSUB 집고오른쪽턴20
                NEXT i

            ENDIF
        ENDIF

    ELSEIF 구역 = 2 THEN '확진구역
        호출함수 = 218

    ENDIF
    이동방향 = 0

    GOSUB 전방하향35도
    DELAY 2000


    '    IF 회전수 <= 3   THEN
    '        IF 화살표 = 1 THEN '화살표가 오른쪽
    '            GOSUB 머리왼쪽60도
    '        ELSE '화살표가 왼쪽
    '            GOSUB 머리오른쪽60도
    '
    '        ENDIF
    '    ELSE
    '        IF 화살표 = 1 THEN '화살표가 오른쪽
    '            GOSUB 머리오른쪽60도
    '        ELSE '화살표가 왼쪽
    '            GOSUB 머리왼쪽60도
    '
    '        ENDIF
    '
    '    ENDIF


호출_우유곽옮기기:
    GOSUB GOSUB_RX_EXIT
    DELAY 1000
    ETX 4800, 호출함수
    'DELAY 1000
    ERX 4800,A, 호출_우유곽옮기기


우유곽옮기기:
    IF 구역 = 1 THEN '안전구역

        IF A = 128 THEN
            GOSUB 우유곽들고전진
            GOTO 호출_우유곽옮기기

        ELSEIF A = 130 THEN
            GOSUB 우유곽내리기
            보행횟수= 3
            GOSUB 횟수_후진종종걸음
            GOTO 모드_우유곽내리고돌아오기

        ELSE
            GOTO 호출_우유곽옮기기'필요없는 코드인가?'

        ENDIF

    ELSEIF 구역 = 2 THEN '확진구역

        IF A = 128 THEN
            GOSUB 우유곽들고후진
            GOTO 호출_우유곽옮기기

        ELSEIF A = 130 THEN
            GOSUB 우유곽내리기
            GOTO 모드_우유곽내리고돌아오기

        ELSE
            GOTO 호출_우유곽옮기기'필요없는 코드인가?'

        ENDIF

    ENDIF

    '********************************************

    '************************************************

우유곽내리기:
    GOSUB 자이로OFF

    GOSUB Leg_motor_mode3


    SPEED 6
    MOVE G6D,100,  71, 145,  93, 100, 100
    MOVE G6A,100,  71, 145,  93, 100, 100
    WAIT

    SPEED 9
    MOVE G6A,100, 140,  37, 145, 100, 100
    MOVE G6D,100, 140,  37, 145, 100, 100
    WAIT


    MOVE G6A,  87, 145,  28, 159, 115, '더 쭈구리기
    MOVE G6D,  87, 145,  28, 159, 115,
    WAIT


    GOSUB Arm_motor_mode3

    MOVE G6B, 153,  15,  55,  ,  ,     '팔 내리기
    MOVE G6C, 153,  15,  55,  ,  ,
    WAIT

    MOVE G6B,165, 30, 100              '팔뻗기
    MOVE G6C,165, 30, 100
    WAIT

    SPEED 6
    MOVE G6A, 100, 145,  28, 145, 100,
    MOVE G6D, 100, 145,  28, 145, 100,
    WAIT

    ' SPEED 10
    '    MOVE G6B, 153,  50,  55,  ,  ,
    '    MOVE G6C, 153,  50,  55,  ,  ,
    '    WAIT

    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 자이로ON

    GOSUB 기본자세

    'IF 화살표 = 1 THEN '오른쪽
    '        GOSUB 왼쪽턴90
    '        GOSUB 왼쪽턴20
    '        GOSUB 왼쪽턴20
    '        GOSUB 왼쪽턴20
    '
    '    ELSEIF 화살표 = 2 THEN '왼쪽
    '        GOSUB 오른쪽턴90
    '        GOSUB 오른쪽턴20
    '        GOSUB 오른쪽턴20
    '        GOSUB 오른쪽턴20
    '    ENDIF

    'GOTO 모드_우유곽내리고돌아오기
    RETURN


    '********************************************


    '************************************************

모드_우유곽내리고돌아오기:
    동작모드 = 9
    호출함수 = 209

    '    IF 회전수 < 3 THEN
    '        회전수= 3 - 회전수+ 5
    '
    '        IF 화살표= 1 THEN
    '            FOR i = 1 TO 회전수
    '                GOSUB 왼쪽턴20
    '            NEXT i
    '
    '        ELSE
    '            FOR i = 1 TO 회전수
    '                GOSUB 오른쪽턴20
    '            NEXT i
    '
    '            DELAY 2000
    '
    '        ENDIF
    '    ELSE
    '        회전수= 회전수 - 3 + 5
    '
    '        IF 화살표= 1 THEN
    '            FOR i = 1 TO 회전수
    '                GOSUB 오른쪽턴20
    '            NEXT i
    '
    '        ELSE
    '            FOR i = 1 TO 회전수
    '                GOSUB 왼쪽턴20
    '            NEXT i
    '
    '            DELAY 2000
    '
    '        ENDIF
    '
    '    ENDIF

    IF 화살표= 1 THEN
        FOR i = 1 TO 4
            GOSUB 왼쪽턴20
        NEXT i

    ELSE
        FOR i = 1 TO 4
            GOSUB 오른쪽턴20
        NEXT i

        DELAY 2000

    ENDIF

우유곽내리고돌아오기:
    cnt = 0
    GOSUB 전방하향60도
    확인 = 0	'전방하향 60
    DELAY 1000

    IF 회전수<= 3 THEN
        GOSUB 전방하향40도

    ELSE
        GOSUB 전방하향60도

    ENDIF

호출_우유곽내리고돌아오기_x좌표:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, 209
    DELAY 1000
    ERX 4800, A, 호출_우유곽내리고돌아오기_x좌표


우유곽내리고돌아오기_x좌표:

    IF A = 199 AND cnt = 0 THEN '인식실패

        IF 화살표= 1 THEN
            FOR i = 1 TO 3
                GOSUB 왼쪽턴3
            NEXT i

        ELSE
            FOR i = 1 TO 3
                GOSUB 오른쪽턴3
            NEXT i

        ENDIF
        DELAY 2000

        cnt = cnt + 1
        GOTO 호출_우유곽내리고돌아오기_x좌표

    ELSEIF	A = 199 AND cnt = 1 THEN
        IF 화살표= 1 THEN
            GOSUB 왼쪽턴10

        ELSE
            GOSUB 오른쪽턴10
        ENDIF

        DELAY 2000

        cnt = 2
        GOTO 호출_우유곽내리고돌아오기_x좌표

    ELSEIF	A = 199 AND cnt = 2 THEN
        IF 확인 = 0 THEN
            GOSUB 전방하향40도
            확인= 1
        ELSE
            GOSUB 전방하향60도
            확인= 0
        ENDIF	
        cnt = 0
        GOTO 호출_우유곽내리고돌아오기_x좌표


    ELSEIF A > 200 THEN 'x좌표가 오른쪽
        A = A - 200
        xcount = A / 10

        IF xcount = 0 THEN
            GOTO 우유곽내리고돌아오기_y좌표

        ELSE
            FOR i = 1 TO xcount
                GOSUB 오른쪽옆으로20
            NEXT i
            DELAY 100
        ENDIF

    ELSEIF A > 100 THEN 'x좌표가 왼쪽
        A = A - 100
        xcount = A / 10

        IF xcount = 0 THEN
            GOTO 우유곽내리고돌아오기_x좌표

        ELSE
            FOR i = 1 TO xcount
                GOSUB 왼쪽옆으로20
            NEXT i
            DELAY 100   	
        ENDIF

    ELSE
        GOTO 호출_우유곽내리고돌아오기_x좌표

    ENDIF

우유곽내리고돌아오기_y좌표:
    ycount = 0

    IF 확인 = 0 THEN '전방하향 60
        ycount = 3

    ELSEIF 확인 = 1 THEN '전방하향 40
        ycount = A % 10

        IF ycount = 0 THEN
            보행횟수= 2
            GOSUB 횟수_전진종종걸음
            GOTO 모드_라인트레이싱

        ENDIF
    ENDIF

    보행횟수 = ycount+10
    GOSUB 횟수_전진종종걸음
    DELAY 1000

    IF 회전수 <= 3 THEN

        IF 화살표= 1 THEN
            FOR i = 1 TO 3
                GOSUB 오른쪽턴3
            NEXT i

        ELSE
            FOR i = 1 TO 3
                GOSUB 왼쪽턴3
            NEXT i

        ENDIF
        DELAY 2000
    ENDIF

    GOTO 모드_라인트레이싱


    'IF 확인 = 0 THEN '라인 멀리 있을 때
    '        확인 =   1
    '        GOSUB 전방하향60도
    '
    '        GOTO 호출_우유곽내리고돌아오기
    '
    '    ELSEIF 확인 = 1 THEN '라인 가까이 있을 때
    '        확인 = 0
    '
    '        IF 화살표 = 1 THEN '오른쪽
    '            FOR i = 1 TO 3
    '                GOSUB 오른쪽턴20
    '            NEXT i
    '
    '        ELSEIF 화살표 = 2 THEN '왼쪽
    '            FOR i = 1 TO 3
    '                GOSUB 왼쪽턴20
    '            NEXT i
    '
    '        ENDIF
    '
    '        GOTO 미션수행성공



    '********************************************
    '************************************************

모드_문열고나가기:
    동작모드 = 12
    '문열기 = 0


문열고나가기:
    IF 화살표 = 1 THEN '오른쪽
        GOSUB 오른쪽턴80
    ELSEIF 화살표 = 2 THEN '왼쪽
        GOSUB 왼쪽턴80

    ENDIF

    GOSUB 연속전진

    GOTO 모드_결과발표

    '********************************************	

    '************************************************

문열고나가기_오른쪽:
    GOSUB Arm_motor_mode3


    SPEED 15
    MOVE G6B, 100, 100,  85,  ,  , '오른팔 조금 들고 왼팔 90도 들기
    MOVE G6C, 100,  50,  60,  ,  ,
    WAIT


    FOR i = 1 TO 13
        GOSUB 오른쪽옆으로20
    NEXT i


    GOSUB 오른쪽턴90


    GOTO MAIN

    '********************************************	
    '************************************************

문열고나가기_왼쪽:
    GOSUB Arm_motor_mode3


    SPEED 15
    MOVE G6C, 100, 100,  85,  ,  , '왼팔 조금 들고 오른팔 90도 들기
    MOVE G6B, 100,  50,  60,  ,  ,
    WAIT


    FOR i = 1 TO 13
        GOSUB 왼쪽옆으로20
    NEXT i


    GOSUB 왼쪽턴90


    GOTO 모드_결과발표

    '********************************************	


    '************************************************

모드_결과발표:
    동작모드 = 13


결과발표:
    PRINT "OPEN M_ABCD.mrs !"
    PRINT "VOLUME 200 !"


    결과 = 결과 + 1

    IF 결과 = 1 THEN '첫번째구역결과
        ON 확진구역1 GOTO 결과발표X, 결과발표A, 결과발표B, 결과발표C, 결과발표D
    ELSEIF 결과 = 2 THEN '두번째구역결과
        ON 확진구역2 GOTO 결과발표X, 결과발표A, 결과발표B, 결과발표C, 결과발표D
    ELSEIF 결과 = 3 THEN '세번째구역결과
        ON 확진구역3 GOTO 결과발표X, 결과발표A, 결과발표B, 결과발표C, 결과발표D

    ENDIF

    GOTO RX_EXIT

    '********************************************	

    '************************************************

결과발표X:
    GOTO 결과발표


결과발표A:
    PRINT "SND 0 !"

    GOTO 결과발표


결과발표B:
    PRINT "SND 1 !"

    GOTO 결과발표


결과발표C:
    PRINT "SND 2 !"

    GOTO 결과발표


결과발표D:
    PRINT "SND 3 !"

    GOTO 결과발표

    '********************************************


    '************************************************
    '************************************************
    '************************************************

MAIN: '라벨설정
    GOSUB GOSUB_RX_EXIT
    ETX 4800, 38 ' 동작 멈춤 확인 송신 값


MAIN_2:
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    GOSUB 적외선거리센서확인

    'GOSUB GOSUB_RX_EXIT
    ERX 4800,A,MAIN_2	

    A_old = A


MAIN_3:
    IF A >= 100 THEN
        ON 동작모드 GOTO MAIN,방위인식,화살표인식,알파벳색상인식,알파벳인식,구역색상인식,미션수행확인,우유곽찾기,우유곽옮기기,우유곽내리고돌아오기,라인트레이싱
        'GOTO MAIN
    ELSE
        '**** 입력된 A값이 0 이면 MAIN 라벨로 가고
        '**** 1이면 KEY1 라벨, 2이면 key2로... 가는문
        ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32

    ENDIF


    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************


    '****************************
KEY1:
    GOTO 모드_방위인식

    '****************************
KEY2:
    HIGHSPEED SETON
    보행횟수= 1
    GOSUB 횟수_전진종종걸음
    HIGHSPEED SETOFF
    GOTO MAIN

    '****************************
KEY3:
    GOSUB Arm_motor_mode3
    SPEED 17
    MOVE G6B,190, 10, 100 '양손 앞으로 나란히
    MOVE G6C,190, 10, 100
    DELAY 200
    GOTO MAIN

    '****************************
KEY4:
    GOTO 모드_문열고들어가기
    GOTO MAIN

    '****************************
KEY5:
    GOSUB 전방하향35도
    GOTO MAIN


    '****************************
KEY6:
    GOTO 모드_미션수행확인

    '****************************
KEY7:
    GOTO 우유곽들기

    '****************************
KEY8:
    GOTO 모드_우유곽옮기기

    '****************************
KEY9:
    GOTO 모드_우유곽내리고돌아오기

    '****************************
KEY10: ' 0
    GOTO 모드_라인트레이싱

    '****************************
    '********************************

KEY11: ' ▲
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY12: ' ▼
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY13: ' ▶
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY14: ' ◀
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY15: ' A
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY16: ' POWER
    GOSUB Leg_motor_mode3
    IF MODE = 0 THEN
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT
    ENDIF
    SPEED 4
    GOSUB 앉은자세	
    GOSUB 종료음

    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF


    GOSUB GOSUB_RX_EXIT

KEY16_1:

    IF 모터ONOFF = 1  THEN
        OUT 52,1
        DELAY 200
        OUT 52,0
        DELAY 200
    ENDIF
    ERX 4800,A,KEY16_1
    ETX  4800,A

    '**** RX DATA Number Sound ********
    BUTTON_NO = A
    GOSUB Number_Play
    GOSUB SOUND_PLAY_CHK


    IF  A = 16 THEN 	'다시 파워버튼을 눌러야만 복귀
        GOSUB MOTOR_ON
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT

        GOSUB 기본자세
        GOSUB 자이로ON
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOSUB GOSUB_RX_EXIT
    GOTO KEY16_1


    GOTO RX_EXIT

    '****************************
    '********************************

KEY17: ' C
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY18: ' E
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY19: ' P2
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY20: ' B	
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY21: ' △
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************
KEY22: ' *	
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY23: ' G
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY24: ' #
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY25: ' P1
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY26: ' ■
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY27: ' D
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY28: ' ◁
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY29: ' □
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY30: ' ▷
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY31: ' ▽
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY32: ' F
    보행순서 = 0
    반전체크 = 0
    기울기확인횟수 = 0
    보행횟수 = 1
    모터ONOFF = 0

    동작모드 = 1
    동작모드_old = 0
    호출함수 = 201
    '전진 = 0
    '문열기 = 0
    이동방향 = 0
    화살표 = 1
    알파벳 = 0
    '알파벳색상 = 0
    확인구역수 = 3
    구역 = 0
    확진구역1 = 0
    확진구역2 = 2
    확진구역3 = 0
    확인 = 0
    회전수 = 0
    결과 = 0

    xcount = 0
    ycount = 0

    A = 0


    TEMPO 230
    MUSIC "cdefg"


    SPEED 5
    GOSUB MOTOR_ON

    S11 = MOTORIN(11)
    S16 = MOTORIN(16)

    SERVO 11, 100
    SERVO 16, 100


    GOSUB 전원초기자세
    GOSUB 기본자세


    GOSUB 자이로INIT
    GOSUB 자이로MID
    GOSUB 자이로ON


    PRINT "OPEN 20GongMo.mrs !"
    PRINT "VOLUME 200 !"
    'PRINT "SOUND 12 !" '안녕하세요

    GOSUB All_motor_mode3


    'GOTO 모드_방위인식
    GOTO MAIN

    '****************************
    '********************************
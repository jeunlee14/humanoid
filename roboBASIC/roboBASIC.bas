'********** Setting Begin **********'

CONST cHEAD_SPEED = 6
CONST cIR_SENSOR_PORT = 4

CONST cCOUNT_MAX =3
CONST cMIN = 61	'�ڷγѾ�������
CONST cMAX = 107	'�����γѾ�������
CONST cFB_TILT_AD_PORT = 0
CONST cLR_TILT_AD_PORT = 1
CONST cTILT_TIME_CHECK = 20  'ms

CONST ���ܼ�AD��Ʈ  = 4

'********** Setting End **********'

'********** Protocol Value Begin **********'

CONST cSIGNAL_CHECK = &H40
CONST cSIGNAL_IMAGE = &H41
CONST cSIGNAL_STATE = &H42

CONST cMOTION_LINE_MOVE_FRONT_BIG = &H80
CONST cMOTION_LINE_MOVE_FRONT_SMALL = &H81
CONST cMOTION_LINE_MOVE_LEFT = &H82
CONST cMOTION_LINE_MOVE_RIGHT = &H83
CONST cMOTION_LINE_TURN_LEFT_SMALL = &H84
CONST cMOTION_LINE_TURN_RIGHT_SMALL = &H85
CONST cMOTION_LINE_TURN_LEFT_BIG = &H86
CONST cMOTION_LINE_TURN_RIGHT_BIG = &H87
CONST cMOTION_LINE_LOST = &H88
CONST cMOTION_LINE_CORNER = &H89

CONST cMOTION_DIRECTION_UNKNOWN = &H90
CONST cMOTION_DIRECTION_EAST = &H91
CONST cMOTION_DIRECTION_WEST = &H92
CONST cMOTION_DIRECTION_SOUTH = &H93
CONST cMOTION_DIRECTION_NORTH = &H94
CONST cMOTION_DIRECTION_DOOR = &H95

CONST cMOTION_ARROW_UNKNOWN = &HA0
CONST cMOTION_ARROW_RIGHT = &HA1
CONST cMOTION_ARROW_LEFT = &HA2

CONST cMOTION_AREA_BLACK= &HB0
'CONST cMOTION_AREA_GREEN = &H100

'�̼� ���� Ƚ��
CONST cMOTION_MILK_LOST = &HC0
CONST cMOTION_MILK_POSION_FRONT_BIG = &HC1
CONST cMOTION_MILK_POSION_FRONT_SMALL = &HC2
CONST cMOTION_MILK_POSION_LEFT = &HC3
CONST cMOTION_MILK_POSION_RIGHT = &HC4
CONST cMOTION_MILK_CATCH = &HC5

DIM rx_data AS BYTE
DIM i AS BYTE
DIM dMISSION_NUMBER AS BYTE
DIM dALPHABET AS BYTE
DIM dARROW AS BYTE
DIM dBLACK_AREA AS BYTE
DIM dBLACK_AREA_FIRST AS BYTE
DIM dBLACK_AREA_SECOND AS BYTE
DIM dBLACK_AREA_THIRD AS BYTE
DIM dWALK_NUMBER AS BYTE
DIM dWALK_SPEED AS BYTE
DIM dWALK_ORDER AS BYTE
DIM dWALK_COUNT AS BYTE
DIM dFALL_CHECK AS BYTE
DIM dTILT_FRONT AS BYTE
DIM dTILT_BACK AS BYTE
DIM dGYRO_ON_OFF AS BYTE
DIM dINFRARED_dISTANCE_VALUE AS BYTE

'********** Potocol Value End **********'
dWALK_ORDER = 0
dARROW = &HA1

GOTO Main

'********** Motor Control Begin **********'

MotorAllOn:
    GOSUB MotorGetAndSet

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    GOSUB SoundStart
    RETURN

MotorAllOff:
    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D

    GOSUB MotorGetAndSet
    GOSUB SoundFinish
    RETURN

MotorGetAndSet:
    GETMOTORSET G6A, 1, 1, 1, 1, 1, 0
    GETMOTORSET G6B, 1, 1, 1, 0, 0, 1
    GETMOTORSET G6C, 1, 1, 1, 0, 1, 0
    GETMOTORSET G6D, 1, 1, 1, 1, 1, 0
    RETURN

    '****************************************

MotorAllMode1:
    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1
    RETURN

MotorAllMode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2
    RETURN

MotorAllMode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3

    RETURN

    '****************************************

MotorLegMode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN

MotorLegMode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

MotorLegMode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN

    '****************************************

MotorArmMode1:
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1
    RETURN

MotorArmMode2:
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2
    RETURN

MotorArmMode3:
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3
    RETURN

    '********** MOTOR Control END **********'


    '********** Posture Setting Begin **********'

PostureInit:
    MOVE G6A, 100,  76, 145,  93, 100, 100
    MOVE G6D, 100,  76, 145,  93, 100, 100
    MOVE G6B, 100,  35,  90,
    MOVE G6C, 100,  35,  90
    WAIT
    RETURN

PostureDefault:
    MOVE G6A, 100,  76, 145,  93, 100, 100
    MOVE G6D, 100,  76, 145,  93, 100, 100
    MOVE G6B, 100,  30,  80,
    MOVE G6C, 100,  30,  80,
    WAIT
    RETURN

PostureMilk:
    MOVE G6A, 100,  76, 145,  93, 100, 100
    MOVE G6D, 100,  76, 145,  93, 100, 100
    MOVE G6B, 190,  15,  55,  ,  ,
    MOVE G6C, 190,  15,  55,  ,  ,
    WAIT
    RETURN

PostureSit:
    GOSUB GyroOff

    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    RETURN

    '****************************************

PostureHeadLeft10:
    SPEED cHEAD_SPEED
    SERVO 11, 90
    WAIT
    RETURN

PostureHeadLeft45:
    SPEED cHEAD_SPEED
    SERVO 11, 55
    WAIT
    RETURN

PostureHeadRight10:
    SPEED cHEAD_SPEED
    SERVO 11, 110
    WAIT
    RETURN

PostureHeadRight45:
    SPEED cHEAD_SPEED
    SERVO 11, 145
    WAIT
    RETURN

    '****************************************

PostureHeadDown30:
    SPEED cHEAD_SPEED
    SERVO 16, 30
    WAIT
    RETURN

PostureHeadDown35:
    SPEED cHEAD_SPEED
    SERVO 16, 35
    WAIT
    RETURN

PostureHeadDown70:
    SPEED cHEAD_SPEED
    SERVO 16, 70
    WAIT
    RETURN

PostureHeadDown80:
    SPEED cHEAD_SPEED
    SERVO 16, 80
    WAIT
    RETURN

PostureHeadDown86:
    SPEED cHEAD_SPEED
    SERVO 16, 86
    WAIT
    RETURN

PostureHeadDown100:
    SPEED cHEAD_SPEED
    SERVO 16, 100
    WAIT
    RETURN

    '********** Posture Setting End **********'


    '********** Sound Begin **********'

SoundStart:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN

SoundFinish:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN

SoundError:
    TEMPO 250
    MUSIC "FFF"
    RETURN

    '********** Sound End **********'


    '********** Check Begin **********'

CheckTiltFB:
    FOR i = 0 TO cCOUNT_MAX
        dTILT_FRONT = AD(cFB_TILT_AD_PORT)	'���� �յ�

        IF dTILT_FRONT > 250 OR dTILT_FRONT < 5 THEN RETURN
        IF dTILT_FRONT > cMIN AND dTILT_FRONT < cMAX THEN RETURN
        DELAY cTILT_TIME_CHECK
    NEXT i

    IF dTILT_FRONT < cMIN THEN
        GOSUB CheckTiltFront
    ELSEIF dTILT_FRONT > cMAX THEN
        GOSUB CheckTiltBack
    ENDIF

    RETURN

CheckTiltFront:
    dTILT_FRONT = AD(cFB_TILT_AD_PORT)

    IF dTILT_FRONT < cMIN THEN
        ETX  4800,16
        GOSUB MotionBackStandup
    ENDIF

    RETURN

CheckTiltBack:
    dTILT_FRONT = AD(cFB_TILT_AD_PORT)

    IF dTILT_FRONT > cMAX THEN
        ETX  4800,15
        GOSUB MotionFrontStandup
    ENDIF

    RETURN

    '********** Check End **********'


    '********** Gyro Begin **********'

GyroInit:
    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0
    RETURN


GyroMid:
    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0
    RETURN


GyroOn:
    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    dGYRO_ON_OFF = 1
    RETURN


GyroOff:
    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0

    dGYRO_ON_OFF = 0
    RETURN

    '********** Gyro End **********'


    '********** Motion Begin **********'

MotionFrontStandup:
    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB GyroOff

    GOSUB MotorAllMode1

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

    GOSUB MotorLegMode3

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
    GOSUB MotorAllMode2

    GOSUB PostureDefault

    dFALL_CHECK = 1

    DELAY 200
    GOSUB GyroOn


    'ETX 4800, ȣ���Լ�


    GOTO Main

MotionBackStandup:
    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB GyroOff

    GOSUB MotorAllMode1

    SPEED 15
    GOSUB PostureDefault

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

    GOSUB MotorLegMode3

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
    GOSUB PostureDefault

    dFALL_CHECK = 1

    DELAY 200
    GOSUB GyroOn


    'ETX 4800, ȣ���Լ�


    GOTO Main

    '****************************************

MotionCountWalk:

    dWALK_SPEED = 15
    dFALL_CHECK = 0
    dWALK_COUNT = 0

    GOSUB MotorAllMode3

    SPEED dWALK_SPEED

    IF dWALK_ORDER = 0 THEN
        dWALK_ORDER = 1

        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO MotionCountWalk_1

    ELSE
        dWALK_ORDER = 0

        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO MotionCountWalk_2

    ENDIF


    '************************************	

MotionCountWalk_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C, 115
    WAIT

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT


    GOSUB CheckTiltFB
    IF dFALL_CHECK = 1 THEN
        dFALL_CHECK = 0
        GOTO MAIN
    ENDIF


    dWALK_COUNT = dWALK_COUNT + 1

    IF dWALK_COUNT > dWALK_NUMBER THEN
        GOTO MotionCountWalk_1_Stop

    ELSE
        GOTO MotionCountWalk_2

    ENDIF


MotionCountWalk_1_Stop:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT


    SPEED 12
    GOSUB PostureInit

    SPEED 4
    GOSUB PostureDefault


    RETURN

    '************************************

MotionCountWalk_2:
    MOVE G6D,95,  90, 125, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT

    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB CheckTiltFB
    IF dFALL_CHECK = 1 THEN
        dFALL_CHECK = 0
        GOTO MAIN
    ENDIF


    dWALK_COUNT = dWALK_COUNT + 1

    IF dWALK_COUNT > dWALK_NUMBER THEN
        GOTO MotionCountWalk_2_Stop

    ELSE
        GOTO MotionCountWalk_1

    ENDIF


MotionCountWalk_2_Stop:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    SPEED 12
    GOSUB PostureInit

    SPEED 4
    GOSUB PostureDefault


    RETURN

    '****************************************
MotionMilkWalk:

    '�ӽ� �׹�°�� �㸮 -5����
    GOSUB MotionCatchMilk

    dWALK_SPEED = 7
    dFALL_CHECK = 0
    dWALK_COUNT = 0

    GOSUB MotorAllMode3

    SPEED dWALK_SPEED

    IF dWALK_ORDER = 0 THEN
        dWALK_ORDER = 1

        MOVE G6A,95,  76, 147,  83, 101
        MOVE G6D,101,  76, 147,  83, 98

        WAIT

        GOTO MotionMilkWalk_1

    ELSE
        dWALK_ORDER = 0

        MOVE G6D,95,  76, 147,  83, 101
        MOVE G6A,101,  76, 147,  83, 98

        WAIT

        GOTO MotionMilkWalk_2

    ENDIF


    '************************************	

MotionMilkWalk_1:
    MOVE G6A,95,  90, 125, 90, 104
    MOVE G6D,104,  77, 147,  83,  102
    WAIT

    MOVE G6A,103,   73, 140, 93,  100
    MOVE G6D, 95,  85, 147,  75, 102
    WAIT


    GOSUB CheckTiltFB
    IF dFALL_CHECK = 1 THEN
        dFALL_CHECK = 0
        GOTO MAIN
    ENDIF


    dWALK_COUNT = dWALK_COUNT + 1

    IF dWALK_COUNT > dWALK_NUMBER THEN
        GOTO MotionMilkWalk_1_Stop

    ELSE
        GOTO MotionMilkWalk_2

    ENDIF


MotionMilkWalk_1_Stop:
    MOVE G6D,95,  90, 125, 85, 104
    MOVE G6A,104,  76, 145,  81,  102
    WAIT


    SPEED 12
    GOSUB PostureMilk

    '    SPEED 4
    '    GOSUB PostureDefault


    RETURN

    '************************************

MotionMilkWalk_2:
    MOVE G6D,95,  90, 125, 90, 104
    MOVE G6A,104,  77, 147,  83,  102
    WAIT

    MOVE G6D,103,    73, 140, 93,  100
    MOVE G6A, 95,  85, 147,  75, 102
    WAIT


    GOSUB CheckTiltFB
    IF dFALL_CHECK = 1 THEN
        dFALL_CHECK = 0
        GOTO MAIN
    ENDIF


    dWALK_COUNT = dWALK_COUNT + 1

    IF dWALK_COUNT > dWALK_NUMBER THEN
        GOTO MotionMilkWalk_2_Stop

    ELSE
        GOTO MotionMilkWalk_1

    ENDIF


MotionMilkWalk_2_Stop:
    MOVE G6A,95,  90, 125, 85, 104
    MOVE G6D,104,  76, 145,  81,  102
    WAIT

    SPEED 12
    GOSUB PostureMilk

    '    SPEED 4
    '    GOSUB PostureDefault


    RETURN


    '****************************************


MotionOpenDoor:
    SPEED 17
    MOVE G6B,190, 10, 100
    MOVE G6C,190, 10, 100

    dWALK_NUMBER = 10
    GOSUB MotionCountWalk

    'HIGHSPEED SETON
    'GOSUB Ƚ��_������������_��
    'HIGHSPEED SETOFF

    DELAY 1000 '�� ���������� ���

    RETURN

    '****************************************

MotionTurnLeft10:
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

    GOSUB PostureDefault

    RETURN

MotionTurnRight10:
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

    GOSUB PostureDefault

    RETURN

MotionTurnRight20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8
    MOVE G6D,93,  96, 145,  73, 105, 100
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 6
    MOVE G6D,93,  96, 145,  73, 105, 100
    MOVE G6A,94,  56, 145,  113, 105, 100
    WAIT

    SPEED 7
    MOVE G6D,93,  96, 145,  73, 105, 100
    MOVE G6A,93,  56, 145,  113, 105, 100
    WAIT

    SPEED 6
    MOVE G6D,100,  76, 146,  93, 98, 100
    MOVE G6A,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB PostureDefault

    RETURN

MotionTurnLeft20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6C,90
    MOVE G6B,110
    WAIT

    SPEED 6
    MOVE G6D,94,  56, 145,  113, 105, 100
    MOVE G6A,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 7
    MOVE G6D,93,  56, 145,  113, 105, 100
    MOVE G6A,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6A,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB PostureDefault

    RETURN

MotionGoLeftSide20:
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

    GOSUB PostureDefault
    GOSUB MotorAllMode3


    RETURN

MotionGoRightSide20:
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
    GOSUB PostureDefault
    GOSUB MotorAllMode3

    RETURN

    '****************************************
MotionCatchMilk:

    GOSUB MotorLegMode3

    SPEED 6
    GOSUB PostureSit
    WAIT

    GOSUB MotorArmMode3

    SPEED 10
    MOVE G6B,150, 10, 100              '�Ȼ���
    MOVE G6C,150, 10, 100
    WAIT	

    SPEED 4
   ' MOVE G6A,  87, 145,  33, 159, 115, '�� �ޱ�����
'    MOVE G6D,  87, 145,  33, 159, 115,
'    WAIT

	MOVE G6A,  77, 155,  33, 144, 120,  
	MOVE G6D,  77, 155,  33, 144, 120,  
	WAIT
	
    SPEED 5
    MOVE G6B, 145,  15,  55,  ,  ,     '������ ���
    MOVE G6C, 145,  15,  55,  ,  ,
    WAIT
	
    MOVE G6B, 140,  15,  55,  ,  ,     '������ ���
    MOVE G6C, 140,  15,  55,  ,  ,
	WAIT 
	
    MOVE G6B,150, 30, 100              '�Ȼ���
    MOVE G6C,150, 30, 100
    WAIT
	
	SPEED 5
    MOVE G6B, 145,  15,  55,  ,  ,     '������ ���
    MOVE G6C, 145,  15,  55,  ,  ,
    WAIT

    MOVE G6B,150, 20, 100              '�Ȼ���
    MOVE G6C,150, 20, 100
    WAIT


    SPEED 4
    MOVE G6B, 145,  15,  55,  ,  ,     '������ ���
    MOVE G6C, 145,  15,  55,  ,  ,
    WAIT

    SPEED 6
    MOVE G6A, 100, 145,  28, 145, 100, '�ٸ�������
    MOVE G6D, 100, 145,  28, 145, 100,
    WAIT

    SPEED 5
    MOVE G6A,100, 76, 145,  93, 100, 100 '�Ͼ��
    MOVE G6D,100, 76, 145,  93, 100, 100
    WAIT

    MOVE G6B, 190,  15,  55,  ,  ,     '������ ��� �� ����
    MOVE G6C, 190,  15,  55,  ,  ,
    WAIT


    '    MOVE G6A, 100,  76, 145,  83, 100,   '�㸮���
    '    MOVE G6D, 100,  76, 145,  83, 100,
    '    WAIT


    GOSUB MotorAllMode3
    GOSUB GyroOn

    RETURN

MotionPutMilk:

    RETURN
    '********** Motion End **********'


    '********** Function Begin **********'

Initiate:
    PTP SETON
    PTP ALLON	

    PRINT "OPEN 20GongMo.mrs !"
    PRINT "VOLUME 200 !"

    DIR G6A, 1, 0, 0, 1, 0, 0
    DIR G6D, 0, 1, 1, 0, 1, 1
    DIR G6B, 1, 1, 1, 1, 1, 1
    DIR G6C, 0, 0, 0, 0, 1, 0

    OUT 52, 0

    TEMPO 230
    MUSIC "CDEFG"

    SPEED 50
    GOSUB MotorAllOn

    SERVO 11, 100
    SERVO 16, 100

    GOSUB PostureInit
    GOSUB PostureDefault

    PRINT "VOLUME 200 !"
    PRINT "SND 12 !"

    GOSUB GyroInit
    GOSUB GyroMid
    GOSUB GyroON

    GOSUB MotorAllMode3
    dMISSION_NUMBER = 0


    RETURN


UartRx:
    DELAY 10

    ERX 4800, rx_data, UartRx_2
    GOTO UartRx

UartRx_2:
    RETURN

UartConnectWait:
    ERX 4800, rx_data, UartConnectWait

    IF rx_data = cSIGNAL_CHECK THEN
        RETURN

    ELSEIF rx_data < &H40 THEN
        GOTO Main_2
    ENDIF

    GOTO UartConnectWait	


    '********** Function End **********'


    '********** State Begin **********'

StateDirectionRecognition:
    GOSUB PostureHeadDown86
    GOSUB PostureHeadLeft10
    WAIT	'or DELAY

    ETX 4800, cSIGNAL_IMAGE
    GOSUB UartRx

    IF rx_data = cMOTION_DIRECTION_UNKNOWN THEN
        GOSUB PostureHeadRight10
        DELAY 300

        ETX 4800, cSIGNAL_IMAGE
        GOSUB UartRx
    ENDIF

    GOSUB MotorArmMode3
    SPEED 15

    IF rx_data = cMOTION_DIRECTION_EAST THEN
        MOVE G6B, 100,  30,  80
        MOVE G6C, 190,  10, 100
        DELAY 200
        PRINT "SND 0 !"

    ELSEIF rx_data = cMOTION_DIRECTION_WEST THEN
        MOVE G6B, 190,  10, 100
        MOVE G6C, 100,  30,  80
        DELAY 200
        PRINT "SND 1 !"

    ELSEIF rx_data = cMOTION_DIRECTION_SOUTH THEN
        MOVE G6B,  10,  10, 100
        MOVE G6C,  10,  10, 100
        DELAY 200
        PRINT "SND 2 !"

    ELSEIF rx_data = cMOTION_DIRECTION_NORTH THEN
        MOVE G6B, 190,  10, 100
        MOVE G6C, 190,  10, 100
        DELAY 200
        PRINT "SND 3 !"

    ENDIF

    GOSUB PostureDefault
    GOSUB MotorArmMode1

    ETX 4800, cSIGNAL_STATE		
    GOTO StateLineTracingToDoor1


StateLineTracingToDoor1:
    GOSUB PostureHeadDown35
    GOSUB MotorAllMode3
    WAIT	'or DELAY

StateLineTracingToDoor2:
    ETX 4800, cSIGNAL_IMAGE
    GOSUB UartRx

    IF rx_data = cMOTION_LINE_LOST THEN
        GOSUB MotionOpenDoor

        'MUSIC "GFEDC"		'����?????
        'STOP 'temp fin'

        ETX 4800, cSIGNAL_STATE	
        GOTO StateArrowRecognition

    ELSEIF rx_data = cMOTION_LINE_MOVE_FRONT_SMALL THEN	
        dWALK_NUMBER = 4
        GOSUB MotionCountWalk

    ELSEIF rx_data = cMOTION_LINE_TURN_LEFT_SMALL THEN
        GOSUB MotionTurnLeft10

    ELSEIF rx_data = cMOTION_LINE_TURN_RIGHT_SMALL THEN
        GOSUB MotionTurnRight10

    ELSEIF rx_data = cMOTION_LINE_TURN_LEFT_BIG THEN
        GOSUB MotionTurnLeft20

    ELSEIF rx_data = cMOTION_LINE_TURN_RIGHT_BIG THEN
        GOSUB MotionTurnRight20

    ELSEIF rx_data = cMOTION_LINE_MOVE_LEFT THEN
        GOSUB MotionGoLeftSide20

    ELSEIF rx_data = cMOTION_LINE_MOVE_RIGHT THEN
        GOSUB MotionGoRightSide20

    ENDIF

    GOTO StateLineTracingToDoor2


StateArrowRecognition:
    GOSUB MotorArmMode1
    GOSUB PostureHeadDown100
    WAIT	'or DELAY

    ETX 4800, cSIGNAL_IMAGE
    GOSUB UartRx

    IF rx_data = cMOTION_ARROW_UNKNOWN THEN
        '�ν� ���� �� ���� ���� �ʿ�
        ETX 4800, cSIGNAL_IMAGE
        GOSUB UartRx
        '���� �� ȸ�� �� ����
    ELSEIF rx_data = cMOTION_ARROW_RIGHT THEN

        dARROW = cMOTION_ARROW_RIGHT	' ���� �ν� �� �ʿ�  or  ȸ����Ǽ۽�

        FOR i = 1 TO 5
            GOSUB MotionTurnRight20
        NEXT i

    ELSEIF rx_data = cMOTION_ARROW_LEFT THEN

        dARROW = cMOTION_ARROW_LEFT		' ���� �ν� �� �ʿ�  or  ȸ����Ǽ۽�

        FOR i = 1 TO 5
            GOSUB MotionTurnLeft20
        NEXT i

    ENDIF


    GOSUB PostureDefault

    ETX 4800, cSIGNAL_STATE	
    GOTO StateLineTracing1


StateLineTracing1:
    GOSUB PostureHeadDown30
    GOSUB MotorAllMode3
    WAIT	'or DELAY

StateLineTracing2:
    ETX 4800, cSIGNAL_IMAGE
    GOSUB UartRx

    IF rx_data = cMOTION_LINE_LOST THEN

        ' ���� ��Ż�� ��ó ��� ���ϱ� ->�ʿ� x

    ELSEIF rx_data = cMOTION_LINE_MOVE_FRONT_SMALL THEN	
        dWALK_NUMBER = 4
        GOSUB MotionCountWalk

    ELSEIF rx_data = cMOTION_LINE_TURN_LEFT_SMALL THEN
        GOSUB MotionTurnLeft10

    ELSEIF rx_data = cMOTION_LINE_TURN_RIGHT_SMALL THEN
        GOSUB MotionTurnRight10

    ELSEIF rx_data = cMOTION_LINE_TURN_LEFT_BIG THEN
        GOSUB MotionTurnLeft20

    ELSEIF rx_data = cMOTION_LINE_TURN_RIGHT_BIG THEN
        GOSUB MotionTurnRight20

    ELSEIF rx_data = cMOTION_LINE_MOVE_LEFT THEN
        GOSUB MotionGoLeftSide20

    ELSEIF rx_data = cMOTION_LINE_MOVE_RIGHT THEN
        GOSUB MotionGoRightSide20

    ELSEIF rx_data = cMOTION_LINE_CORNER THEN
        ETX 4800, cSIGNAL_STATE		
        '�ڳ� �߰� �� ����� �ɾ���� ����
        GOTO StateAlphabetRecognition

    ENDIF

    GOTO StateLineTracing2

StateAlphabetRecognition:
    GOSUB PostureHeadDown86
    GOSUB MotorAllMode1
    WAIT	'or DELAY

    ETX 4800, cSIGNAL_IMAGE
    GOSUB UartRx '���ĺ� ����, ���� X '���� �޾ƿ� �ʿ� x

    ' �ν� ������ ��� �ʿ��Ѱ�?

    dALPHABET = rx_data		' ������ Ȯ������ ���Ҷ� �ʿ�

    ETX 4800, cSIGNAL_STATE		
    GOTO StateAreaRecognition


StateAreaRecognition:

    dBLACK_AREA = 0		' �̼� ���� �� �ʿ�

    'ȭ��ǥ ���� ���� ȸ��
    IF dARROW = cMOTION_ARROW_RIGHT THEN
        GOSUB PostureHeadRight45

    ELSEIF dARROW = cMOTION_ARROW_LEFT THEN
        GOSUB PostureHeadLeft45

    ENDIF

    GOSUB PostureHeadDown80
    WAIT	'or DELAY

    ETX 4800, cSIGNAL_IMAGE
    GOSUB UartRx

    dMISSION_NUMBER = dMISSION_NUMBER + 1

    ETX 4800, cSIGNAL_STATE

    IF rx_data = cMOTION_AREA_BLACK THEN	' Ȯ�������̸� ���ĺ� �� ����
        dBLACK_AREA = 1
        ON dMISSION_NUMBER GOTO BlackAreaSaveFirst, BlackAreaSaveSecond, BlackAreaSaveThird

        GOTO StateMilkPosionFind_1

    ENDIF


    ' Ȯ������ ���� , �ʱ�ȭ �ʿ�? ���������̸�?
BlackAreaSaveFirst:
    dBLACK_AREA_FIRST = dALPHABET
    GOTO StateMilkPosionFind_1


BlackAreaSaveSecond:
    dBLACK_AREA_SECOND = dALPHABET
    GOTO StateMilkPosionFind_1


BlackAreaSaveThird:
    dBLACK_AREA_THIRD = dALPHABET
    GOTO StateMilkPosionFind_1


StateMilkPosionFind_1:

    GOSUB PostureHeadDown35
    DELAY 1000

    ETX 4800, cSIGNAL_IMAGE
    GOSUB UartRx

    IF rx_data = cMOTION_MILK_LOST THEN
        GOSUB PostureHeadDown70
        DELAY 1000
        GOTO StateMilkPosionFind_3

    ELSEIF rx_data = cMOTION_MILK_CATCH THEN
        GOSUB MotionCatchMilk
        
        GOTO Main

        'ETX 4800, cSIGNAL_STATE

        'GOTO StateMilkCarry

    ENDIF


StateMilkPosionFind_2:

    IF rx_data = cMOTION_MILK_POSION_FRONT_BIG OR rx_data = cMOTION_MILK_CATCH THEN'�������� 70���� ��츸
        dWALK_NUMBER= 8
        GOSUB MotionCountWalk

    ELSEIF rx_data = cMOTION_MILK_POSION_FRONT_SMALL THEN
        dWALK_NUMBER= 8
        GOSUB MotionCountWalk

    ELSEIF rx_data = cMOTION_MILK_POSION_LEFT THEN
        GOSUB MotionGoLeftSide20

    ELSEIF rx_data = cMOTION_MILK_POSION_RIGHT THEN
        GOSUB MotionGoRightSide20

    ENDIF

    GOTO StateMilkPosionFind_1


StateMilkPosionFind_3:
    ETX 4800, cSIGNAL_IMAGE
    GOSUB UartRx

    IF rx_data = cMOTION_MILK_LOST THEN

        IF dARROW = cMOTION_ARROW_RIGHT THEN
            GOSUB MotionTurnRight20
        ELSEIF dARROW = cMOTION_ARROW_LEFT THEN
            GOSUB MotionTurnLeft20
        ENDIF

        GOTO StateMilkPosionFind_1

    ELSE
        GOTO StateMilkPosionFind_2

    ENDIF


StateMilkCarry:
    ' Ȯ������ �ٷ� �ڳ�ã��

    IF dBLACK_AREA = 1 THEN		
        GOTO StateCornerRecognition

        ' ��������
        ' �� ������ ���� ��ġ Ȯ�� �� ȸ���ؼ� �������� ����




        GOSUB MotionPutMilk 	

    ENDIF

    ETX 4800, cSIGNAL_IMAGE
    GOSUB UartRx

    GOTO StateCornerRecognition

StateCornerRecognition:
    ' �ȴ� ����� �ٸ���
    ' ���������� ������ �̹� �������� �Ȱ�,
    ' Ȯ�������� �������� ��� �ȴ´�.

    ETX 4800, cSIGNAL_IMAGE
    GOSUB UartRx

    IF rx_data = cMOTION_MILK_POSION_FRONT_BIG THEN
        dWALK_NUMBER= 4
        GOSUB MotionCountWalk

    ELSEIF rx_data = cMOTION_MILK_POSION_FRONT_SMALL THEN
        dWALK_NUMBER= 1
        GOSUB MotionCountWalk

    ELSEIF rx_data = cMOTION_MILK_POSION_LEFT THEN
        GOSUB MotionGoLeftSide20

    ELSEIF rx_data = cMOTION_MILK_POSION_RIGHT THEN
        GOSUB MotionGoRightSide20

    ENDIF


    GOTO StateLineTracing1



    'Ȯ�� ���� ��ǥ!!!

    '********** State End **********'

    '********** Main Begin **********'

Main:
    GOSUB Initiate
    GOSUB UartRx
    'GOTO StateDirectionRecognition
    'GOSUB PostureHeadDown100
    'GOTO StateMilkPosionFind_1

    'dWALK_NUMBER = 8
    'GOSUB MotionCountWalk

Main_2:

    ON rx_data GOTO Main, KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28,KEY29,KEY30,KEY31,KEY32

    '********** Main End **********'

    '********** Key Begin **********'
    '****************************
KEY1:
    GOSUB PostureInit
    GOTO UartConnectWait


    '****************************
KEY2:
    GOSUB MotionGoLeftSide20
    GOTO UartConnectWait


    '****************************
KEY3:
    GOSUB MotionGoRightSide20
    GOTO UartConnectWait


    '****************************
KEY4:
    GOSUB MotionOpenDoor
    GOTO UartConnectWait


    '****************************
KEY5:
    GOSUB MotionTurnLeft10
    GOTO UartConnectWait


    '****************************
KEY6:
    GOSUB MotionTurnRight10
    GOTO UartConnectWait


    '****************************
KEY7:
    GOSUB MotionTurnLeft20
    GOTO UartConnectWait


    '****************************
KEY8:
    GOSUB MotionTurnRight20
    GOTO UartConnectWait


    '****************************
KEY9:
    GOSUB PostureHeadDown30
    GOTO UartConnectWait


    '****************************
KEY10: '0
    GOSUB PostureHeadDown100
    GOTO UartConnectWait


    '****************************
    '********************************

KEY11: ' ��
    dWALK_NUMBER = 2
    GOSUB MotionCountWalk
    GOTO UartConnectWait


    '****************************
    '********************************

KEY12: ' ��
	GOSUB PostureSit
    GOTO UartConnectWait



    '****************************
    '********************************

KEY13: ' ��
    GOTO UartConnectWait


    '****************************
    '********************************

KEY14: ' ��
    GOTO UartConnectWait


    '****************************
    '********************************

KEY15: ' A
    GOTO UartConnectWait


    '****************************
    '********************************

KEY16: ' POWER
    GOTO UartConnectWait


    '****************************
    '********************************

KEY17: ' C
    GOTO UartConnectWait



    '****************************
    '********************************

KEY18: ' E
    dWALK_NUMBER = 10
    GOSUB MotionMilkWalk
    GOTO UartConnectWait


    '****************************
    '********************************

KEY19: ' P2
    GOTO UartConnectWait



    '****************************
    '********************************

KEY20: ' B	
    GOTO UartConnectWait


    '****************************
    '********************************

KEY21: ' ��
    GOTO UartConnectWait


    '****************************
    '********************************
KEY22: ' *	
    GOTO UartConnectWait


    '****************************
    '********************************

KEY23: ' G
    GOTO UartConnectWait


    '****************************
    '********************************

KEY24: ' #
    GOTO UartConnectWait


    '****************************
    '********************************

KEY25: ' P1
    GOTO UartConnectWait


    '****************************
    '********************************

KEY26: ' ��
    GOTO UartConnectWait


    '****************************
    '********************************

KEY27: ' D
    GOTO UartConnectWait


    '****************************
    '********************************

KEY28: ' ��
    GOTO UartConnectWait


    '****************************
    '********************************

KEY29: ' ��
    GOTO UartConnectWait


    '****************************
    '********************************

KEY30: ' ��
    GOTO UartConnectWait


    '****************************
    '********************************

KEY31: ' ��
    GOTO UartConnectWait


    '****************************
    '********************************

KEY32: ' F
    GOTO StateMilkPosionFind_1


    '********** Key End **********'

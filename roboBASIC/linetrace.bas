'******** 2�� ����κ� �ʱ� ���� ���α׷� ********
'******** INIT ���� ********
DIM ȣ���Լ� AS BYTE
DIM �νĽ���Ƚ�� AS BYTE
DIM ȭ��ǥ AS BYTE

CONST �νĽ���= 129
CONST �����ν�= 201
CONST ȭ��ǥ�ν�= 202
CONST ���������= 203
CONST ���������2 = 204
CONST ���ĺ������ν�= 205
CONST ���ĺ��ν�= 206
CONST ���������ν�= 207
CONST ����Ʈ���̽�= 210
CONST ���� = 113
CONST ���� = 114
CONST ���� = 112
CONST ���� = 111
CONST ������ = 113
CONST ���� = 114

DIM ���۸��_old AS BYTE
DIM ���۸�� AS BYTE
DIM �̵����� AS BYTE
DIM Ȯ�α����� AS BYTE
DIM ���ĺ����� AS BYTE
DIM ���ĺ� AS BYTE
DIM ���� AS BYTE
DIM Ȯ������1 AS BYTE
DIM Ȯ������2 AS BYTE
DIM Ȯ������3 AS BYTE
DIM Ȯ�� AS BYTE
DIM ȸ���� AS BYTE
DIM cnt AS BYTE
DIM xcount AS BYTE
DIM ycount AS BYTE
DIM ��� AS BYTE
'******** �⺻ ���� *********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM �¿�ӵ�2 AS BYTE
DIM ������� AS BYTE
DIM �������� AS BYTE
DIM ����üũ AS BYTE
DIM ����ONOFF AS BYTE
DIM ���̷�ONOFF AS BYTE
DIM ����յ� AS INTEGER
DIM �����¿� AS INTEGER

DIM ����� AS BYTE

DIM �Ѿ���Ȯ�� AS BYTE
DIM ����Ȯ��Ƚ�� AS BYTE
DIM ����Ƚ�� AS BYTE
DIM ����COUNT AS BYTE

DIM ���ܼ��Ÿ���  AS BYTE

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

'**** ���⼾����Ʈ ���� ****
CONST �յڱ���AD��Ʈ = 0
CONST �¿����AD��Ʈ = 1
CONST ����Ȯ�νð� = 20  'ms

CONST ���ܼ�AD��Ʈ  = 4


CONST min = 61	'�ڷγѾ�������
CONST max = 107	'�����γѾ�������
CONST COUNT_MAX = 3


CONST �Ӹ��̵��ӵ� = 10
'************************************************

PTP SETON 				'�����׷캰 ���������� ����
PTP ALLON				'��ü���� ������ ���� ����

DIR G6A,1,0,0,1,0,0		'����0~5��
DIR G6D,0,1,1,0,1,1		'����18~23��
DIR G6B,1,1,1,1,1,1		'����6~11��
DIR G6C,0,0,0,0,1,0		'����12~17��

'************************************************

OUT 52,0	'�Ӹ� LED �ѱ�
'***** �ʱ⼱�� '************************************************

������� = 0
����üũ = 0
����Ȯ��Ƚ�� = 0
����Ƚ�� = 1
����ONOFF = 0

'****�ʱ���ġ �ǵ��*****************************


TEMPO 230
MUSIC "cdefg"


SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16

SERVO 16, 100


GOSUB �����ʱ��ڼ�
GOSUB �⺻�ڼ�


GOSUB ���̷�INIT
GOSUB ���̷�MID
GOSUB ���̷�ON

PRINT "OPEN 20GongMo.mrs !"
PRINT "VOLUME 200 !"
PRINT "SOUND 12 !" '�ȳ��ϼ���

GOSUB All_motor_Reset


'GOTO MAIN	'�ø��� ���� ��ƾ���� ����

GOTO MAIN
'************************************************


'****************************************************
������:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '****************************************
������:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '****************************************
������:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************


    '************************************************
Number_Play: '  BUTTON_NO = ���ڴ���
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
    TEMP_INTEGER = BUTTON_NO MOD 10000	'MOD ������ ������

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
    '**** ���̷ΰ��� ���� ****
���̷�INIT:
    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0
    RETURN
    '****************************************
    '**** ���̷ΰ��� ���� ****
���̷�MAX:
    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0
    RETURN
    '****************************************
���̷�MID:
    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0
    RETURN
    '****************************************
���̷�MIN:
    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '****************************************
���̷�ON:
    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    ���̷�ONOFF = 1
    RETURN
    '****************************************
���̷�OFF:
    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0

    ���̷�ONOFF = 0
    RETURN
    '************************************************


    '************************************************
    '����Ʈ�������ͻ�뼳��
MOTOR_ON:
    GOSUB MOTOR_GET
    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    ����ONOFF = 0
    GOSUB ������	
    RETURN

    '****************************************
    '����Ʈ�������ͻ�뼳��
MOTOR_OFF:
    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D

    ����ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB ������	
    RETURN
    '****************************************
    '��ġ���ǵ��
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN
    '****************************************
    '��ġ���ǵ��
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

�Ӹ�������10��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,110
    RETURN

�Ӹ�������20��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,120
    RETURN

�Ӹ�������30��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,130
    RETURN

�Ӹ�������45��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,145
    RETURN	

�Ӹ�������60��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,160
    RETURN

�Ӹ�������70��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,170
    RETURN	

�Ӹ�������90��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,190
    RETURN

    '****************************************

�Ӹ�����10��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,90
    RETURN

�Ӹ�����30��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,70
    RETURN

�Ӹ�����45��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,55
    RETURN

�Ӹ�����60��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,40
    RETURN

�Ӹ�����70��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,30
    RETURN

�Ӹ�����90��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,10
    RETURN

    '****************************************

�Ӹ��¿��߾�:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,100
    RETURN

�Ӹ���������:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,100	
    SPEED 5
    GOSUB �⺻�ڼ�
    GOTO MAIN

    '****************************************

��������100��:
    SPEED 3
    SERVO 16, 100
    RETURN

��������95��:
    SPEED 3
    SERVO 16, 95
    RETURN

��������90��:
    SPEED 3
    SERVO 16, 90
    RETURN

��������86��:
    SPEED 3
    SERVO 16, 86
    RETURN

��������85��:
    SPEED 3
    SERVO 16, 85
    RETURN

��������80��:
    SPEED 3
    SERVO 16, 80
    RETURN

��������70��:
    SPEED 3
    SERVO 16, 70
    RETURN

��������75��:
    SPEED 3
    SERVO 16, 75
    RETURN

��������67��:
    SPEED 3
    SERVO 16, 67
    RETURN

��������60��:
    SPEED 3
    SERVO 16, 65
    RETURN

��������50��:
    SPEED 3
    SERVO 16, 50
    RETURN

��������40��:
    SPEED 3
    SERVO 16, 40
    RETURN

��������35��:
    SPEED 3
    SERVO 16, 35
    RETURN

��������30��:
    SPEED 3
    SERVO 16, 30
    RETURN


��������20��:
    SPEED 3
    SERVO 16, 20
    RETURN

    '************************************************


    '************************************************
�����ʱ��ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0
    RETURN
    '****************************************
����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0
    RETURN
    '****************************************
����ȭ�ڼ�_������:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B, 190,  15,  55,  ,  ,
    MOVE G6C, 190,  15,  55,  ,  ,
    WAIT
    mode = 0
    RETURN
    '****************************************
�⺻�ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    mode = 0
    RETURN
    '****************************************
�⺻�ڼ�_������:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B, 190,  15,  55,  ,  ,
    MOVE G6C, 190,  15,  55,  ,  ,
    WAIT
    mode = 0
    RETURN
    '****************************************
�⺻�ڼ�_������:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B, 100, 100,  85,  ,  , '������ ���� ��� ���� 90�� ���
    MOVE G6C, 100,  50,  60,  ,  ,
    WAIT
    mode = 0
    RETURN
    '****************************************

�����ڼ�:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    mode = 2
    RETURN
    '****************************************
�����ڼ�:
    GOSUB ���̷�OFF
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

���ܼ��Ÿ�����Ȯ��:
    ' Infrared_Distance = 60 ' About 20cm
    ' Infrared_Distance = 50 ' About 25cm
    ' Infrared_Distance = 40 ' About 35cm
    ' Infrared_Distance = 30 ' About 45cm
    ' Infrared_Distance = 20 ' About 65cm
    ' Infrared_Distance = 10 ' About 95cm

    ���ܼ��Ÿ��� = AD(���ܼ�AD��Ʈ)

    'IF ���ܼ��Ÿ��� > 60 THEN '60 = ���ܼ��Ÿ��� 20cm
    '        'MUSIC "C"
    '        DELAY 400
    '    ELSEIF ���ܼ��Ÿ��� > 50 THEN '50 = ���ܼ��Ÿ��� = 25cm
    '        'MUSIC "C"
    '        DELAY 400
    '    ELSEIF ���ܼ��Ÿ��� > 40 THEN '30 = ���ܼ��Ÿ���  45cm
    '        'MUSIC "E"
    '        DELAY 600
    '    ELSEIF ���ܼ��Ÿ��� > 20 THEN '30 = ���ܼ��Ÿ���  45cm
    '        'MUSIC "C"
    '        DELAY 600
    '    ELSEIF ���ܼ��Ÿ��� > 18 THEN '30 = ���ܼ��Ÿ���  45cm
    '        'MUSIC "E"
    '        DELAY 500
    '    ELSEIF ���ܼ��Ÿ��� > 0 THEN '30 = ���ܼ��Ÿ���  45cm
    '        'MUSIC "G"
    '        DELAY 300
    '    ENDIF


    RETURN

    '********************************************
    '************************************************

�յڱ�������:
    FOR i = 0 TO COUNT_MAX
        A = AD(�յڱ���AD��Ʈ)	'���� �յ�
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF A < MIN THEN
        GOSUB �����
    ELSEIF A > MAX THEN
        GOSUB �����
    ENDIF

    RETURN

    '****************************************

�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A < MIN THEN GOSUB �������Ͼ��
    IF A < MIN THEN
        ETX  4800,16
        GOSUB �ڷ��Ͼ��
    ENDIF

    RETURN

�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A > MAX THEN GOSUB �ڷ��Ͼ��
    IF A > MAX THEN
        ETX  4800,15
        GOSUB �������Ͼ��
    ENDIF

    RETURN

    '****************************************

�¿��������:
    FOR i = 0 TO COUNT_MAX
        B = AD(�¿����AD��Ʈ)	'���� �¿�
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB �⺻�ڼ�	
    ENDIF

    RETURN

    '************************************************


    '************************************************

�������Ͼ��:
    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB ���̷�OFF

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

    GOSUB �⺻�ڼ�

    �Ѿ���Ȯ��= 1

    DELAY 200
    GOSUB ���̷�ON


    ETX 4800, ȣ���Լ�


    GOTO MAIN_2

    '********************************************
    '************************************************

�ڷ��Ͼ��:
    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB ���̷�OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB �⺻�ڼ�

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
    GOSUB �⺻�ڼ�

    �Ѿ���Ȯ��= 1

    DELAY 200
    GOSUB ���̷�ON


    ETX 4800, ȣ���Լ�


    GOTO MAIN_2

    '********************************************


    '************************************************

��������:
    ����ӵ� = 8
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0
    ����COUNT= 0

    GOSUB Leg_motor_mode3


    IF ������� = 0 THEN
        ������� = 1

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

        GOTO ��������_1

    ELSE
        ������� = 0

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

        GOTO ��������_2

    ENDIF

    '************************************

��������_1:
    '���� = 1

    'IF ���۸�� = 10 THEN '����Ʈ���̽�
    ETX 4800, ȣ���Լ�

    'ENDIF


    SPEED ����ӵ�
    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3
    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT


    SPEED ����ӵ�


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ��������_2
    IF A = ȣ���Լ� THEN
        GOTO ��������_2
    ENDIF


    'IF ���۸�� = 2 THEN 'ȭ��ǥ�ν�
    '        ����COUNT = ����COUNT + 1
    '
    '        IF ����COUNT = 3 THEN
    '            GOTO ��������_1_stop
    '        ELSE
    '            GOTO ��������_2
    '
    '        ENDIF
    '
    '    ELSEIF ���۸�� = 3 THEN '���ĺ������ν�
    '        ����COUNT = ����COUNT + 1
    '
    '        IF ����COUNT = 4 THEN
    '            GOTO ��������_1_stop
    '        ELSE
    '            GOTO ��������_2
    '
    '        ENDIF
    '
    '    ELSEIF ���۸�� = 11 OR ���۸�� = 12 THEN '������
    '        IF ������ = 0 THEN '������ ��
    '            GOTO ��ֹ�����_��_1
    '
    '        ELSEIF ������ = 1 THEN '������ ��
    '            ����COUNT = ����COUNT + 1
    '
    '            IF ����COUNT = 8 THEN	
    '                ������ = 0
    '
    '                GOTO ��������_1_stop
    '            ELSE
    '                GOTO ��������_2
    '
    '            ENDIF
    '
    '        ENDIF
    '
    '    ELSE '����Ʈ���̽�
    '        ERX 4800,A, ��������_2
    '
    '        IF A <> 111 THEN
    '            GOTO ��������_1_stop
    '        ELSE
    '            GOTO ��������_2
    '
    '        ENDIF
    '
    '    ENDIF
    '

��������_1_stop:
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
    GOSUB �⺻�ڼ�
    DELAY 200


    RETURN

    '************************************

��������_2:
    '���� = 2

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT


��������_3:
    'IF ���۸�� = 10 THEN '����Ʈ���̽�
    ETX 4800, ȣ���Լ�

    'ENDIF


    SPEED ����ӵ�
    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT


    SPEED ����ӵ�


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ��������_4
    IF A = ȣ���Լ� THEN
        GOTO ��������_4

    ENDIF


    'IF ���۸�� = 2 THEN 'ȭ��ǥ�ν�
    '        ����COUNT = ����COUNT + 1
    '
    '        IF ����COUNT = 3 THEN
    '            GOTO ��������_3_stop
    '        ELSE
    '            GOTO ��������_4
    '
    '        ENDIF
    '
    '    ELSEIF ���۸�� = 3 THEN '���ĺ������ν�
    '        ����COUNT = ����COUNT + 1
    '
    '        IF ����COUNT = 4 THEN
    '            GOTO ��������_3_stop
    '        ELSE
    '            GOTO ��������_4
    '
    '        ENDIF
    '
    '    ELSEIF ���۸�� = 11 OR ���۸�� = 12 THEN '������
    '        IF ������ = 0 THEN '������ ��
    '            GOTO ��ֹ�����_��_2
    '
    '        ELSEIF ������ = 1 THEN '������ ��
    '            ����COUNT = ����COUNT + 1
    '
    '            IF ����COUNT = 8 THEN
    '                ������ = 0
    '
    '                GOTO ��������_3_stop
    '            ELSE
    '                GOTO ��������_4
    '
    '            ENDIF
    '
    '        ENDIF
    '
    '    ELSE '����Ʈ���̽�
    '        ERX 4800,A, ��������_4
    '
    '        IF A <> 111 THEN
    '            GOTO ��������_3_stop
    '        ELSE
    '            GOTO ��������_4
    '
    '        ENDIF
    '
    '
    '    ENDIF


��������_3_stop:
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
    GOSUB �⺻�ڼ�
    DELAY 400


    RETURN


��������_4:
    '�޹ߵ��10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO ��������_1

    '********************************************
    '************************************************

��������:
    ����ӵ� = 8
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0
    ����COUNT= 0

    GOSUB Leg_motor_mode3


    IF ������� = 0 THEN
        ������� = 1

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

        GOTO ��������_1	

    ELSE
        ������� = 0

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

        GOTO ��������_2

    ENDIF

    '************************************

��������_1:
    SPEED ����ӵ�
    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    '********************************������ ����

    SPEED �¿�ӵ�
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, ��������_2

    IF A <> A_old THEN

        'IF ���۸�� = 4 THEN '���ĺ��ν�
        '        ����COUNT = ����COUNT + 1
        '
        '        IF ����COUNT = 4 THEN
        '            GOTO ��������_1_stop
        '        ELSE
        '            GOTO ��������_2
        '
        '        ENDIF
        '
        '    ELSE
        '        ERX 4800,A, ��������_1
        '
        '        IF A <> 112 THEN
        '            GOTO ��������_1_stop
        '        ELSE
        '            GOTO ��������_2
        '
        '        ENDIF
        '
        '    ENDIF


��������_1_stop:
        SPEED 5
        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB �⺻�ڼ�
        DELAY 200
    ENDIF

    RETURN

    '************************************

��������_2:
    ETX 4800,12 '�����ڵ带 ����
    SPEED ����ӵ�

    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED �¿�ӵ�
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    MOVE G6B, 90
    MOVE G6C,110
    WAIT



    'IF ���۸�� = 4 THEN '���ĺ��ν�
    '        ����COUNT = ����COUNT + 1
    '
    '        IF ����COUNT = 4 THEN
    '            GOTO ��������_2_stop
    '        ELSE
    '            GOTO ��������_1
    '
    '        ENDIF
    '
    '    ELSE
    '        ERX 4800,A, ��������_2
    '
    '        IF A <> 112 THEN
    '            GOTO ��������_2_stop
    '        ELSE
    '            GOTO ��������_1
    '
    '        ENDIF
    '
    '    ENDIF

    ERX 4800,A, ��������_1
    IF A <> A_old THEN

��������_2_stop:
        SPEED 5

        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT		

        SPEED 3
        GOSUB �⺻�ڼ�
        DELAY 200
    ENDIF

    'GOTO ��������_1 '???????????????

    RETURN

    '********************************************	

    '************************************************

�������������:
    ����ӵ� = 8
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0

    GOSUB Leg_motor_mode3


    IF ������� = 0 THEN
        ������� = 1

        SPEED 4
        MOVE G6A,  88,  74, 144,  90, 110,
        MOVE G6D, 108,  76, 146,  83,  96,
        WAIT

        SPEED 8
        MOVE G6A,  90,  90, 120, 100, 110,
        MOVE G6D, 110,  76, 147,  86,  96,
        WAIT

        GOTO �������������_1

    ELSE
        ������� = 0

        SPEED 4
        MOVE G6D,  88,  74, 144,  90, 110,
        MOVE G6A, 108,  76, 146,  83,  96,
        WAIT

        SPEED 8
        MOVE G6D,  90,  90, 120, 100, 110,
        MOVE G6A, 110,  76, 147,  86,  96,
        WAIT

        GOTO �������������_2

    ENDIF

    '************************************

�������������_1:
    ETX 4800,ȣ���Լ� '�������ű��


    SPEED ����ӵ�
    MOVE G6A,  90,  56, 145, 103, 110,
    MOVE G6D, 108,  76, 147,  83,  96,
    WAIT

    SPEED �¿�ӵ�
    MOVE G6A,110,  76, 142, 93,   96      '�����ٸ� ���
    MOVE G6D, 93,  90, 140,  69, 110
    WAIT




    SPEED ����ӵ�


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, �������������_2

    IF A <> 128 THEN
�������������_1_stop:
        MOVE G6D,  90, 100, 100, 110, 118, '������ �ٸ� ���ø���
        MOVE G6A, 113,  76, 146,  86,  95, '���� �� �ε��� ''�������'
        WAIT

        SPEED 6
        MOVE G6D,  88,  71, 152,  81, 110, '������ �ٸ� ������
        MOVE G6A, 106,  76, 146,  83,  96,
        WAIT

        SPEED 2
        GOSUB �⺻�ڼ�_������


        RETURN


    ENDIF

    '************************************

�������������_2:
    MOVE G6A, 110,  76, 147,  88,  96,
    MOVE G6D,  90,  90, 120,  95, 110,
    WAIT

�������������_3:
    ETX 4800,ȣ���Լ� '�������ű��


    SPEED ����ӵ�
    MOVE G6D,  90,  56, 145, 105, 110,
    MOVE G6A, 108,  76, 147,  83,  96,
    WAIT

    SPEED �¿�ӵ�
    MOVE G6A,  86, 100, 140,  64, 110,
    MOVE G6D, 110,  76, 147,  88,  96,
    WAIT


    SPEED ����ӵ�


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, �������������_4

    IF A <> 128 THEN
�������������_3_stop:
        MOVE G6A,  90, 100, 100, 107, 112, '���� �ٸ� �ø���
        MOVE G6D, 112,  76, 146,  85,  96,
        WAIT

        SPEED 6
        MOVE G6D, 106,  76, 146,  85,  96, '���� �ٸ� �� �ø���
        MOVE G6A,  88,  71, 152,  83, 106,
        WAIT

        SPEED 2
        GOSUB �⺻�ڼ�_������


        RETURN

    ENDIF

    '************************************

�������������_4:
    MOVE G6A,  90,  90, 120,  97, 110, '�޹ߵ��10
    MOVE G6D, 110,  76, 146,  85,  96,
    WAIT


    GOTO �������������_1

    '********************************************


    '************************************************

�������������:
    ����ӵ� = 5
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0


    GOSUB Leg_motor_mode3


    IF ������� = 0 THEN
        ������� = 1

        '�޹� ���
        SPEED 4
        MOVE G6A, 88,  71, 144,  95, 110
        MOVE G6D,108,  76, 145,  93,  96
        WAIT


        SPEED 10
        MOVE G6A,  90,  98, 115,  89, 110,
        MOVE G6D, 110,  76, 147,  90,  96,
        WAIT

        GOTO �������������_1

    ELSE
        ������� = 0

        SPEED 4
        MOVE G6D, 88,  71, 144,  95, 110
        MOVE G6A,108,  76, 145,  93,  96
        WAIT


        SPEED 10
        MOVE G6D,  90,  98, 115,  89, 110,
        MOVE G6A, 110,  76, 147,  90,  96,
        WAIT

        GOTO �������������_2

    ENDIF

    '************************************

�������������_1:
    ETX 4800,ȣ���Լ� '�������ű��

    SPEED ����ӵ�
    MOVE G6A,  86, 100, 140,  64, 110,
    MOVE G6D, 110,  76, 147,  88,  96,
    WAIT

    '***************************�����ٸ� ����

    SPEED �¿�ӵ�
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    SPEED ����ӵ�


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, �������������_2

    IF A <> 128 THEN
�������������_1_stop:
        HIGHSPEED SETOFF
        SPEED 5
        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        WAIT

        SPEED 2
        GOSUB �⺻�ڼ�_������


        RETURN


    ENDIF

    '************************************
�������������_2:
    MOVE G6D,  90,  90, 120, 100, 110,
    MOVE G6A, 110,  76, 147,  86,  96,
    WAIT

    '*********************


�������������_3:
    ETX 4800,ȣ���Լ� '�������ű��

    SPEED ����ӵ�
    MOVE G6D,  86, 100, 140,  64, 110,
    MOVE G6A, 110,  76, 147,  88,  96,
    WAIT


    SPEED �¿�ӵ�
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107,  85, 137,  93,  96
    WAIT

    SPEED ����ӵ�


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, �������������_4

    IF A <> 128 THEN
�������������_2_stop:

        HIGHSPEED SETOFF

        SPEED 5
        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        WAIT

        SPEED 2
        GOSUB �⺻�ڼ�_������


        RETURN

    ENDIF

�������������_4:
    MOVE G6A,  90,  90, 120, 100, 110,
    MOVE G6D, 110,  76, 147,  86,  96,
    WAIT


    GOTO �������������_1

    '************************************************




    '************************************************

������������:
    ����Ƚ�� = 0
    ����ӵ� = 18

Ƚ��_������������:

    �Ѿ���Ȯ�� = 0
    ����COUNT = 0

    GOSUB All_motor_mode3

    SPEED ����ӵ�

    IF ������� = 0 THEN
        ������� = 1

        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_1

    ELSE
        ������� = 0

        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_2

    ENDIF


    GOTO RX_EXIT

    '************************************	

������������_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C, 115
    WAIT

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    ����COUNT = ����COUNT + 1

    IF ����COUNT > ����Ƚ�� THEN
        GOTO ������������_1_stop

    ELSE
        GOTO ������������_2

    ENDIF


������������_1_stop:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT


    SPEED 12
    GOSUB ����ȭ�ڼ�

    SPEED 4
    GOSUB �⺻�ڼ�


    RETURN

    '************************************

������������_2:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT

    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    ����COUNT = ����COUNT + 1

    IF ����COUNT > ����Ƚ�� THEN
        GOTO ������������_2_stop

    ELSE
        GOTO ������������_1

    ENDIF


������������_2_stop:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    SPEED 12
    GOSUB ����ȭ�ڼ�

    SPEED 4
    GOSUB �⺻�ڼ�


    RETURN
    '*******************************************
    '************************************************

������������_��:
    ����Ƚ�� = 0
    
Ƚ��_������������_��:

	����ӵ� = 18
    �Ѿ���Ȯ�� = 0
    ����COUNT = 0

    GOSUB All_motor_mode3

    SPEED ����ӵ�

    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,  95,  76, 147,  83, 105,
        MOVE G6D,  95,  76, 147,  83, 105,
        MOVE G6B, 170,  15,  55,  ,  ,
        MOVE G6C, 170,  15,  55,  ,  ,

        MOVE G6A,  95,  76, 147,  83, 105,
        MOVE G6D,  95,  76, 147,  83, 105,


        WAIT

        GOTO Ƚ��_������������_��_1

    ELSE
        ������� = 0

        MOVE G6A,  95,  76, 147,  83, 105,
        MOVE G6D,  95,  76, 147,  83, 105,
        MOVE G6B, 170,  15,  55,  ,  ,
        MOVE G6C, 170,  15,  55,  ,  ,

        WAIT

        GOTO Ƚ��_������������_��_2

    ENDIF


    GOTO RX_EXIT

    '************************************	

Ƚ��_������������_��_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    WAIT

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    ����COUNT = ����COUNT + 1
    DELAY 200

    IF ����COUNT > ����Ƚ�� THEN
        GOTO Ƚ��_������������_��_1_stop

    ELSE
        GOTO Ƚ��_������������_��_2

    ENDIF


Ƚ��_������������_��_1_stop:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    WAIT


    SPEED 12
    GOSUB ����ȭ�ڼ�

    SPEED 4
    GOSUB �⺻�ڼ�


    RETURN

    '************************************

Ƚ��_������������_��_2:
    MOVE G6D,  95,  95, 120,  95, 104,
    MOVE G6A, 104,  77, 147,  88, 102,

    WAIT

    MOVE G6D,103,    73, 140, 98,  100
    MOVE G6A, 95,  85, 147,  80, 102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    ����COUNT = ����COUNT + 1
    DELAY 200

    IF ����COUNT > ����Ƚ�� THEN
        GOTO Ƚ��_������������_��_2_stop

    ELSE
        GOTO Ƚ��_������������_��_1

    ENDIF


Ƚ��_������������_��_2_stop:

    MOVE G6A,  98,  90, 123,  90, 104,
    MOVE G6D, 101,  76, 142,  86, 100,


    WAIT

    SPEED 12
    GOSUB ����ȭ�ڼ�

    SPEED 4
    GOSUB �⺻�ڼ�


    RETURN

    '********************************************	
    '************************************************





    '********************************************	
    '************************************************
������������:
    ����Ƚ�� = 0

Ƚ��_������������:
    ����ӵ� = 18
    �Ѿ���Ȯ��= 0
    ����COUNT = 0

    GOSUB All_motor_mode3

    SPEED 18

    IF ������� = 0 THEN
        ������� = 1

        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_1

    ELSE
        ������� = 0

        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_2

    ENDIF


    GOTO RX_EXIT

    '************************************

������������_1:
    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    ����COUNT = ����COUNT + 1

    IF ����COUNT > ����Ƚ�� THEN
        GOTO ������������_1_stop

    ELSE
        GOTO ������������_2

    ENDIF


������������_1_stop:
    MOVE G6D,95,  85, 130, 100, 104
    MOVE G6A,104,  77, 146,  93,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT

    SPEED 12
    GOSUB ����ȭ�ڼ�

    SPEED 4
    GOSUB �⺻�ڼ�


    RETURN

    '************************************

������������_2:
    MOVE G6A,104,  76, 147,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6C,115
    MOVE G6B,85
    WAIT

    MOVE G6D, 103,  79, 147,  89, 100
    MOVE G6A,95,   65, 147, 103,  102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    ����COUNT = ����COUNT + 1

    IF ����COUNT > ����Ƚ�� THEN
        GOTO ������������_2_stop

    ELSE
        GOTO ������������_1

    ENDIF


������������_2_stop:
    MOVE G6A,95,  85, 130, 100, 104
    MOVE G6D,104,  77, 146,  93,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT


    SPEED 12
    GOSUB ����ȭ�ڼ�

    SPEED 4
    GOSUB �⺻�ڼ�


    RETURN

    '********************************************


    '************************************************

�����ʿ�����20: '****
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
    GOSUB �⺻�ڼ�
    GOSUB All_motor_mode3

    RETURN
    '********************************************
    '************************************************

���ʿ�����20:
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

    GOSUB �⺻�ڼ�

    GOSUB All_motor_mode3


    RETURN

    '********************************************


    '************************************************

�����ʿ�����70����:
    ����COUNT= 0

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


�����ʿ�����70����_loop:
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


    ERX 4800,A, �����ʿ�����70����_loop

    IF A <> 113 THEN
        GOTO �����ʿ�����70����_stop
    ELSE
        GOTO �����ʿ�����70����_loop

    ENDIF


�����ʿ�����70����_stop:
    GOSUB �⺻�ڼ�


    RETURN

    '********************************************
    '************************************************

���ʿ�����70����:
    ����COUNT= 0

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


���ʿ�����70����_loop:
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


    ERX 4800,A, ���ʿ�����70����_loop

    IF A <> 114 THEN
        GOTO ���ʿ�����70����_stop
    ELSE
        GOTO ���ʿ�����70����_loop

    ENDIF


���ʿ�����70����_stop:
    GOSUB �⺻�ڼ�


    RETURN

    '********************************************


    '************************************************

��������3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


��������3_LOOP:
    IF ������� = 0 THEN
        ������� = 1

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
        ������� = 0

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
    GOSUB �⺻�ڼ�


    RETURN

    '********************************************
    '************************************************

������3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


������3_LOOP:
    IF ������� = 0 THEN
        ������� = 1

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
        ������� = 0

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
    GOSUB �⺻�ڼ�


    RETURN

    '********************************************

    '************************************************

��������10:
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

    GOSUB �⺻�ڼ�


    RETURN

    '********************************************
    '************************************************

������10:
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

    GOSUB �⺻�ڼ�


    RETURN

    '********************************************

    '************************************************

��������20:
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

    GOSUB �⺻�ڼ�

    RETURN

    '********************************************
    '************************************************

������20:
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
    GOSUB �⺻�ڼ�

    RETURN

    '********************************************

    '************************************************

��������45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


��������45_LOOP:
    SPEED 10
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB �⺻�ڼ�

    ' DELAY 50
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,��������45_LOOP
    '    IF A_old = A THEN GOTO ��������45_LOOP


    RETURN

    '********************************************
    '************************************************

������45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


������45_LOOP:
    SPEED 10
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB �⺻�ڼ�

    'DELAY 50
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,������45_LOOP
    '    IF A_old = A THEN GOTO ������45_LOOP


    RETURN

    '********************************************

    '************************************************

��������60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


��������60_LOOP:
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
    GOSUB �⺻�ڼ�

    ' DELAY 50
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,��������60_LOOP
    '    IF A_old = A THEN GOTO ��������60_LOOP


    RETURN

    '********************************************
    '************************************************

������60:
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
    GOSUB �⺻�ڼ�

    '  DELAY 50
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,������60_LOOP
    '    IF A_old = A THEN GOTO ������60_LOOP


    RETURN

    '********************************************

    '************************************************

�����������10:
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

    GOSUB �⺻�ڼ�_������


    RETURN

    '********************************************
    '************************************************

���������10:
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

    GOSUB �⺻�ڼ�_������


    RETURN

    '********************************************

    '************************************************

�����������20:
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

    GOSUB �⺻�ڼ�_������


    RETURN

    '********************************************
    '************************************************

���������20:
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

    GOSUB �⺻�ڼ�_������


    RETURN

    '********************************************

    '************************************************

�����������45:
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

    GOSUB �⺻�ڼ�_������


    RETURN

    '********************************************
    '************************************************

���������45:
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

    GOSUB �⺻�ڼ�_������


    RETURN

    '********************************************

    '************************************************

�����������60:
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

    GOSUB �⺻�ڼ�_������


    RETURN

    '********************************************
    '************************************************

���������60:
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

    GOSUB �⺻�ڼ�_������


    RETURN

    '********************************************
    '************************************************

��������80:
    FOR i = 1 TO 5
        GOSUB ��������20
    NEXT i


    RETURN

��������90:
    FOR i = 1 TO 6
        GOSUB ��������20
    NEXT i


    RETURN

    '********************************************	
    '************************************************

������90:
    FOR i = 1 TO 6
        GOSUB ������20
    NEXT i


    RETURN

������80:
    FOR i = 1 TO 5
        GOSUB ������20
    NEXT i


    RETURN

    '********************************************
    '************************************************

����:

    ����COUNT = 0

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

    'GOTO ���������_LOOP

����_LOOP:


    MOVE G6A, 100, 160,  55, 160, 100
    MOVE G6D, 100, 145,  75, 160, 100
    MOVE G6B, 175,  25,  70
    MOVE G6C, 190,  50,  40
    WAIT
    ERX 4800, A, ����_1
    GOTO ����_1
    'IF A = 8 THEN GOTO ����_1
    'IF A = 9 THEN GOTO �����������_LOOP
    'IF A = 7 THEN GOTO ���������_LOOP

    'GOTO �����Ͼ��

����_1:
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

    ERX 4800, A, ����_2

    GOTO ����_2
    'IF A = 8 THEN GOTO ����_2
    'IF A = 9 THEN GOTO �����������_LOOP
    'IF A = 7 THEN GOTO ���������_LOOP

    'GOTO �����Ͼ��

����_2:
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 160,  25,  70
    MOVE G6B, 190,  25,  70
    WAIT

    ����COUNT= ����COUNT + 1

    IF ����COUNT > ����Ƚ�� THEN
        GOTO �����Ͼ��

    ELSE
        GOTO ����_LOOP

    ENDIF

�����Ͼ��:
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

    GOSUB �⺻�ڼ�

    RETURN	
    '********************************************
    '************************************************

���_�����ν�:
    '���۸�� = �����ν�'1

    ȣ���Լ� = �����ν�	'201
    �νĽ���Ƚ��= 0

    GOSUB �Ӹ�������10��
    GOSUB ��������80��
    DELAY 2000


ȣ��_�����ν�:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, ȣ���Լ�
    DELAY 1000

    ERX 4800,A, ȣ��_�����ν�


�����ν�:
    IF A = ���� THEN 'E
        GOSUB �����ν�_����
    ELSEIF A = ���� THEN 'W
        GOSUB �����ν�_����
    ELSEIF A = ���� THEN 'S
        GOSUB �����ν�_����
    ELSEIF A = ���� THEN 'N
        GOSUB �����ν�_����
    ELSEIF A = �νĽ��� AND �νĽ���Ƚ��< 2 THEN ' 129
        �νĽ���Ƚ��= �νĽ���Ƚ��+ 1
        GOTO ȣ��_�����ν�
    ELSE '�ι� �� �ν� ������ ��� �� �ݴ��
        GOSUB �Ӹ�����10��
        DELAY 2000
        GOTO ȣ��_�����ν�

    ENDIF

    GOSUB �⺻�ڼ�
    GOTO ���_���������
    'GOTO MAIN

    '********************************************
    '************************************************

�����ν�_����:
    GOSUB Arm_motor_mode3


    SPEED 15
    MOVE G6B,100, 30, 80 '������ ������ ���
    MOVE G6C,190, 10, 100
    DELAY 200

    PRINT "SND 0 !" '����


    GOSUB Arm_motor_mode1
    RETURN

    '********************************************	

�����ν�_����:
    GOSUB Arm_motor_mode3


    SPEED 15
    MOVE G6B,190, 10, 100 '���� ������ ���
    MOVE G6C,100, 30, 80
    DELAY 200

    PRINT "SND 1 !" '����


    GOSUB Arm_motor_mode1
    RETURN

    '********************************************	

�����ν�_����:
    GOSUB Arm_motor_mode3


    SPEED 15
    MOVE G6B,10, 10, 100 '��� �ڷ� ������
    MOVE G6C,10, 10, 100
    DELAY 200

    PRINT "SND 2 !" '����


    GOSUB Arm_motor_mode1
    RETURN

    '********************************************	

�����ν�_����:
    GOSUB Arm_motor_mode3


    SPEED 15
    MOVE G6B,190, 10, 100 '��� ������ ������
    MOVE G6C,190, 10, 100
    DELAY 200

    PRINT "SND 3 !" '����


    GOSUB Arm_motor_mode1

    RETURN

    '********************************************	
    '************************************************
���_���������:
    ���۸�� = ���������
    GOTO ���_����Ʈ���̽�

���������:
    GOSUB �⺻�ڼ�

    GOTO ���_����Ʈ���̽�

    '*******************************************
    '************************************************

���_ȭ��ǥ�ν�:

    ���۸�� = ȭ��ǥ�ν�
    ȣ���Լ� = ȭ��ǥ�ν�'202
    GOSUB �Ӹ��¿��߾�
    GOSUB ��������100��
    DELAY 2000


ȣ��_ȭ��ǥ�ν�:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, ȣ���Լ�
    DELAY 1000

    ERX 4800,A, ȣ��_ȭ��ǥ�ν�


ȭ��ǥ�ν�:
    IF A = ������ THEN '113
        ȭ��ǥ = ������
        MUSIC "C"
        DELAY 100

    ELSEIF A = ���� THEN '114
        ȭ��ǥ = ����
        MUSIC "C"
        DELAY 100
        MUSIC "C"
        DELAY 100

    ELSE '�νĽ��� (A = 129)
        GOTO ȣ��_ȭ��ǥ�ν�

    ENDIF

    GOSUB Leg_motor_mode3

    ����ӵ� = 18
    ����Ƚ��= 4
    GOSUB  Ƚ��_������������

    IF ȭ��ǥ = ������ THEN '113
        GOSUB ��������60
        GOSUB ��������60
    ELSEIF ȭ��ǥ = ���� THEN '114
        GOSUB ������60
        GOSUB ������60
    ENDIF

    GOTO ���_����Ʈ���̽�

    '********************************************

���_����Ʈ���̽�:

    GOSUB All_motor_mode3

    '���۸��_old = ���۸��
    '���۸�� = 10
    ȣ���Լ� = ����Ʈ���̽�'210
    �̵����� = 0

    GOSUB �Ӹ��¿��߾�
    GOSUB ��������35��
    DELAY 2000


ȣ��_����Ʈ���̽�:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, ȣ���Լ�
    DELAY 500

    ERX 4800,A, ȣ��_����Ʈ���̽�


����Ʈ���̽�:

    IF A = �νĽ��� THEN

        IF ���۸��= ���������  THEN

            ���۸�� = ���������2
            GOSUB Arm_motor_mode3
            SPEED 17
            MOVE G6B,190, 10, 100
            MOVE G6C,190, 10, 100

            ����Ƚ�� = 20
            GOSUB Ƚ��_������������_��
  	
        ENDIF

        GOTO ȣ��_����Ʈ���̽�

    ELSEIF A >= 200 THEN

        IF A = 220 THEN
            GOSUB ���ʿ�����20

        ELSEIF A = 225 THEN

            IF ���۸�� = ��������� THEN
                ����Ƚ�� = 4        		
            ELSE
                ����Ƚ�� = 6
            ENDIF

            ����ӵ� = 18
            GOSUB Ƚ��_������������

        ELSEIF A = 230 THEN
            GOSUB �����ʿ�����20

        ENDIF


    ELSE  ' CORNER
        GOTO ����Ʈ���̽�_�ڳ�

    ENDIF
    DELAY 100

    GOTO ȣ��_����Ʈ���̽�


ȣ��_����Ʈ���̽�_�ڳ�:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, ȣ���Լ�
    DELAY 500

    ERX 4800,A, ȣ��_����Ʈ���̽�_�ڳ�


����Ʈ���̽�_�ڳ�:

    IF A > 200 THEN
        GOTO ȣ��_����Ʈ���̽�

    ENDIF

    IF A = 125 THEN
        GOSUB ���ʿ�����20

    ELSEIF A = 130 THEN
        GOSUB �����ʿ�����20

    ELSEIF A = 135 THEN
        GOSUB ��������3

    ELSEIF A = 140 THEN
        GOSUB ������3

    ELSEIF A = 145 THEN
        GOSUB ��������10

    ELSEIF A = 150 THEN
        GOSUB ������10

    ELSE
            IF ���۸�� = ���������2 THEN
                	GOTO ���_ȭ��ǥ�ν�
    		
            ELSE
                    ����Ƚ�� = 5
                    ����ӵ� = 18
                    GOSUB Ƚ��_������������

                    GOTO ���_���ĺ������ν�

            ENDIF

    ENDIF

    GOTO ȣ��_����Ʈ���̽�_�ڳ�


    '********************************************

    '************************************************	

���_���ĺ������ν�:
    ���۸�� = ���ĺ������ν�
    ȣ���Լ� = ���ĺ������ν�

    GOSUB �Ӹ��¿��߾�
    GOSUB ��������85��


ȣ��_���ĺ������ν�:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, ȣ���Լ�
    DELAY 1000

    ERX 4800,A, ȣ��_���ĺ������ν�


���ĺ������ν�:
    IF A = 130 THEN '����
        ���ĺ����� = 1
        MUSIC "E"
    ELSEIF A = 128 THEN '�Ķ�
        ���ĺ����� = 2
        MUSIC "E"
        MUSIC "E"
    ELSE '�νĽ��� (A = 129)
        MUSIC "E"
        MUSIC "E"
        MUSIC "E"
        GOTO ȣ��_���ĺ������ν�
    ENDIF


    GOTO ���_���ĺ��ν�

    '********************************************


    '************************************************	

���_���ĺ��ν�:
    ���۸�� = ���ĺ��ν�
    ȣ���Լ� = ���ĺ��ν�


ȣ��_���ĺ��ν�:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, ȣ���Լ�
    DELAY 1000

    ERX 4800,A, ȣ��_���ĺ��ν�


���ĺ��ν�:
    IF A = 113 THEN 'A
        ���ĺ� = 1
        MUSIC "G"
        DELAY 100
    ELSEIF A = 114 THEN 'B
        ���ĺ� = 2
        MUSIC "G"
        DELAY 100
        MUSIC "G"
        DELAY 100
    ELSEIF A = 112 THEN 'C
        ���ĺ� = 3
        MUSIC "G"
        DELAY 100
        MUSIC "G"
        DELAY 100
        MUSIC "G"
        DELAY 100
    ELSEIF A = 111 THEN 'D
        ���ĺ� = 4
        MUSIC "G"
        DELAY 100
        MUSIC "G"
        DELAY 100
        MUSIC "G"
        DELAY 100
        MUSIC "G"
        DELAY 100
    ELSE '�νĽ��� (A = 129)
        GOTO ȣ��_���ĺ��ν�

    ENDIF

    GOTO ���_���������ν�

    '********************************************


    '************************************************

���_���������ν�:
    ���۸�� = ���������ν�
    ȣ���Լ� = ���������ν�

    IF ȭ��ǥ = 1 THEN '������
        GOSUB �Ӹ�������45��
    ELSEIF ȭ��ǥ = 2 THEN '����
        GOSUB �Ӹ�����45��

    ENDIF

    GOSUB ��������80��
    DELAY 2000


ȣ��_���������ν�:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, ȣ���Լ�
    DELAY 1000

    ERX 4800,A, ȣ��_���������ν�


���������ν�:
    IF A = 130 THEN '�ʷ�
        ���� = 1
        PRINT "SND 4 !" '��������

    ELSEIF A = 128 THEN '����
        ���� = 2
        PRINT "SND 5 !" 'Ȯ������
        ON Ȯ�α����� GOTO �����Ǻ�1, �����Ǻ�2, �����Ǻ�3

    ELSE '�νĽ��� (A = 129)
        GOTO ȣ��_���������ν�

    ENDIF

    GOTO ���_�̼Ǽ���Ȯ��

    '********************************************

    '************************************************

�����Ǻ�1:
    Ȯ������1 = ���ĺ�

    GOTO ���_�̼Ǽ���Ȯ��

    '********************************************
    '************************************************

�����Ǻ�2:
    Ȯ������2 = ���ĺ�

    GOTO ���_�̼Ǽ���Ȯ��

    '********************************************
    '************************************************

�����Ǻ�3:
    Ȯ������3 = ���ĺ�

    GOTO ���_�̼Ǽ���Ȯ��

    '********************************************


    '************************************************

���_�̼Ǽ���Ȯ��:
    ���۸�� = 6
    IF ���� = 1 THEN '��������
        ȣ���Լ� = 206
    ELSEIF ���� = 2 THEN 'Ȯ������
        ȣ���Լ� = 216

    ENDIF

    Ȯ�� = 0
    ȸ���� = 0

    GOSUB �Ӹ��¿��߾�
    GOSUB ��������40��
    DELAY 2000


ȣ��_�̼Ǽ���Ȯ��:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, ȣ���Լ�
    DELAY 1000

    ERX 4800,A, ȣ��_�̼Ǽ���Ȯ��


�̼Ǽ���Ȯ��:
    IF ȭ��ǥ = 1 THEN '������
        ON Ȯ�� GOTO �̼Ǽ���Ȯ��_������40, �̼Ǽ���Ȯ��_������80
    ELSEIF ȭ��ǥ = 2 THEN '����
        ON Ȯ�� GOTO �̼Ǽ���Ȯ��_����40, �̼Ǽ���Ȯ��_����80

    ENDIF


�̼Ǽ��༺��:
    ���ĺ� = 0
    ���ĺ����� = 0
    ���� = 0
    Ȯ�α����� = Ȯ�α����� + 1


    GOTO ���_����Ʈ���̽�

    '********************************************

    '************************************************

�̼Ǽ���Ȯ��_������40:
    Ȯ�� = 1

    IF A = 130 THEN '���� (Ÿ���� �ʷ� �ȿ� �ְų� ���� �ۿ� ����)
        FOR i = 1 TO ȸ���� 'ȸ���Ѹ�ŭ �ݴ�� ȸ��
            GOSUB ������20
            DELAY 100

        NEXT i

        GOSUB ������20
        DELAY 100
        GOSUB ������45
        DELAY 100

        FOR i = 1 TO 5
            GOSUB �����ʿ�����20
        NEXT i

        GOTO �̼Ǽ��༺��

    ELSEIF A = 128 THEN '���� (Ÿ���� �ʷ� �ۿ� �ְų� ���� �ȿ� ����)
        GOTO ���_������ã��

    ELSE 'Ÿ���� ���� (A = 129) => ��������80 Ȯ��
        GOSUB ��������75��
        DELAY 2000

        GOTO ȣ��_�̼Ǽ���Ȯ��

    ENDIF

    '********************************************
    '************************************************

�̼Ǽ���Ȯ��_������80:
    Ȯ�� = 0

    IF A = 130 THEN '���� (Ÿ���� �ʷ� �ȿ� �ְų� ���� �ۿ� ����)

        FOR i = 1 TO ȸ���� 'ȸ���Ѹ�ŭ �ݴ�� ȸ��
            GOSUB ������20
            DELAY 100
        NEXT i

        GOSUB ������20
        DELAY 100
        GOSUB ������45
        DELAY 100

        FOR i = 1 TO 5
            GOSUB �����ʿ�����20
        NEXT i

        GOTO �̼Ǽ��༺��

    ELSEIF A = 128 THEN '���� (Ÿ���� �ʷ� �ۿ� �ְų� ���� �ȿ� ����)
        GOTO ���_������ã��

    ELSE 'Ÿ���� ���� (A = 129 => 20�� �� ���� ��������40 Ȯ��
        IF ȸ���� > 6 THEN '90�� ���Ҵµ��� Ÿ���� ������ �̼Ǽ��༺��
            GOSUB ������90
            DELAY 100
            GOSUB ������20
            DELAY 100
            GOSUB ������45
            DELAY 100      		

            FOR i = 1 TO 5
                GOSUB �����ʿ�����20
            NEXT i

            GOTO �̼Ǽ��༺��

        ELSE
            ȸ���� = ȸ���� + 1

            GOSUB ��������20
            DELAY 100
            GOSUB ��������40��
            DELAY 2000

            GOTO ȣ��_�̼Ǽ���Ȯ��

        ENDIF

    ENDIF

    '********************************************
    '************************************************

�̼Ǽ���Ȯ��_����40:
    Ȯ�� = 1

    IF A = 130 THEN '���� (Ÿ���� �ʷ� �ȿ� �ְų� ���� �ۿ� ����)
        FOR i = 1 TO ȸ���� 'ȸ���Ѹ�ŭ �ݴ�� ȸ��
            GOSUB ��������20
        NEXT i

        GOSUB ��������20
        GOSUB ��������45

        FOR i = 1 TO 3
            GOSUB ���ʿ�����20
        NEXT i

        GOTO �̼Ǽ��༺��

    ELSEIF A = 128 THEN '���� (Ÿ���� �ʷ� �ۿ� �ְų� ���� �ȿ� ����)
        GOTO ���_������ã��

    ELSE 'Ÿ���� ���� (A = 129) => ��������80 Ȯ��
        GOSUB ��������75��
        DELAY 2000

        GOTO ȣ��_�̼Ǽ���Ȯ��

    ENDIF

    '********************************************
    '************************************************

�̼Ǽ���Ȯ��_����80:
    Ȯ�� = 0

    IF A = 130 THEN '���� (Ÿ���� �ʷ� �ȿ� �ְų� ���� �ۿ� ����)
        FOR i = 1 TO ȸ���� 'ȸ���Ѹ�ŭ �ݴ�� ȸ��
            GOSUB ��������20
        NEXT i

        GOSUB ��������20
        GOSUB ��������45

        FOR i = 1 TO 3
            GOSUB ���ʿ�����20
        NEXT i

        GOTO �̼Ǽ��༺��

    ELSEIF A = 128 THEN '���� (Ÿ���� �ʷ� �ۿ� �ְų� ���� �ȿ� ����)
        GOTO ���_������ã��

    ELSE 'Ÿ���� ���� (A = 129 => 20�� �� ���� ��������40 Ȯ��
        IF ȸ���� > 6 THEN '90�� ���Ҵµ��� Ÿ���� ������ �̼Ǽ��༺��
            GOSUB ��������90
            GOSUB ��������20
            GOSUB ��������45

            FOR i = 1 TO 3
                GOSUB ���ʿ�����20
            NEXT i

            GOTO �̼Ǽ��༺��

        ELSE
            ȸ���� = ȸ���� + 1

            GOSUB ������20
            GOSUB ��������40��
            DELAY 2000

            GOTO ȣ��_�̼Ǽ���Ȯ��

        ENDIF

    ENDIF

    '********************************************


    '************************************************

���_������ã��:
    ���۸�� = 7
    ȣ���Լ� = 207
    cnt = 0
    GOTO ȣ��_������x��ǥã��


������ã��:
    cnt = 0
    GOSUB ��������40��
    Ȯ�� = 1
    WAIT
    DELAY 2000


ȣ��_������x��ǥã��:
    GOSUB GOSUB_RX_EXIT
    ETX  4800,207
    DELAY 1000

    ERX 4800, A, ȣ��_������x��ǥã��


������x��ǥã��_1:

    IF A = 199 AND cnt = 0 THEN
        cnt = 1
        GOTO ȣ��_������x��ǥã��

    ELSEIF A = 199 AND cnt = 1 THEN
        IF Ȯ�� = 1 THEN
            GOSUB ��������75��
            Ȯ�� = 0
        ENDIF

        WAIT
        DELAY 1000
        GOTO ������x��ǥã��_2

    ELSEIF A = 100 OR A = 200 THEN
        GOTO ȣ��_������y��ǥã��

    ELSEIF A > 200 THEN
        A = A - 200

        FOR i = 1 TO A
            GOSUB �����ʿ�����20
        NEXT i
        DELAY 100

        GOTO ȣ��_������y��ǥã��

    ELSEIF A > 100 THEN
        A = A - 100

        FOR i = 0 TO A
            GOSUB ���ʿ�����20
        NEXT i
        DELAY 100

        GOTO ȣ��_������y��ǥã��

    ELSE
        GOTO ȣ��_������x��ǥã��

    ENDIF

������x��ǥã��_2:
    GOSUB GOSUB_RX_EXIT
    ETX  4800,207
    DELAY 1000
    ERX 4800, A, ������x��ǥã��_2

    IF A = 199 THEN

        IF ȭ��ǥ = 1 THEN '������
            GOSUB ��������20
        ELSEIF ȭ��ǥ = 2 THEN '����
            GOSUB ������20
        ENDIF

        WAIT
        GOTO ������ã��

    ELSE
        GOTO ������x��ǥã��_1

    ENDIF

    '********************************************
    '************************************************

ȣ��_������y��ǥã��:
    GOSUB GOSUB_RX_EXIT
    ETX 4800,217
    DELAY 1000

    ERX 4800, A, ȣ��_������y��ǥã��
    WAIT

������y��ǥã��_0:

    IF A = 199 THEN       '�������� 40 �ϰ�� �Ķ��� �ν� ���Ұ��
        ����Ƚ��= 1
        GOSUB Ƚ��_������������
        GOTO ������ã�� ' �ѹ�¥�� ���� x_pos�� �̵� �� ã��

    ELSEIF Ȯ�� = 0 THEN      ''�������� 80'
        ����Ƚ��= 7
        GOSUB Ƚ��_������������

        IF ȭ��ǥ = 1 THEN '������
            GOSUB ������10
        ELSEIF ȭ��ǥ = 2 THEN '����
            GOSUB ��������10
        ENDIF

        GOTO ������ã��  ''ó������ �ٽ� ���� -> x_pos �ٽ� ����

    ELSE  '�������� 40

        IF A = 189 THEN
            GOSUB GOSUB_RX_EXIT
            DELAY 100

            ����Ƚ��= 2
            ����ӵ� = 12
            GOSUB Ƚ��_������������
            DELAY 500

            GOTO ���������

        ELSE
            ����Ƚ��= A
            GOSUB Ƚ��_������������
            GOTO ȣ��_������y��ǥã��

        ENDIF

    ENDIF

    '********************************************

    '************************************************

���������:

    '���⼭ �� �����ϰ� ������ ��ġ Ȯ�� �ʿ�!!!!!'

    GOSUB Leg_motor_mode3

    GOSUB ���̷�OFF

    SPEED 6
    GOSUB �����ڼ�
    WAIT

    GOSUB Arm_motor_mode3

    SPEED 12	
    MOVE G6B,165, 10, 100              '�Ȼ���
    MOVE G6C,165, 10, 100
    WAIT	

    SPEED 6
    MOVE G6A,  87, 145,  28, 159, 115, '�� �ޱ�����
    MOVE G6D,  87, 145,  28, 159, 115,
    WAIT

    '***************************************'
    '****************�߰����ڵ�***************'

    SPEED 9
    MOVE G6B, 145,  15,  55,  ,  ,     '������ ���
    MOVE G6C, 145,  15,  55,  ,  ,
    WAIT

    MOVE G6B,165, 30, 100              '�Ȼ���
    MOVE G6C,165, 30, 100
    WAIT

    MOVE G6B, 145,  15,  55,  ,  ,     '������ ���
    MOVE G6C, 145,  15,  55,  ,  ,
    WAIT

    MOVE G6B,165, 30, 100              '�Ȼ���
    MOVE G6C,165, 30, 100
    WAIT


    '***************************************'



    SPEED 2
    MOVE G6B, 153,  15,  55,  ,  ,     '������ ���
    MOVE G6C, 153,  15,  55,  ,  ,
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


    GOSUB All_motor_mode3

    GOTO ���_�������ű��

    '********************************************


    '************************************************

���_�������ű��:
    ���۸�� = 8
    GOSUB ���̷�ON

    IF ���� = 1 THEN '��������
        ȣ���Լ� = 208

        IF ȸ���� < 3   THEN
            ȸ����= 3 - ȸ����+ 2

            IF ȭ��ǥ = 1 THEN '������
                FOR i = 1 TO ȸ���� 'ȸ���� ����+1 ��ŭ ȭ��ǥ �������� ȸ��
                    GOSUB �����������20
                    WAIT
                NEXT i

            ELSEIF ȭ��ǥ = 2 THEN '����
                FOR i = 1 TO ȸ���� 'ȸ���� ����+1 ��ŭ ȭ��ǥ ��������
                    GOSUB ���������20
                    WAIT
                NEXT i

            ENDIF

        ELSE
            ȸ����= ȸ����- 3 + 2

            IF ȭ��ǥ = 1 THEN '������
                FOR i = 1 TO ȸ���� 'ȸ���� ����+1 ��ŭ �ݴ�� ȸ��
                    GOSUB ���������20
                NEXT i

            ELSEIF ȭ��ǥ = 2 THEN '����
                FOR i = 1 TO ȸ���� 'ȸ���� ����+1 ��ŭ �ݴ�� ȸ��
                    GOSUB �����������20
                NEXT i

            ENDIF
        ENDIF

    ELSEIF ���� = 2 THEN 'Ȯ������
        ȣ���Լ� = 218

    ENDIF
    �̵����� = 0

    GOSUB ��������35��
    DELAY 2000


    '    IF ȸ���� <= 3   THEN
    '        IF ȭ��ǥ = 1 THEN 'ȭ��ǥ�� ������
    '            GOSUB �Ӹ�����60��
    '        ELSE 'ȭ��ǥ�� ����
    '            GOSUB �Ӹ�������60��
    '
    '        ENDIF
    '    ELSE
    '        IF ȭ��ǥ = 1 THEN 'ȭ��ǥ�� ������
    '            GOSUB �Ӹ�������60��
    '        ELSE 'ȭ��ǥ�� ����
    '            GOSUB �Ӹ�����60��
    '
    '        ENDIF
    '
    '    ENDIF


ȣ��_�������ű��:
    GOSUB GOSUB_RX_EXIT
    DELAY 1000
    ETX 4800, ȣ���Լ�
    'DELAY 1000
    ERX 4800,A, ȣ��_�������ű��


�������ű��:
    IF ���� = 1 THEN '��������

        IF A = 128 THEN
            GOSUB �������������
            GOTO ȣ��_�������ű��

        ELSEIF A = 130 THEN
            GOSUB ������������
            ����Ƚ��= 3
            GOSUB Ƚ��_������������
            GOTO ���_�������������ƿ���

        ELSE
            GOTO ȣ��_�������ű��'�ʿ���� �ڵ��ΰ�?'

        ENDIF

    ELSEIF ���� = 2 THEN 'Ȯ������

        IF A = 128 THEN
            GOSUB �������������
            GOTO ȣ��_�������ű��

        ELSEIF A = 130 THEN
            GOSUB ������������
            GOTO ���_�������������ƿ���

        ELSE
            GOTO ȣ��_�������ű��'�ʿ���� �ڵ��ΰ�?'

        ENDIF

    ENDIF

    '********************************************

    '************************************************

������������:
    GOSUB ���̷�OFF

    GOSUB Leg_motor_mode3


    SPEED 6
    MOVE G6D,100,  71, 145,  93, 100, 100
    MOVE G6A,100,  71, 145,  93, 100, 100
    WAIT

    SPEED 9
    MOVE G6A,100, 140,  37, 145, 100, 100
    MOVE G6D,100, 140,  37, 145, 100, 100
    WAIT


    MOVE G6A,  87, 145,  28, 159, 115, '�� �ޱ�����
    MOVE G6D,  87, 145,  28, 159, 115,
    WAIT


    GOSUB Arm_motor_mode3

    MOVE G6B, 153,  15,  55,  ,  ,     '�� ������
    MOVE G6C, 153,  15,  55,  ,  ,
    WAIT

    MOVE G6B,165, 30, 100              '�Ȼ���
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

    GOSUB ���̷�ON

    GOSUB �⺻�ڼ�

    'IF ȭ��ǥ = 1 THEN '������
    '        GOSUB ������90
    '        GOSUB ������20
    '        GOSUB ������20
    '        GOSUB ������20
    '
    '    ELSEIF ȭ��ǥ = 2 THEN '����
    '        GOSUB ��������90
    '        GOSUB ��������20
    '        GOSUB ��������20
    '        GOSUB ��������20
    '    ENDIF

    'GOTO ���_�������������ƿ���
    RETURN


    '********************************************


    '************************************************

���_�������������ƿ���:
    ���۸�� = 9
    ȣ���Լ� = 209

    '    IF ȸ���� < 3 THEN
    '        ȸ����= 3 - ȸ����+ 5
    '
    '        IF ȭ��ǥ= 1 THEN
    '            FOR i = 1 TO ȸ����
    '                GOSUB ������20
    '            NEXT i
    '
    '        ELSE
    '            FOR i = 1 TO ȸ����
    '                GOSUB ��������20
    '            NEXT i
    '
    '            DELAY 2000
    '
    '        ENDIF
    '    ELSE
    '        ȸ����= ȸ���� - 3 + 5
    '
    '        IF ȭ��ǥ= 1 THEN
    '            FOR i = 1 TO ȸ����
    '                GOSUB ��������20
    '            NEXT i
    '
    '        ELSE
    '            FOR i = 1 TO ȸ����
    '                GOSUB ������20
    '            NEXT i
    '
    '            DELAY 2000
    '
    '        ENDIF
    '
    '    ENDIF

    IF ȭ��ǥ= 1 THEN
        FOR i = 1 TO 4
            GOSUB ������20
        NEXT i

    ELSE
        FOR i = 1 TO 4
            GOSUB ��������20
        NEXT i

        DELAY 2000

    ENDIF

�������������ƿ���:
    cnt = 0
    GOSUB ��������60��
    Ȯ�� = 0	'�������� 60
    DELAY 1000

    IF ȸ����<= 3 THEN
        GOSUB ��������40��

    ELSE
        GOSUB ��������60��

    ENDIF

ȣ��_�������������ƿ���_x��ǥ:
    GOSUB GOSUB_RX_EXIT
    ETX 4800, 209
    DELAY 1000
    ERX 4800, A, ȣ��_�������������ƿ���_x��ǥ


�������������ƿ���_x��ǥ:

    IF A = 199 AND cnt = 0 THEN '�νĽ���

        IF ȭ��ǥ= 1 THEN
            FOR i = 1 TO 3
                GOSUB ������3
            NEXT i

        ELSE
            FOR i = 1 TO 3
                GOSUB ��������3
            NEXT i

        ENDIF
        DELAY 2000

        cnt = cnt + 1
        GOTO ȣ��_�������������ƿ���_x��ǥ

    ELSEIF	A = 199 AND cnt = 1 THEN
        IF ȭ��ǥ= 1 THEN
            GOSUB ������10

        ELSE
            GOSUB ��������10
        ENDIF

        DELAY 2000

        cnt = 2
        GOTO ȣ��_�������������ƿ���_x��ǥ

    ELSEIF	A = 199 AND cnt = 2 THEN
        IF Ȯ�� = 0 THEN
            GOSUB ��������40��
            Ȯ��= 1
        ELSE
            GOSUB ��������60��
            Ȯ��= 0
        ENDIF	
        cnt = 0
        GOTO ȣ��_�������������ƿ���_x��ǥ


    ELSEIF A > 200 THEN 'x��ǥ�� ������
        A = A - 200
        xcount = A / 10

        IF xcount = 0 THEN
            GOTO �������������ƿ���_y��ǥ

        ELSE
            FOR i = 1 TO xcount
                GOSUB �����ʿ�����20
            NEXT i
            DELAY 100
        ENDIF

    ELSEIF A > 100 THEN 'x��ǥ�� ����
        A = A - 100
        xcount = A / 10

        IF xcount = 0 THEN
            GOTO �������������ƿ���_x��ǥ

        ELSE
            FOR i = 1 TO xcount
                GOSUB ���ʿ�����20
            NEXT i
            DELAY 100   	
        ENDIF

    ELSE
        GOTO ȣ��_�������������ƿ���_x��ǥ

    ENDIF

�������������ƿ���_y��ǥ:
    ycount = 0

    IF Ȯ�� = 0 THEN '�������� 60
        ycount = 3

    ELSEIF Ȯ�� = 1 THEN '�������� 40
        ycount = A % 10

        IF ycount = 0 THEN
            ����Ƚ��= 2
            GOSUB Ƚ��_������������
            GOTO ���_����Ʈ���̽�

        ENDIF
    ENDIF

    ����Ƚ�� = ycount+10
    GOSUB Ƚ��_������������
    DELAY 1000

    IF ȸ���� <= 3 THEN

        IF ȭ��ǥ= 1 THEN
            FOR i = 1 TO 3
                GOSUB ��������3
            NEXT i

        ELSE
            FOR i = 1 TO 3
                GOSUB ������3
            NEXT i

        ENDIF
        DELAY 2000
    ENDIF

    GOTO ���_����Ʈ���̽�


    'IF Ȯ�� = 0 THEN '���� �ָ� ���� ��
    '        Ȯ�� =   1
    '        GOSUB ��������60��
    '
    '        GOTO ȣ��_�������������ƿ���
    '
    '    ELSEIF Ȯ�� = 1 THEN '���� ������ ���� ��
    '        Ȯ�� = 0
    '
    '        IF ȭ��ǥ = 1 THEN '������
    '            FOR i = 1 TO 3
    '                GOSUB ��������20
    '            NEXT i
    '
    '        ELSEIF ȭ��ǥ = 2 THEN '����
    '            FOR i = 1 TO 3
    '                GOSUB ������20
    '            NEXT i
    '
    '        ENDIF
    '
    '        GOTO �̼Ǽ��༺��



    '********************************************
    '************************************************

���_����������:
    ���۸�� = 12
    '������ = 0


����������:
    IF ȭ��ǥ = 1 THEN '������
        GOSUB ��������80
    ELSEIF ȭ��ǥ = 2 THEN '����
        GOSUB ������80

    ENDIF

    GOSUB ��������

    GOTO ���_�����ǥ

    '********************************************	

    '************************************************

����������_������:
    GOSUB Arm_motor_mode3


    SPEED 15
    MOVE G6B, 100, 100,  85,  ,  , '������ ���� ��� ���� 90�� ���
    MOVE G6C, 100,  50,  60,  ,  ,
    WAIT


    FOR i = 1 TO 13
        GOSUB �����ʿ�����20
    NEXT i


    GOSUB ��������90


    GOTO MAIN

    '********************************************	
    '************************************************

����������_����:
    GOSUB Arm_motor_mode3


    SPEED 15
    MOVE G6C, 100, 100,  85,  ,  , '���� ���� ��� ������ 90�� ���
    MOVE G6B, 100,  50,  60,  ,  ,
    WAIT


    FOR i = 1 TO 13
        GOSUB ���ʿ�����20
    NEXT i


    GOSUB ������90


    GOTO ���_�����ǥ

    '********************************************	


    '************************************************

���_�����ǥ:
    ���۸�� = 13


�����ǥ:
    PRINT "OPEN M_ABCD.mrs !"
    PRINT "VOLUME 200 !"


    ��� = ��� + 1

    IF ��� = 1 THEN 'ù��°�������
        ON Ȯ������1 GOTO �����ǥX, �����ǥA, �����ǥB, �����ǥC, �����ǥD
    ELSEIF ��� = 2 THEN '�ι�°�������
        ON Ȯ������2 GOTO �����ǥX, �����ǥA, �����ǥB, �����ǥC, �����ǥD
    ELSEIF ��� = 3 THEN '����°�������
        ON Ȯ������3 GOTO �����ǥX, �����ǥA, �����ǥB, �����ǥC, �����ǥD

    ENDIF

    GOTO RX_EXIT

    '********************************************	

    '************************************************

�����ǥX:
    GOTO �����ǥ


�����ǥA:
    PRINT "SND 0 !"

    GOTO �����ǥ


�����ǥB:
    PRINT "SND 1 !"

    GOTO �����ǥ


�����ǥC:
    PRINT "SND 2 !"

    GOTO �����ǥ


�����ǥD:
    PRINT "SND 3 !"

    GOTO �����ǥ

    '********************************************


    '************************************************
    '************************************************
    '************************************************

MAIN: '�󺧼���
    GOSUB GOSUB_RX_EXIT
    ETX 4800, 38 ' ���� ���� Ȯ�� �۽� ��


MAIN_2:
    GOSUB �յڱ�������
    GOSUB �¿��������
    GOSUB ���ܼ��Ÿ�����Ȯ��

    'GOSUB GOSUB_RX_EXIT
    ERX 4800,A,MAIN_2	

    A_old = A


MAIN_3:
    IF A >= 100 THEN
        ON ���۸�� GOTO MAIN,�����ν�,ȭ��ǥ�ν�,���ĺ������ν�,���ĺ��ν�,���������ν�,�̼Ǽ���Ȯ��,������ã��,�������ű��,�������������ƿ���,����Ʈ���̽�
        'GOTO MAIN
    ELSE
        '**** �Էµ� A���� 0 �̸� MAIN �󺧷� ����
        '**** 1�̸� KEY1 ��, 2�̸� key2��... ���¹�
        ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32

    ENDIF


    '*******************************************
    '		MAIN �󺧷� ����
    '*******************************************


    '****************************
KEY1:
    GOTO ���_�����ν�

    '****************************
KEY2:
    HIGHSPEED SETON
    ����Ƚ��= 1
    GOSUB Ƚ��_������������
    HIGHSPEED SETOFF
    GOTO MAIN

    '****************************
KEY3:
    GOSUB Arm_motor_mode3
    SPEED 17
    MOVE G6B,190, 10, 100 '��� ������ ������
    MOVE G6C,190, 10, 100
    DELAY 200
    GOTO MAIN

    '****************************
KEY4:
    GOTO ���_���������
    GOTO MAIN

    '****************************
KEY5:
    GOSUB ��������35��
    GOTO MAIN


    '****************************
KEY6:
    GOTO ���_�̼Ǽ���Ȯ��

    '****************************
KEY7:
    GOTO ���������

    '****************************
KEY8:
    GOTO ���_�������ű��

    '****************************
KEY9:
    GOTO ���_�������������ƿ���

    '****************************
KEY10: ' 0
    GOTO ���_����Ʈ���̽�

    '****************************
    '********************************

KEY11: ' ��
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY12: ' ��
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY13: ' ��
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY14: ' ��
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
    GOSUB �����ڼ�	
    GOSUB ������

    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF


    GOSUB GOSUB_RX_EXIT

KEY16_1:

    IF ����ONOFF = 1  THEN
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


    IF  A = 16 THEN 	'�ٽ� �Ŀ���ư�� �����߸� ����
        GOSUB MOTOR_ON
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT

        GOSUB �⺻�ڼ�
        GOSUB ���̷�ON
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

KEY21: ' ��
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

KEY26: ' ��
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY27: ' D
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY28: ' ��
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY29: ' ��
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY30: ' ��
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY31: ' ��
    A = A + 100

    GOTO MAIN_3

    '****************************
    '********************************

KEY32: ' F
    ������� = 0
    ����üũ = 0
    ����Ȯ��Ƚ�� = 0
    ����Ƚ�� = 1
    ����ONOFF = 0

    ���۸�� = 1
    ���۸��_old = 0
    ȣ���Լ� = 201
    '���� = 0
    '������ = 0
    �̵����� = 0
    ȭ��ǥ = 1
    ���ĺ� = 0
    '���ĺ����� = 0
    Ȯ�α����� = 3
    ���� = 0
    Ȯ������1 = 0
    Ȯ������2 = 2
    Ȯ������3 = 0
    Ȯ�� = 0
    ȸ���� = 0
    ��� = 0

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


    GOSUB �����ʱ��ڼ�
    GOSUB �⺻�ڼ�


    GOSUB ���̷�INIT
    GOSUB ���̷�MID
    GOSUB ���̷�ON


    PRINT "OPEN 20GongMo.mrs !"
    PRINT "VOLUME 200 !"
    'PRINT "SOUND 12 !" '�ȳ��ϼ���

    GOSUB All_motor_mode3


    'GOTO ���_�����ν�
    GOTO MAIN

    '****************************
    '********************************
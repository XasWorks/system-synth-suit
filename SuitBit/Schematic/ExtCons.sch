EESchema Schematic File Version 4
LIBS:SuitBit-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 4
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector:Conn_01x03_Male J401
U 1 1 5E35DF11
P 5175 2375
F 0 "J401" H 5281 2653 50  0000 C CNN
F 1 "Conn_01x03_Male" H 5281 2562 50  0000 C CNN
F 2 "Connector_PinHeader_2.00mm:PinHeader_1x03_P2.00mm_Vertical" H 5175 2375 50  0001 C CNN
F 3 "~" H 5175 2375 50  0001 C CNN
	1    5175 2375
	1    0    0    -1  
$EndComp
Wire Wire Line
	5375 2275 5850 2275
$Comp
L power:GND #PWR0104
U 1 1 5E35DF8A
P 5850 2275
F 0 "#PWR0104" H 5850 2025 50  0001 C CNN
F 1 "GND" V 5855 2147 50  0000 R CNN
F 2 "" H 5850 2275 50  0001 C CNN
F 3 "" H 5850 2275 50  0001 C CNN
	1    5850 2275
	0    -1   -1   0   
$EndComp
$Comp
L power:+5V #PWR0108
U 1 1 5E35E01D
P 5850 2375
F 0 "#PWR0108" H 5850 2225 50  0001 C CNN
F 1 "+5V" V 5865 2503 50  0000 L CNN
F 2 "" H 5850 2375 50  0001 C CNN
F 3 "" H 5850 2375 50  0001 C CNN
	1    5850 2375
	0    1    1    0   
$EndComp
Wire Wire Line
	5850 2375 5375 2375
Wire Wire Line
	5375 2475 5850 2475
Text Label 5850 2475 2    50   ~ 0
WS_Protec
$Comp
L Connector:Conn_01x03_Male J402
U 1 1 5E35E797
P 5175 3100
F 0 "J402" H 5281 3378 50  0000 C CNN
F 1 "Conn_01x03_Male" H 5281 3287 50  0000 C CNN
F 2 "Connector_PinHeader_2.00mm:PinHeader_1x03_P2.00mm_Vertical" H 5175 3100 50  0001 C CNN
F 3 "~" H 5175 3100 50  0001 C CNN
	1    5175 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	5375 3000 5850 3000
$Comp
L power:GND #PWR0109
U 1 1 5E35E885
P 5850 3000
F 0 "#PWR0109" H 5850 2750 50  0001 C CNN
F 1 "GND" V 5855 2872 50  0000 R CNN
F 2 "" H 5850 3000 50  0001 C CNN
F 3 "" H 5850 3000 50  0001 C CNN
	1    5850 3000
	0    -1   -1   0   
$EndComp
$Comp
L power:+5V #PWR0110
U 1 1 5E35E8CF
P 5850 3100
F 0 "#PWR0110" H 5850 2950 50  0001 C CNN
F 1 "+5V" V 5865 3228 50  0000 L CNN
F 2 "" H 5850 3100 50  0001 C CNN
F 3 "" H 5850 3100 50  0001 C CNN
	1    5850 3100
	0    1    1    0   
$EndComp
Wire Wire Line
	5850 3100 5375 3100
Wire Wire Line
	5375 3200 5900 3200
Wire Wire Line
	8250 3100 8650 3100
Text HLabel 8650 3100 2    50   Input ~ 0
Fan_PWM
$Comp
L Device:R_Pack04 RN401
U 1 1 5E35F7DB
P 8050 3300
F 0 "RN401" V 7633 3300 50  0000 C CNN
F 1 "R_Pack04" V 7724 3300 50  0000 C CNN
F 2 "Resistor_SMD:R_Array_Concave_4x0603" V 8325 3300 50  0001 C CNN
F 3 "~" H 8050 3300 50  0001 C CNN
	1    8050 3300
	0    1    1    0   
$EndComp
Wire Wire Line
	7850 3100 7400 3100
Text Label 7400 3100 0    50   ~ 0
Fan_Protec
Text Label 5900 3200 2    50   ~ 0
Fan_Protec
Wire Wire Line
	7850 3200 7400 3200
Text Label 7400 3200 0    50   ~ 0
WS_Protec
Wire Wire Line
	8250 3200 8650 3200
Text HLabel 8650 3200 2    50   Input ~ 0
WS_EXT
Wire Wire Line
	8250 3300 9200 3300
Text GLabel 9200 3300 2    50   Input ~ 0
TWI_SDA
Text GLabel 9200 3400 2    50   Input ~ 0
TWI_SCL
Wire Wire Line
	8250 3400 9200 3400
Wire Wire Line
	7850 3300 7400 3300
Text Label 7400 3300 0    50   ~ 0
SDA_Prot
Text Label 7400 3400 0    50   ~ 0
SCL_Prot
Wire Wire Line
	7400 3400 7850 3400
$Comp
L Device:R_Pack04 RN1
U 1 1 5E376B8A
P 8050 4050
F 0 "RN1" V 7633 4050 50  0000 C CNN
F 1 "R_Pack04" V 7724 4050 50  0000 C CNN
F 2 "Resistor_SMD:R_Array_Concave_4x0603" V 8325 4050 50  0001 C CNN
F 3 "~" H 8050 4050 50  0001 C CNN
	1    8050 4050
	0    1    1    0   
$EndComp
$EndSCHEMATC

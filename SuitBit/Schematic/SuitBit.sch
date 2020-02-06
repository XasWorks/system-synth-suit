EESchema Schematic File Version 4
LIBS:SuitBit-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 4
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 2225 3650 1025 600 
U 5E10E2B9
F0 "Power Generation" 50
F1 "PowerGen.sch" 50
F2 "B_Unfused" I L 2225 3750 50 
$EndSheet
$Comp
L Connector:Conn_01x04_Male J101
U 1 1 5E16611C
P 1375 1325
F 0 "J101" H 1481 1603 50  0000 C CNN
F 1 "Conn_01x04_Male" H 1481 1512 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Horizontal" H 1375 1325 50  0001 C CNN
F 3 "~" H 1375 1325 50  0001 C CNN
	1    1375 1325
	1    0    0    -1  
$EndComp
Wire Wire Line
	1575 1225 2150 1225
$Comp
L power:GND #PWR0101
U 1 1 5E1665DC
P 2150 1225
F 0 "#PWR0101" H 2150 975 50  0001 C CNN
F 1 "GND" V 2155 1097 50  0000 R CNN
F 2 "" H 2150 1225 50  0001 C CNN
F 3 "" H 2150 1225 50  0001 C CNN
	1    2150 1225
	0    -1   -1   0   
$EndComp
Wire Wire Line
	1575 1425 1875 1425
Text Label 1875 1425 2    50   ~ 0
CAN_L
Text Label 1875 1525 2    50   ~ 0
CAN_H
Wire Wire Line
	1875 1525 1575 1525
Wire Wire Line
	1575 1875 2150 1875
$Comp
L power:GND #PWR0103
U 1 1 5E166A3C
P 2150 1875
F 0 "#PWR0103" H 2150 1625 50  0001 C CNN
F 1 "GND" V 2155 1747 50  0000 R CNN
F 2 "" H 2150 1875 50  0001 C CNN
F 3 "" H 2150 1875 50  0001 C CNN
	1    2150 1875
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2075 1975 1575 1975
Wire Wire Line
	1575 2075 1875 2075
Text Label 1875 2075 2    50   ~ 0
CAN_L
Text Label 1875 2175 2    50   ~ 0
CAN_H
Wire Wire Line
	1875 2175 1575 2175
$Sheet
S 8575 1075 1500 825 
U 5E166E24
F0 "Onboard WS2812" 50
F1 "OnboardLEDs.sch" 50
$EndSheet
$Comp
L dk_Motion-Sensors-IMUs-Inertial-Measurement-Units:LSM6DS3TR U103
U 1 1 5E17BDF6
P 8900 5775
F 0 "U103" H 9125 6375 60  0000 C CNN
F 1 "LSM6DS3TR" H 9250 6250 60  0000 C CNN
F 2 "digikey-footprints:LGA-14L_2.5x3mm__LSM6DS3" H 9100 5975 60  0001 L CNN
F 3 "http://www.st.com/content/ccc/resource/technical/document/datasheet/a3/f5/4f/ae/8e/44/41/d7/DM00133076.pdf/files/DM00133076.pdf/jcr:content/translations/en.DM00133076.pdf" H 9100 6075 60  0001 L CNN
F 4 "497-15383-1-ND" H 9100 6175 60  0001 L CNN "Digi-Key_PN"
F 5 "LSM6DS3TR" H 9100 6275 60  0001 L CNN "MPN"
F 6 "Sensors, Transducers" H 9100 6375 60  0001 L CNN "Category"
F 7 "Motion Sensors - IMUs (Inertial Measurement Units)" H 9100 6475 60  0001 L CNN "Family"
F 8 "http://www.st.com/content/ccc/resource/technical/document/datasheet/a3/f5/4f/ae/8e/44/41/d7/DM00133076.pdf/files/DM00133076.pdf/jcr:content/translations/en.DM00133076.pdf" H 9100 6575 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/stmicroelectronics/LSM6DS3TR/497-15383-1-ND/5180534" H 9100 6675 60  0001 L CNN "DK_Detail_Page"
F 10 "IMU ACCEL/GYRO I2C/SPI 14VFLGA" H 9100 6775 60  0001 L CNN "Description"
F 11 "STMicroelectronics" H 9100 6875 60  0001 L CNN "Manufacturer"
F 12 "Active" H 9100 6975 60  0001 L CNN "Status"
	1    8900 5775
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J102
U 1 1 5E33DCB0
P 1375 1975
F 0 "J102" H 1481 2253 50  0000 C CNN
F 1 "Conn_01x04_Male" H 1481 2162 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Horizontal" H 1375 1975 50  0001 C CNN
F 3 "~" H 1375 1975 50  0001 C CNN
	1    1375 1975
	1    0    0    -1  
$EndComp
Wire Wire Line
	3875 1400 4325 1400
Text Label 4325 1600 2    50   ~ 0
CAN_L
Text Label 4325 1400 2    50   ~ 0
CAN_H
$Comp
L power:GND #PWR0106
U 1 1 5E33E335
P 3375 1975
F 0 "#PWR0106" H 3375 1725 50  0001 C CNN
F 1 "GND" H 3380 1802 50  0000 C CNN
F 2 "" H 3375 1975 50  0001 C CNN
F 3 "" H 3375 1975 50  0001 C CNN
	1    3375 1975
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C102
U 1 1 5E33E7B9
P 3700 1025
F 0 "C102" V 3850 1175 50  0000 C CNN
F 1 "1uF" V 3775 1200 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 3700 1025 50  0001 C CNN
F 3 "~" H 3700 1025 50  0001 C CNN
	1    3700 1025
	0    1    1    0   
$EndComp
Wire Wire Line
	3375 1100 3375 1025
$Comp
L power:+3.3V #PWR0105
U 1 1 5E33EAE7
P 3375 975
F 0 "#PWR0105" H 3375 825 50  0001 C CNN
F 1 "+3.3V" H 3390 1148 50  0000 C CNN
F 2 "" H 3375 975 50  0001 C CNN
F 3 "" H 3375 975 50  0001 C CNN
	1    3375 975 
	1    0    0    -1  
$EndComp
Wire Wire Line
	3375 975  3375 1025
Connection ~ 3375 1025
$Comp
L power:GND #PWR0107
U 1 1 5E33EC2E
P 3900 1025
F 0 "#PWR0107" H 3900 775 50  0001 C CNN
F 1 "GND" V 3905 897 50  0000 R CNN
F 2 "" H 3900 1025 50  0001 C CNN
F 3 "" H 3900 1025 50  0001 C CNN
	1    3900 1025
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2225 3750 1775 3750
Text Label 1775 3750 0    50   ~ 0
B_UNFUSED
Wire Wire Line
	1575 1325 2075 1325
Text Label 2075 1325 2    50   ~ 0
B_UNFUSED
Text Label 2075 1975 2    50   ~ 0
B_UNFUSED
NoConn ~ 8500 5575
Text GLabel 8375 5675 0    50   Input ~ 0
TWI_SCL
Text GLabel 9500 5975 2    50   Input ~ 0
TWI_SDA
Wire Wire Line
	9400 5975 9500 5975
Wire Wire Line
	8375 5675 8500 5675
$Comp
L Device:R_Small R101
U 1 1 5E3578AD
P 8650 2775
F 0 "R101" H 8709 2821 50  0000 L CNN
F 1 "4.7k" H 8709 2730 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 8650 2775 50  0001 C CNN
F 3 "~" H 8650 2775 50  0001 C CNN
	1    8650 2775
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R102
U 1 1 5E3579EF
P 8925 2775
F 0 "R102" H 8984 2821 50  0000 L CNN
F 1 "4.7k" H 8984 2730 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 8925 2775 50  0001 C CNN
F 3 "~" H 8925 2775 50  0001 C CNN
	1    8925 2775
	1    0    0    -1  
$EndComp
Wire Wire Line
	8650 2675 8800 2675
Wire Wire Line
	8800 2675 8800 2625
Connection ~ 8800 2675
Wire Wire Line
	8800 2675 8925 2675
$Comp
L power:+3.3V #PWR0102
U 1 1 5E358094
P 8800 2625
F 0 "#PWR0102" H 8800 2475 50  0001 C CNN
F 1 "+3.3V" H 8815 2798 50  0000 C CNN
F 2 "" H 8800 2625 50  0001 C CNN
F 3 "" H 8800 2625 50  0001 C CNN
	1    8800 2625
	1    0    0    -1  
$EndComp
Text GLabel 8650 2925 3    50   Input ~ 0
TWI_SDA
Text GLabel 8925 2925 3    50   Input ~ 0
TWI_SCL
Wire Wire Line
	8925 2925 8925 2875
Wire Wire Line
	8650 2925 8650 2875
$Sheet
S 6725 1175 1425 850 
U 5E35B5BB
F0 "Externals" 50
F1 "ExtCons.sch" 50
$EndSheet
Wire Wire Line
	8800 5275 8800 5150
$Comp
L power:+3.3V #PWR0111
U 1 1 5E377A79
P 8800 4975
F 0 "#PWR0111" H 8800 4825 50  0001 C CNN
F 1 "+3.3V" H 8815 5148 50  0000 C CNN
F 2 "" H 8800 4975 50  0001 C CNN
F 3 "" H 8800 4975 50  0001 C CNN
	1    8800 4975
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C103
U 1 1 5E377B11
P 8575 5150
F 0 "C103" V 8346 5150 50  0000 C CNN
F 1 "0.1uF" V 8437 5150 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 8575 5150 50  0001 C CNN
F 3 "~" H 8575 5150 50  0001 C CNN
	1    8575 5150
	0    1    1    0   
$EndComp
Wire Wire Line
	8475 5150 8350 5150
Wire Wire Line
	8350 5150 8350 5225
$Comp
L power:GND #PWR0112
U 1 1 5E377FBA
P 8350 5225
F 0 "#PWR0112" H 8350 4975 50  0001 C CNN
F 1 "GND" H 8355 5052 50  0000 C CNN
F 2 "" H 8350 5225 50  0001 C CNN
F 3 "" H 8350 5225 50  0001 C CNN
	1    8350 5225
	1    0    0    -1  
$EndComp
Wire Wire Line
	8675 5150 8800 5150
Connection ~ 8800 5150
Wire Wire Line
	8800 5150 8800 4975
Wire Wire Line
	8900 6175 8950 6175
Wire Wire Line
	8950 6175 8950 6250
Connection ~ 8950 6175
Wire Wire Line
	8950 6175 9000 6175
$Comp
L power:GND #PWR0113
U 1 1 5E379429
P 8950 6250
F 0 "#PWR0113" H 8950 6000 50  0001 C CNN
F 1 "GND" H 8955 6077 50  0000 C CNN
F 2 "" H 8950 6250 50  0001 C CNN
F 3 "" H 8950 6250 50  0001 C CNN
	1    8950 6250
	1    0    0    -1  
$EndComp
$Comp
L Interface_CAN_LIN:TCAN330 U101
U 1 1 5E37A78C
P 3375 1500
F 0 "U101" H 3000 1950 50  0000 C CNN
F 1 "TCAN330" H 3125 1850 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-8" H 3375 1000 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/tcan337.pdf" H 3375 1500 50  0001 C CNN
	1    3375 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	4325 1600 3875 1600
NoConn ~ 2875 1600
NoConn ~ 2875 1700
Wire Wire Line
	3375 1900 3375 1975
Wire Wire Line
	3375 1025 3600 1025
Wire Wire Line
	3800 1025 3900 1025
Wire Wire Line
	2875 1400 2550 1400
Text Label 2550 1400 0    50   ~ 0
C>MCU
Text Label 2550 1300 0    50   ~ 0
MCU>C
Wire Wire Line
	2550 1300 2875 1300
$Comp
L MCU_ST_STM32L4:STM32L451CEUx U102
U 1 1 5E3B749C
P 5775 3600
F 0 "U102" H 5775 5178 50  0000 C CNN
F 1 "STM32L451CEUx" H 5775 5087 50  0000 C CNN
F 2 "Package_DFN_QFN:QFN-48-1EP_7x7mm_P0.5mm_EP5.6x5.6mm" H 5275 2200 50  0001 R CNN
F 3 "http://www.st.com/st-web-ui/static/active/en/resource/technical/document/datasheet/DM00340475.pdf" H 5775 3600 50  0001 C CNN
	1    5775 3600
	1    0    0    -1  
$EndComp
$EndSCHEMATC

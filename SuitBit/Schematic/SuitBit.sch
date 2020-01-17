EESchema Schematic File Version 4
LIBS:SuitBit-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 3
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
L MCU_ST_STM32F4:STM32F401CBUx U?
U 1 1 5E10E1E9
P 5775 3675
F 0 "U?" H 5725 5453 50  0000 C CNN
F 1 "STM32F401CBUx" H 5725 5362 50  0000 C CNN
F 2 "Package_DFN_QFN:QFN-48-1EP_7x7mm_P0.5mm_EP5.6x5.6mm" H 5175 2175 50  0001 R CNN
F 3 "http://www.st.com/st-web-ui/static/active/en/resource/technical/document/datasheet/DM00086815.pdf" H 5775 3675 50  0001 C CNN
	1    5775 3675
	1    0    0    -1  
$EndComp
$Sheet
S 2225 3650 1025 600 
U 5E10E2B9
F0 "Power Generation" 50
F1 "PowerGen.sch" 50
$EndSheet
$Comp
L dk_Interface-Drivers-Receivers-Transceivers:MCP2551-I_SN U?
U 1 1 5E165CED
P 3050 1650
F 0 "U?" H 3050 2250 60  0000 C CNN
F 1 "MCP2551-I_SN" H 3050 2144 60  0000 C CNN
F 2 "digikey-footprints:SOIC-8_W3.9mm" H 3250 1850 60  0001 L CNN
F 3 "http://www.microchip.com/mymicrochip/filehandler.aspx?ddocname=en011797" H 3250 1950 60  0001 L CNN
F 4 "MCP2551-I/SN-ND" H 3250 2050 60  0001 L CNN "Digi-Key_PN"
F 5 "MCP2551-I/SN" H 3250 2150 60  0001 L CNN "MPN"
F 6 "Integrated Circuits (ICs)" H 3250 2250 60  0001 L CNN "Category"
F 7 "Interface - Drivers, Receivers, Transceivers" H 3250 2350 60  0001 L CNN "Family"
F 8 "http://www.microchip.com/mymicrochip/filehandler.aspx?ddocname=en011797" H 3250 2450 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/microchip-technology/MCP2551-I-SN/MCP2551-I-SN-ND/509452" H 3250 2550 60  0001 L CNN "DK_Detail_Page"
F 10 "IC TRANSCEIVER CAN HI-SPD 8-SOIC" H 3250 2650 60  0001 L CNN "Description"
F 11 "Microchip Technology" H 3250 2750 60  0001 L CNN "Manufacturer"
F 12 "Active" H 3250 2850 60  0001 L CNN "Status"
	1    3050 1650
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J?
U 1 1 5E16611C
P 1375 1325
F 0 "J?" H 1481 1603 50  0000 C CNN
F 1 "Conn_01x04_Male" H 1481 1512 50  0000 C CNN
F 2 "" H 1375 1325 50  0001 C CNN
F 3 "~" H 1375 1325 50  0001 C CNN
	1    1375 1325
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Female J?
U 1 1 5E166245
P 1375 2075
F 0 "J?" H 1269 1650 50  0000 C CNN
F 1 "Conn_01x04_Female" H 1269 1741 50  0000 C CNN
F 2 "" H 1375 2075 50  0001 C CNN
F 3 "~" H 1375 2075 50  0001 C CNN
	1    1375 2075
	-1   0    0    1   
$EndComp
Wire Wire Line
	1575 1225 1875 1225
$Comp
L power:GND #PWR?
U 1 1 5E1665DC
P 1875 1225
F 0 "#PWR?" H 1875 975 50  0001 C CNN
F 1 "GND" V 1880 1097 50  0000 R CNN
F 2 "" H 1875 1225 50  0001 C CNN
F 3 "" H 1875 1225 50  0001 C CNN
	1    1875 1225
	0    -1   -1   0   
$EndComp
$Comp
L power:+BATT #PWR?
U 1 1 5E16680E
P 1875 1325
F 0 "#PWR?" H 1875 1175 50  0001 C CNN
F 1 "+BATT" V 1890 1453 50  0000 L CNN
F 2 "" H 1875 1325 50  0001 C CNN
F 3 "" H 1875 1325 50  0001 C CNN
	1    1875 1325
	0    1    1    0   
$EndComp
Wire Wire Line
	1875 1325 1575 1325
Wire Wire Line
	1575 1425 1875 1425
Text Label 1875 1425 2    50   ~ 0
CAN_L
Text Label 1875 1525 2    50   ~ 0
CAN_H
Wire Wire Line
	1875 1525 1575 1525
Wire Wire Line
	1575 1875 1875 1875
$Comp
L power:GND #PWR?
U 1 1 5E166A3C
P 1875 1875
F 0 "#PWR?" H 1875 1625 50  0001 C CNN
F 1 "GND" V 1880 1747 50  0000 R CNN
F 2 "" H 1875 1875 50  0001 C CNN
F 3 "" H 1875 1875 50  0001 C CNN
	1    1875 1875
	0    -1   -1   0   
$EndComp
$Comp
L power:+BATT #PWR?
U 1 1 5E166A42
P 1875 1975
F 0 "#PWR?" H 1875 1825 50  0001 C CNN
F 1 "+BATT" V 1890 2103 50  0000 L CNN
F 2 "" H 1875 1975 50  0001 C CNN
F 3 "" H 1875 1975 50  0001 C CNN
	1    1875 1975
	0    1    1    0   
$EndComp
Wire Wire Line
	1875 1975 1575 1975
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
L dk_Motion-Sensors-IMUs-Inertial-Measurement-Units:LSM6DS3TR U?
U 1 1 5E17BDF6
P 8125 4875
F 0 "U?" H 8175 5575 60  0000 C CNN
F 1 "LSM6DS3TR" H 8175 5469 60  0000 C CNN
F 2 "digikey-footprints:LGA-14L_2.5x3mm__LSM6DS3" H 8325 5075 60  0001 L CNN
F 3 "http://www.st.com/content/ccc/resource/technical/document/datasheet/a3/f5/4f/ae/8e/44/41/d7/DM00133076.pdf/files/DM00133076.pdf/jcr:content/translations/en.DM00133076.pdf" H 8325 5175 60  0001 L CNN
F 4 "497-15383-1-ND" H 8325 5275 60  0001 L CNN "Digi-Key_PN"
F 5 "LSM6DS3TR" H 8325 5375 60  0001 L CNN "MPN"
F 6 "Sensors, Transducers" H 8325 5475 60  0001 L CNN "Category"
F 7 "Motion Sensors - IMUs (Inertial Measurement Units)" H 8325 5575 60  0001 L CNN "Family"
F 8 "http://www.st.com/content/ccc/resource/technical/document/datasheet/a3/f5/4f/ae/8e/44/41/d7/DM00133076.pdf/files/DM00133076.pdf/jcr:content/translations/en.DM00133076.pdf" H 8325 5675 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/stmicroelectronics/LSM6DS3TR/497-15383-1-ND/5180534" H 8325 5775 60  0001 L CNN "DK_Detail_Page"
F 10 "IMU ACCEL/GYRO I2C/SPI 14VFLGA" H 8325 5875 60  0001 L CNN "Description"
F 11 "STMicroelectronics" H 8325 5975 60  0001 L CNN "Manufacturer"
F 12 "Active" H 8325 6075 60  0001 L CNN "Status"
	1    8125 4875
	1    0    0    -1  
$EndComp
$EndSCHEMATC

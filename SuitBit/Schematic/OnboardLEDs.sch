EESchema Schematic File Version 4
LIBS:SuitBit-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 4
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 1450 2150 0    50   Input ~ 0
WS_Data
$Comp
L LED:WS2812B D303
U 1 1 5E168415
P 4175 1050
F 0 "D303" H 4516 1096 50  0000 L CNN
F 1 "IN-PI42TASPRPGPB" H 4516 1005 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 4225 750 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 4275 675 50  0001 L TNN
	1    4175 1050
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0303
U 1 1 5E30B5FD
P 2450 1400
F 0 "#PWR0303" H 2450 1250 50  0001 C CNN
F 1 "+5V" H 2465 1573 50  0000 C CNN
F 2 "" H 2450 1400 50  0001 C CNN
F 3 "" H 2450 1400 50  0001 C CNN
	1    2450 1400
	1    0    0    -1  
$EndComp
$Comp
L LED:WS2812B D306
U 1 1 5E30BE2E
P 5100 1050
F 0 "D306" H 5441 1096 50  0000 L CNN
F 1 "IN-PI42TASPRPGPB" H 5441 1005 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 5150 750 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 5200 675 50  0001 L TNN
	1    5100 1050
	1    0    0    -1  
$EndComp
$Comp
L LED:WS2812B D304
U 1 1 5E30C094
P 4175 1950
F 0 "D304" H 4516 1996 50  0000 L CNN
F 1 "IN-PI42TASPRPGPB" H 4516 1905 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 4225 1650 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 4275 1575 50  0001 L TNN
	1    4175 1950
	1    0    0    -1  
$EndComp
$Comp
L LED:WS2812B D307
U 1 1 5E30C09B
P 5100 1950
F 0 "D307" H 5441 1996 50  0000 L CNN
F 1 "IN-PI42TASPRPGPB" H 5441 1905 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 5150 1650 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 5200 1575 50  0001 L TNN
	1    5100 1950
	1    0    0    -1  
$EndComp
$Comp
L LED:WS2812B D310
U 1 1 5E30C0A2
P 6025 1950
F 0 "D310" H 6366 1996 50  0000 L CNN
F 1 "IN-PI42TASPRPGPB" H 6366 1905 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 6075 1650 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 6125 1575 50  0001 L TNN
	1    6025 1950
	1    0    0    -1  
$EndComp
$Comp
L LED:WS2812B D305
U 1 1 5E30C2EB
P 4175 2900
F 0 "D305" H 4516 2946 50  0000 L CNN
F 1 "IN-PI42TASPRPGPB" H 4516 2855 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 4225 2600 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 4275 2525 50  0001 L TNN
	1    4175 2900
	1    0    0    -1  
$EndComp
$Comp
L LED:WS2812B D308
U 1 1 5E30C2F2
P 5100 2900
F 0 "D308" H 5441 2946 50  0000 L CNN
F 1 "IN-PI42TASPRPGPB" H 5441 2855 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 5150 2600 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 5200 2525 50  0001 L TNN
	1    5100 2900
	1    0    0    -1  
$EndComp
$Comp
L LED:WS2812B D311
U 1 1 5E30C2F9
P 6025 2900
F 0 "D311" H 6366 2946 50  0000 L CNN
F 1 "IN-PI42TASPRPGPB" H 6366 2855 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 6075 2600 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 6125 2525 50  0001 L TNN
	1    6025 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4475 1050 4800 1050
Wire Wire Line
	5400 1050 5725 1050
Wire Wire Line
	5400 1950 5725 1950
Wire Wire Line
	4475 1950 4800 1950
Wire Wire Line
	4475 2900 4800 2900
Wire Wire Line
	5400 2900 5725 2900
Wire Wire Line
	4175 2600 4175 2550
Wire Wire Line
	4175 2550 5100 2550
Wire Wire Line
	6025 2550 6025 2600
Wire Wire Line
	5100 2600 5100 2550
Connection ~ 5100 2550
Wire Wire Line
	5100 2550 6025 2550
Wire Wire Line
	4175 3200 4175 3275
Wire Wire Line
	4175 3275 5100 3275
Wire Wire Line
	6025 3275 6025 3200
Wire Wire Line
	5100 3200 5100 3275
Connection ~ 5100 3275
Wire Wire Line
	5100 3275 6025 3275
$Comp
L power:GND #PWR0304
U 1 1 5E30D774
P 5100 3375
F 0 "#PWR0304" H 5100 3125 50  0001 C CNN
F 1 "GND" H 5105 3202 50  0000 C CNN
F 2 "" H 5100 3375 50  0001 C CNN
F 3 "" H 5100 3375 50  0001 C CNN
	1    5100 3375
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 3275 5100 3375
Wire Wire Line
	4175 2250 4175 2325
Wire Wire Line
	4175 2325 5100 2325
Wire Wire Line
	6025 2325 6025 2250
Wire Wire Line
	5100 2250 5100 2325
Connection ~ 5100 2325
Wire Wire Line
	5100 2325 6025 2325
Wire Wire Line
	4175 1350 4175 1425
Wire Wire Line
	4175 1425 5100 1425
Wire Wire Line
	6025 1425 6025 1350
Wire Wire Line
	5100 1350 5100 1425
Connection ~ 5100 1425
Wire Wire Line
	5100 1425 6025 1425
Wire Wire Line
	4175 750  4175 700 
Wire Wire Line
	4175 700  5100 700 
Wire Wire Line
	6025 700  6025 750 
Wire Wire Line
	5100 750  5100 700 
Connection ~ 5100 700 
Wire Wire Line
	5100 700  6025 700 
Wire Wire Line
	4175 1650 4175 1600
Wire Wire Line
	4175 1600 5100 1600
Wire Wire Line
	6025 1600 6025 1650
Wire Wire Line
	5100 1650 5100 1600
Connection ~ 5100 1600
Wire Wire Line
	5100 1600 6025 1600
Wire Wire Line
	3875 1525 3875 1950
Wire Wire Line
	6325 1950 6325 2425
Wire Wire Line
	6325 2425 3875 2425
Wire Wire Line
	3875 2425 3875 2900
Wire Wire Line
	6025 700  6550 700 
Wire Wire Line
	7125 700  7125 1600
Wire Wire Line
	7125 2550 6025 2550
Connection ~ 6025 700 
Connection ~ 6025 2550
Wire Wire Line
	6025 3275 6775 3275
Wire Wire Line
	6775 3275 6775 2325
Connection ~ 6025 3275
$Comp
L Device:C_Small C302
U 1 1 5E31575C
P 6950 1750
F 0 "C302" V 6721 1750 50  0000 C CNN
F 1 "100nF" V 6812 1750 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 6950 1750 50  0001 C CNN
F 3 "~" H 6950 1750 50  0001 C CNN
	1    6950 1750
	0    1    1    0   
$EndComp
$Comp
L Device:C_Small C303
U 1 1 5E315825
P 6950 2175
F 0 "C303" V 6721 2175 50  0000 C CNN
F 1 "100nF" V 6812 2175 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 6950 2175 50  0001 C CNN
F 3 "~" H 6950 2175 50  0001 C CNN
	1    6950 2175
	0    1    1    0   
$EndComp
Wire Wire Line
	6850 1750 6775 1750
Connection ~ 6775 1750
Wire Wire Line
	7050 1750 7125 1750
Connection ~ 7125 1750
Wire Wire Line
	7125 1750 7125 2175
Wire Wire Line
	7050 2175 7125 2175
Connection ~ 7125 2175
Wire Wire Line
	7125 2175 7125 2550
Wire Wire Line
	6850 2175 6775 2175
Connection ~ 6775 2175
Wire Wire Line
	6775 2175 6775 1750
$Comp
L power:+5V #PWR0305
U 1 1 5E31B47E
P 6550 700
F 0 "#PWR0305" H 6550 550 50  0001 C CNN
F 1 "+5V" H 6565 873 50  0000 C CNN
F 2 "" H 6550 700 50  0001 C CNN
F 3 "" H 6550 700 50  0001 C CNN
	1    6550 700 
	1    0    0    -1  
$EndComp
Connection ~ 6550 700 
Wire Wire Line
	6550 700  7125 700 
Wire Wire Line
	3250 1700 3250 1050
Wire Wire Line
	3250 1050 3875 1050
$Comp
L LED:WS2812B D309
U 1 1 5E30BEF2
P 6025 1050
F 0 "D309" H 6366 1096 50  0000 L CNN
F 1 "IN-PI42TASPRPGPB" H 6366 1005 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 6075 750 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 6125 675 50  0001 L TNN
	1    6025 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	6325 1050 6325 1525
Wire Wire Line
	6325 1525 3875 1525
Wire Wire Line
	6025 2325 6775 2325
Connection ~ 6025 2325
Connection ~ 6775 2325
Wire Wire Line
	6775 2325 6775 2175
Wire Wire Line
	6025 1425 6550 1425
Wire Wire Line
	6775 1425 6775 1750
Connection ~ 6025 1425
$Comp
L power:GND #PWR0114
U 1 1 5E3B96DC
P 6550 1425
F 0 "#PWR0114" H 6550 1175 50  0001 C CNN
F 1 "GND" H 6555 1252 50  0000 C CNN
F 2 "" H 6550 1425 50  0001 C CNN
F 3 "" H 6550 1425 50  0001 C CNN
	1    6550 1425
	1    0    0    -1  
$EndComp
Connection ~ 6550 1425
Wire Wire Line
	6550 1425 6775 1425
Wire Wire Line
	6025 1600 7125 1600
Connection ~ 6025 1600
Connection ~ 7125 1600
Wire Wire Line
	7125 1600 7125 1750
$Comp
L LED:WS2812B D312
U 1 1 5E3E2E9E
P 4175 4200
F 0 "D312" H 4516 4246 50  0000 L CNN
F 1 "IN-PI42TASPRPGPB" H 4516 4155 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 4225 3900 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 4275 3825 50  0001 L TNN
	1    4175 4200
	1    0    0    -1  
$EndComp
$Comp
L LED:WS2812B D313
U 1 1 5E3E2EA4
P 5100 4200
F 0 "D313" H 5441 4246 50  0000 L CNN
F 1 "IN-PI42TASPRPGPB" H 5441 4155 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 5150 3900 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 5200 3825 50  0001 L TNN
	1    5100 4200
	1    0    0    -1  
$EndComp
$Comp
L LED:WS2812B D314
U 1 1 5E3E2EAA
P 6025 4200
F 0 "D314" H 6366 4246 50  0000 L CNN
F 1 "IN-PI42TASPRPGPB" H 6366 4155 50  0000 L CNN
F 2 "XasPrints:IN-PI42TAS" H 6075 3900 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf" H 6125 3825 50  0001 L TNN
	1    6025 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4475 4200 4800 4200
Wire Wire Line
	5400 4200 5725 4200
Wire Wire Line
	4175 3900 4175 3850
Wire Wire Line
	6025 3850 6025 3900
Wire Wire Line
	5100 3900 5100 3850
Wire Wire Line
	4175 4500 4175 4575
Wire Wire Line
	6025 4575 6025 4500
Wire Wire Line
	5100 4500 5100 4575
Wire Wire Line
	6325 4200 6925 4200
Wire Wire Line
	4175 3850 5100 3850
Connection ~ 5100 3850
Wire Wire Line
	5100 3850 6025 3850
Wire Wire Line
	7125 2550 7125 3850
Wire Wire Line
	7125 3850 6025 3850
Connection ~ 7125 2550
Connection ~ 6025 3850
Wire Wire Line
	6775 3275 6775 4575
Wire Wire Line
	6775 4575 6025 4575
Connection ~ 6775 3275
Connection ~ 5100 4575
Wire Wire Line
	5100 4575 4175 4575
Connection ~ 6025 4575
Wire Wire Line
	6025 4575 5100 4575
Wire Wire Line
	6325 2900 6325 3650
Wire Wire Line
	6325 3650 3875 3650
Wire Wire Line
	3875 3650 3875 4200
Text HLabel 7075 4200 2    50   Input ~ 0
WS2812_Out
$Comp
L Device:Jumper_NO_Small JP301
U 1 1 5E4091B4
P 3250 3450
F 0 "JP301" V 3204 3498 50  0000 L CNN
F 1 "Jumper_NO_Small" V 3295 3498 50  0000 L CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Open_TrianglePad1.0x1.5mm" H 3250 3450 50  0001 C CNN
F 3 "~" H 3250 3450 50  0001 C CNN
	1    3250 3450
	0    1    1    0   
$EndComp
Wire Wire Line
	3250 1700 3250 3350
Connection ~ 3250 1700
Wire Wire Line
	3250 3550 3250 4850
Wire Wire Line
	3250 4850 6925 4850
Wire Wire Line
	6925 4850 6925 4200
Connection ~ 6925 4200
Wire Wire Line
	6925 4200 7075 4200
$Comp
L Device:R_Small R301
U 1 1 5E42692A
P 1825 2150
F 0 "R301" V 1629 2150 50  0000 C CNN
F 1 "10k" V 1720 2150 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 1825 2150 50  0001 C CNN
F 3 "~" H 1825 2150 50  0001 C CNN
	1    1825 2150
	0    1    1    0   
$EndComp
$Comp
L dk_Transistors-Bipolar-BJT-Single:PMBT2222A_215 Q301
U 1 1 5E435976
P 2350 2150
F 0 "Q301" H 2575 2350 60  0000 L CNN
F 1 "PMBT2222A_215" H 2550 2250 60  0000 L CNN
F 2 "digikey-footprints:SOT-23-3" H 2550 2350 60  0001 L CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/PMBT2222_PMBT2222A.pdf" H 2550 2450 60  0001 L CNN
F 4 "1727-2956-1-ND" H 2550 2550 60  0001 L CNN "Digi-Key_PN"
F 5 "PMBT2222A,215" H 2550 2650 60  0001 L CNN "MPN"
F 6 "Discrete Semiconductor Products" H 2550 2750 60  0001 L CNN "Category"
F 7 "Transistors - Bipolar (BJT) - Single" H 2550 2850 60  0001 L CNN "Family"
F 8 "https://assets.nexperia.com/documents/data-sheet/PMBT2222_PMBT2222A.pdf" H 2550 2950 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/nexperia-usa-inc/PMBT2222A,215/1727-2956-1-ND/763512" H 2550 3050 60  0001 L CNN "DK_Detail_Page"
F 10 "TRANS NPN 40V 0.6A SOT23" H 2550 3150 60  0001 L CNN "Description"
F 11 "Nexperia USA Inc." H 2550 3250 60  0001 L CNN "Manufacturer"
F 12 "Active" H 2550 3350 60  0001 L CNN "Status"
	1    2350 2150
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R302
U 1 1 5E4385D8
P 2450 1500
F 0 "R302" H 2509 1546 50  0000 L CNN
F 1 "10K" H 2509 1455 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 2450 1500 50  0001 C CNN
F 3 "~" H 2450 1500 50  0001 C CNN
	1    2450 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2450 1700 2450 1600
Wire Wire Line
	2450 1950 2450 1700
Connection ~ 2450 1700
Wire Wire Line
	2450 2350 2450 2400
Wire Wire Line
	2450 1700 3250 1700
$Comp
L power:GND #PWR0122
U 1 1 5E445FD0
P 2450 2400
F 0 "#PWR0122" H 2450 2150 50  0001 C CNN
F 1 "GND" H 2455 2227 50  0000 C CNN
F 2 "" H 2450 2400 50  0001 C CNN
F 3 "" H 2450 2400 50  0001 C CNN
	1    2450 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	1450 2150 1725 2150
Wire Wire Line
	1925 2150 2150 2150
Text Notes 900  2450 0    50   ~ 0
Skip the amp here, it works <.<
$EndSCHEMATC

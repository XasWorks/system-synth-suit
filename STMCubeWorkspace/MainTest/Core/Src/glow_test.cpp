/*
 * glow_test.cpp
 *
 *  Created on: 8 Mar 2020
 *      Author: xasin
 */

#include "NeoController/NeoController.h"
#include "main.h"

#include "cmsis_os.h"

#include <cmath>
#include <math.h>
#include <array>

struct led_coord_t {
	float x;
	float y;
};

led_coord_t leds[31] = {
		{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0},	// Stub 12 first LEDs
		{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0},
		{-3, -1.4}, {-3, -0.7}, {-3, 0},
		{-0.7, 4.5}, {0, 4.5}, {0.7, 4.5},
		{2.5, 1.4}, {2.5, 0.7}, {2.5, 0},
		{6, 1}, {7, 5}, // Thumb
		{3, 6}, {3, 10},
		{1.5, 7}, {1.5, 12},
		{-1, 6}, {-1, 10},
		{-2.5, 5}, {-2.5, 8},
};

auto glow = Xasin::NeoController(hspi1, 31, false);

float calc_position(const led_coord_t led, const led_coord_t facts) {
	float sum = 0;

	auto led_c = reinterpret_cast<const float*>(&led);
	auto fact_c = reinterpret_cast<const float*>(&facts);

	for(int i=0; i<sizeof(led_coord_t) / sizeof(float); i++) {
		if(fact_c[i] == 0)
			continue;
		if(isnan(led_c[i]))
			return 0;

		sum = fmaf(led_c[i], fact_c[i], sum);
	}

	return sum;
}

extern "C" {
void testGlow() {
	for(int i=0; i<12; i++)
		leds[i] = {2*cosf(M_PI*i/6.0F), 2*sinf(M_PI*i/6.0F)};

	led_coord_t spin_coords = {};

	while(1) {
		HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_8);
		osDelay(10);

		float kernel_move = osKernelGetTickCount() / 6.0F;
		spin_coords = {sinf(kernel_move*0.015F), cosf(kernel_move*0.015F)};

		for(int i=0; i<31; i++) {
			float led_pos = calc_position(leds[i], spin_coords);
			if(fabsf(led_pos) < 1)
				glow.colors[i] = Material::RED;
			else
				glow.colors[i].merge_overlay(0, 0.04);
		}

		glow.push();
	}
}
}

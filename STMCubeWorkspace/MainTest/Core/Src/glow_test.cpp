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

#include <Animation/AnimationServer.h>
#include <Animation/NumericElement.h>

#include <Animation/WaveElement.h>

#include <config.h>

Xasin::AnimationServer server = Xasin::AnimationServer();

auto test_num_elem = Xasin::NumericElement(server, {1, 1});
auto comp_elem = Xasin::NumericElement(server, {1, 2});
auto num_smoother = Xasin::NumericElement(server, {1, 3});

led_coord_t leds[31] = {
		{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0},	// Stub 12 first LEDs
		{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0},
		{-3, -1.4}, {-3, -0.7}, {-3, 0},
		{-0.7, 4.5}, {0, 4.5}, {0.7, 4.5},
		{2.5, 1.4}, {2.5, 0.7}, {2.5, 0},
		{6, 1}, {7, 5}, // Thumb (22, 23)
		{3, 6}, {3, 10},
		{1.5, 7}, {1.5, 12},
		{-1, 6}, {-1, 10},
		{-2.5, 5}, {-2.5, 8},
};

auto glow = Xasin::NeoController(hspi1, 31, false);

Xasin::Layer l_gem = glow.colors;

int flash_leds[] = {
		21,
		23,
		25,
		27,
		29
};
Xasin::Color flash_colors[] = {
		Material::GREEN,
		Material::PURPLE,
		Material::BLUE,
		Material::RED,
		Material::ORANGE,
};

uint8_t wave_num = 0;
void start_wave(led_coord_t center_point, Xasin::Color w_color, float speed = 20) {
	auto n_glow = new Xasin::Animation::WaveElement(server, {2, wave_num++}, glow.colors);

	n_glow->wave_color = w_color;
	n_glow->wave_color.alpha = 0.5;

	n_glow->x_dir = {1, 0};
	n_glow->y_dir = {0, 1};
	n_glow->offset = center_point;

	n_glow->circle_speed = speed;

	n_glow->delete_after = server.get_synch_time() + 5;
}

float last_blep_time = 3;

extern "C" {
void testGlow() {
	Xasin::AnimationElement::led_coordinates = leds;

	for(int i=0; i<12; i++)
		leds[i] = {2*cosf(M_PI*i/6.0F), 2*sinf(M_PI*i/6.0F)};

	server.tick(0.01);

	l_gem.fill(Xasin::Color(0, 0, 0));
	l_gem.alpha = 0.1;

	while(1) {
		osDelay(10);

		server.tick(0.01);

		if(server.get_synch_time() > last_blep_time) {
			last_blep_time += 2;
			if(wave_num < 5) {
				int led_num = flash_leds[wave_num];
				Xasin::Color flash_color = flash_colors[wave_num];
				flash_color.bMod(0.8);

				l_gem[led_num] = flash_color;

				start_wave(leds[led_num], flash_color);
			}
			else if(wave_num == 5) {
				wave_num = 6;

				l_gem.fill(Material::YELLOW, 0, 11);

				start_wave({0, 0}, Material::YELLOW, 10);
			}
		}

		for(int i=0; i<31; i++)
			glow.colors[i].merge_overlay(Xasin::Color(0xE2B007, 0.3), 0.04);

		glow.colors.merge_overlay(l_gem);

		glow.push();
	}
}
}

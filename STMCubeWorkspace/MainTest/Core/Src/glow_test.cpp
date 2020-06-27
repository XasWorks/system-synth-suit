/*
 * glow_test.cpp
 *
 *  Created on: 8 Mar 2020
 *      Author: xasin
 */

#include "NeoController/NeoController.h"
#include "main.h"

#include "sys_funcs.h"

#include "cmsis_os.h"

#include <cmath>
#include <math.h>
#include <array>
#include <string.h>

#include <Animation/AnimationServer.h>

#include <Animation/Box.h>

#include <config.h>

#include <FurComs/LLHandler.h>

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

auto test_handler = TEF::FurComs::LL_Handler(USART1);

extern "C" {
void USART1_IRQHandler() {
	test_handler.handle_isr();
}

void on_data(const char *topic, const void *data, size_t length) {
	auto str_data = reinterpret_cast<const char*>(data);

	if(strcmp(topic, "SET") == 0) {
		HW::server.handle_set_command(str_data);
	}
	else if(strcmp(topic, "CSET") == 0) {
		HW::server.handle_color_set_command(str_data);
	}
	else if(strcmp(topic, "DELETE") == 0) {
		HW::server.handle_delete_command(str_data);
	}
	else if(strcmp(topic, "DTIME") == 0) {
		HW::server.handle_dtime_command(str_data);
	}
	else if(strcmp(topic, "NEW") == 0) {

		if(strncmp(str_data, "BOX", 3) == 0) {
			Xasin::Layer * layer_refs[] = {
					&HW::la_0,
					&HW::la_1,
					&HW::la_2,
					&HW::lb_1,
			};

			int layer_no = 0;
			auto layer_ptr = strchr(str_data, ' ');
			if(layer_ptr != nullptr) {
				layer_ptr = strchr(layer_ptr + 1, ' ');

				if(layer_ptr != nullptr)
					layer_no = strtol(layer_ptr + 1, nullptr, 0);
			}

			if(layer_no < 0 || layer_no > 3)
				layer_no = 0;

			auto new_box = new Xasin::Animation::Box(HW::server, HW::server.decode_value_tgt(str_data).ID, *layer_refs[layer_no]);

			new_box->x_coord = {1, 0};
			new_box->y_coord = {0, 1};
		}
	}
}

void testGlow() {
	Xasin::AnimationElement::led_coordinates = leds;

	HW::init();

	for(int i=0; i<12; i++)
		leds[i] = {2*cosf(M_PI*i/6.0F), 2*sinf(M_PI*i/6.0F)};

	test_handler.init();
	test_handler.on_rx = on_data;

	auto test_box = new Xasin::Animation::Box(HW::server, {100, 0}, HW::la_0);
	test_box->x_coord = {1, 0};
	test_box->y_coord = {0, 1};

	test_box->up = 3;
	test_box->down = 3;
	test_box->left = 3;
	test_box->right = 3;

	test_box->draw_color = 0x334455;

	float next_blip = 0;

	bool old_btn = false;

	while(1) {
		osDelay(16);
		HW::tick(0.016);

		bool current_btn = HAL_GPIO_ReadPin(BTN_INT_GPIO_Port, BTN_INT_Pin);

		if(current_btn != old_btn) {
			test_handler.start_packet("BTN");
			const char *d_ptr = current_btn ? "UP" : "DOWN";
			test_handler.add_packet_data(d_ptr, strlen(d_ptr));
			test_handler.close_packet();

			old_btn = current_btn;
		}

		if(HW::server.get_synch_time() > next_blip) {
			next_blip += 0.5;
			HAL_GPIO_TogglePin(PIN_LED_GPIO_Port, PIN_LED_Pin);
		}
	}
}
}

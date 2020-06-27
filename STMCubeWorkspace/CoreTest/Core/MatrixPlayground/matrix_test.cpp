/*
 * matrix_test.cpp
 *
 *  Created on: 10 Jun 2020
 *      Author: xasin
 */

#include <algorithm>
#include <cmath>
#include <cstring>

#include "main.h"
#include "cmsis_os.h"

#include "MatrixContainers.h"

#include <tef/led/matrix/Matrix.h>

#include "FurComs/LLHandler.h"
#include "Animation/AnimationServer.h"

#include <Animation/Eyes.h>
#include <Animation/MatrixString.h>

extern DMA_HandleTypeDef hdma_tim1_ch1;
extern TIM_HandleTypeDef htim1;
extern TIM_HandleTypeDef htim4;
extern UART_HandleTypeDef huart4;

const TEF::LED::Matrix::HUB75_conf_t hub_config = {
		DMA2_Stream1,
		DMA2,
		0x3F << 6,

		TIM1,

		GPIOB,
		GPIO_PIN_6,

		GPIOG,
		9,

		reinterpret_cast<uint32_t>(&GPIOD->ODR)
};

using namespace TEF;
using namespace TEF::Animation;

LED::Matrix::HUB75<16, 32, 4> frame_container = LED::Matrix::HUB75<16, 32, 4>(hub_config);

TEF::FurComs::LL_Handler furcoms = TEF::FurComs::LL_Handler(UART4);

AnimationServer anim_server = AnimationServer();
Eyes anim_eyes = Eyes(anim_server, {1, 0}, frame_container);
MatrixString anim_str = MatrixString(anim_server, {1, 1}, frame_container);

void show_meme() {
	const uint8_t meme_pixels[]= {
			0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4, 0x2,
			0x20, 0x58, 0x4, 0x82, 0x20, 0x48, 0x44, 0x82, 0x20, 0x48, 0x44, 0x84, 0x20, 0x44, 0xa4, 0x84,
			0x60, 0x44, 0xa8, 0x84, 0x40, 0xc4, 0xa8, 0x84, 0x40, 0x84, 0xa8, 0x84, 0x7f, 0x3, 0x30, 0x88,
			0x0, 0x3, 0x0, 0xf8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	};
}

int c_row = 0;

void on_data(const char *topic, const void *data, size_t length) {
	auto str_data = reinterpret_cast<const char*>(data);

	anim_server.parse_command(topic, str_data);
}

// TODO Optimize this bunch :>
extern "C" {
void UART4_IRQHandler() {
	furcoms.handle_isr();
}

void matrix_isr_tick() {
	frame_container.Timer_IRQHandler();
}

void matrix_task() {
	htim1.Instance->DIER |= (TIM_DMA_CC1);
	htim1.Instance->CCER |= 1<<TIM_CHANNEL_1;
	htim1.Instance->BDTR |= 1<<15;

	__HAL_TIM_ENABLE_IT(&htim4, TIM_IT_UPDATE);

	furcoms.init();
	furcoms.on_rx = on_data;

	TickType_t start_tick = xTaskGetTickCount();

	GPIOE->MODER |= GPIO_MODE_OUTPUT_PP << 20;

	while(true) {
		vTaskDelayUntil(&start_tick, 20);

		GPIOE->ODR |= GPIO_PIN_10;

		anim_server.tick(0.02);
		frame_container.switch_frame();

		frame_container.clear();

		GPIOE->ODR &= ~GPIO_PIN_10;
	}
}
}

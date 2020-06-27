/*
 * sys_funcs.cpp
 *
 *  Created on: Mar 22, 2020
 *      Author: xasin
 */

#include "main.h"
#include "sys_funcs.h"

#include <config.h>

uint16_t tick_total_duration = 0;
uint16_t tick_duration = 0;
uint16_t tick_load = 0;

extern led_coord_t leds[];

namespace HW {

	TEF::Animation::AnimationServer server = TEF::Animation::AnimationServer();
	TEF::LED::NeoController glow = TEF::LED::NeoController(hspi1, ANIM_LED_COUNT, false);

	const uint32_t rg_swap_map[] = {
			0b11U<<30, 131071U
	};

	TEF::LED::Layer la_0 = glow.colours;
	TEF::LED::Layer la_1 = glow.colours;
	TEF::LED::Layer la_2 = glow.colours;
	TEF::LED::Layer lb_1 = glow.colours;
	TEF::LED::Layer lb_2 = glow.colours;

	uint16_t tick_start = 0;

	int note_index = 0;
	float note_current_playtime = 0;

	std::vector<note_config_t> current_notes;
	std::vector<note_config_t> pending_notes;

	bool tmr_was_stopped = true;
	float old_freq = 0;

	void set_bzr_freq(float frequency) {
		if(frequency == old_freq)
			return;
		old_freq = frequency;

		if((frequency < 100 || frequency > 20000)) {
			if(!tmr_was_stopped)
				HAL_TIM_PWM_Stop(&htim1, TIM_CHANNEL_1);
			tmr_was_stopped = true;
		}
		else if(tmr_was_stopped) {
			tmr_was_stopped = false;
			HAL_TIM_PWM_Start(&htim1, TIM_CHANNEL_1);
		}

		if(!tmr_was_stopped) {
			TIM1->ARR = (4000000 / frequency);
			TIM1->CCR1 = TIM1->ARR/2;
			TIM1->CNT = 0;

			TIM1->EGR = TIM_EGR_UG;
		}
	}

	void note_tick(float delta_t) {
		for(auto i = pending_notes.begin(); i != pending_notes.end(); ) {
			auto c_note = *i;

			if(c_note.start_time >= server.get_synch_time()) {
				i = pending_notes.erase(i);
				current_notes.push_back(c_note);
			}
			else
				i++;
		}

		if(current_notes.empty())
			set_bzr_freq(0);
		else {
			if(note_index >= current_notes.size()) {
				note_index = 0;
				note_current_playtime = 0;
			}

			auto &c_note = current_notes[note_index];
			set_bzr_freq(c_note.freq);

			note_current_playtime += delta_t;

			if(c_note.end_time < server.get_synch_time()) {
				current_notes.erase(current_notes.begin() + note_index);
			}
			else if(note_current_playtime > c_note.swap_dur) {
				note_index++;
				note_current_playtime = 0;
			}
		}
	}

	void init() {
		// glow.rg_swap_map = rg_swap_map;

		la_1.alpha = 0.01;
		la_2.alpha = 0.005;
		la_2.fill(TEF::LED::Colour(0, 0));

		lb_2.alpha = 0.07;
		lb_2.fill(TEF::LED::Colour(0x000000, 1, 0.6)); // TODO CAREFUL - DIM
	}

	void tick(float delta_t) {
		tick_total_duration = SYS_CNT - tick_start;
		tick_start = SYS_CNT;

		note_tick(delta_t);

		glow.colours = la_0;

		la_1.merge_transition(la_2);
		la_0.merge_transition(la_1);

		lb_1.merge_transition(lb_2);

		glow.colours.merge_overlay(lb_1);

		server.tick(delta_t);

		glow.push();

		tick_duration = SYS_CNT - tick_start;
		if(tick_total_duration > 10)
			tick_load = uint32_t(tick_duration) * 1000 / tick_total_duration;
	}

	void add_note(float frequency, float duration, float swap_time) {
		note_config_t note = {swap_time, 0, duration + server.get_synch_time(), frequency};
		current_notes.push_back(note);
	}
}

/*
 * sys_funcs.hh
 *
 *  Created on: Mar 22, 2020
 *      Author: xasin
 */

#ifndef INC_SYS_FUNCS_H_
#define INC_SYS_FUNCS_H_

#include "main.h"

#include <tef/led/NeoController.h>

#include <Animation/AnimationServer.h>

#include <vector>
#define SYS_CNT TIM2->CNT

namespace HW {

extern TEF::Animation::AnimationServer server;
extern TEF::LED::NeoController glow;

// Slow-rolling set, provides very smoothed effects
extern TEF::LED::Layer la_0;
extern TEF::LED::Layer la_1;
extern TEF::LED::Layer la_2;

// Fast flashing layers for juicy kicks and similar
extern TEF::LED::Layer lb_1;
extern TEF::LED::Layer lb_2;

struct note_config_t {
	float swap_dur;
	float start_time;
	float end_time;

	float freq;
};

extern std::vector<note_config_t> current_notes;

void set_bzr_freq(float frequency);

void init();
void tick(float delta_t);

void add_note(float frequency, float duration, float swap_time = 0.1);

}


#endif /* INC_SYS_FUNCS_H_ */

/*
 * beat_gen.cpp
 *
 *  Created on: 31 Mar 2020
 *      Author: xasin
 */

#include "Animation/Box.h"

#include "beat_gen.h"
#include "sys_funcs.h"

#include <vector>

std::vector<music_event_t> pending_evt;
std::vector<music_event_t> music_queue;


void add_event(float offset, void (*on_event)(int), int payload) {
	pending_evt.push_back(music_event_t({HW::server.get_synch_time() + offset, on_event, payload}));
}
void insert_pending_beats() {
	while(!pending_evt.empty()) {
		auto insert_evt = pending_evt[pending_evt.size()-1];
		pending_evt.pop_back();

		auto i = music_queue.begin();
		while(1) {
			if(i == music_queue.end()) {
				music_queue.push_back(insert_evt);
				break;
			}

			if(insert_evt.timestamp > i->timestamp) {
				music_queue.insert(i, insert_evt);
				break;
			}

			i++;
		}
	}
}

void music_tick() {
	if(music_queue.empty())
		return;

	auto next_event = music_queue[music_queue.size() -1];
	if(next_event.timestamp < HW::server.get_synch_time()) {
		music_queue.pop_back();
		next_event.on_event(next_event.payload);

		insert_pending_beats();
	}
}

struct beat_conf_t {
	float up;
	float down;
	float left;
	float right;

	Xasin::Color color;
};
beat_conf_t beat_type_list[] = {
		{ 3, 3, 3, 3, Xasin::Color(Material::LIME, 0.5) },
		{ 10, -4.9, 3, 3, Material::RED},
		{ 3, 3, 3, -0.1, Xasin::Color(Material::BLUE, 0.5) },
		{ 3, 3, -0.1, 3, Xasin::Color(Material::BLUE, 0.5) },
		{ 50, 50, 50, 50, Xasin::Color(Material::AMBER, 0.2) },
		{ 5.1, -0.9, -5.5, 8, 0x555555 },
		{ 12, 12, 3, -1, Xasin::Color(Material::LIME) },
		{ 12, 12, 1, 0, Xasin::Color(Material::GREEN) },
		{ 12, 12, 0, 2, Xasin::Color(Material::CYAN)  },
		{ 12, 12, -2, 4, Xasin::Color(Material::BLUE) }
};
void add_beat(int num) {
	beat_conf_t conf = beat_type_list[num];

	Xasin::Layer &l_ref = HW::lb_1;

	auto box = new Xasin::Animation::Box(HW::server, {2, num}, l_ref, 10);

	box->x_coord = {1, 0};
	box->y_coord = {0, 1};

	box->up = conf.up;
	box->down = conf.down;
	box->left = conf.left;
	box->right = conf.right;

	box->draw_color = conf.color;

	if(num >= BEAT_ONE && num <= BEAT_FOUR)
		box->delete_after = HW::server.get_synch_time() + 0.2;
	else
		box->delete_after = HW::server.get_synch_time() + 0.1;
}

struct cheer_conf {
	float rotation;
	float speed;
	float duration;
	Xasin::Color color;
};

cheer_conf cheer_configs[] = {
		{ 0, 15, 2*QUARTERS, Xasin::Color(Material::GREEN, 0.7) },
		{ 1, 20, 4*QUARTERS, Xasin::Color(Material::PINK, 0.7) },
		{ -1, 20, 4*QUARTERS, Xasin::Color(Material::PINK, 0.7) },
};

void add_cheer(int num) {
	auto box = new Xasin::Animation::Box(HW::server, {3, 0}, HW::la_1, 4);

	box->draw_color = cheer_configs[num].color;
	box->x_coord = {1, 0};
	box->y_coord = {0, 1};

	box->left = 100;
	box->right = 100;

	box->center = {0, 5};

	box->rotation = cheer_configs[num].rotation;

	box->set_flt(0x001, "JUMP -10 SPEED 15 20 0 1 100");
	box->copy_ops[0x001].pt2_speed = cheer_configs[num].speed;
	box->set_flt(0x002, "S3M0V1 -1 -1");

	box->delete_after = HW::server.get_synch_time() + cheer_configs[num].duration;
}

void add_beat_count(int type) {
	switch(type) {
	default:
	case COUNT_PRELUDE:
		for(int i=0; i<4; i++)
			add_event(BT(0, i, 0), add_beat, BEAT_SOFT);
		break;
	case COUNT_BEAT:
		for(int i=0; i<4; i++)
			add_event(BT(0, i, 0), add_beat, BEAT_MAIN);
		break;
	case COUNT_CHARGE:
		for(int i=0; i<4; i++)
			add_event(BT(0, i, 0), add_beat, i<2 ? BEAT_LEFT : BEAT_RIGHT);
		break;
	case COUNT_OFFBEATS:
		for(int i=2; i<4; i++)
			add_event(BT(1, i, 0), add_beat, BEAT_TOP);
		break;
	case COUNT_KICKS:
		for(int i=0; i<4; i++)
			add_event(BT(1, i, 0), add_beat, BEAT_THUMB);
		break;

	case COUNT_OTTF:
		for(int i=0; i<4; i++)
			add_event(BT(0, i, 0), add_beat, BEAT_ONE + i);
		break;

	case COUNT_BEAT_2:
		add_event(BT(0, 0, 0), add_beat, BEAT_LEFT);
		add_event(BT(0, 1, 0), add_beat, BEAT_LEFT);
		add_event(BT(1, 2, 0), add_beat, BEAT_RIGHT);
		add_event(BT(1, 3, 0), add_beat, BEAT_RIGHT);
		break;
	}
}

void add_step(int type) {
	switch(type) {
	default:
	case STEP_PRELUDE:
		for(int i=0; i<4; i++)
			add_event(BT(0, 0, i), add_beat_count, COUNT_PRELUDE);
		add_event(BT(0, 0, 3), add_cheer, 0);
	break;
	case STEP_BEAT_CHARGE:
		for(int i=0; i<4; i++)
			add_event(BT(0, 0, i), add_beat_count, i<3 ? COUNT_BEAT : COUNT_CHARGE);
	break;
	case STEP_KICKS:
		for(int i=0; i<4; i++)
			add_event(BT(0, 0, i), add_beat_count, COUNT_KICKS);
	break;

	case STEP_BEAT_OFFBEATS:
		for(int i=0; i<4; i++)
			add_event(BT(0, 0, i), add_beat_count, COUNT_OFFBEATS);
	break;

	case STEP_FULL_BEATS:
		add_step(STEP_BEAT_CHARGE);
		add_step(STEP_KICKS);
		add_step(STEP_BEAT_OFFBEATS);
	break;

	case STEP_FULL_BEATS_2:
		add_step(STEP_KICKS);
		for(int i=0; i<4; i++)
			add_event(BT(0, 0, i), add_beat_count, i<3 ? COUNT_BEAT_2 : COUNT_OTTF);
	break;

	case STEP_REACH:
		add_step(STEP_KICKS);

		add_event(BT(1, 0, 0), add_beat, BEAT_MAIN);
		add_event(BT(1, 1, 0), add_beat, BEAT_MAIN);
		add_event(BT(0, 2, 0), add_beat, BEAT_TOP);
		add_event(BT(1, 2, 0), add_beat, BEAT_MAIN);

		add_event(BT(0, 0, 1), add_cheer, 0);
		add_event(BT(0, 0, 2), add_cheer, 1);
		add_event(BT(0, 0, 3), add_cheer, 2);
		break;
	}
}

void start_sequence() {
	for(int i=0; i<4; i++)
		add_event(BT(0, i, 0), add_beat, BEAT_LEFT);
	add_event(BT(0, 0, 1), add_beat_count, COUNT_OTTF);

	add_event(BT(0, 0, 2), add_step, STEP_PRELUDE);
	add_event(BT(0, 0, 6), add_step, STEP_BEAT_CHARGE);
	add_event(BT(0, 0, 10), add_step, STEP_BEAT_CHARGE);
	add_event(BT(0, 0, 10), add_step, STEP_KICKS);
	add_event(BT(0, 0, 14), add_cheer, 0);

	add_event(BT(0, 0, 15), add_step, STEP_FULL_BEATS);
	add_event(BT(0, 0, 19), add_step, STEP_FULL_BEATS);
	add_event(BT(0, 0, 23), add_step, STEP_FULL_BEATS_2);
	add_event(BT(0, 0, 27), add_step, STEP_FULL_BEATS_2);
	add_event(BT(0, 0, 31), add_step, STEP_FULL_BEATS);
	add_event(BT(0, 0, 35), add_step, STEP_FULL_BEATS_2);
	add_event(BT(0, 0, 39), add_step, STEP_FULL_BEATS_2);
	add_event(BT(0, 0, 43), add_step, STEP_FULL_BEATS);
	add_event(BT(0, 0, 47), add_step, STEP_REACH);
	add_event(BT(0, 0, 51), add_step, STEP_REACH);

	add_event(BT(0, 0, 55), add_step, STEP_FULL_BEATS);
	add_event(BT(0, 0, 59), add_cheer, 0);
}

/*
 * beat_gen.h
 *
 *  Created on: 3 Apr 2020
 *      Author: xasin
 */

#ifndef INC_BEAT_GEN_H_
#define INC_BEAT_GEN_H_

#define BPM ((145.35/136.0F) * 141)
#define TPB (60.0F / BPM)

#define QUARTERS TPB
#define EIGHTS  (0.5F * QUARTERS)
#define COUNTS   (4*QUARTERS)

#define BT(eights, quarters, counts) (eights*EIGHTS + quarters*QUARTERS + counts*COUNTS)

enum beat_types {
	BEAT_MAIN,
	BEAT_TOP,
	BEAT_LEFT,
	BEAT_RIGHT,
	BEAT_SOFT,
	BEAT_THUMB,
	BEAT_ONE,
	BEAT_TWO,
	BEAT_THREE,
	BEAT_FOUR,
};

enum count_types {
	COUNT_PRELUDE,
	COUNT_BEAT,
	COUNT_CHARGE,
	COUNT_OFFBEATS,
	COUNT_KICKS,
	COUNT_OTTF,
	COUNT_BEAT_2,
};

enum step_types {
	STEP_PRELUDE,
	STEP_BEAT_CHARGE,
	STEP_KICKS,
	STEP_BEAT_OFFBEATS,
	STEP_FULL_BEATS,
	STEP_FULL_BEATS_2,
	STEP_REACH,
};

struct music_event_t {
	float timestamp;
	void (*on_event)(int);
	int payload;
};

void music_tick();
void insert_pending_beats();

void start_sequence();

#endif /* INC_BEAT_GEN_H_ */

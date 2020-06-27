/*
 * config.h
 *
 *  Created on: 20 Mar 2020
 *      Author: xasin
 */

#ifndef INC_CONFIG_H_
#define INC_CONFIG_H_

struct led_coord_t {
	float x;
	float y;
	// float charge;
};

#define ANIM_USE_CUSTOM_COORDS
#define LED_COORD_COUNT 2
#define ANIM_LED_COUNT (31 + 20)

#endif /* INC_CONFIG_H_ */

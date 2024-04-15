#ifndef TIMER_H
#define TIMER_H

#include <stdint.h>

#define CORE0_TIMER_IRQ_CTRL ((volatile unsigned long *)(0x40000040))

void enable_timer_interrupt();
void disable_timer_interrupt();
void set_expired_time(uint64_t duration);
uint64_t get_current_time();

#endif
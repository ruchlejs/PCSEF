#ifndef _TIMER_H
#define _TIMER_H

#include <inttypes.h>
#include <stdio.h>
#include <cpu.h>
#include <cep_platform.h>

void reveil(void);
void trap_handler(uint64_t mcause, uint64_t mie, uint64_t mip);
void init_traitant_timer(void (*traitant)(void));
void enable_timer(void);
uint32_t nbr_secondes(void);

#endif

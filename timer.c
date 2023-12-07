#include "timer.h"

uint64_t tick = 0;

void reveil(void){
  uint64_t current_time = *((uint64_t*)CLINT_TIMER);
  *((uint64_t*)CLINT_TIMER_CMP) = current_time + (TIMER_FREQ/20);
}

void trap_handler(uint64_t mcause, uint64_t mie, uint64_t mip){
  if((mcause & 0xFF) == 7){
    reveil();
    tick++;
    int sec = (tick/20)%60;
    int min = (tick/(20*60))%60;
    int h = (tick/(20*60*60));
    if( (tick%20) == 0){
      printf("%02d:%02d:%02d\n",h,min,sec);
    }
    ordonnance();
  }
}

void init_traitant_timer(void (*traitant)(void)){
  __asm__("csrw mtvec, %0":: "r"(traitant));
}

void enable_timer(void){
  __asm__("csrs mie, %0":: "r"(1<<7));
  reveil();
}

uint32_t nbr_secondes(void){
  return tick/20;
}

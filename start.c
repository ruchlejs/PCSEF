#include "timer.h"
#include "processus.h"

extern void mon_traitant(void);

void kernel_start(void)
{
    init_traitant_timer(mon_traitant);
    enable_timer();
    //enable_it();
    init_proc();
    cree_processus(proc1,"proc1");
    cree_processus(proc2,"proc2");
    cree_processus(proc3,"proc3");

    idle();
    
    while (1) {
      // cette fonction arrete le processeur
      hlt();
    }
}

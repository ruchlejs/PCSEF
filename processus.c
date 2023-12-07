#include "processus.h"
#include "timer.h"

extern void ctx_sw(uint64_t *ctxt_de_sauvegarde, uint64_t *ctxt_a_restaurer);

int32_t PID = 0;

proc process[NBR_PROC_MAX];
proc* pactif;

void idle()
{
    for (;;) {
      printf("[idle]\n" );
        enable_it();
        hlt();
        disable_it();
    }
}

void proc1(void)
{
  for (int32_t i = 0; i < 2; i++) {
  printf("[temps = %u] processus %s pid = %i\n",
         nbr_secondes(),
         mon_nom(),
         mon_pid());
  dors(2);
}
  printf("proc 1 mort\n");
    fin_processus();
}

void proc2(void)
{
  for (int32_t i = 0; i < 2; i++) {
      printf("[temps = %u] processus %s pid = %i\n",
             nbr_secondes(),
             mon_nom(),
             mon_pid());
      dors(4);
  }
  printf("proc 2 mort\n");
    fin_processus();
}

void proc3(void)
{
  for (int32_t i = 0; i < 2; i++) {
    printf("[temps = %u] processus %s pid = %i\n",
           nbr_secondes(),
           mon_nom(),
           mon_pid());
    dors(5);
  }
  printf("proc 1 mort\n");
  fin_processus();
}

void init_proc(void){
  PID = 0;
  process[PID].pid = PID;
  sprintf(process[PID].nom,"idle");
  process[PID].etat = ELU;
  process[PID].save[0] = (uint64_t)idle;
  process[PID].save[1] = &(process[PID].pile[TAILLE_PILE-1]);
  pactif = &process[0];
  PID++;
}

int32_t cree_processus(void (*code)(void), char *nom){
  //Statique
  if(PID < NBR_PROC_MAX){
    process[PID].pid = PID;
    sprintf(process[PID].nom,"proc%d",PID);
    process[PID].etat = ACTIVABLE;
    process[PID].save[0] = (uint64_t)proc_launcher;
    process[PID].save[4] = (uint64_t)code;
    process[PID].save[1] = &(process[PID].pile[TAILLE_PILE-1]);
    PID++;
  }
  //dynamique
  /*
  for(int = 0; (process[i].etat != MORT) && (i < PID); i++);

  if(process[i].etat == MORT){
    sprintf(process[i].nom,"proc%d",i);
    process[PID].etat = ACTIVABLE;
    process[PID].save[0] = (uint64_t)proc_launcher;
    process[PID].save[4] = (uint64_t)code;
    process[PID].save[1] = &(process[PID].pile[TAILLE_PILE-1]);
  }

  process[PID].pid = PID;
  sprintf(process[PID].nom,"proc%d",PID);
  process[PID].etat = ACTIVABLE;
  process[PID].save[0] = (uint64_t)proc_launcher;
  process[PID].save[4] = (uint64_t)code;
  process[PID].save[1] = &(process[PID].pile[TAILLE_PILE-1]);
  PID++;
  */
}

void ordonnance(void){
 int32_t current_pid = mon_pid();
 do{
   if( (current_pid+1) == PID){
     current_pid = 0;
   }
   else{
     current_pid++;
   }
   if( (process[current_pid].etat == ENDORMI) && (nbr_secondes() >= process[current_pid].sommeil) ){
     process[current_pid].etat = ACTIVABLE;
   }
 }
 while( (process[current_pid].etat == ENDORMI) || (process[current_pid].etat == MORT) );

 if( ((*pactif).etat != ENDORMI) && ((*pactif).etat != MORT) ){
   (*pactif).etat = ACTIVABLE;
 }
 process[current_pid].etat = ELU;
 proc* temp;
 temp = pactif;
 pactif = &process[current_pid];
 ctx_sw(temp->save,pactif->save);
}

int32_t mon_pid(void){
  return pactif->pid;
}

char* mon_nom(void){
  return pactif->nom;
}

void dors(uint32_t nbr_secs){
  if(pactif->pid != 0){
    pactif->etat = ENDORMI;
    pactif->sommeil = nbr_secondes() + nbr_secs;
    ordonnance();
  }
}

void fin_processus(void){
  if(pactif->pid != 0){
    pactif->etat = MORT;
    ordonnance();
  }
}

void proc_launcher(void (*proc)(void)){
  proc();
  fin_processus();
}

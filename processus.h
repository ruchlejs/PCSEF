#ifndef _PROCESSUS_H
#define _PROCESSUS_H

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <cpu.h>
#include <cep_platform.h>

#define TAILLE_PILE 4096
#define NBR_PROC_MAX 4


enum etat {ELU,ACTIVABLE,ENDORMI,MORT};

typedef struct processus{
  int32_t pid;
  char nom[10];
  enum etat etat;
  uint64_t save[17];
  int pile[TAILLE_PILE];
  uint32_t sommeil;
}proc;

void idle(void);
void ordonnance(void);
void proc1(void);
void proc2(void);
void proc3(void);
int32_t mon_pid(void);
char* mon_nom(void);
int32_t cree_processus(void (*code)(void), char *nom);
void dors(uint32_t nbr_secs);
void fin_processus(void);
void proc_launcher(void (*proc)(void));

#endif

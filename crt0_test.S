
.equ STACK_SIZE,   4096

.section .text.init.test,"ax",@progbits
.globl entry_test, todo, power_off
entry_test:
    # set up stack pointer at some zeroed address range 
    la      sp, stacks + STACK_SIZE

    # jump to libfemto_start_main
    jal       test_start
power_off:
    # Power off
    li a0,0x10000000
    li a1,0x3333
    sw a1,0(a0)
	.weak console_putbytes, 
    .weak trap_handler,init_traitant_timer, enable_timer, nbr_secondes, init_timer
    .weak init_proc, cree_processus, ordonnance,mon_pid, mon_nom, 
    .weak dors, fin_processus
    .weak mon_traitant
todo:
console_putbytes:
    nop
    jal __console_putbytes__
    nop
    nop
    nop
    ret
init_traitant_timer:
    nop
    jal __init_traitant_timer__
    nop
    nop
    nop
    ret
trap_handler:
    nop
    jal __trap_handler__
    nop
    nop
    nop
    ret
enable_timer:
    nop
    jal __enable_timer__
    nop
    nop
    nop
    ret
nbr_secondes:
    nop
    jal __nbr_secondes__
    nop
    nop
    nop
    ret
init_timer:
    nop
    jal __init_timer__
    nop
    nop
    nop
    ret
init_proc:
    nop
    jal __init_proc__
    nop
    nop
    nop
    ret
ordonnance:
    nop
    jal ___ordonnance___
    nop
    nop
    nop
    ret
mon_pid:
    nop
    li a0,0x123456
    nop
    nop
    nop
    nop
    ret
mon_nom:
    nop
    jal __mon_mon__
    nop
    nop
    nop
    nop
    ret
dors:
    nop
    jal __dors__
    nop
    nop
    nop
    ret
fin_processus:
    nop
    jal __fin_processus__
    j power_off
    nop
    nop
    nop
    nop
    ret
cree_processus:
    nop
    jal __cree_processus__
    addi a0,zero,-1
    nop
    nop
    nop
    nop
    ret
mon_traitant:
    nop
    jal __mon_traitant__
    nop
    nop
    nop
    mret
.global get_mtvec, get_mie, _reset_mie_
get_mtvec:
    csrr a0,mtvec
    ret
get_mie:
    csrr a0,mie
    ret
_reset_mie_:
    csrrw zero,mie,zero
    ret
.global fake_ordonnance, _fake_ordonnance_c
.global __ordonnance__, _ordonnance_

_ordonnance_:
    lui a0, %hi(_fake_ordonnance_c)
    add a0,a0,%lo(_fake_ordonnance_c)
    ld a0,0(a0)
    jr a0
__ordonnance__:
    nop
    nop
    nop
    nop
    nop

_fake_ordonnance_c:
    .8byte 0

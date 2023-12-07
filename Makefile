# noyau
KERNEL = kernel.bin

# on compile tous les fichiers assembleur et c du repertoire
SRCS = $(wildcard *.S *.c)

# crt0.o doit etre linke en premier
OBJS = $(strip crt0.o test.o serial_io.o $(filter-out crt0.o test.o serial_io.o,$(notdir $(patsubst %.S,%.o,$(patsubst %.c,%.o,$(SRCS))))))
RVDIR ?= /matieres/4MMPCSEA/xinul
AS = $(RVDIR)/bin/riscv64-unknown-elf-gcc
ASFLAGS = -g -c -I.
CC = $(AS)
CFLAGS = -march=rv64ima -mabi=lp64 -mcmodel=medany -Wno-main -Wformat-truncation=0 -pipe -nostdinc -Wall -Wextra -std=c11 -mabi=lp64 -ffunction-sections -fdata-sections -g -D verb=$(VERB)
CFLAGS += -I.
ASFLAGS = $(CFLAGS) -c
LD = $(RVDIR)/bin/riscv64-unknown-elf-gcc
LDFLAGS = -nostdlib -nostartfiles -static -lgcc -Wl,--nmagic -Wl,--gc-sections
OBJCOPY = $(RVDIR)/bin/riscv64-unknown-elf-objcopy
QEMU = $(RVDIR)/bin/qemu-system-riscv64

QEMUBASEOPT = -machine cep -bios none -kernel kernel.bin -m 32M
QEMUOPTSRUN = $(QEMUBASEOPT) -nographic
QEMUOPTS = $(QEMUBASEOPT) -nographic -gdb tcp::1234 -S
QEMUOPTSRUNG = $(QEMUBASEOPT) -serial mon:stdio -display default,show-cursor=on 
QEMUOPTSG = $(QEMUOPTSRUNG) -gdb tcp::1234 -S 

# cible principale, on nettoie systematiquement le repertoire avant
.PHONY: all
all: clean kernel.bin

kernel.bin: kernel.lds $(OBJS)
	$(LD) $(LDFLAGS) -e entry -Tkernel.lds $(OBJS) -o $@

%.o: %.oo
	cp $< $@

%.o: %.S
	$(AS) $(ASFLAGS) -o $@ $<

clean:
	$(RM) $(OBJS) $(KERNEL) task_dump_screen.o test test.bin *.log .gdb_history
	$(RM) -rf badges

debug: $(KERNEL)
	$(QEMU) $(QEMUOPTS)

run: $(KERNEL)
	$(QEMU) $(QEMUOPTSRUN)

debugg: $(KERNEL)
	$(QEMU) $(QEMUOPTSG)

rung: $(KERNEL)
	$(QEMU) $(QEMUOPTSRUNG)

VERB ?= 0

test.bin: test.lds $(OBJS)
	$(LD) $(LDFLAGS) -e entry_test -T test.lds $(OBJS) -o $@

.PHONY: test 

test: test.bin
	$(QEMU) -machine cep -bios none -kernel test.bin -m 32M -nographic > test
test_to: test.bin
	$(QEMU) -machine cep -bios none -kernel test.bin -m 32M -nographic 
badges: test
	mkdir -p badges;cat test | awk 'match($$0,/^.*\[(.*)\] \((.*)\/(.*)\)/,a){gsub(" ","_",a[1]);system("rm -f \"badges/"a[1]".svg\";anybadge -l \""a[1]"\" -v \""((a[2]==a[3])?"ok":"failed")"\" -f \"badges/"a[1]".svg\" -c "((a[2]==a[3])?"green":"red"))}'
testg: test.bin
	$(QEMU) -machine cep -bios none -kernel test.bin -m 32M -serial mon:stdio -display default,show-cursor=on 
testgd: test.bin
	$(QEMU) -machine cep -bios none -kernel test.bin -m 32M -serial mon:stdio -display default,show-cursor=on -gdb tcp::1234 -S
testd: test.bin
	$(QEMU) -machine cep -bios none -kernel test.bin -m 32M -nographic -gdb tcp::1234 -S
testdebug: test.bin
	tmux new-session -s debugsession -d -n debug $(QEMU) -machine cep -bios none -kernel test.bin -m 32M -nographic -gdb tcp::1234 -S
	tmux split-window -t debugsession -t debugsession -v gdb-multiarch test.bin
	tmux attach-session -t debugsession

CC=msp430-gcc
AR=msp430-ar
OPT=-O0
DBG=-g
CFLAGS=-mmcu=msp430fr5969 $(OPT) $(DBG)

all: libperfctr.a

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

libperfctr.a: perfctr.o
	$(AR) r $@ $^
	$(RM) $^

clean:
	$(RM) *.elf *.o *.a

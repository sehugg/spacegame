; Written by rainwarrior, rewritten for  NESASM by me
; http://forums.nesdev.com/viewtopic.php?f=2&t=13172&hilit=rng&start=15#p154158
; http://wiki.nesdev.com/w/index.php/Random_number_generator
;
; Returns a random 8-bit number in A (0-255), clobbers X (0).
;
; Requires a 2-byte value on the zero page called "seed".
; Initialize seed to any value except 0 before the first call to prng.
; (A seed value of 0 will cause prng to always return 0.)
;
; This is a 16-bit Galois linear feedback shift register with polynomial $002D.
; The sequence of numbers it generates will repeat after 65535 calls.
;
; Execution time is an average of 125 cycles (excluding jsr and rts)

seed .rs 2

;notes by me, to get to know the algoritm better
;executes one and two both 8 times.
;If carry set after rol seed+1, eor #$2D, then go to two, otherwise go to two immediately

prng:
	
	ldx #8     ; iteration count (generates 8 bits)
	lda seed+0
	
	one:
		asl A       ; shift the register
		rol seed+1
		bcc two
		eor #$2D   ; apply XOR feedback whenever a 1 bit is shifted out
	two:
		dex
		bne one
		sta seed+0
		cmp #0     ; reload flags
		rts
BUTTON_A		= %10000000
BUTTON_B		= %01000000
BUTTON_SELECT	= %00100000
BUTTON_START	= %00010000
BUTTON_UP		= %00001000
BUTTON_DOWN		= %00000100
BUTTON_LEFT		= %00000010
BUTTON_RIGHT	= %00000001

readInput:
	;As long as the first bit of $4016 is 1, the shift registers of the controllers are reloaded continuously which means that you can only get the state of the A button
	;Writing first 1, then 0 to the CPU_JOYSTICK_1 will set the first bit to 0, so other buttons can be read as well
	;This applies to all controllers
	;http://wiki.nesdev.com/w/index.php/Standard_controller#Input_.28.244016_write.29
	lda #$01
	sta CPU_JOYSTICK_1
	lda #$00
	sta CPU_JOYSTICK_1
	
	ldx #$08 ;8 different buttons
	loopReadInput:
		lda CPU_JOYSTICK_1
		lsr A
		rol buttons
		dex
		bne loopReadInput
    rts
; 		
; handleButtonUp:
; 	lda buttons
; 	and #BUTTON_UP
; 	beq handleButtonRight
; 	
; 	lda playerY
; 	sec
; 	sbc playerSpeed
; 	sta playerY
; 	
; handleButtonRight:
; 	lda buttons
; 	and #BUTTON_RIGHT
; 	beq handleButtonDown
; 	
; 	lda playerX
; 	clc
; 	adc playerSpeed
; 	sta playerX
; 	
; handleButtonDown:
; 	lda buttons
; 	and #BUTTON_DOWN
; 	beq handleButtonLeft
; 	
; 	lda playerY
; 	clc
; 	adc playerSpeed
; 	sta playerY
; 	
; handleButtonLeft:
; 	lda buttons
; 	and #BUTTON_LEFT
; 	beq handleButtonA
; 	
; 	lda playerX
; 	sec
; 	sbc playerSpeed
; 	sta playerX
; 	
; handleButtonA:
; 	lda canShoot
; 	beq handleButtonAShoot
; 	dec canShoot
; 	rts
; 	
; 	handleButtonAShoot:
; 		lda buttons
; 		and #BUTTON_A
; 		beq returnFromHandleInput
; 		
; 		jsr playerShoot
; 		
; 		lda #CAN_SHOOT_COUNTER
; 		sta canShoot
; 		
; returnFromHandleInput:
; 	rts
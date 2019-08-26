playerSpeed .rs 1
playerX .rs 1
playerY .rs 1
canShoot .rs 1
;A bullet will be two digits x and y. For the player 16 bullets will be remembered,
;meaning we need a space of 32 bytes
bulletCount .rs 1
bulletLastIndex .rs 1
bullets .rs 16

health .rs 1
MAX_HEALTH = $05

PLAYER_MIN_X = $0A
PLAYER_MIN_Y = $0A
PLAYER_MAX_X = $E5
PLAYER_MAX_Y = $DB

PLAYER_SPRITE = $0200
PLAYER_BULLET_SPRITES = $0210

CAN_SHOOT_COUNTER = $10
BULLET_SPEED = $6
MAX_PLAYER_BULLETS = $08
MAX_PLAYER_BULLETS_INDEX = $10

resetPlayerVariables:
	lda #$4
	sta playerSpeed
	
	lda #$80
	sta playerX
	sta playerY
    
    lda #MAX_HEALTH
    sta health
	
loadPlayerSprite:
	ldx #$00
	loopLoadPlayerSprite:
		lda playerSprite, x
		sta PLAYER_SPRITE, x
		
		inx
		cpx #$10
		bne loopLoadPlayerSprite
	rts

readInputPlayer:
    jsr readInput
    .handleButtonUp:
    	lda buttons
    	and #BUTTON_UP
    	beq .handleButtonRight
    	
    	lda playerY
    	sec
    	sbc playerSpeed
    	sta playerY
    	
    .handleButtonRight:
    	lda buttons
    	and #BUTTON_RIGHT
    	beq .handleButtonDown
    	
    	lda playerX
    	clc
    	adc playerSpeed
    	sta playerX
    	
    .handleButtonDown:
    	lda buttons
    	and #BUTTON_DOWN
    	beq .handleButtonLeft
    	
    	lda playerY
    	clc
    	adc playerSpeed
    	sta playerY
    	
    .handleButtonLeft:
    	lda buttons
    	and #BUTTON_LEFT
    	beq .handleButtonA
    	
    	lda playerX
    	sec
    	sbc playerSpeed
    	sta playerX
    	
    .handleButtonA:
    	lda canShoot
    	beq .handleButtonAShoot
    	dec canShoot
    	rts
    	
    	.handleButtonAShoot:
    		lda buttons
    		and #BUTTON_A
    		beq .returnFromHandleInput
    		
    		jsr playerShoot
    		
    		lda #CAN_SHOOT_COUNTER
    		sta canShoot
    		
    .returnFromHandleInput:
    	rts

repositionPlayer:

restrictPlayerPositionY:
	lda playerY
	cmp #PLAYER_MIN_Y
	bcc .restrictYLowerBound
	cmp #PLAYER_MAX_Y
	bcs .restrictYHigherBound
	
	jmp restrictPlayerPositionX
	
	.restrictYLowerBound:
		lda #PLAYER_MIN_Y
		sta playerY
		
		jmp restrictPlayerPositionX
	
	.restrictYHigherBound:
		lda #PLAYER_MAX_Y
		sta playerY
		
		jmp restrictPlayerPositionX
		
restrictPlayerPositionX:
	lda playerX
	cmp #PLAYER_MIN_X
	bcc .restrictXLowerBound
	cmp #PLAYER_MAX_X
	bcs .restrictXHigherBound
	
	jmp allignPlayerSprites
	
	.restrictXLowerBound:
		lda #PLAYER_MIN_X
		sta playerX
		
		jmp allignPlayerSprites
	
	.restrictXHigherBound:
		lda #PLAYER_MAX_X
		sta playerX
		
		jmp allignPlayerSprites

allignPlayerSprites:
	clc

	lda playerY
	sta PLAYER_SPRITE
	sta PLAYER_SPRITE+$4
	adc #PPU_OAM_SPRITE_SIZE
	sta PLAYER_SPRITE+$8
	sta PLAYER_SPRITE+$C
	
	lda playerX
	sta PLAYER_SPRITE+$3
	sta PLAYER_SPRITE+$B
	adc #PPU_OAM_SPRITE_SIZE
	sta PLAYER_SPRITE+$7
	sta PLAYER_SPRITE+$F
	
	rts
	
updatePlayerBullets:
	ldx #$00 ;cursor index bullet
	ldy #$00 ;new index of bullet
	
	lda bulletCount
	cmp #$0
	beq .rts
	
	;Making sure the bullets are at the start of the stack, and all the empty spots
	;are at the end
	;from: AX AY 00 00 BX BY 00 00 CX CY
	;to:   AX AY BX BY CX CY 00 00 00 00
	.loopOverBullets:
		lda bullets, x
		
		sec
		sbc #BULLET_SPEED
		bcc .destroyBullet ;If the Y-position of the bullet <= 0

		sta bullets, y
		lda bullets+1, x
		sta bullets+1, y

		iny
		iny

		.continue:
			cpx bulletLastIndex
			inx
			inx
			bcc .loopOverBullets
	
	;Since the bullets are now copied one cell to the front when the previous bullet is destroyed,
	;the old bullet values are still present on the next cell. Here these cells will be cleared
	cpy #$00
	beq .noMoreBullets
	dey
	dey
	sty bulletLastIndex
	iny
	iny
	.clearRedundantCells:
		lda #$0
		sta bullets, y
		sta bullets+$1, y
		
		dex
		cpx bulletLastIndex
		bne .clearRedundantCells

	.rts:
		rts
		
	.destroyBullet:
		dec bulletCount
		jmp .continue
		
	.noMoreBullets:
		lda #$00
		sta bulletLastIndex
		jmp .rts
	
playerShoot:
	
	lda bulletCount
	cmp #MAX_PLAYER_BULLETS
	beq .rts
		
	inc bulletCount
	
	clc
	adc bulletCount
	tax ;Store bulletCount * 2 in X
	dex ;Since counting starts from 0, so prevent the off-by-one-error
	
	stx bulletLastIndex
	
	lda playerY
	sta bullets, x
	lda playerX
	adc #$04 ;Allign bullet center of player
	sta bullets+1, x
	
	.rts:
		rts
		
showBullets:

	;Since only checking the first index is not possible due to underflow, I just check wether or not there should be bullet
	;on the first index, and if so, just remove the first index
	lda bulletCount
	cmp #$00
	beq .removeBulletsFirstIndex

	;Two different counters
	;Counter x is used for the bullets that are stored. It will make jumps of two since it contains 2 values (Y and X)
	;Counter y is used for the bullets on the screen. It will make jumps of four since it contains 4 values
	;Reason we start x with $FE is because we need to check (cpx) before incrementation of x
	ldx #$FE ;$FE + 2 = 00, 0 first index
	ldy #$00
	
	.showBulletsLoop:
		inx
		inx

		lda bullets, x
		sta PLAYER_BULLET_SPRITES, y
		
		lda #$02
		sta PLAYER_BULLET_SPRITES+$1, y
		
		lda #%00100001
		sta PLAYER_BULLET_SPRITES+$2, y
		
		lda bullets+$1, x
		sta PLAYER_BULLET_SPRITES+$3, y
		
		iny
		iny
		iny
		iny
		
		cpx bulletLastIndex
		bne .showBulletsLoop
		
	.removeUnexistingBullets:
		cpy #MAX_PLAYER_BULLETS_INDEX
		beq .rts
		
		lda PLAYER_BULLET_SPRITES, y
		cmp #$FE
		beq .rts
		
		lda #$FE
		sta PLAYER_BULLET_SPRITES, y
		
		iny
		jmp .removeUnexistingBullets
	
	.removeBulletsFirstIndex:
		ldx #$FE
		stx PLAYER_BULLET_SPRITES
		stx PLAYER_BULLET_SPRITES+$1
		stx PLAYER_BULLET_SPRITES+$2
		stx PLAYER_BULLET_SPRITES+$3
		inx
		inx
		stx bullets
		stx bullets+$1
		
	.rts:	
		rts
        
updateHealthHUD:
    lda PPU_STATUS_REGISTER

    lda #$20
    sta PPU_ADDRESS_REGISTER
    lda #$53
    sta PPU_ADDRESS_REGISTER

    ldx #$00
	cpx health
	beq .dead
	
    ldy #$00
    clc
	.loop:
        lda #$18
        sta PPU_DATA
        
        inx
        cpx health
        bne .loop
    .loop2:
        cpx #MAX_HEALTH
        beq .rts
        
        lda #$00
        sta PPU_DATA
        
        inx
        jmp .loop2
		
	.dead:
		;display "DEAD"
		lda #$44
		sta PPU_DATA
		lda #$45
		sta PPU_DATA
		lda #$41
		sta PPU_DATA
		lda #$44
		sta PPU_DATA
		lda #$00
		sta PPU_DATA
        
    .rts:
        rts
		
isPlayerAlive:
	lda health
	cmp #$00
	beq .no
	
	lda #$01
	rts
	
	.no:
		lda #$00
		rts
	

playerSprite:
	.db $00, $00, %00100000, $00
	.db $00, $00, %01100000, $00
	.db $00, $10, %00100000, $00
	.db $00, $10, %01100000, $00
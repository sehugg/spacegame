gameStartButtonShownCounter .rs 1
GAME_START_BUTTON_MAX = $30
gameStartButtonShown .rs 1
GAME_START_BUTTON_SHOWN = $00
GAME_START_BUTTON_HIDDEN = $01
gameOverCounter .rs 1
GAME_OVER_COUNTER_MAX = $50
seedRoller .rs 1
toggleButtonRoller .rs 1
TOGGLE_BUTTON_ROLLER_MAX = $20

menuInit:
    lda #GAME_START_BUTTON_MAX
    sta gameStartButtonShownCounter
    lda #$01
    sta seedRoller
    rts
    
updateSeedRoller:
    inc seedRoller
    rts

gameStartButtonShowHide:
    ldx gameStartButtonShownCounter
    dex
    cpx #$00
    beq .toggleStartButton
    rts
    
    .toggleStartButton:
        lda gameStartButtonShown
        cmp #GAME_START_BUTTON_SHOWN
        beq .hideStartButton
        
        lda #GAME_START_BUTTON_SHOWN
        sta gameStartButtonShown
        
    .hideStartButton:
        lda #GAME_START_BUTTON_HIDDEN
        sta gameStartButtonShown

readInputMenu:
    jsr readInput
    
    lda buttons
    and #BUTTON_A
    bne startGame
    
    rts
    
startGame:
	jsr resetScore
    jsr loadBackgroundGame
    jsr resetPlayerVariables
	
	lda #$FE
	sta $0240
    
    .setSeed:
        ldx seedRoller
        cpx #$00
        beq .seedCannotBeZero
        stx seed
        stx seed+1
        
    .initialiseEnemies:
        jsr initialiseEnemySprite
        jsr initialiseEnemyCounter

    .changeGameState:
        lda #GAME_STATE_GAME
        sta gamestate
        lda #$00
        sta nameTableLoader
        
	rts
    
    .seedCannotBeZero:
        inx ;So we change it to one
        stx seed
        stx seed+1
        jmp .initialiseEnemies

countDownGameOver:
	jsr updateSeedRoller
	
	ldx toggleButtonRoller
	cpx #$00
	beq .toggleButton
	dex
	stx toggleButtonRoller
	
	.checkGameOverCounter:
		ldx gameOverCounter
		cpx #$00
		beq .waitForInput
		dex
		stx gameOverCounter

    rts
	
	.toggleButton:
		lda #TOGGLE_BUTTON_ROLLER_MAX
		sta toggleButtonRoller
		
		lda $0240
		cmp #$FE
		beq .showButton
		lda #$FE
		sta $0240
		sta $0243
		jmp .checkGameOverCounter
		
	.showButton:
		lda #$95
		sta $0240
		lda #$55
		sta $0243
		jmp .checkGameOverCounter
	
	.waitForInput:
		jsr readInput
		lda buttons
		and #BUTTON_A
		bne .restart
		rts
		
	.restart:
		jsr startGame
		rts
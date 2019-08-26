spawnEnemyCounter .rs 1
enemy .rs 3 ;max 10 enemies. Attributes: y x speed
enemyCollisionBulletCondition .rs 1
SPAWN_ENEMY_COUNTER = $60
ENEMY_SPRITE = $230

initialiseEnemySprite:
	ldx #$0
	.loop:
		lda enemySprite, x
		sta ENEMY_SPRITE, x
		
		inx
		cpx #$10
		bne .loop
	rts

initialiseEnemyCounter:
	lda #SPAWN_ENEMY_COUNTER
	sta spawnEnemyCounter
	rts
	
spawnEnemyEveryXFrames:
	ldx spawnEnemyCounter
	cpx #$00
	beq spawnEnemy
	dex
	stx spawnEnemyCounter
	rts

spawnEnemy:
	jsr initialiseEnemyCounter
	
	lda #$1
	sta enemy+0
	jsr prng
	cmp #PLAYER_MIN_X
	bcc .restrictEnemyMinX
	cmp #PLAYER_MAX_X
	bcs .restrictEnemyMaxX
	sta enemy+1
	
	jmp .finishSpawn
	
	.restrictEnemyMinX:
		lda #PLAYER_MIN_X
		sta enemy+1
		jmp .finishSpawn
		
	.restrictEnemyMaxX:
		lda #PLAYER_MAX_X
		sta enemy+1
		jmp .finishSpawn
		
	.finishSpawn:
		lda #$3
		sta enemy+2
		rts
	
updateEnemy:
	lda enemy
	cmp #$00
	beq .noEnemy
	clc
	adc enemy+2
	bcs .despawnEnemy
	sta enemy
    
    jsr checkEnemyBulletCollision
    cmp #$01
    beq .defeatEnemy
    
    jmp showEnemy
    
    .noEnemy:
	   jmp hideEnemy
       rts
	
    .defeatEnemy:
        jsr updateScore
        jmp .destroyEnemy
    
    .despawnEnemy:
        ldx health
        dex
        stx health
        jmp .destroyEnemy
    
	.destroyEnemy:
		lda #$00
		sta enemy
		sta enemy+1
        jsr hideEnemy
		rts
	
showEnemy:
	lda enemy
	cmp #$00
	beq hideEnemy
	
	sta ENEMY_SPRITE
	sta ENEMY_SPRITE+4
	clc
	adc #PPU_OAM_SPRITE_SIZE
	sta ENEMY_SPRITE+8
	sta ENEMY_SPRITE+12
	
	lda enemy+1
	sta ENEMY_SPRITE+3
	sta ENEMY_SPRITE+11
	adc #PPU_OAM_SPRITE_SIZE
	sta ENEMY_SPRITE+7
	sta ENEMY_SPRITE+15
	
	rts
	
	
hideEnemy:
    ldx #$FE
    stx ENEMY_SPRITE
    stx ENEMY_SPRITE+3
    stx ENEMY_SPRITE+4
    stx ENEMY_SPRITE+7
    stx ENEMY_SPRITE+8
    stx ENEMY_SPRITE+11
    stx ENEMY_SPRITE+12
    stx ENEMY_SPRITE+15
	rts
        
checkEnemyBulletCollision:
    ldx #$0
    .loop:        
        ;If no more bullets, there was no collision
        ldy bullets, x
        cpy #$00
        beq .noCollision
        
        ;; ??????????????
        ;Why does -10+18 work, but +8 nog...???
        ;from: http://atariage.com/forums/topic/71120-6502-killer-hacks/page-3#entry1054049
        tya
        sbc enemy
        sbc #$10
        adc #$18
        ;adc #PPU_OAM_SPRITE_SIZE
    	bcc .checkForNextBullet
		
        lda bullets+1, x
        sbc enemy+1
        sbc #$10
        adc #$18
        ;adc #PPU_OAM_SPRITE_SIZE
    	bcc .checkForNextBullet
	
    .collision:
        lda #$01
        rts
    
    .noCollision:
        lda #$00
        rts
		
	.checkForNextBullet:
		inx
		inx
		cpx #$10
		bne .loop
		jmp .noCollision

enemySprite:
	.db $FE, $20, %00100010, $FE
	.db $FE, $21, %00100010, $FE
	.db $FE, $30, %00100010, $FE
	.db $FE, $31, %00100010, $FE
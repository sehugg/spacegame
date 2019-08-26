resetScore:
	ldx #$00
	lda #$00
	.forEachDigit:
		sta score, x
		inx
		cpx #SCORE_DIGITS
		bne .forEachDigit
	rts

updateScore:
	ldx #SCORE_DIGITS
	dex ;counting starts at 0, so we need to decrease by one
	inc score, x
	
	sec ;.handleScoreDigits will never underflow, so carry will stay set
	.handleScoreDigits:
		cpx #$FF
		beq .rts
		
		lda score, x
		cmp #$0A
		bcc .rts
		
		sbc #$0A
		sta score, x
		dex
		inc score, x
		
		jmp .handleScoreDigits
		
	.rts:
		RTS
		
updateScoreHUD:
	lda PPU_STATUS_REGISTER
	
	lda #$20
	sta PPU_ADDRESS_REGISTER
	lda #$49
	sta PPU_ADDRESS_REGISTER
	
	ldx #$00
	clc
	.loopUpdateScoreHUD:
		lda score, x
		adc #$30
		sta PPU_DATA
		
		inx
		cpx #SCORE_DIGITS
		bne .loopUpdateScoreHUD
		
	rts
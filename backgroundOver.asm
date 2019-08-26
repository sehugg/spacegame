loadBackgroundOver:
	
	lda PPU_STATUS_REGISTER
	
	lda #$20
	sta PPU_ADDRESS_REGISTER
	lda #$00
	sta PPU_ADDRESS_REGISTER
	
    ldx nameTableLoader
	
    cpx #$00
    beq .loadBackgroundGameFirstQ
	
    cpx #$01
    beq .loadBackgroundGameSecondQ
     
    cpx #$02
    beq .loadBackgroundGameThirdQ
    
    cpx #$03
    beq .loadBackgroundGameForthQ
    
    ;jmp .loadBackgroundGameRest
    
.loadBackgroundGameFirstQ:
        lda #$20
        sta PPU_ADDRESS_REGISTER
        lda #$00
        sta PPU_ADDRESS_REGISTER
		
		ldy #$00
		.loop:
		    lda backgroundOverPart1, y
            sta PPU_DATA
            
            iny
            cpy #$00
		    bne .loop
            
        inc nameTableLoader
		rts
    
.loadBackgroundGameSecondQ:
        lda #$21
        sta PPU_ADDRESS_REGISTER
        lda #$00
        sta PPU_ADDRESS_REGISTER
		
		.loop1:
			cpy #$B3
			beq .drawScore
			
		    lda backgroundOverPart2, y
            sta PPU_DATA
            
            iny
            cpy #$00
		    bne .loop1
            
        inc nameTableLoader
		rts
			
		.drawScore:
			ldx #$00
			clc
			.drawDigits:
				lda score, x
				adc #$30
				sta PPU_DATA
				inx
				iny
				cpx #SCORE_DIGITS
				bne .drawDigits
			jmp .loop1
        
.loadBackgroundGameThirdQ:
        lda #$22
        sta PPU_ADDRESS_REGISTER
        lda #$00
        sta PPU_ADDRESS_REGISTER
		
		ldy #$00
		.loop2:
		    lda backgroundOverPart3, y
            sta PPU_DATA
            
            iny
            cpy #$00
		    bne .loop2
            
        inc nameTableLoader
		rts
            
.loadBackgroundGameForthQ:
        lda #$23
        sta PPU_ADDRESS_REGISTER
        lda #$00
        sta PPU_ADDRESS_REGISTER
		
		.loop3:
		    lda backgroundOverPart4, y
            sta PPU_DATA
            
            iny
            cpy #$C0
		    bne .loop3
            
        inc nameTableLoader
		
		;no rts here, as now we execute the .done
	
    .done:
	
		;lda #$95
		;sta $0240
		lda #$01
		sta $0241
		lda #%00000011
		sta $0242
		;lda #$55
		;sta $0243
	
        lda PPU_STATUS_REGISTER
        
        lda #$23
        sta PPU_ADDRESS_REGISTER
        lda #$C0
        sta PPU_ADDRESS_REGISTER
    	ldx #$00
    	.loopLoadAttributes:
    		lda attributesOver, x
    		sta PPU_DATA
    		
    		inx
    		cpx #$40
    		bne .loopLoadAttributes
	.rts:	
		rts

backgroundOverPart1:
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
backgroundOverPart2:
	.db 0,0,0,16,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,18,0,0,0
	.db 0,0,0,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0
	.db 0,0,0,19,0,71,65,77,69,0,79,86,69,82,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0
	.db 0,0,0,19,0,17,17,17,17,17,17,17,17,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0
	.db 0,0,0,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0
	.db 0,0,0,19,0,89,79,85,0,68,69,83,84,82,79,89,69,68,0,79,79,79,79,79,79,79,79,0,20,0,0,0
	.db 0,0,0,19,0,83,80,65,67,69,83,72,73,80,83,33,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0
	.db 0,0,0,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0
backgroundOverPart3:
	.db 0,0,0,21,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,23,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,130,131,132,133,134,0,80,114,101,115,115,0,65,0,116,111,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,146,147,148,149,150,0,99,111,110,116,105,110,117,101,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
backgroundOverPart4:
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	
attributesOver:
	;Attribute table works on a grid of 16x16 pixels, where every byte is 32x32 pixels
	;Image 4 16x16 blocks like so:
	; +---+---+
	; | 4 | 3 |
	; +---+---+
	; | 2 | 1 |
	; +---+---+
	;The byte will be formated as follows: %{1}{2}{3}{4}
	;That the blocks have dimension of 16x16 means that 4 backgroundtiles have to
	;use the same colorpalette
	
	.db 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, %10100000, %00100000, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0
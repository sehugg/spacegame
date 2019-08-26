
loadBackgroundGame:
    lda PPU_STATUS_REGISTER
    
    ldx nameTableLoader
    cpx #$00
    beq .loadBackgroundGameFirstQ
    
    ldy #$00
    cpx #$01
    beq .loadBackgroundGameSecondQ
     
    cpx #$02
    beq .loadBackgroundGameThirdQ
    
    cpx #$03
    beq .loadBackgroundGameForthQ
    
    cpx #NAME_TABLE_LOADING_PARTS
    beq .done
    
    jmp .loadBackgroundGameRest

.loadBackgroundGameFirstQ:
        lda #$20
        sta PPU_ADDRESS_REGISTER
        lda #$00
        sta PPU_ADDRESS_REGISTER
        
    	ldx #$00
    	.loopLoadBackgroundHUD:
    		lda backgroundGame, x
    		sta PPU_DATA
    		inx
    		cpx #$80
    		bne .loopLoadBackgroundHUD
        
        lda #$00
		.loadRestOfQuarterNameTable:
            sta PPU_DATA
            inx
            cpx #$F0
            bne .loadRestOfQuarterNameTable
        
        inc nameTableLoader
        rts
    
.loadBackgroundGameSecondQ:
        lda #$20
        sta PPU_ADDRESS_REGISTER
        lda #$F0
        sta PPU_ADDRESS_REGISTER
        jmp .loadBackgroundGameRest
        
.loadBackgroundGameThirdQ:
        lda #$21
        sta PPU_ADDRESS_REGISTER
        lda #$E0
        sta PPU_ADDRESS_REGISTER
        jmp .loadBackgroundGameRest
            
.loadBackgroundGameForthQ:
        lda #$22
        sta PPU_ADDRESS_REGISTER
        lda #$D0
        sta PPU_ADDRESS_REGISTER
        jmp .loadBackgroundGameRest

.loadBackgroundGameRest:
        
        .loop:
		    lda #$00
            sta PPU_DATA
            
            iny
            cpy #$F0
		    bne .loop
            
        inc nameTableLoader

    .done:
        ldx nameTableLoader
        cpx #NAME_TABLE_LOADING_PARTS
        beq .rts
        
        lda PPU_STATUS_REGISTER
        
        lda #$23
        sta PPU_ADDRESS_REGISTER
        lda #$C0
        sta PPU_ADDRESS_REGISTER
    	ldx #$00
    	.loopLoadAttributes:
    		lda attributes, x
    		sta PPU_DATA
    		
    		inx
    		cpx #$10
    		bne .loopLoadAttributes
    .rts:	
	   rts

backgroundGame:

	;Top row that is not shown on NTCS.
	;Because people using NTCS will not see the top row, lets just keep it empty
	.db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	;Border top
	.db $00, $10, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $12, $00

	; | score: xxxx
	.db $00, $13
	.db "SCORE:"
	.db $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $18, $18, $18, $18, $18, $00, $19, $19, $19, $19, $19, $14, $00

	;Border bottom

	.db $00, $15, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $17, $00
	
attributes:
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
	
	;Rows 1 and 2 (HUD):
	.db 0, 0, 0, 0, 0, 0, 0, 0
	
	;Rows 3 and 4:
	.db 0, 0, 0, 0, 0, 0, 0, 0
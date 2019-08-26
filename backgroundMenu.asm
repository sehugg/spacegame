loadBackgroundMenu:
    lda PPU_STATUS_REGISTER

    lda #$20
    sta PPU_ADDRESS_REGISTER
    lda #$00
    sta PPU_ADDRESS_REGISTER

    ldx #$00
    .loopLoadBackgroundTop:
        lda #$00
        sta PPU_DATA
        inx
        cpx #$A0
        bne .loopLoadBackgroundTop
    
    ldy #$00
    .loopLoadBackgroundLogo:
        lda backgroundLogo, y
        sta PPU_DATA
        
        iny
        inx
        cpx #$E0
        bne .loopLoadBackgroundLogo
        
    .loopLoadBackgroundBottom:
        lda #$00
        sta PPU_DATA
        inx
        cpx #$FF
        bne .loopLoadBackgroundBottom
        
    lda PPU_STATUS_REGISTER

    lda #$23
    sta PPU_ADDRESS_REGISTER
    lda #$C0
    sta PPU_ADDRESS_REGISTER

    ldx #$00
    .loopLoadAttributes:
        lda attributesMenu, x
        sta PPU_DATA
        
        inx
        cpx #$10
        bne .loopLoadAttributes
        
    rts

backgroundLogo:
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .db $80, $81, $00
        .db "MADE BY"
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .db $90, $91, $00
        .db "PIJOKRA"
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    
attributesMenu:
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

    ;Rows 1 and 2:
    .db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

    ;Rows 3 and 4:
    .db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
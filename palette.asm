;The first color of the nth background palette is also the first color of the
;nth sprite palette; they mirror each other

;The first color of the first background palette or sprite palette is the 
;color used as the background color

;In the palette the following colors cannot be used:
;	$0D: this extreme dark color causes the signal to go far lower the 
;		normal black level, so some televisions mistake it for a blanking signal
;		(http://wiki.nesdev.com/w/index.php/Color_$0D_games)
;		According to most sources this color should be black, but some say dark purple
;		(http://forums.nesdev.com/viewtopic.php?f=2&t=13252&start=60#p161169)
;	Either $1D or $0F should not be used as they are both the same color
;		(http://wiki.nesdev.com/w/index.php/PPU_palettes#Memory_Map)
;	$2D and $3D: they are not supported on the 2CO3 and 2CO5 palettes
;		Instead colors $00 and $10 can be used as they are almost the same anyway
;		(http://wiki.nesdev.com/w/index.php/PPU_palettes#2C03_and_2C05)

palette:
	;Background colors
	.db $1F, $30, $16, $00 ;Black, White, Red, Gray
	.db $1F, $11, $21, $30 ;Black, Blue, Light blue, White
	.db $1F, $20, $10, $16 ;Black, White, Pink, Black
	.db $1F, $1A, $2A, $30 ;Black, Dark green, Green, White

	;Sprite colors
	;First color is always used for transparancy and 
	;needs to be the same color (last one I am not 100% sure of tho...)
	.db $1F, $0F, $16, $30 ;Black, Red, White
	.db $1F, $11, $21, $30 ;Blue, Light blue, White
	.db $1F, $30, $24, $1F ;Dark green, Light green, White
	.db $1F, $20, $10, $16 
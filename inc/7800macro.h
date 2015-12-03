
.macro align

 ift :0>0

  ift (*/:1)*:1<>*
   .def ?tmp = [(*/:1)*:1+:1]-*
   :?tmp brk
  eif

 els

  ert 'Unexpected end of line'

 eif
.endm

*********************************************************
*	MARIA MACROS FOR EASIER GRAPHICS CONSTRUCTION	*
*********************************************************
*
*
*this macro constructs a 4 byte header for display lists
*
	.macro	header 		;	address palette width hpos
	.byte [:1 & $FF] 				;	.byte	\address & $ff
	.byte [(:2*$20) | ($1f & !:3)]	;	.byte	(\palette*$20) | ($1f & -\width)
	.byte [:1 >> 8]				;	.byte	\address >> 8
	.byte :4				;	.byte	\hpos
	.endm
;
;this macro constructs a 5 byte header for display lists
;
	.macro	xheader				;	address,palette,width,hpos,wm,ind

	.byte [:1 & $FF]						;	.byte	\address & $ff
	.byte [(:5*$80) | $40 | (:6*$20)]		;	.byte	((\wm*$80) | $40 | (\ind*$20))
	.byte [:1 >> 8]						;	.byte	\address >> 8
	.byte [[:2*$20] | [$1F & !:3]]		;	.byte	((\palette*$20) | ($1F & -\width))
	.byte :4						;	.byte	\hpos
	.endm

;
;this macro constructs a end-of-display-list header
;
	.macro	nullhdr

	.byte	0,0
	.endm

;
;this macro constructs a display list entry for the display list list
;
	.macro	display					;	dli,h16,h8,offset,address

	.byte [(:1*$80) | (:2*$40) | (:3*$20) | :4]	;	.byte	((\dli*$80) | (\h16*$40) | (\h8*$20) | \offset)
	.byte [:5 >> 8]							;	.byte	\address >> 8
	.byte [:5 & $FF]							;	.byte	\address & $ff
	.endm

;
;this macro loads a palette register with a color
;
	.macro	paint						;	palnum,colornum,color,lum

	lda #[(:3*$10) | :4]					;	lda	#(\color*$10) | \lum
	sta [BKGRND | ((:1*4) | :2)]				;	sta	\bkgrnd | ((\palnum*4) | (\colornum))
	.endm

;
;this macro writes to the crtl register
;
ckoff	=	$0	;normal color
ckon	=	$1	;kill the color

dmaoff	=	$3	;turn off dma
dmaon	=	$2	;normal dma

char1b	=	$0	;one byte character definition
char2b	=	$1	;two byte character definition

bcoff	=	$0	;black border
bcback	=	$1	;background colored border

kangoff	=	$0	;transparency
kangon	=	$1	;"kangaroo" mode : no transparency!

mode1	=	$0	;160x2 or 160x4 modes
modebd	=	$2	;320b or 320d modes
modeac	=	$3	;320a or 320c modes

	.macro	screen	;	ck,dma,cw,bc,km,mode
	lda #[(:1*$80) | (:2*$20) | (:3*$10) | (:4*8) | (:5*4) | :6]	;	lda	#((\ck*$80) | (\dma*$20) | (\cw*$10) | (\bc*8) | (\km*4)|\mode)
	sta CTRL										;	sta	CTRL
	.endm

	.macro	dppload	;	adr
	lda #[:1 & $ff]			;	lda	#\adr & $ff
	sta DPPL			;	sta	DPPL
	sta SDPPL			;	sta	sdppl
	lda #[:1>>8]			;	lda	#\adr >> 8
	sta DPPH			;	sta	DPPH
	sta SDPPH			;	sta	sdpph
	.endm

;********************************************************
;	end of the system macros definitions		*
;********************************************************


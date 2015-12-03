; Atari 7800 Development Cartridge BIOS
; Written by Sebastian Kotek (tdididit@gmail.com)
;
; Assemble with MADS 1.9.3
;
;******* a78 ROM file header ****************************
.array tab [127] .byte = $00
[0] = 1					            ; wersja nag³ówka
[1] = 'ATARI7800'			      ; 
[17] = 'TINYMON 7800'			    ; Tytu³
[49] = $00,$00,$40,$00		  ; rozmiar (4 bajty)
[53] = %00000000, %00000000	; typ cartridge'a
						                ; bit 0 - pokey
						                ; bit 1 - supercart bankswitched
						                ; bit 2 - supercart ram
[55] = 1					          ; kontroler port 1
[56] = 0					          ; kontroler port 2
						                ; 0 = brak
						                ; 1 = joystick
						                ; 2 = pistolet
;[57] = 1					          ; PAL ???
[100] = 'ACTUAL CART DATA STARTS HERE'
.enda
;******* End of a78 ROM file header **********************

		    icl 'inc/maria.h'
		    icl 'inc/7800macro.h'
	
		    opt f+h-
	
		    org $40	 ; strona zerowa
ZEROP   equ *
NMIVECT       .ds 2
JMPVECT       .ds 2
BANK_SHADOW   .ds 1

VBL_COUNTER   .ds 1

MENU_POS      .ds 1
MENU_TEMP     .ds 2

CURSOR_X      .ds 1
CURSOR_Y      .ds 1

JOY1_TEMP      .ds 1   ; AB--RLDU
JOY1_LAST      .ds 1
JOY1_TIMER     .ds 1   ; debounce timer

SCREEN_PTR    .ds 2
MEM_PTR       .ds 2
TEMP_PTR      .ds 2

        org $80
STACK         .ds 80
        org $1800 ; RAM1    $840 bajtów
 
        org $2000
SCR_ROW1  .ds 32
SCR_ROW19  .ds 32        
        org $2100 ; RAM2    $40 bajtów
SCR_ROW18  .ds 32
SCR_ROW20  .ds 32        
        org $2200 ; RAM3    $200 bajtów
SCR_ROW2  .ds 32
SCR_ROW3  .ds 32 
SCR_ROW4  .ds 32 
SCR_ROW5  .ds 32 
SCR_ROW6  .ds 32
SCR_ROW7 .ds 32
SCR_ROW8 .ds 32
SCR_ROW9 .ds 32
SCR_ROW10 .ds 32
SCR_ROW11 .ds 32 
SCR_ROW12 .ds 32 
SCR_ROW13 .ds 32 
SCR_ROW14 .ds 32 
SCR_ROW15 .ds 32 
SCR_ROW16 .ds 32 
SCR_ROW17 .ds 32 
        
        org $2400
RAM_DLS equ *

; --- $27FF end of RAM
        org $4000 ; CART RAM
POKEY1  .ds 16    ; FIRST 16bytes reserved for pokey chip
POKEY2  .ds 16
SID1    .ds 32
SID2    .ds 32

        org $C000 ; CART RAM or ROM
ROMTOP	EQU	*
; grafika font 8x8   x256 tryb:320x1
        icl 'inc\font-320x1.h'

        
        org $C800
        icl 'inc\dlists.h'
        align 256

RAM_CODE equ *

.LOCAL,$2500
TINY_MON:

TM_MAIN_LOOP:
      jsr WAIT_VBL
      jsr UPDATE_SCREEN
      jsr UPDATE_JOY1
        ; control proc
        lda JOY1_TIMER
        and #$07
        bne mm_joydone
        txa                   ; up
        eor #$0f
        tax
        and #$1
        beq mm_joydown
        lda CURSOR_Y
        beq mm_joyup1
        dec CURSOR_Y
        jmp mm_joydown
mm_joyup1:        
        lda MEM_PTR
        clc
        adc #$80
        beq mm_joyup2
        clc
        dec MEM_PTR+1
mm_joyup2:
        sta MEM_PTR
        
mm_joydown:
        txa                    ; down
        and #$2
        beq mm_joyleft
        lda CURSOR_Y
        cmp #15
        beq mm_joydown1
        inc CURSOR_Y
        jmp mm_joyleft 
mm_joydown1:
        lda MEM_PTR
        clc
        adc #$80
        bne mm_joydown2
        clc
        inc MEM_PTR+1        
mm_joydown2:
        sta MEM_PTR
        
mm_joyleft:
        txa                    ; left
        and #$4
        beq mm_joyright 
        lda CURSOR_X
        beq mm_joyright
        dec CURSOR_X
        
mm_joyright:
        txa
        and #$8
        beq mm_joyfireB          ; right        
        
        lda CURSOR_X
        cmp #7
        beq mm_joyfireB
        inc CURSOR_X
mm_joyfireB:        
        txa
        and #$40
        beq mm_joyfireA
        
        jsr SET_VALUE
        jmp mm_joydone
mm_joyfireA:
        txa
        and #$80
        beq mm_joydone
        
        jsr SET_BANK
        
mm_joydone:
        

      jmp TM_MAIN_LOOP

;-------------------------------------------------------------------------------
SET_VALUE:
        lda MEM_PTR+1
        sta TEMP_PTR+1
        lda CURSOR_Y

        asl
        asl
        asl
        
        clc
        adc CURSOR_X
        adc MEM_PTR
        sta TEMP_PTR

        ldy #$00
        lda (TEMP_PTR),y
        jsr EDIT_BYTE
        ldy #0
        sta (TEMP_PTR),y
        rts
;-------------------------------------------------------------------------------
SET_BANK:
        lda BANK_SHADOW
        jsr EDIT_BYTE
        sta BANK_SHADOW
        sta $BFFF
        rts
;-------------------------------------------------------------------------------
EDIT_BYTE:
        sta MENU_TEMP
        pha
        lda #0
        sta MENU_POS
        
EDIT_BYTE_MAIN_LOOP:
        jsr WAIT_VBL
        
        lda >SCR_ROW19
        sta SCREEN_PTR+1
        lda <SCR_ROW19 + 15
        sta SCREEN_PTR
        lda MENU_TEMP
        jsr PUT_HEX
        
        lda >SCR_ROW18
        sta SCREEN_PTR+1
        lda <SCR_ROW18 + 15
        sta SCREEN_PTR
        
        lda MENU_POS
        beq ebml_1
        lda #0
        jsr PUT_CHAR
ebml_1: lda #$5d
        jsr PUT_CHAR
        lda #$00
        jsr PUT_CHAR
        
      jsr UPDATE_JOY1
        ; control proc
        lda JOY1_TIMER
        and #$07
        beq eb_joyup
        jmp eb_joydone
eb_joyup:
        txa                   ; up
        eor #$0f
        tax
        and #$1
        beq eb_joydown
        
        lda MENU_POS
        bne eb_joyup1
        lda MENU_TEMP
        clc
        adc #$10
        sta MENU_TEMP
        jmp eb_joydown
eb_joyup1:
        lda MENU_TEMP
        pha
        clc
        adc #1
        and #$0f
        sta MENU_TEMP
        pla
        and #$f0
        clc
        adc MENU_TEMP
        sta MENU_TEMP
         
eb_joydown:
        txa                    ; down
        and #$2
        beq eb_joyleft
        
        lda MENU_POS
        bne eb_joydown1
        lda MENU_TEMP
        sec
        sbc #$10
        sta MENU_TEMP
        jmp eb_joyleft
eb_joydown1:
        lda MENU_TEMP
        pha
        sec
        sbc #1
        and #$0f
        sta MENU_TEMP
        pla
        and #$f0
        clc
        adc MENU_TEMP
        sta MENU_TEMP
        
eb_joyleft:
        txa                    ; left
        and #$4
        beq eb_joyright 
        lda MENU_POS
        beq eb_joyright
        dec MENU_POS
        
eb_joyright:
        txa
        and #$8
        beq eb_joyfireB          ; right        
        
        lda MENU_POS
        bne eb_joyfireB
        inc MENU_POS
eb_joyfireB:        
        txa
        and #$40
        beq eb_joyfireA
;        inc JOY1_TIMER
        ldy #0
        tya
eb_joyB1:
        sta SCR_ROW18,y
        sta SCR_ROW19,y
        iny
        cpy #$20
        bne eb_joyB1
        pla
        lda MENU_TEMP
        rts

eb_joyfireA:
        txa
        and #$80
        beq eb_joydone
;        inc JOY1_TIMER
        
        ldy #0
        tya
eb_joyA1:
        sta SCR_ROW18,y
        sta SCR_ROW19,y
        iny
        cpy #$20
        bne eb_joyA1
        pla
;        lda MENU_TEMP
        rts
        
eb_joydone:
        

      jmp EDIT_BYTE_MAIN_LOOP
        
        rts
;-------------------------------------------------------------------------------
UPDATE_SCREEN:

        lda >SCR_ROW1
        sta SCREEN_PTR+1
        lda <SCR_ROW1 + 30
        sta SCREEN_PTR
        lda BANK_SHADOW
        jsr PUT_HEX
        
        lda MEM_PTR
        sta TEMP_PTR
        lda MEM_PTR+1
        sta TEMP_PTR+1
        
        lda #$01
        sta SCREEN_PTR
        lda #$22
        sta SCREEN_PTR+1
        
        ldx #0
us_loop1:
        txa
        pha
        lda #$04
        jsr PUT_CHAR
                
        lda TEMP_PTR+1
        jsr PUT_HEX
        lda TEMP_PTR
        jsr PUT_HEX

        inc SCREEN_PTR

        pla
        tax
        ldy #0
us_loop2:
        txa
        pha
        cpx CURSOR_Y
        bne us_loop3
        cpy CURSOR_X
        bne us_loop3
        lda (TEMP_PTR),y
        jsr PUT_HEX_INV
        jmp us_loop4
us_loop3:
        lda (TEMP_PTR),y
        jsr PUT_HEX  
us_loop4:
        pla
        tax
        iny
        cpy #8
        bne us_loop2
        clc
        inc SCREEN_PTR
        
        ldy #0
us_loop5:
        txa
        pha
        lda (TEMP_PTR),y
        jsr PUT_CHAR
        pla
        tax
        iny
        cpy #8
        bne us_loop5
        clc
        lda SCREEN_PTR
        adc #1
        bcc us_loop6
        inc SCREEN_PTR+1
us_loop6:
        sta SCREEN_PTR
        clc
        lda TEMP_PTR
        adc #8
        bcc us_loop7
        inc TEMP_PTR+1
us_loop7:
        sta TEMP_PTR
        inx
        cpx #16
        bne us_loop1
        rts
;-------------------------------------------------------------------------------
PUT_CHAR:
        tax
        tya
        pha
        txa
        ldy #0
        sta (SCREEN_PTR),y
        clc
        lda SCREEN_PTR
        adc #1
        bcc pc_1
        inc SCREEN_PTR+1
pc_1:
        sta SCREEN_PTR
        pla
        tay
        rts
;-------------------------------------------------------------------------------
PUT_HEX:
        pha
        
        lsr
        lsr
        lsr
        lsr
        
        cmp #$0a
        bcc ph_1
        adc #6
ph_1:
        adc #$10
        jsr PUT_CHAR
        pla
        and #$0f
        cmp #$0a
        bcc ph_2
        adc #6
ph_2:
        adc #$10
        jsr PUT_CHAR
        rts
;-------------------------------------------------------------------------------
PUT_HEX_INV:
        pha
        
        lsr
        lsr
        lsr
        lsr
        
        cmp #$0a
        bcc phi_1
        adc #6
phi_1:
        adc #$90
        jsr PUT_CHAR
        pla
        and #$0f
        cmp #$0a
        bcc phi_2
        adc #6
phi_2:
        adc #$90
        jsr PUT_CHAR
        rts
;-------------------------------------------------------------------------------
WAIT_VBL:
        bit MSTAT         
        bmi WAIT_VBL      ; wait for end of VBLANK
VB_ON:  
        bit MSTAT                                                                        
        bpl VB_ON         ; wait for begin of VBLANK
        rts
;-------------------------------------------------------------------------------
UPDATE_JOY1:
        lda SWCHA
        lsr
        lsr
        lsr
        lsr
        tax
        lda INPT0
        bpl ujoyB
        txa
        ora #$80
        tax
ujoyB:
        lda INPT1
        bpl ujoy2temp
        txa
        ora #$40
        tax
ujoy2temp:
        txa
        sta JOY1_TEMP
        cmp JOY1_LAST
        bne ujoy_newstate
        inc JOY1_TIMER
        rts 
ujoy_newstate:
        sta JOY1_LAST
        lda #$00
        sta JOY1_TIMER
ujoy_debounce:
        rts

.ENDL 

        align 256
               
;STRINGS
STRING_1   .byte "TINYMON 7800           BANK: $00"
        org $f000
; start main loop
START:	sei            ; disable interrupts
        cld            ; clear deciaml mode
        
; ***** Atari recomended startup procedure

        lda #$07
        sta INPTCTRL    ; lock into 7800 mode
        lda #$7f
        sta CTRL        ; disable Maria DMA
        lda #$00
        sta OFFSET
        sta INPTCTRL
        ldx #$ff        ; reset stack pointer to $01ff
        txs        
     
; ***** Clear zeropage & stack RAM

        ldx #$40
        lda #$00
cl_loop1:
        sta $00,x       ; zeropage
        sta $0100,x     ; 1st page
        inx
        bne cl_loop1
        
; ***** Clear RAM

        ldy #$00
        lda #$18        ; start at $1800
        sta $81
        lda #$00
        sta $80
cl_loop2:
        lda #$00
        sta ($80),y
        iny
        bne cl_loop2
        inc $81
        lda $81         
        cmp #$20        ; end at $1fff
        bne cl_loop2
        
        ldy #$00
        lda #$22        ; start at $2200
        sta $81
        lda #$00
        sta $80
cl_loop3:
        lda #$00
        sta ($80),y
        iny
        bne cl_loop3
        inc $81
        lda $81
        cmp #$28       ; end at $27ff
        bne cl_loop3
        
        ldx #$00
        lda #$00
cl_loop4:              
        sta $2000,x    ; $2000 - $203f
        sta $2100,x    ; $2100 - $213f
        inx
        cpx #$40
        bne cl_loop4

;Init joystick
 	      lda	#$14
 	      sta	CTLSWB
	      lda	#0
	      sta	CTLSWA
	      sta	SWCHB

        jsr INIT_SCREEN
        
        ldy #$0
cp_loop1:        
        lda STRING_1,y
        sta SCR_ROW1,y
        iny
        cpy #$20
        bne cp_loop1
        ldy #$00
cp_loop2:        
        lda RAM_CODE,y
        sta $2500,y
        lda RAM_CODE + $100,y
        sta $2600,y
        lda RAM_CODE + $200,y
        sta $2700,y
        iny
        bne cp_loop2
        
        lda #$80
        sta BANK_SHADOW
                
        jmp $2500
;        jmp MAIN_MENU

; *****             
;-------------------------------------------------------------------------------
; ----- PROCEDURY
;-------------------------------------------------------------------------------
; * MOVE_MEM ($80 - source address / $82 - target address / $84 lenght)
;-------------------------------------------------------------------------------
MOVE_MEM:
        ldy #$00
        lda ($80),y       ; move byte from address stored in $80-$81
        sta ($82),y       ; to address stored in $82-$83
        inc $80           ; increase source address word value on zero page
        bne mvmem1
        inc $81
mvmem1:
        inc $82           ; increase target address word value on zero page
        bne mvmem2
        inc $83
mvmem2:
        dec $84          ; decrease lenght word value on zero page
        bne MOVE_MEM
        dec $85
        lda $85
        cmp #$ff
        bne MOVE_MEM
        rts
           
;-------------------------------------------------------------------------------
; * WAIT_VBL
;-------------------------------------------------------------------------------
WAIT_VBL:
        bit MSTAT         
        bmi WAIT_VBL      ; wait for end of VBLANK
VB_ON:  
        bit MSTAT                                                                        
        bpl VB_ON         ; wait for begin of VBLANK
        rts
        
;-------------------------------------------------------------------------------
; * CHECK_VIDEO   - returns DLL low byte offset (0 - PAL / 6 - NTSC)
;-------------------------------------------------------------------------------
CHECK_VIDEO:
        jsr WAIT_VBL
vbover: bit MSTAT
        bmi vbover
        
        lda #$06        ; prepare NTSC DLL low byte address
        
        ldx #$00
countl: bit MSTAT       ; wait for start of VBLANK
        bmi comparel
        sta WSYNC       ; wait 2 scanlines
        sta WSYNC
        dex             ; decrease counter
        bne countl
comparel:
        cpx #$78        ; if less than 274 lines passed
        bcs nopal       ; code runs on NTSC device
        lda #$00
nopal:  
        rts


;-------------------------------------------------------------------------------
; * INIT_SCREEN
;-------------------------------------------------------------------------------
INIT_SCREEN:
; ***** copy CharacterSet to RAM
        lda <ROMTOP
        sta $80
        lda >ROMTOP
        sta $81
        
        lda #$00          ; RAM as a destination ($82)
        sta $82
        lda #$18
        sta $83
        
        lda #$00      ; size of block to move ($84)
        sta $84
        lda #$08
        sta $85

        jsr MOVE_MEM

; ***** copy screen display lists to RAM
        lda <SCREEN_DLLS    ; ROM address as a source ($80)
        sta $80
        lda >SCREEN_DLLS
        sta $81
        
        lda #$00          ; RAM as a destination ($82)
        sta $82
        lda #$24
        sta $83
        
        lda <SCREENSIZE      ; size of block to move ($84)
        sta $84
        lda >SCREENSIZE
        sta $85
        
        jsr MOVE_MEM
; reinitialize TIA & disable MARIA DMA
        lda #$02
        sta INPTCTRL
        lda #$7f
        sta CTRL
; set 320x1 mode character set        
        jsr WAIT_VBL      
        lda #$18      ; highbyte of $1800
        sta CHBASE    ; char-set base address
; set MARIA Display List Pointer Register & initialize screen        
        jsr CHECK_VIDEO ; function returns DLL offset for PAL or NTSC in @      
        sta DPPL
        lda #$24
        sta DPPH
        
;        lda <TITLE_DLI1
;        sta NMIVECT
;        lda >TITLE_DLI1
;        sta NMIVECT + 1
        
        screen 0, 2, 0, 1, 0, 3   ;Maria setups:
				                          ;0=normal color.
				                          ;2=Normal DMA.
				                          ;0=single byte wide characters.
				                          ;1=background colored border.
				                          ;0=transparency mode.
				                          ;3=320 a or c mode.      
; *****
        lda #$04
        sta P0C1
 ;       sta COLORS        
        lda #$0f
        sta P0C2
 ;       sta COLORS+1
        lda #$08
        sta P0C3
 ;       sta COLORS+2
        
        lda #$02
        sta P1C2
        
        lda #$05
        sta P2C2
        
        lda #$0f
        sta P3C2
        

; *****
        rts

NMI_PROC:	                ; przerwanie NMI
        jmp (NMIVECT)

IRQ_PROC:
        RTI
        
		    ORG	$FF7A
		    .DS	126 = $00

		    ORG	$FFF8
;		    .WORD	ROMTOP  + $07FF
        .WORD $f7ff
		    .WORD	NMI_PROC
		    .WORD	START
		    .WORD	IRQ_PROC
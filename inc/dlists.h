; Display listy
; ***** DLL
SCREEN_DLLS equ *
PALDLL   .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16   blank lines  <- PAL dll start
         .byte $09, (>DL_NULL-$A4), <DL_NULL 
NTSCDLL  .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines  <- NTSC dll start
         .byte $08, (>DL_NULL-$A4), <DL_NULL     ; dl 4 	blank lines
;<- start visible
;        .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
;        .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
;        .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
;        .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
        .byte $07, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines

            .byte $07, (>DL_ROW1-$A4), <DL_ROW1     ; dl 8   screen row 1 
        .byte $07, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
            .byte $07, (>DL_ROW2-$A4), <DL_ROW2     ; dl 8   screen row 2
            .byte $07, (>DL_ROW3-$A4), <DL_ROW3     ; dl 8   screen row 3
            .byte $07, (>DL_ROW4-$A4), <DL_ROW4     ; dl 8   screen row 4
            .byte $07, (>DL_ROW5-$A4), <DL_ROW5     ; dl 8   screen row 5
            .byte $07, (>DL_ROW6-$A4), <DL_ROW6     ; dl 8   screen row 6
            .byte $07, (>DL_ROW7-$A4), <DL_ROW7     ; dl 8   screen row 7
            .byte $07, (>DL_ROW8-$A4), <DL_ROW8     ; dl 8   screen row 8

            .byte $07, (>DL_ROW9-$A4), <DL_ROW9     ; dl 8   screen row 1 
            .byte $07, (>DL_ROW10-$A4), <DL_ROW10     ; dl 8   screen row 2
            .byte $07, (>DL_ROW11-$A4), <DL_ROW11     ; dl 8   screen row 3
            .byte $07, (>DL_ROW12-$A4), <DL_ROW12     ; dl 8   screen row 4
            .byte $07, (>DL_ROW13-$A4), <DL_ROW13     ; dl 8   screen row 5
            .byte $07, (>DL_ROW14-$A4), <DL_ROW14     ; dl 8   screen row 6
            .byte $07, (>DL_ROW15-$A4), <DL_ROW15     ; dl 8   screen row 7
            .byte $07, (>DL_ROW16-$A4), <DL_ROW16     ; dl 8   screen row 8

            .byte $07, (>DL_ROW17-$A4), <DL_ROW17     ; dl 8   screen row 8
        .byte $07, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
            .byte $07, (>DL_ROW18-$A4), <DL_ROW18     ; dl 8   screen row 8
            .byte $07, (>DL_ROW19-$A4), <DL_ROW19     ; dl 8   screen row 8
            .byte $07, (>DL_ROW20-$A4), <DL_ROW20     ; dl 8   screen row 8

        .byte $07, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
;        .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
;        .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
;        .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
;        .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
;<-- 192
        .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
        .byte $09, (>DL_NULL-$A4), <DL_NULL     ; dl 10  blank lines  <- NTSC dll end
        .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
        .byte $0f, (>DL_NULL-$A4), <DL_NULL     ; dl 16  blank lines
        .byte $07, (>DL_NULL-$A4), <DL_NULL     ; dl 8   blank lines  <- PAL dll end

; ***** DL
DL_ROW1 equ *
        xheader   SCR_ROW1, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
DL_NULL equ *
        .byte $00, $00  ; nullhdr        
DL_ROW2 equ *
        xheader   SCR_ROW2, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW3 equ *
        xheader   SCR_ROW3, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW4 equ *
        xheader   SCR_ROW4, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW5 equ *
        xheader   SCR_ROW5, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW6 equ *
        xheader   SCR_ROW6, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW7 equ *
        xheader   SCR_ROW7, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW8 equ *
        xheader   SCR_ROW8, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW9 equ *
        xheader   SCR_ROW9, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW10 equ *
        xheader   SCR_ROW10, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW11 equ *
        xheader   SCR_ROW11, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW12 equ *
        xheader   SCR_ROW12, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW13 equ *
        xheader   SCR_ROW13, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW14 equ *
        xheader   SCR_ROW14, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW15 equ *
        xheader   SCR_ROW15, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW16 equ *
        xheader   SCR_ROW16, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW17 equ *
        xheader   SCR_ROW17, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW18 equ *
        xheader   SCR_ROW18, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW19 equ *
        xheader   SCR_ROW19, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
DL_ROW20 equ *
        xheader   SCR_ROW20, 0, 31, 16, 0, 1  ; address, palette, width, hpos, wm, ind
        .byte $00, $00  ; nullhdr        
; TITLE DL i DLL razem
SCREENSIZE = * - SCREEN_DLLS


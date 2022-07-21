; Provided under the CC0 license. See the included LICENSE.txt for details.

 processor 6502
 include "vcs.h"
 include "macro.h"
 include "2600basic.h"
 include "2600basic_variable_redefs.h"
 ifconst bankswitch
  if bankswitch == 8
     ORG $1000
     RORG $D000
  endif
  if bankswitch == 16
     ORG $1000
     RORG $9000
  endif
  if bankswitch == 32
     ORG $1000
     RORG $1000
  endif
  if bankswitch == 64
     ORG $1000
     RORG $1000
  endif
 else
   ORG $F000
 endif

 ifconst bankswitch_hotspot
 if bankswitch_hotspot = $083F ; 0840 bankswitching hotspot
   .byte 0 ; stop unexpected bankswitches
 endif
 endif
; Provided under the CC0 license. See the included LICENSE.txt for details.

start
 sei
 cld
 ldy #0
 lda $D0
 cmp #$2C               ;check RAM location #1
 bne MachineIs2600
 lda $D1
 cmp #$A9               ;check RAM location #2
 bne MachineIs2600
 dey
MachineIs2600
 ldx #0
 txa
clearmem
 inx
 txs
 pha
 bne clearmem
 sty temp1
 ifnconst multisprite
 ifconst pfrowheight
 lda #pfrowheight
 else
 ifconst pfres
 lda #(96/pfres)
 else
 lda #8
 endif
 endif
 sta playfieldpos
 endif
 ldx #5
initscore
 lda #<scoretable
 sta scorepointers,x 
 dex
 bpl initscore
 lda #1
 sta CTRLPF
 ora INTIM
 sta rand

 ifconst multisprite
   jsr multisprite_setup
 endif

 ifnconst bankswitch
   jmp game
 else
   lda #>(game-1)
   pha
   lda #<(game-1)
   pha
   pha
   pha
   ldx #1
   jmp BS_jsr
 endif
; Provided under the CC0 license. See the included LICENSE.txt for details.

     ; This is a 2-line kernel!
     ifnconst vertical_reflect
kernel
     endif
     sta WSYNC
     lda #255
     sta TIM64T

     lda #1
     sta VDELBL
     sta VDELP0
     ldx ballheight
     inx
     inx
     stx temp4
     lda player1y
     sta temp3

     ifconst shakescreen
         jsr doshakescreen
     else
         ldx missile0height
         inx
     endif

     inx
     stx stack1

     lda bally
     sta stack2

     lda player0y
     ldx #0
     sta WSYNC
     stx GRP0
     stx GRP1
     stx PF1L
     stx PF2
     stx CXCLR
     ifconst readpaddle
         stx paddle
     else
         sleep 3
     endif

     sta temp2,x

     ;store these so they can be retrieved later
     ifnconst pfres
         ldx #128-44+(4-pfwidth)*12
     else
         ldx #132-pfres*pfwidth
     endif

     dec player0y

     lda missile0y
     sta temp5
     lda missile1y
     sta temp6

     lda playfieldpos
     sta temp1
     
     ifconst pfrowheight
         lda #pfrowheight+2
     else
         ifnconst pfres
             lda #10
         else
             lda #(96/pfres)+2 ; try to come close to the real size
         endif
     endif
     clc
     sbc playfieldpos
     sta playfieldpos
     jmp .startkernel

.skipDrawP0
     lda #0
     tay
     jmp .continueP0

.skipDrawP1
     lda #0
     tay
     jmp .continueP1

.kerloop     ; enter at cycle 59??

continuekernel
     sleep 2
continuekernel2
     lda ballheight
     
     ifconst pfres
         ldy playfield+pfres*pfwidth-132,x
         sty PF1L ;3
         ldy playfield+pfres*pfwidth-131-pfadjust,x
         sty PF2L ;3
         ldy playfield+pfres*pfwidth-129,x
         sty PF1R ; 3 too early?
         ldy playfield+pfres*pfwidth-130-pfadjust,x
         sty PF2R ;3
     else
         ldy playfield-48+pfwidth*12+44-128,x
         sty PF1L ;3
         ldy playfield-48+pfwidth*12+45-128-pfadjust,x ;4
         sty PF2L ;3
         ldy playfield-48+pfwidth*12+47-128,x ;4
         sty PF1R ; 3 too early?
         ldy playfield-48+pfwidth*12+46-128-pfadjust,x;4
         sty PF2R ;3
     endif

     ; should be playfield+$38 for width=2

     dcp bally
     rol
     rol
     ; rol
     ; rol
goback
     sta ENABL 
.startkernel
     lda player1height ;3
     dcp player1y ;5
     bcc .skipDrawP1 ;2
     ldy player1y ;3
     lda (player1pointer),y ;5; player0pointer must be selected carefully by the compiler
     ; so it doesn't cross a page boundary!

.continueP1
     sta GRP1 ;3

     ifnconst player1colors
         lda missile1height ;3
         dcp missile1y ;5
         rol;2
         rol;2
         sta ENAM1 ;3
     else
         lda (player1color),y
         sta COLUP1
         ifnconst playercolors
             sleep 7
         else
             lda.w player0colorstore
             sta COLUP0
         endif
     endif

     ifconst pfres
         lda playfield+pfres*pfwidth-132,x 
         sta PF1L ;3
         lda playfield+pfres*pfwidth-131-pfadjust,x 
         sta PF2L ;3
         lda playfield+pfres*pfwidth-129,x 
         sta PF1R ; 3 too early?
         lda playfield+pfres*pfwidth-130-pfadjust,x 
         sta PF2R ;3
     else
         lda playfield-48+pfwidth*12+44-128,x ;4
         sta PF1L ;3
         lda playfield-48+pfwidth*12+45-128-pfadjust,x ;4
         sta PF2L ;3
         lda playfield-48+pfwidth*12+47-128,x ;4
         sta PF1R ; 3 too early?
         lda playfield-48+pfwidth*12+46-128-pfadjust,x;4
         sta PF2R ;3
     endif 
     ; sleep 3

     lda player0height
     dcp player0y
     bcc .skipDrawP0
     ldy player0y
     lda (player0pointer),y
.continueP0
     sta GRP0

     ifnconst no_blank_lines
         ifnconst playercolors
             lda missile0height ;3
             dcp missile0y ;5
             sbc stack1
             sta ENAM0 ;3
         else
             lda (player0color),y
             sta player0colorstore
             sleep 6
         endif
         dec temp1
         bne continuekernel
     else
         dec temp1
         beq altkernel2
         ifconst readpaddle
             ldy currentpaddle
             lda INPT0,y
             bpl noreadpaddle
             inc paddle
             jmp continuekernel2
noreadpaddle
             sleep 2
             jmp continuekernel
         else
             ifnconst playercolors 
                 ifconst PFcolors
                     txa
                     tay
                     lda (pfcolortable),y
                     ifnconst backgroundchange
                         sta COLUPF
                     else
                         sta COLUBK
                     endif
                     jmp continuekernel
                 else
                     ifconst kernelmacrodef
                         kernelmacro
                     else
                         sleep 12
                     endif
                 endif
             else
                 lda (player0color),y
                 sta player0colorstore
                 sleep 4
             endif
             jmp continuekernel
         endif
altkernel2
         txa
         ifnconst vertical_reflect
             sbx #256-pfwidth
         else
             sbx #256-pfwidth/2
         endif
         bmi lastkernelline
         ifconst pfrowheight
             lda #pfrowheight
         else
             ifnconst pfres
                 lda #8
             else
                 lda #(96/pfres) ; try to come close to the real size
             endif
         endif
         sta temp1
         jmp continuekernel
     endif

altkernel

     ifconst PFmaskvalue
         lda #PFmaskvalue
     else
         lda #0
     endif
     sta PF1L
     sta PF2


     ;sleep 3

     ;28 cycles to fix things
     ;minus 11=17

     ; lax temp4
     ; clc
     txa
     ifnconst vertical_reflect
         sbx #256-pfwidth
     else
         sbx #256-pfwidth/2
     endif

     bmi lastkernelline

     ifconst PFcolorandheight
         ifconst pfres
             ldy playfieldcolorandheight-131+pfres*pfwidth,x
         else
             ldy playfieldcolorandheight-87,x
         endif
         ifnconst backgroundchange
             sty COLUPF
         else
             sty COLUBK
         endif
         ifconst pfres
             lda playfieldcolorandheight-132+pfres*pfwidth,x
         else
             lda playfieldcolorandheight-88,x
         endif
         sta.w temp1
     endif
     ifconst PFheights
         lsr
         lsr
         tay
         lda (pfheighttable),y
         sta.w temp1
     endif
     ifconst PFcolors
         tay
         lda (pfcolortable),y
         ifnconst backgroundchange
             sta COLUPF
         else
             sta COLUBK
         endif
         ifconst pfrowheight
             lda #pfrowheight
         else
             ifnconst pfres
                 lda #8
             else
                 lda #(96/pfres) ; try to come close to the real size
             endif
         endif
         sta temp1
     endif
     ifnconst PFcolorandheight
         ifnconst PFcolors
             ifnconst PFheights
                 ifnconst no_blank_lines
                     ; read paddle 0
                     ; lo-res paddle read
                     ; bit INPT0
                     ; bmi paddleskipread
                     ; inc paddle0
                     ;donepaddleskip
                     sleep 10
                     ifconst pfrowheight
                         lda #pfrowheight
                     else
                         ifnconst pfres
                             lda #8
                         else
                             lda #(96/pfres) ; try to come close to the real size
                         endif
                     endif
                     sta temp1
                 endif
             endif
         endif
     endif
     

     lda ballheight
     dcp bally
     sbc temp4


     jmp goback


     ifnconst no_blank_lines
lastkernelline
         ifnconst PFcolors
             sleep 10
         else
             ldy #124
             lda (pfcolortable),y
             sta COLUPF
         endif

         ifconst PFheights
             ldx #1
             ;sleep 4
             sleep 3 ; this was over 1 cycle
         else
             ldx playfieldpos
             ;sleep 3
             sleep 2 ; this was over 1 cycle
         endif

         jmp enterlastkernel

     else
lastkernelline
         
         ifconst PFheights
             ldx #1
             ;sleep 5
             sleep 4 ; this was over 1 cycle
         else
             ldx playfieldpos
             ;sleep 4
             sleep 3 ; this was over 1 cycle
         endif

         cpx #0
         bne .enterfromNBL
         jmp no_blank_lines_bailout
     endif

     if ((<*)>$d5)
         align 256
     endif
     ; this is a kludge to prevent page wrapping - fix!!!

.skipDrawlastP1
     lda #0
     tay ; added so we don't cross a page
     jmp .continuelastP1

.endkerloop     ; enter at cycle 59??
     
     nop

.enterfromNBL
     ifconst pfres
         ldy.w playfield+pfres*pfwidth-4
         sty PF1L ;3
         ldy.w playfield+pfres*pfwidth-3-pfadjust
         sty PF2L ;3
         ldy.w playfield+pfres*pfwidth-1
         sty PF1R ; possibly too early?
         ldy.w playfield+pfres*pfwidth-2-pfadjust
         sty PF2R ;3
     else
         ldy.w playfield-48+pfwidth*12+44
         sty PF1L ;3
         ldy.w playfield-48+pfwidth*12+45-pfadjust
         sty PF2L ;3
         ldy.w playfield-48+pfwidth*12+47
         sty PF1R ; possibly too early?
         ldy.w playfield-48+pfwidth*12+46-pfadjust
         sty PF2R ;3
     endif

enterlastkernel
     lda ballheight

     ; tya
     dcp bally
     ; sleep 4

     ; sbc stack3
     rol
     rol
     sta ENABL 

     lda player1height ;3
     dcp player1y ;5
     bcc .skipDrawlastP1
     ldy player1y ;3
     lda (player1pointer),y ;5; player0pointer must be selected carefully by the compiler
     ; so it doesn't cross a page boundary!

.continuelastP1
     sta GRP1 ;3

     ifnconst player1colors
         lda missile1height ;3
         dcp missile1y ;5
     else
         lda (player1color),y
         sta COLUP1
     endif

     dex
     ;dec temp4 ; might try putting this above PF writes
     beq endkernel


     ifconst pfres
         ldy.w playfield+pfres*pfwidth-4
         sty PF1L ;3
         ldy.w playfield+pfres*pfwidth-3-pfadjust
         sty PF2L ;3
         ldy.w playfield+pfres*pfwidth-1
         sty PF1R ; possibly too early?
         ldy.w playfield+pfres*pfwidth-2-pfadjust
         sty PF2R ;3
     else
         ldy.w playfield-48+pfwidth*12+44
         sty PF1L ;3
         ldy.w playfield-48+pfwidth*12+45-pfadjust
         sty PF2L ;3
         ldy.w playfield-48+pfwidth*12+47
         sty PF1R ; possibly too early?
         ldy.w playfield-48+pfwidth*12+46-pfadjust
         sty PF2R ;3
     endif

     ifnconst player1colors
         rol;2
         rol;2
         sta ENAM1 ;3
     else
         ifnconst playercolors
             sleep 7
         else
             lda.w player0colorstore
             sta COLUP0
         endif
     endif
     
     lda.w player0height
     dcp player0y
     bcc .skipDrawlastP0
     ldy player0y
     lda (player0pointer),y
.continuelastP0
     sta GRP0



     ifnconst no_blank_lines
         lda missile0height ;3
         dcp missile0y ;5
         sbc stack1
         sta ENAM0 ;3
         jmp .endkerloop
     else
         ifconst readpaddle
             ldy currentpaddle
             lda INPT0,y
             bpl noreadpaddle2
             inc paddle
             jmp .endkerloop
noreadpaddle2
             sleep 4
             jmp .endkerloop
         else ; no_blank_lines and no paddle reading
             pla
             pha ; 14 cycles in 4 bytes
             pla
             pha
             ; sleep 14
             jmp .endkerloop
         endif
     endif


     ; ifconst donepaddleskip
         ;paddleskipread
         ; this is kind of lame, since it requires 4 cycles from a page boundary crossing
         ; plus we get a lo-res paddle read
         ; bmi donepaddleskip
     ; endif

.skipDrawlastP0
     lda #0
     tay
     jmp .continuelastP0

     ifconst no_blank_lines
no_blank_lines_bailout
         ldx #0
     endif

endkernel
     ; 6 digit score routine
     stx PF1
     stx PF2
     stx PF0
     clc

     ifconst pfrowheight
         lda #pfrowheight+2
     else
         ifnconst pfres
             lda #10
         else
             lda #(96/pfres)+2 ; try to come close to the real size
         endif
     endif

     sbc playfieldpos
     sta playfieldpos
     txa

     ifconst shakescreen
         bit shakescreen
         bmi noshakescreen2
         ldx #$3D
noshakescreen2
     endif

     sta WSYNC,x

     ; STA WSYNC ;first one, need one more
     sta REFP0
     sta REFP1
     STA GRP0
     STA GRP1
     ; STA PF1
     ; STA PF2
     sta HMCLR
     sta ENAM0
     sta ENAM1
     sta ENABL

     lda temp2 ;restore variables that were obliterated by kernel
     sta player0y
     lda temp3
     sta player1y
     ifnconst player1colors
         lda temp6
         sta missile1y
     endif
     ifnconst playercolors
         ifnconst readpaddle
             lda temp5
             sta missile0y
         endif
     endif
     lda stack2
     sta bally

     ; strangely, this isn't required any more. might have
     ; resulted from the no_blank_lines score bounce fix
     ;ifconst no_blank_lines
         ;sta WSYNC
     ;endif

     lda INTIM
     clc
     ifnconst vblank_time
         adc #43+12+87
     else
         adc #vblank_time+12+87

     endif
     ; sta WSYNC
     sta TIM64T

     ifconst minikernel
         jsr minikernel
     endif

     ; now reassign temp vars for score pointers

     ; score pointers contain:
     ; score1-5: lo1,lo2,lo3,lo4,lo5,lo6
     ; swap lo2->temp1
     ; swap lo4->temp3
     ; swap lo6->temp5
     ifnconst noscore
         lda scorepointers+1
         ; ldy temp1
         sta temp1
         ; sty scorepointers+1

         lda scorepointers+3
         ; ldy temp3
         sta temp3
         ; sty scorepointers+3


         sta HMCLR
         tsx
         stx stack1 
         ldx #$E0
         stx HMP0

         LDA scorecolor 
         STA COLUP0
         STA COLUP1
         ifconst scorefade
             STA stack2
         endif
         ifconst pfscore
             lda pfscorecolor
             sta COLUPF
         endif
         sta WSYNC
         ldx #0
         STx GRP0
         STx GRP1 ; seems to be needed because of vdel

         lda scorepointers+5
         ; ldy temp5
         sta temp5,x
         ; sty scorepointers+5
         lda #>scoretable
         sta scorepointers+1
         sta scorepointers+3
         sta scorepointers+5
         sta temp2
         sta temp4
         sta temp6
         LDY #7
         STY VDELP0
         STA RESP0
         STA RESP1


         LDA #$03
         STA NUSIZ0
         STA NUSIZ1
         STA VDELP1
         LDA #$F0
         STA HMP1
         lda (scorepointers),y
         sta GRP0
         STA HMOVE ; cycle 73 ?
         jmp beginscore


         if ((<*)>$d4)
             align 256 ; kludge that potentially wastes space! should be fixed!
         endif

loop2
         lda (scorepointers),y ;+5 68 204
         sta GRP0 ;+3 71 213 D1 -- -- --
         ifconst pfscore
             lda.w pfscore1
             sta PF1
         else
             ifconst scorefade
                 sleep 2
                 dec stack2 ; decrement the temporary scorecolor
             else
                 sleep 7
             endif
         endif
         ; cycle 0
beginscore
         lda (scorepointers+$8),y ;+5 5 15
         sta GRP1 ;+3 8 24 D1 D1 D2 --
         lda (scorepointers+$6),y ;+5 13 39
         sta GRP0 ;+3 16 48 D3 D1 D2 D2
         lax (scorepointers+$2),y ;+5 29 87
         txs
         lax (scorepointers+$4),y ;+5 36 108
         ifconst scorefade
             lda stack2
         else
             sleep 3
         endif

         ifconst pfscore
             lda pfscore2
             sta PF1
         else
             ifconst scorefade
                 sta COLUP0
                 sta COLUP1
             else
                 sleep 6
             endif
         endif

         lda (scorepointers+$A),y ;+5 21 63
         stx GRP1 ;+3 44 132 D3 D3 D4 D2!
         tsx
         stx GRP0 ;+3 47 141 D5 D3! D4 D4
         sta GRP1 ;+3 50 150 D5 D5 D6 D4!
         sty GRP0 ;+3 53 159 D4* D5! D6 D6
         dey
         bpl loop2 ;+2 60 180

         ldx stack1 
         txs
         ; lda scorepointers+1
         ldy temp1
         ; sta temp1
         sty scorepointers+1

         LDA #0 
         sta PF1
         STA GRP0
         STA GRP1
         STA VDELP0
         STA VDELP1;do we need these
         STA NUSIZ0
         STA NUSIZ1

         ; lda scorepointers+3
         ldy temp3
         ; sta temp3
         sty scorepointers+3

         ; lda scorepointers+5
         ldy temp5
         ; sta temp5
         sty scorepointers+5
     endif ;noscore
    ifconst readpaddle
        lda #%11000010
    else
        ifconst qtcontroller
            lda qtcontroller
            lsr    ; bit 0 in carry
            lda #4
            ror    ; carry into top of A
        else
            lda #2
        endif ; qtcontroller
    endif ; readpaddle
 sta WSYNC
 sta VBLANK
 RETURN
     ifconst shakescreen
doshakescreen
         bit shakescreen
         bmi noshakescreen
         sta WSYNC
noshakescreen
         ldx missile0height
         inx
         rts
     endif

; Provided under the CC0 license. See the included LICENSE.txt for details.

; playfield drawing routines
; you get a 32x12 bitmapped display in a single color :)
; 0-31 and 0-11

pfclear ; clears playfield - or fill with pattern
 ifconst pfres
 ldx #pfres*pfwidth-1
 else
 ldx #47-(4-pfwidth)*12 ; will this work?
 endif
pfclear_loop
 ifnconst superchip
 sta playfield,x
 else
 sta playfield-128,x
 endif
 dex
 bpl pfclear_loop
 RETURN
 
setuppointers
 stx temp2 ; store on.off.flip value
 tax ; put x-value in x 
 lsr
 lsr
 lsr ; divide x pos by 8 
 sta temp1
 tya
 asl
 if pfwidth=4
  asl ; multiply y pos by 4
 endif ; else multiply by 2
 clc
 adc temp1 ; add them together to get actual memory location offset
 tay ; put the value in y
 lda temp2 ; restore on.off.flip value
 rts

pfread
;x=xvalue, y=yvalue
 jsr setuppointers
 lda setbyte,x
 and playfield,y
 eor setbyte,x
; beq readzero
; lda #1
; readzero
 RETURN

pfpixel
;x=xvalue, y=yvalue, a=0,1,2
 jsr setuppointers

 ifconst bankswitch
 lda temp2 ; load on.off.flip value (0,1, or 2)
 beq pixelon_r  ; if "on" go to on
 lsr
 bcs pixeloff_r ; value is 1 if true
 lda playfield,y ; if here, it's "flip"
 eor setbyte,x
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 RETURN
pixelon_r
 lda playfield,y
 ora setbyte,x
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 RETURN
pixeloff_r
 lda setbyte,x
 eor #$ff
 and playfield,y
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 RETURN

 else
 jmp plotpoint
 endif

pfhline
;x=xvalue, y=yvalue, a=0,1,2, temp3=endx
 jsr setuppointers
 jmp noinc
keepgoing
 inx
 txa
 and #7
 bne noinc
 iny
noinc
 jsr plotpoint
 cpx temp3
 bmi keepgoing
 RETURN

pfvline
;x=xvalue, y=yvalue, a=0,1,2, temp3=endx
 jsr setuppointers
 sty temp1 ; store memory location offset
 inc temp3 ; increase final x by 1 
 lda temp3
 asl
 if pfwidth=4
   asl ; multiply by 4
 endif ; else multiply by 2
 sta temp3 ; store it
 ; Thanks to Michael Rideout for fixing a bug in this code
 ; right now, temp1=y=starting memory location, temp3=final
 ; x should equal original x value
keepgoingy
 jsr plotpoint
 iny
 iny
 if pfwidth=4
   iny
   iny
 endif
 cpy temp3
 bmi keepgoingy
 RETURN

plotpoint
 lda temp2 ; load on.off.flip value (0,1, or 2)
 beq pixelon  ; if "on" go to on
 lsr
 bcs pixeloff ; value is 1 if true
 lda playfield,y ; if here, it's "flip"
 eor setbyte,x
  ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 rts
pixelon
 lda playfield,y
 ora setbyte,x
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 rts
pixeloff
 lda setbyte,x
 eor #$ff
 and playfield,y
 ifconst superchip
 sta playfield-128,y
 else
 sta playfield,y
 endif
 rts

setbyte
 ifnconst pfcenter
 .byte $80
 .byte $40
 .byte $20
 .byte $10
 .byte $08
 .byte $04
 .byte $02
 .byte $01
 endif
 .byte $01
 .byte $02
 .byte $04
 .byte $08
 .byte $10
 .byte $20
 .byte $40
 .byte $80
 .byte $80
 .byte $40
 .byte $20
 .byte $10
 .byte $08
 .byte $04
 .byte $02
 .byte $01
 .byte $01
 .byte $02
 .byte $04
 .byte $08
 .byte $10
 .byte $20
 .byte $40
 .byte $80
; Provided under the CC0 license. See the included LICENSE.txt for details.

pfscroll ;(a=0 left, 1 right, 2 up, 4 down, 6=upup, 12=downdown)
 bne notleft
;left
 ifconst pfres
 ldx #pfres*4
 else
 ldx #48
 endif
leftloop
 lda playfield-1,x
 lsr

 ifconst superchip
 lda playfield-2,x
 rol
 sta playfield-130,x
 lda playfield-3,x
 ror
 sta playfield-131,x
 lda playfield-4,x
 rol
 sta playfield-132,x
 lda playfield-1,x
 ror
 sta playfield-129,x
 else
 rol playfield-2,x
 ror playfield-3,x
 rol playfield-4,x
 ror playfield-1,x
 endif

 txa
 sbx #4
 bne leftloop
 RETURN

notleft
 lsr
 bcc notright
;right

 ifconst pfres
 ldx #pfres*4
 else
 ldx #48
 endif
rightloop
 lda playfield-4,x
 lsr
 ifconst superchip
 lda playfield-3,x
 rol
 sta playfield-131,x
 lda playfield-2,x
 ror
 sta playfield-130,x
 lda playfield-1,x
 rol
 sta playfield-129,x
 lda playfield-4,x
 ror
 sta playfield-132,x
 else
 rol playfield-3,x
 ror playfield-2,x
 rol playfield-1,x
 ror playfield-4,x
 endif
 txa
 sbx #4
 bne rightloop
  RETURN

notright
 lsr
 bcc notup
;up
 lsr
 bcc onedecup
 dec playfieldpos
onedecup
 dec playfieldpos
 beq shiftdown 
 bpl noshiftdown2 
shiftdown
  ifconst pfrowheight
 lda #pfrowheight
 else
 ifnconst pfres
   lda #8
 else
   lda #(96/pfres) ; try to come close to the real size
 endif
 endif

 sta playfieldpos
 lda playfield+3
 sta temp4
 lda playfield+2
 sta temp3
 lda playfield+1
 sta temp2
 lda playfield
 sta temp1
 ldx #0
up2
 lda playfield+4,x
 ifconst superchip
 sta playfield-128,x
 lda playfield+5,x
 sta playfield-127,x
 lda playfield+6,x
 sta playfield-126,x
 lda playfield+7,x
 sta playfield-125,x
 else
 sta playfield,x
 lda playfield+5,x
 sta playfield+1,x
 lda playfield+6,x
 sta playfield+2,x
 lda playfield+7,x
 sta playfield+3,x
 endif
 txa
 sbx #252
 ifconst pfres
 cpx #(pfres-1)*4
 else
 cpx #44
 endif
 bne up2

 lda temp4
 
 ifconst superchip
 ifconst pfres
 sta playfield+pfres*4-129
 lda temp3
 sta playfield+pfres*4-130
 lda temp2
 sta playfield+pfres*4-131
 lda temp1
 sta playfield+pfres*4-132
 else
 sta playfield+47-128
 lda temp3
 sta playfield+46-128
 lda temp2
 sta playfield+45-128
 lda temp1
 sta playfield+44-128
 endif
 else
 ifconst pfres
 sta playfield+pfres*4-1
 lda temp3
 sta playfield+pfres*4-2
 lda temp2
 sta playfield+pfres*4-3
 lda temp1
 sta playfield+pfres*4-4
 else
 sta playfield+47
 lda temp3
 sta playfield+46
 lda temp2
 sta playfield+45
 lda temp1
 sta playfield+44
 endif
 endif
noshiftdown2
 RETURN


notup
;down
 lsr
 bcs oneincup
 inc playfieldpos
oneincup
 inc playfieldpos
 lda playfieldpos

  ifconst pfrowheight
 cmp #pfrowheight+1
 else
 ifnconst pfres
   cmp #9
 else
   cmp #(96/pfres)+1 ; try to come close to the real size
 endif
 endif

 bcc noshiftdown 
 lda #1
 sta playfieldpos

 ifconst pfres
 lda playfield+pfres*4-1
 sta temp4
 lda playfield+pfres*4-2
 sta temp3
 lda playfield+pfres*4-3
 sta temp2
 lda playfield+pfres*4-4
 else
 lda playfield+47
 sta temp4
 lda playfield+46
 sta temp3
 lda playfield+45
 sta temp2
 lda playfield+44
 endif

 sta temp1

 ifconst pfres
 ldx #(pfres-1)*4
 else
 ldx #44
 endif
down2
 lda playfield-1,x
 ifconst superchip
 sta playfield-125,x
 lda playfield-2,x
 sta playfield-126,x
 lda playfield-3,x
 sta playfield-127,x
 lda playfield-4,x
 sta playfield-128,x
 else
 sta playfield+3,x
 lda playfield-2,x
 sta playfield+2,x
 lda playfield-3,x
 sta playfield+1,x
 lda playfield-4,x
 sta playfield,x
 endif
 txa
 sbx #4
 bne down2

 lda temp4
 ifconst superchip
 sta playfield-125
 lda temp3
 sta playfield-126
 lda temp2
 sta playfield-127
 lda temp1
 sta playfield-128
 else
 sta playfield+3
 lda temp3
 sta playfield+2
 lda temp2
 sta playfield+1
 lda temp1
 sta playfield
 endif
noshiftdown
 RETURN
; Provided under the CC0 license. See the included LICENSE.txt for details.

;standard routines needed for pretty much all games
; just the random number generator is left - maybe we should remove this asm file altogether?
; repositioning code and score pointer setup moved to overscan
; read switches, joysticks now compiler generated (more efficient)

randomize
	lda rand
	lsr
 ifconst rand16
	rol rand16
 endif
	bcc noeor
	eor #$B4
noeor
	sta rand
 ifconst rand16
	eor rand16
 endif
	RETURN
; Provided under the CC0 license. See the included LICENSE.txt for details.

drawscreen
     ifconst debugscore
         ldx #14
         lda INTIM ; display # cycles left in the score

         ifconst mincycles
             lda mincycles 
             cmp INTIM
             lda mincycles
             bcc nochange
             lda INTIM
             sta mincycles
nochange
         endif

         ; cmp #$2B
         ; bcs no_cycles_left
         bmi cycles_left
         ldx #64
         eor #$ff ;make negative
cycles_left
         stx scorecolor
         and #$7f ; clear sign bit
         tax
         lda scorebcd,x
         sta score+2
         lda scorebcd1,x
         sta score+1
         jmp done_debugscore 
scorebcd
         .byte $00, $64, $28, $92, $56, $20, $84, $48, $12, $76, $40
         .byte $04, $68, $32, $96, $60, $24, $88, $52, $16, $80, $44
         .byte $08, $72, $36, $00, $64, $28, $92, $56, $20, $84, $48
         .byte $12, $76, $40, $04, $68, $32, $96, $60, $24, $88
scorebcd1
         .byte 0, 0, 1, 1, 2, 3, 3, 4, 5, 5, 6
         .byte 7, 7, 8, 8, 9, $10, $10, $11, $12, $12, $13
         .byte $14, $14, $15, $16, $16, $17, $17, $18, $19, $19, $20
         .byte $21, $21, $22, $23, $23, $24, $24, $25, $26, $26
done_debugscore
     endif

     ifconst debugcycles
         lda INTIM ; if we go over, it mucks up the background color
         ; cmp #$2B
         ; BCC overscan
         bmi overscan
         sta COLUBK
         bcs doneoverscan
     endif

overscan
     ifconst interlaced
         PHP
         PLA 
         EOR #4 ; flip interrupt bit
         PHA
         PLP
         AND #4 ; isolate the interrupt bit
         TAX ; save it for later
     endif

overscanloop
     lda INTIM ;wait for sync
     bmi overscanloop
doneoverscan

     ;do VSYNC

     ifconst interlaced
         CPX #4
         BNE oddframevsync
     endif

     lda #2
     sta WSYNC
     sta VSYNC
     STA WSYNC
     STA WSYNC
     lsr
     STA WSYNC
     STA VSYNC
     sta VBLANK
     ifnconst overscan_time
         lda #37+128
     else
         lda #overscan_time+128
     endif
     sta TIM64T

     ifconst interlaced
         jmp postsync 

oddframevsync
         sta WSYNC

         LDA ($80,X) ; 11 waste
         LDA ($80,X) ; 11 waste
         LDA ($80,X) ; 11 waste

         lda #2
         sta VSYNC
         sta WSYNC
         sta WSYNC
         sta WSYNC

         LDA ($80,X) ; 11 waste
         LDA ($80,X) ; 11 waste
         LDA ($80,X) ; 11 waste

         lda #0
         sta VSYNC
         sta VBLANK
         ifnconst overscan_time
             lda #37+128
         else
             lda #overscan_time+128
         endif
         sta TIM64T

postsync
     endif

     ifconst legacy
         if legacy < 100
             ldx #4
adjustloop
             lda player0x,x
             sec
             sbc #14 ;?
             sta player0x,x
             dex
             bpl adjustloop
         endif
     endif
     if ((<*)>$e9)&&((<*)<$fa)
         repeat ($fa-(<*))
         nop
         repend
     endif
     sta WSYNC
     ldx #4
     SLEEP 3
HorPosLoop     ; 5
     lda player0x,X ;+4 9
     sec ;+2 11
DivideLoop
     sbc #15
     bcs DivideLoop;+4 15
     sta temp1,X ;+4 19
     sta RESP0,X ;+4 23
     sta WSYNC
     dex
     bpl HorPosLoop;+5 5
     ; 4

     ldx #4
     ldy temp1,X
     lda repostable-256,Y
     sta HMP0,X ;+14 18

     dex
     ldy temp1,X
     lda repostable-256,Y
     sta HMP0,X ;+14 32

     dex
     ldy temp1,X
     lda repostable-256,Y
     sta HMP0,X ;+14 46

     dex
     ldy temp1,X
     lda repostable-256,Y
     sta HMP0,X ;+14 60

     dex
     ldy temp1,X
     lda repostable-256,Y
     sta HMP0,X ;+14 74

     sta WSYNC
     
     sta HMOVE ;+3 3


     ifconst legacy
         if legacy < 100
             ldx #4
adjustloop2
             lda player0x,x
             clc
             adc #14 ;?
             sta player0x,x
             dex
             bpl adjustloop2
         endif
     endif




     ;set score pointers
     lax score+2
     jsr scorepointerset
     sty scorepointers+5
     stx scorepointers+2
     lax score+1
     jsr scorepointerset
     sty scorepointers+4
     stx scorepointers+1
     lax score
     jsr scorepointerset
     sty scorepointers+3
     stx scorepointers

vblk
     ; run possible vblank bB code
     ifconst vblank_bB_code
         jsr vblank_bB_code
     endif
vblk2
     LDA INTIM
     bmi vblk2
     jmp kernel
     

     .byte $80,$70,$60,$50,$40,$30,$20,$10,$00
     .byte $F0,$E0,$D0,$C0,$B0,$A0,$90
repostable

scorepointerset
     and #$0F
     asl
     asl
     asl
     adc #<scoretable
     tay 
     txa
     ; and #$F0
     ; lsr
     asr #$F0
     adc #<scoretable
     tax
     rts
game
.L00 ;  rem Generated 14/03/2016 17:44:53 by Visual bB Version 1.0.0.554

.
 ; 

.L01 ;  rem configuracao geral ( tamanho da rom sistemar de cor  da tv ) 

.
 ; 

.L02 ;  set tv ntsc

.L03 ;  set romsize 4k

.L04 ;  set smartbranching on

.
 ; 

.L05 ;  dim _sc1  =  score

.L06 ;  dim _sc2  =  score  +  1

.L07 ;  dim _sc3  =  score  +  2

.L08 ;  _sc1  =  $0

	LDA #$0
	STA _sc1
.L09 ;  _sc3  =  $0

	LDA #$0
	STA _sc3
.L010 ;  rem titulo 

.
 ; 

.title
 ; title

.L011 ;  playfield:

  ifconst pfres
	  ldx #(11>pfres)*(pfres*pfwidth-1)+(11<=pfres)*43
  else
	  ldx #((11*pfwidth-1)*((11*pfwidth-1)<47))+(47*((11*pfwidth-1)>=47))
  endif
	jmp pflabel0
PF_data0
	.byte %00111010, %10111101
	if (pfwidth>2)
	.byte %11001010, %00000000
 endif
	.byte %00101010, %10000101
	if (pfwidth>2)
	.byte %01001010, %01111110
 endif
	.byte %00110010, %10110101
	if (pfwidth>2)
	.byte %11101010, %10100101
 endif
	.byte %00101010, %10100101
	if (pfwidth>2)
	.byte %00100100, %01111110
 endif
	.byte %00101011, %10111101
	if (pfwidth>2)
	.byte %11100100, %00000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00000111, %11011100
	if (pfwidth>2)
	.byte %10111001, %00000011
 endif
	.byte %00000101, %01010100
	if (pfwidth>2)
	.byte %10101001, %00000010
 endif
	.byte %00000111, %11001101
	if (pfwidth>2)
	.byte %10111101, %00000010
 endif
	.byte %00000110, %01010101
	if (pfwidth>2)
	.byte %10100101, %00000010
 endif
	.byte %00000111, %01010101
	if (pfwidth>2)
	.byte %10111101, %00000011
 endif
pflabel0
	lda PF_data0,x
	sta playfield,x
	dex
	bpl pflabel0
.
 ; 

.L012 ;  rem cor do titulo e fundo da tela 

.
 ; 

.L013 ;  COLUBK  =  216

	LDA #216
	STA COLUBK
.L014 ;  COLUPF  =  $90

	LDA #$90
	STA COLUPF
.L015 ;  drawscreen

 jsr drawscreen
.
 ; 

.L016 ;  rem quando finalizar o game, esconder os personagens fora da tela 

.
 ; 

.L017 ;  player0x  =  1  :  player0y  =  1

	LDA #1
	STA player0x
	STA player0y
.L018 ;  player1x  =  1  :  player1y  =  1

	LDA #1
	STA player1x
	STA player1y
.
 ; 

.L019 ;  rem se o acionado o botao, pular o titulo 

.
 ; 

.L020 ;  if joy0fire  ||  joy1fire then goto skiptitle

 bit INPT4
	BMI .skipL020
.condpart0
 jmp .condpart1
.skipL020
 bit INPT5
	BMI .skip0OR
.condpart1
 jmp .skiptitle

.skip0OR
.
 ; 

.L021 ;  rem se nao acionado o botao, permanecer no titulo 

.
 ; 

.L022 ;  goto title

 jmp .title

.
 ; 

.L023 ;  rem inicio do loop principal 

.
 ; 

.skiptitle
 ; skiptitle

.
 ; 

.L024 ;  rem tela de jogo inicial (apos o titulo )

.
 ; 

.L025 ;  playfield:

  ifconst pfres
	  ldx #(11>pfres)*(pfres*pfwidth-1)+(11<=pfres)*43
  else
	  ldx #((11*pfwidth-1)*((11*pfwidth-1)<47))+(47*((11*pfwidth-1)>=47))
  endif
	jmp pflabel1
PF_data1
	.byte %11111111, %11111111
	if (pfwidth>2)
	.byte %11111111, %11111111
 endif
	.byte %10000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %10000000
 endif
	.byte %10000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %10000000
 endif
	.byte %10000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %10000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %10000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %10000000
 endif
	.byte %10000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %10000000
 endif
	.byte %10000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %10000000
 endif
	.byte %11111111, %11111111
	if (pfwidth>2)
	.byte %11111111, %11111111
 endif
pflabel1
	lda PF_data1,x
	sta playfield,x
	dex
	bpl pflabel1
.
 ; 

.
 ; 

.L026 ;  rem posicao dos personagens na tela 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L027 ;  rem cor do fundo da tela 

.
 ; 

.L028 ;  COLUBK  =  216

	LDA #216
	STA COLUBK
.
 ; 

.L029 ;  rem configuracao das contagens de pontos e cor do score 

.
 ; 

.L030 ;  score  =  00000  :  scorecolor  =  $0E

	LDA #$00
	STA score+2
	LDA #$00
	STA score+1
	LDA #$00
	STA score
	LDA #$0E
	STA scorecolor
.L031 ;  m  =  0

	LDA #0
	STA m
.
 ; 

.reset
 ; reset

.L032 ;  if _sc1  >  $04 then goto gameover

	LDA #$04
	CMP _sc1
     BCS .skipL032
.condpart2
 jmp .gameover

.skipL032
.L033 ;  if _sc3  >  $04  &&  _sc3  <  $10 then goto gameover

	LDA #$04
	CMP _sc3
     BCS .skipL033
.condpart3
	LDA _sc3
	CMP #$10
     BCS .skip3then
.condpart4
 jmp .gameover

.skip3then
.skipL033
.
 ; 

.L034 ;  player0x  =  20  :  player0y  =  47

	LDA #20
	STA player0x
	LDA #47
	STA player0y
.L035 ;  player1x  =  130  :  player1y  =  47

	LDA #130
	STA player1x
	LDA #47
	STA player1y
.L036 ;  ballx  =   (  ( rand  &  50 )   +  50 )   :  bally  =   (  ( rand  &  40 )   +  30 ) 

; complex statement detected
 jsr randomize
	AND #50
	CLC
	ADC #50
	STA ballx
; complex statement detected
 jsr randomize
	AND #40
	CLC
	ADC #30
	STA bally
.L037 ;  ballheight  =  3  :  CTRLPF  =  $21

	LDA #3
	STA ballheight
	LDA #$21
	STA CTRLPF
.L038 ;  drawscreen

 jsr drawscreen
.
 ; 

.L039 ;  n  =  0

	LDA #0
	STA n
.L040 ;  p  =  0

	LDA #0
	STA p
.L041 ;  q  =  0

	LDA #0
	STA q
.L042 ;  z  =  0

	LDA #0
	STA z
.L043 ;  rem loop principal 

.
 ; 

.main
 ; main

.
 ; 

.L044 ;  rem cor dos personagens e da base do canhao (heroi)

.
 ; 

.L045 ;  COLUP1  =  $1E

	LDA #$1E
	STA COLUP1
.L046 ;  COLUP0  =  $0E

	LDA #$0E
	STA COLUP0
.L047 ;  COLUPF  =  $90

	LDA #$90
	STA COLUPF
.L048 ;  f = f + 1

	INC f
.L049 ;  g = g + 1

	INC g
.
 ; 

.L050 ;  rem jogador 1

.
 ; 

.L051 ;  if f  =  10  &&  q  =  0 then player0:

	LDA f
	CMP #10
     BNE .skipL051
.condpart5
	LDA q
	CMP #0
     BNE .skip5then
.condpart6
	LDX #<player6then_0
	STX player0pointerlo
	LDA #>player6then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip5then
.skipL051
.L052 ;  if f  =  10  &&  q  =  0 then player0color:

	LDA f
	CMP #10
     BNE .skipL052
.condpart7
	LDA q
	CMP #0
     BNE .skip7then
.condpart8
	LDX #<playercolor8then_0
	STX player0color
	LDA #>playercolor8then_0
	STA player0color+1
.skip7then
.skipL052
.L053 ;  if f  =  20  &&  q  =  0 then player0:

	LDA f
	CMP #20
     BNE .skipL053
.condpart9
	LDA q
	CMP #0
     BNE .skip9then
.condpart10
	LDX #<player10then_0
	STX player0pointerlo
	LDA #>player10then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip9then
.skipL053
.L054 ;  if f  =  20  &&  q  =  0 then player0color:

	LDA f
	CMP #20
     BNE .skipL054
.condpart11
	LDA q
	CMP #0
     BNE .skip11then
.condpart12
	LDX #<playercolor12then_0
	STX player0color
	LDA #>playercolor12then_0
	STA player0color+1
.skip11then
.skipL054
.
 ; 

.L055 ;  if f  =  10  &&  q  =  1 then player0:

	LDA f
	CMP #10
     BNE .skipL055
.condpart13
	LDA q
	CMP #1
     BNE .skip13then
.condpart14
	LDX #<player14then_0
	STX player0pointerlo
	LDA #>player14then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip13then
.skipL055
.L056 ;  if f  =  10  &&  q  =  1 then player0color:

	LDA f
	CMP #10
     BNE .skipL056
.condpart15
	LDA q
	CMP #1
     BNE .skip15then
.condpart16
	LDX #<playercolor16then_0
	STX player0color
	LDA #>playercolor16then_0
	STA player0color+1
.skip15then
.skipL056
.L057 ;  if f  =  20  &&  q  =  1 then player0:

	LDA f
	CMP #20
     BNE .skipL057
.condpart17
	LDA q
	CMP #1
     BNE .skip17then
.condpart18
	LDX #<player18then_0
	STX player0pointerlo
	LDA #>player18then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip17then
.skipL057
.L058 ;  if f  =  20  &&  q  =  1 then player0color:

	LDA f
	CMP #20
     BNE .skipL058
.condpart19
	LDA q
	CMP #1
     BNE .skip19then
.condpart20
	LDX #<playercolor20then_0
	STX player0color
	LDA #>playercolor20then_0
	STA player0color+1
.skip19then
.skipL058
.
 ; 

.L059 ;  rem jogador 2

.
 ; 

.L060 ;  if g  =  10  &&  p  =  0 then player1:

	LDA g
	CMP #10
     BNE .skipL060
.condpart21
	LDA p
	CMP #0
     BNE .skip21then
.condpart22
	LDX #<player22then_1
	STX player1pointerlo
	LDA #>player22then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skip21then
.skipL060
.L061 ;  if g  =  10  &&  p  =  0 then player1color:

	LDA g
	CMP #10
     BNE .skipL061
.condpart23
	LDA p
	CMP #0
     BNE .skip23then
.condpart24
	LDX #<playercolor24then_1
	STX player1color
	LDA #>playercolor24then_1
	STA player1color+1
.skip23then
.skipL061
.L062 ;  if g  =  20  &&  p  =  0 then player1:

	LDA g
	CMP #20
     BNE .skipL062
.condpart25
	LDA p
	CMP #0
     BNE .skip25then
.condpart26
	LDX #<player26then_1
	STX player1pointerlo
	LDA #>player26then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skip25then
.skipL062
.L063 ;  if g  =  20  &&  p  =  0 then player1color:

	LDA g
	CMP #20
     BNE .skipL063
.condpart27
	LDA p
	CMP #0
     BNE .skip27then
.condpart28
	LDX #<playercolor28then_1
	STX player1color
	LDA #>playercolor28then_1
	STA player1color+1
.skip27then
.skipL063
.
 ; 

.L064 ;  if g  =  10  &&  p  =  1 then player1:

	LDA g
	CMP #10
     BNE .skipL064
.condpart29
	LDA p
	CMP #1
     BNE .skip29then
.condpart30
	LDX #<player30then_1
	STX player1pointerlo
	LDA #>player30then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skip29then
.skipL064
.L065 ;  if g  =  10  &&  p  =  1 then player1color:

	LDA g
	CMP #10
     BNE .skipL065
.condpart31
	LDA p
	CMP #1
     BNE .skip31then
.condpart32
	LDX #<playercolor32then_1
	STX player1color
	LDA #>playercolor32then_1
	STA player1color+1
.skip31then
.skipL065
.L066 ;  if g  =  20  &&  p  =  1 then player1:

	LDA g
	CMP #20
     BNE .skipL066
.condpart33
	LDA p
	CMP #1
     BNE .skip33then
.condpart34
	LDX #<player34then_1
	STX player1pointerlo
	LDA #>player34then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skip33then
.skipL066
.L067 ;  if g  =  20  &&  p  =  1 then player1color:

	LDA g
	CMP #20
     BNE .skipL067
.condpart35
	LDA p
	CMP #1
     BNE .skip35then
.condpart36
	LDX #<playercolor36then_1
	STX player1color
	LDA #>playercolor36then_1
	STA player1color+1
.skip35then
.skipL067
.
 ; 

.L068 ;  if f = 20 then f = 0

	LDA f
	CMP #20
     BNE .skipL068
.condpart37
	LDA #0
	STA f
.skipL068
.L069 ;  if g = 20 then g = 0

	LDA g
	CMP #20
     BNE .skipL069
.condpart38
	LDA #0
	STA g
.skipL069
.
 ; 

.L070 ;  rem velocidade  

.
 ; 

.L071 ;  rem a = a + 1  if a < 4 then goto checkfire

.L072 ;  rem a = 0

.
 ; 

.
 ; 

.L073 ;  rem forma que o vilao persegue o heroi 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L074 ;  rem verificando se o tiro saiu do heroi 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L075 ;  rem tiro emitido inicia o jogo e sons de fundo e disparo  

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L076 ;  rem se o tiro acertar o vilao somar pontos ordem crescente surgir outro vilao na tela e som de vilao abatido 

.
 ; 

.
 ; 

.
 ; 

.L077 ;  rem se o vilao encostar no heroi som de explosao retorna para o titulo 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L078 ;  rem configuracao de limite de tela 

.
 ; 

.L079 ;  if m  =  1  &&  collision(player0,playfield) then player0y  =  player0y  +  1

	LDA m
	CMP #1
     BNE .skipL079
.condpart39
	bit 	CXP0FB
	BPL .skip39then
.condpart40
	INC player0y
.skip39then
.skipL079
.L080 ;  if m  =  2  &&  collision(player0,playfield) then player0x  =  player0x  +  1

	LDA m
	CMP #2
     BNE .skipL080
.condpart41
	bit 	CXP0FB
	BPL .skip41then
.condpart42
	INC player0x
.skip41then
.skipL080
.L081 ;  if m  =  3  &&  collision(player0,playfield) then player0y  =  player0y  -  1

	LDA m
	CMP #3
     BNE .skipL081
.condpart43
	bit 	CXP0FB
	BPL .skip43then
.condpart44
	DEC player0y
.skip43then
.skipL081
.L082 ;  if m  =  4  &&  collision(player0,playfield) then player0x  =  player0x  -  1

	LDA m
	CMP #4
     BNE .skipL082
.condpart45
	bit 	CXP0FB
	BPL .skip45then
.condpart46
	DEC player0x
.skip45then
.skipL082
.
 ; 

.L083 ;  if n  =  1  &&  collision(player1,playfield) then player1y  =  player1y  +  1

	LDA n
	CMP #1
     BNE .skipL083
.condpart47
	bit 	CXP1FB
	BPL .skip47then
.condpart48
	INC player1y
.skip47then
.skipL083
.L084 ;  if n  =  2  &&  collision(player1,playfield) then player1x  =  player1x  +  1

	LDA n
	CMP #2
     BNE .skipL084
.condpart49
	bit 	CXP1FB
	BPL .skip49then
.condpart50
	INC player1x
.skip49then
.skipL084
.L085 ;  if n  =  3  &&  collision(player1,playfield) then player1y  =  player1y  -  1

	LDA n
	CMP #3
     BNE .skipL085
.condpart51
	bit 	CXP1FB
	BPL .skip51then
.condpart52
	DEC player1y
.skip51then
.skipL085
.L086 ;  if n  =  4  &&  collision(player1,playfield) then player1x  =  player1x  -  1

	LDA n
	CMP #4
     BNE .skipL086
.condpart53
	bit 	CXP1FB
	BPL .skip53then
.condpart54
	DEC player1x
.skip53then
.skipL086
.
 ; 

.L087 ;  rem configuracao de movimentos

.
 ; 

.L088 ;  if joy0up  &&  !collision(player0,playfield) then player0y  =  player0y  -  1  :  m  =  1

 lda #$10
 bit SWCHA
	BNE .skipL088
.condpart55
	bit 	CXP0FB
	BMI .skip55then
.condpart56
	DEC player0y
	LDA #1
	STA m
.skip55then
.skipL088
.L089 ;  if joy0left  &&  !collision(player0,playfield) then player0x  =  player0x  -  1  :  REFP0  =  8  :  m  =  2

 bit SWCHA
	BVS .skipL089
.condpart57
	bit 	CXP0FB
	BMI .skip57then
.condpart58
	DEC player0x
	LDA #8
	STA REFP0
	LDA #2
	STA m
.skip57then
.skipL089
.L090 ;  if joy0down  &&  !collision(player0,playfield) then player0y  =  player0y  +  1  :  m  =  3

 lda #$20
 bit SWCHA
	BNE .skipL090
.condpart59
	bit 	CXP0FB
	BMI .skip59then
.condpart60
	INC player0y
	LDA #3
	STA m
.skip59then
.skipL090
.L091 ;  if joy0right  &&  !collision(player0,playfield) then player0x  =  player0x  +  1  :  m  =  4  :  REFP0  =  0

 bit SWCHA
	BMI .skipL091
.condpart61
	bit 	CXP0FB
	BMI .skip61then
.condpart62
	INC player0x
	LDA #4
	STA m
	LDA #0
	STA REFP0
.skip61then
.skipL091
.
 ; 

.L092 ;  if joy1up  &&  !collision(player1,playfield) then player1y  =  player1y  -  1  :  n  =  1

 lda #1
 bit SWCHA
	BNE .skipL092
.condpart63
	bit 	CXP1FB
	BMI .skip63then
.condpart64
	DEC player1y
	LDA #1
	STA n
.skip63then
.skipL092
.L093 ;  if joy1left  &&  !collision(player1,playfield) then player1x  =  player1x  -  1  :  REFP1  =  8  :  n  =  2

 lda #4
 bit SWCHA
	BNE .skipL093
.condpart65
	bit 	CXP1FB
	BMI .skip65then
.condpart66
	DEC player1x
	LDA #8
	STA REFP1
	LDA #2
	STA n
.skip65then
.skipL093
.L094 ;  if joy1down  &&  !collision(player1,playfield) then player1y  =  player1y  +  1  :  n  =  3

 lda #2
 bit SWCHA
	BNE .skipL094
.condpart67
	bit 	CXP1FB
	BMI .skip67then
.condpart68
	INC player1y
	LDA #3
	STA n
.skip67then
.skipL094
.L095 ;  if joy1right  &&  !collision(player1,playfield) then player1x  =  player1x  +  1  :  n  =  4  :  REFP1  =  0

 lda #8
 bit SWCHA
	BNE .skipL095
.condpart69
	bit 	CXP1FB
	BMI .skip69then
.condpart70
	INC player1x
	LDA #4
	STA n
	LDA #0
	STA REFP1
.skip69then
.skipL095
.
 ; 

.L096 ;  if collision(ball,player0)  &&  z  =  0 then p  =  0  :  q  =  1  :  ballx  =  100  :  bally  =  130  :  z  =  1

	bit 	CXP0FB
	BVC .skipL096
.condpart71
	LDA z
	CMP #0
     BNE .skip71then
.condpart72
	LDA #0
	STA p
	LDA #1
	STA q
	LDA #100
	STA ballx
	LDA #130
	STA bally
	LDA #1
	STA z
.skip71then
.skipL096
.L097 ;  if collision(ball,player1)  &&  z  =  0 then p  =  1  :  q  =  0  :  ballx  =  100  :  bally  =  130  :  z  =  1

	bit 	CXP1FB
	BVC .skipL097
.condpart73
	LDA z
	CMP #0
     BNE .skip73then
.condpart74
	LDA #1
	STA p
	LDA #0
	STA q
	LDA #100
	STA ballx
	LDA #130
	STA bally
	LDA #1
	STA z
.skip73then
.skipL097
.
 ; 

.L098 ;  z  =  0

	LDA #0
	STA z
.L099 ;  if collision(player0,player1)  &&  p  =  1  &&  q  =  0  &&  z  =  0 then p  =  0  :  q  =  1  :  z  =  1  :  player1x  =  player1x  +  30

	bit 	CXPPMM
	BPL .skipL099
.condpart75
	LDA p
	CMP #1
     BNE .skip75then
.condpart76
	LDA q
	CMP #0
     BNE .skip76then
.condpart77
	LDA z
	CMP #0
     BNE .skip77then
.condpart78
	LDA #0
	STA p
	LDA #1
	STA q
	STA z
	LDA player1x
	CLC
	ADC #30
	STA player1x
.skip77then
.skip76then
.skip75then
.skipL099
.L0100 ;  if collision(player1,player0)  &&  p  =  0  &&  q  =  1  &&  z  =  0 then p  =  1  :  q  =  0  :  z  =  1  :  player0x  =  player0x  -  30

	bit 	CXPPMM
	BPL .skipL0100
.condpart79
	LDA p
	CMP #0
     BNE .skip79then
.condpart80
	LDA q
	CMP #1
     BNE .skip80then
.condpart81
	LDA z
	CMP #0
     BNE .skip81then
.condpart82
	LDA #1
	STA p
	LDA #0
	STA q
	LDA #1
	STA z
	LDA player0x
	SEC
	SBC #30
	STA player0x
.skip81then
.skip80then
.skip79then
.skipL0100
.L0101 ;  z  =  0

	LDA #0
	STA z
.
 ; 

.L0102 ;  if q  =  1  &&  player0x  >=  140 then _sc1  =  _sc1  +  $1  :  goto reset

	LDA q
	CMP #1
     BNE .skipL0102
.condpart83
	LDA player0x
	CMP #140
     BCC .skip83then
.condpart84
	LDA _sc1
	CLC
	ADC #$1
	STA _sc1
 jmp .reset

.skip83then
.skipL0102
.L0103 ;  if p  =  1  &&  player1x  <=  25 then _sc3  =  _sc3  +  $10  :  goto reset

	LDA p
	CMP #1
     BNE .skipL0103
.condpart85
	LDA #25
	CMP player1x
     BCC .skip85then
.condpart86
	LDA _sc3
	CLC
	ADC #$10
	STA _sc3
 jmp .reset

.skip85then
.skipL0103
.
 ; 

.L0104 ;  drawscreen

 jsr drawscreen
.
 ; 

.
 ; 

.skipmove
 ; skipmove

.L0105 ;  if player0x  <  player1x then REFP1  =  8

	LDA player0x
	CMP player1x
     BCS .skipL0105
.condpart87
	LDA #8
	STA REFP1
.skipL0105
.L0106 ;  if player0x  >  player1x then REFP1  =  0

	LDA player1x
	CMP player0x
     BCS .skipL0106
.condpart88
	LDA #0
	STA REFP1
.skipL0106
.L0107 ;  if player1x  <  player0x then REFP0  =  8

	LDA player1x
	CMP player0x
     BCS .skipL0107
.condpart89
	LDA #8
	STA REFP0
.skipL0107
.L0108 ;  if player1x  >  player0x then REFP0  =  0

	LDA player0x
	CMP player1x
     BCS .skipL0108
.condpart90
	LDA #0
	STA REFP0
.skipL0108
.L0109 ;  goto main

 jmp .main

.
 ; 

.
 ; 

.L0110 ;  rem fim do loop principal 

.
 ; 

.
 ; 

.L0111 ;  rem configuracao de sons do jogo 

.
 ; 

.L0112 ;  rem som dos pontos ( quando o vilao morre)

.
 ; 

.pointsound
 ; pointsound

.L0113 ;  AUDV0  =  0

	LDA #0
	STA AUDV0
.L0114 ;  AUDC0  =  8

	LDA #8
	STA AUDC0
.L0115 ;  AUDF0  =  3

	LDA #3
	STA AUDF0
.
 ; 

.L0116 ;  p  =  p  +  1

	INC p
.L0117 ;  drawscreen

 jsr drawscreen
.L0118 ;  rem tempo que o som toca 

.L0119 ;  if p  <  8 then pointsound

	LDA p
	CMP #8
 if ((* - .pointsound) < 127) && ((* - .pointsound) > -128)
	bcc .pointsound
 else
	bcs .0skippointsound
	jmp .pointsound
.0skippointsound
 endif
.L0120 ;  p  =  0

	LDA #0
	STA p
.L0121 ;  AUDV0  =  0 :  AUDC0  =  0 :  AUDF0  =  0

	LDA #0
	STA AUDV0
	STA AUDC0
	STA AUDF0
.L0122 ;  goto main

 jmp .main

.
 ; 

.L0123 ;  rem som do tiro 

.
 ; 

.firesound
 ; firesound

.L0124 ;  AUDV0  =  0

	LDA #0
	STA AUDV0
.L0125 ;  AUDC0  =  8

	LDA #8
	STA AUDC0
.L0126 ;  AUDF0  =  18

	LDA #18
	STA AUDF0
.
 ; 

.L0127 ;  rem som de fundo (fica mis facil configurar aqui no tiro) 

.
 ; 

.L0128 ;  AUDV1  =  0

	LDA #0
	STA AUDV1
.L0129 ;  AUDC1  =  2

	LDA #2
	STA AUDC1
.L0130 ;  AUDF1  =  31

	LDA #31
	STA AUDF1
.
 ; 

.L0131 ;  p  =  p  +  1

	INC p
.L0132 ;  drawscreen

 jsr drawscreen
.L0133 ;  rem tempo que o som toca

.L0134 ;  if p  <  5 then firesound

	LDA p
	CMP #5
 if ((* - .firesound) < 127) && ((* - .firesound) > -128)
	bcc .firesound
 else
	bcs .1skipfiresound
	jmp .firesound
.1skipfiresound
 endif
.L0135 ;  p  =  0

	LDA #0
	STA p
.L0136 ;  AUDV0  =  0 :  AUDC0  =  0 :  AUDF0  =  0

	LDA #0
	STA AUDV0
	STA AUDC0
	STA AUDF0
.L0137 ;  goto main

 jmp .main

.
 ; 

.L0138 ;  rem Som do heroi morredo 

.deadsound
 ; deadsound

.L0139 ;  AUDV1  =  0

	LDA #0
	STA AUDV1
.L0140 ;  AUDC1  =  8

	LDA #8
	STA AUDC1
.L0141 ;  AUDF1  =  31

	LDA #31
	STA AUDF1
.L0142 ;  p  =  p  +  1

	INC p
.L0143 ;  drawscreen

 jsr drawscreen
.L0144 ;  rem tempo que o som toca 

.L0145 ;  if p  <  30 then deadsound

	LDA p
	CMP #30
 if ((* - .deadsound) < 127) && ((* - .deadsound) > -128)
	bcc .deadsound
 else
	bcs .2skipdeadsound
	jmp .deadsound
.2skipdeadsound
 endif
.L0146 ;  p  =  0

	LDA #0
	STA p
.L0147 ;  AUDV1  =  0 :  AUDC1  =  0 :  AUDF1  =  0

	LDA #0
	STA AUDV1
	STA AUDC1
	STA AUDF1
.L0148 ;  if a  =  0 then goto title

	LDA a
	CMP #0
     BNE .skipL0148
.condpart91
 jmp .title

.skipL0148
.
 ; 

.L0149 ;  goto main

 jmp .main

.
 ; 

.gameover
 ; gameover

.
 ; 

.L0150 ;  if joy0fire  ||  joy1fire then goto credits

 bit INPT4
	BMI .skipL0150
.condpart92
 jmp .condpart93
.skipL0150
 bit INPT5
	BMI .skip44OR
.condpart93
 jmp .credits

.skip44OR
.
 ; 

.L0151 ;  playfield:

  ifconst pfres
	  ldx #(11>pfres)*(pfres*pfwidth-1)+(11<=pfres)*43
  else
	  ldx #((11*pfwidth-1)*((11*pfwidth-1)<47))+(47*((11*pfwidth-1)>=47))
  endif
	jmp pflabel2
PF_data2
	.byte %00000000, %00000000
	if (pfwidth>2)
	.byte %00000000, %00000000
 endif
	.byte %00111110, %10110010
	if (pfwidth>2)
	.byte %10011110, %00010000
 endif
	.byte %00100000, %01010010
	if (pfwidth>2)
	.byte %10010000, %00010000
 endif
	.byte %00100110, %01010101
	if (pfwidth>2)
	.byte %10011100, %00010000
 endif
	.byte %00100010, %00010111
	if (pfwidth>2)
	.byte %10010000, %00010000
 endif
	.byte %00111110, %00000101
	if (pfwidth>2)
	.byte %00011110, %00010000
 endif
	.byte %00011010, %11010000
	if (pfwidth>2)
	.byte %11001100, %00010000
 endif
	.byte %00100101, %01001000
	if (pfwidth>2)
	.byte %00010010, %00010000
 endif
	.byte %00100100, %11000101
	if (pfwidth>2)
	.byte %10010100, %00010000
 endif
	.byte %00100100, %01000101
	if (pfwidth>2)
	.byte %00011000, %00000000
 endif
	.byte %00011000, %11000010
	if (pfwidth>2)
	.byte %11010110, %00010000
 endif
pflabel2
	lda PF_data2,x
	sta playfield,x
	dex
	bpl pflabel2
.L0152 ;  player0x  =  0  :  player0y  =  0

	LDA #0
	STA player0x
	STA player0y
.L0153 ;  player1x  =  0  :  player1y  =  0

	LDA #0
	STA player1x
	STA player1y
.
 ; 

.L0154 ;  drawscreen

 jsr drawscreen
.L0155 ;  goto gameover

 jmp .gameover

.
 ; 

.credits
 ; credits

.
 ; 

.L0156 ;  if joy0up  ||  joy1up then goto title

 lda #$10
 bit SWCHA
	BNE .skipL0156
.condpart94
 jmp .condpart95
.skipL0156
 lda #1
 bit SWCHA
	BNE .skip45OR
.condpart95
 jmp .title

.skip45OR
.
 ; 

.L0157 ;  player0x  =  80  :  player0y  =  47

	LDA #80
	STA player0x
	LDA #47
	STA player0y
.L0158 ;  player1x  =  player0x  +  8  :  player1y  =  47

	LDA player0x
	CLC
	ADC #8
	STA player1x
	LDA #47
	STA player1y
.
 ; 

.
 ; 

.
 ; 

.L0159 ;  rem nomes dos creditos 

.
 ; 

.L0160 ;  player0:

	LDX #<playerL0160_0
	STX player0pointerlo
	LDA #>playerL0160_0
	STA player0pointerhi
	LDA #15
	STA player0height
.L0161 ;  player1:

	LDX #<playerL0161_1
	STX player1pointerlo
	LDA #>playerL0161_1
	STA player1pointerhi
	LDA #15
	STA player1height
.
 ; 

.L0162 ;  COLUBK  =  0

	LDA #0
	STA COLUBK
.L0163 ;  COLUPF  =  $01

	LDA #$01
	STA COLUPF
.L0164 ;  COLUP0  =  $42

	LDA #$42
	STA COLUP0
.L0165 ;  COLUP1  =  $42

	LDA #$42
	STA COLUP1
.
 ; 

.L0166 ;  drawscreen

 jsr drawscreen
.L0167 ;  goto credits

 jmp .credits

 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player6then_0
	.byte         %00100100
	.byte         %00100100
	.byte         %00011000
	.byte         %00011010
	.byte         %00111100
	.byte         %01011000
	.byte         %00010000
	.byte         %00011000
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playercolor8then_0
	.byte     $0E;
	.byte     $0E;
	.byte     $0E;
	.byte     $0E;
	.byte     $0E;
	.byte     $0E;
	.byte     $0E;
	.byte     $0E;
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player10then_0
	.byte         %01000010
	.byte         %00100100
	.byte         %00011000
	.byte         %01011000
	.byte         %00111100
	.byte         %00011010
	.byte         %00010000
	.byte         %00011000
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playercolor12then_0
	.byte     $0E;
	.byte     $0E;
	.byte     $0E;
	.byte     $0E;
	.byte     $0E;
	.byte     $0E;
	.byte     $0E;
	.byte     $0E;
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player14then_0
	.byte         %01000010
	.byte         %00100100
	.byte         %00011000
	.byte         %00011000
	.byte         %00011010
	.byte         %00011101
	.byte         %00010010
	.byte         %00011000
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playercolor16then_0
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player18then_0
	.byte         %00100100
	.byte         %00100100
	.byte         %00011000
	.byte         %00011010
	.byte         %00011101
	.byte         %00011010
	.byte         %00010000
	.byte         %00011000
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playercolor20then_0
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player22then_1
	.byte         %00100100
	.byte         %00100100
	.byte         %00011000
	.byte         %00011010
	.byte         %00111100
	.byte         %01011000
	.byte         %00010000
	.byte         %00011000
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playercolor24then_1
	.byte     $16;
	.byte     $16;
	.byte     $16;
	.byte     $16;
	.byte     $16;
	.byte     $16;
	.byte     $16;
	.byte     $16;
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player26then_1
	.byte         %01000010
	.byte         %00100100
	.byte         %00011000
	.byte         %01011000
	.byte         %00111100
	.byte         %00011010
	.byte         %00010000
	.byte         %00011000
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playercolor28then_1
	.byte     $16;
	.byte     $16;
	.byte     $16;
	.byte     $16;
	.byte     $16;
	.byte     $16;
	.byte     $16;
	.byte     $16;
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player30then_1
	.byte         %01000010
	.byte         %00100100
	.byte         %00011000
	.byte         %00011000
	.byte         %00011010
	.byte         %00011101
	.byte         %00010010
	.byte         %00011000
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playercolor32then_1
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player34then_1
	.byte         %00100100
	.byte         %00100100
	.byte         %00011000
	.byte         %00011010
	.byte         %00011101
	.byte         %00011010
	.byte         %00010000
	.byte         %00011000
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playercolor36then_1
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
 if (<*) > (<(*+15))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playerL0160_0
	.byte         %11100110
	.byte         %10101001
	.byte         %10101001
	.byte         %10001001
	.byte         %11100110
	.byte         %00000000
	.byte         %00000000
	.byte         %11111111
	.byte         %00000000
	.byte         %00000000
	.byte         %00000000
	.byte         %11000110
	.byte         %00101001
	.byte         %00101001
	.byte         %00101001
	.byte         %11110110
 if (<*) > (<(*+15))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playerL0161_1
	.byte         %11101100
	.byte         %01000010
	.byte         %01001110
	.byte         %01001000
	.byte         %11100110
	.byte         %00000000
	.byte         %00000000
	.byte         %11111111
	.byte         %00000000
	.byte         %00000000
	.byte         %00000000
	.byte         %10100110
	.byte         %10101001
	.byte         %11101001
	.byte         %10101001
	.byte         %01000110
 if ECHOFIRST
       echo "    ",[(scoretable - *)]d , "bytes of ROM space left")
 endif 
ECHOFIRST = 1
 
 
 
; Provided under the CC0 license. See the included LICENSE.txt for details.

; feel free to modify the score graphics - just keep each digit 8 high
; and keep the conditional compilation stuff intact
 ifconst ROM2k
   ORG $F7AC-8
 else
   ifconst bankswitch
     if bankswitch == 8
       ORG $2F94-bscode_length
       RORG $FF94-bscode_length
     endif
     if bankswitch == 16
       ORG $4F94-bscode_length
       RORG $FF94-bscode_length
     endif
     if bankswitch == 32
       ORG $8F94-bscode_length
       RORG $FF94-bscode_length
     endif
     if bankswitch == 64
       ORG  $10F80-bscode_length
       RORG $1FF80-bscode_length
     endif
   else
     ORG $FF9C
   endif
 endif

; font equates
.21stcentury = 1
alarmclock = 2     
handwritten = 3    
interrupted = 4    
retroputer = 5    
whimsey = 6
tiny = 7
hex = 8

 ifconst font
   if font == hex
     ORG . - 48
   endif
 endif

scoretable

 ifconst font
  if font == .21stcentury
    include "score_graphics.asm.21stcentury"
  endif
  if font == alarmclock
    include "score_graphics.asm.alarmclock"
  endif
  if font == handwritten
    include "score_graphics.asm.handwritten"
  endif
  if font == interrupted
    include "score_graphics.asm.interrupted"
  endif
  if font == retroputer
    include "score_graphics.asm.retroputer"
  endif
  if font == whimsey
    include "score_graphics.asm.whimsey"
  endif
  if font == tiny
    include "score_graphics.asm.tiny"
  endif
  if font == hex
    include "score_graphics.asm.hex"
  endif
 else ; default font

       .byte %00111100
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %00111100

       .byte %01111110
       .byte %00011000
       .byte %00011000
       .byte %00011000
       .byte %00011000
       .byte %00111000
       .byte %00011000
       .byte %00001000

       .byte %01111110
       .byte %01100000
       .byte %01100000
       .byte %00111100
       .byte %00000110
       .byte %00000110
       .byte %01000110
       .byte %00111100

       .byte %00111100
       .byte %01000110
       .byte %00000110
       .byte %00000110
       .byte %00011100
       .byte %00000110
       .byte %01000110
       .byte %00111100

       .byte %00001100
       .byte %00001100
       .byte %01111110
       .byte %01001100
       .byte %01001100
       .byte %00101100
       .byte %00011100
       .byte %00001100

       .byte %00111100
       .byte %01000110
       .byte %00000110
       .byte %00000110
       .byte %00111100
       .byte %01100000
       .byte %01100000
       .byte %01111110

       .byte %00111100
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %01111100
       .byte %01100000
       .byte %01100010
       .byte %00111100

       .byte %00110000
       .byte %00110000
       .byte %00110000
       .byte %00011000
       .byte %00001100
       .byte %00000110
       .byte %01000010
       .byte %00111110

       .byte %00111100
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %00111100
       .byte %01100110
       .byte %01100110
       .byte %00111100

       .byte %00111100
       .byte %01000110
       .byte %00000110
       .byte %00111110
       .byte %01100110
       .byte %01100110
       .byte %01100110
       .byte %00111100 

       ifnconst DPC_kernel_options
 
         .byte %00000000
         .byte %00000000
         .byte %00000000
         .byte %00000000
         .byte %00000000
         .byte %00000000
         .byte %00000000
         .byte %00000000 

       endif

 endif

 ifconst ROM2k
   ORG $F7FC
 else
   ifconst bankswitch
     if bankswitch == 8
       ORG $2FF4-bscode_length
       RORG $FFF4-bscode_length
     endif
     if bankswitch == 16
       ORG $4FF4-bscode_length
       RORG $FFF4-bscode_length
     endif
     if bankswitch == 32
       ORG $8FF4-bscode_length
       RORG $FFF4-bscode_length
     endif
     if bankswitch == 64
       ORG  $10FE0-bscode_length
       RORG $1FFE0-bscode_length
     endif
   else
     ORG $FFFC
   endif
 endif
; Provided under the CC0 license. See the included LICENSE.txt for details.

 ifconst bankswitch
   if bankswitch == 8
     ORG $2FFC
     RORG $FFFC
   endif
   if bankswitch == 16
     ORG $4FFC
     RORG $FFFC
   endif
   if bankswitch == 32
     ORG $8FFC
     RORG $FFFC
   endif
   if bankswitch == 64
     ORG  $10FF0
     RORG $1FFF0
     lda $ffe0 ; we use wasted space to assist stella with EF format auto-detection
     ORG  $10FF8
     RORG $1FFF8
     ifconst superchip 
       .byte "E","F","S","C"
     else
       .byte "E","F","E","F"
     endif
     ORG  $10FFC
     RORG $1FFFC
   endif
 else
   ifconst ROM2k
     ORG $F7FC
   else
     ORG $FFFC
   endif
 endif
 .word (start & $ffff)
 .word (start & $ffff)

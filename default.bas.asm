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

.L01 ;  rem *********************************** 

.L02 ;  rem *<M4K video aula>                  *

.L03 ;  rem *<add som no game>               *

.L04 ;  rem *<CanalMundo4k>                   *

.L05 ;  rem <canalmundo4k@gmail.com>

.L06 ;  rem *<license free >                        *

.L07 ;  rem ***********************************

.
 ; 

.L08 ;  rem configuracao geral ( tamanho da rom sistemar de cor  da tv ) 

.
 ; 

.L09 ;  set tv ntsc

.L010 ;  set romsize 4k

.L011 ;  set smartbranching on

.
 ; 

.L012 ;  rem titulo 

.
 ; 

.title
 ; title

.
 ; 

.L013 ;  playfield:

  ifconst pfres
	  ldx #(11>pfres)*(pfres*pfwidth-1)+(11<=pfres)*43
  else
	  ldx #((11*pfwidth-1)*((11*pfwidth-1)<47))+(47*((11*pfwidth-1)>=47))
  endif
	jmp pflabel0
PF_data0
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
	.byte %00100001, %00000000
	if (pfwidth>2)
	.byte %01100001, %00001000
 endif
	.byte %01110011, %00000001
	if (pfwidth>2)
	.byte %11100001, %00001100
 endif
	.byte %11001100, %10000011
	if (pfwidth>2)
	.byte %10100001, %00000110
 endif
	.byte %11000000, %11000011
	if (pfwidth>2)
	.byte %00100001, %00000011
 endif
	.byte %11000000, %11000011
	if (pfwidth>2)
	.byte %11111001, %00000011
 endif
	.byte %11100001, %00011011
	if (pfwidth>2)
	.byte %01110001, %00000110
 endif
	.byte %01100001, %00011001
	if (pfwidth>2)
	.byte %01100001, %00001100
 endif
	.byte %00100001, %00000000
	if (pfwidth>2)
	.byte %00100001, %00001000
 endif
pflabel0
	lda PF_data0,x
	sta playfield,x
	dex
	bpl pflabel0
.
 ; 

.L014 ;  rem cor do titulo e fundo da tela 

.
 ; 

.L015 ;  COLUBK  =  216

	LDA #216
	STA COLUBK
.L016 ;  COLUPF  =  $90

	LDA #$90
	STA COLUPF
.L017 ;  drawscreen

 jsr drawscreen
.
 ; 

.L018 ;  rem quando finalizar o game esconder os personagens fora da tela 

.
 ; 

.L019 ;  player0x  =  1  :  player0y  =  1

	LDA #1
	STA player0x
	STA player0y
.L020 ;  player1x  =  1  :  player1y  =  1

	LDA #1
	STA player1x
	STA player1y
.
 ; 

.L021 ;  rem se o acionado o botao de tiro pular o titulo 

.
 ; 

.L022 ;  if joy0fire  ||  joy1fire then goto skiptitle

 bit INPT4
	BMI .skipL022
.condpart0
 jmp .condpart1
.skipL022
 bit INPT5
	BMI .skip0OR
.condpart1
 jmp .skiptitle

.skip0OR
.
 ; 

.L023 ;  rem se nao acionado o botao de tiro permanecer no titulo 

.
 ; 

.L024 ;  goto title

 jmp .title

.
 ; 

.L025 ;  rem inicio do loop principal 

.
 ; 

.skiptitle
 ; skiptitle

.
 ; 

.L026 ;  rem tela de jogo inicial (apos o titulo )

.
 ; 

.L027 ;  playfield:

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

.startposx
 ; startposx

.L028 ;  player1x  =  rand

 jsr randomize
	STA player1x
.L029 ;  if player1x  >  150 then goto startposx

	LDA #150
	CMP player1x
     BCS .skipL029
.condpart2
 jmp .startposx

.skipL029
.startposy
 ; startposy

.L030 ;  player1y  =  rand

 jsr randomize
	STA player1y
.L031 ;  if player1y  >  100 then goto startposy

	LDA #100
	CMP player1y
     BCS .skipL031
.condpart3
 jmp .startposy

.skipL031
.
 ; 

.L032 ;  rem posicao dos personagens na tela 

.
 ; 

.L033 ;  player0x  =  20  :  player0y  =  47

	LDA #20
	STA player0x
	LDA #47
	STA player0y
.L034 ;  player1x  =  130  :  player1y  =  47

	LDA #130
	STA player1x
	LDA #47
	STA player1y
.
 ; 

.L035 ;  rem configura?o do missil saindo do heroi 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L036 ;  rem cor do fundo da tela 

.
 ; 

.L037 ;  COLUBK  =  216

	LDA #216
	STA COLUBK
.
 ; 

.L038 ;  rem configuracao das contagens de pontos e cor do score 

.
 ; 

.L039 ;  score  =  00000  :  scorecolor  =  $0E

	LDA #$00
	STA score+2
	LDA #$00
	STA score+1
	LDA #$00
	STA score
	LDA #$0E
	STA scorecolor
.L040 ;  m  =  0

	LDA #0
	STA m
.
 ; 

.L041 ;  rem loop principal 

.
 ; 

.main
 ; main

.
 ; 

.L042 ;  rem cor dos personagens e da base do canhao (heroi)

.
 ; 

.L043 ;  COLUP1  =  $00

	LDA #$00
	STA COLUP1
.L044 ;  COLUP0  =  $0E

	LDA #$0E
	STA COLUP0
.L045 ;  COLUPF  =  $90

	LDA #$90
	STA COLUPF
.L046 ;  f = f + 1

	INC f
.L047 ;  g = g + 1

	INC g
.
 ; 

.L048 ;  rem heroi 

.
 ; 

.L049 ;  if f = 10 then player0:

	LDA f
	CMP #10
     BNE .skipL049
.condpart4
	LDX #<player4then_0
	STX player0pointerlo
	LDA #>player4then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skipL049
.
 ; 

.L050 ;  rem vilao 

.
 ; 

.L051 ;  if g = 10 then player1:

	LDA g
	CMP #10
     BNE .skipL051
.condpart5
	LDX #<player5then_1
	STX player1pointerlo
	LDA #>player5then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skipL051
.
 ; 

.L052 ;  if f = 10 then f = 0

	LDA f
	CMP #10
     BNE .skipL052
.condpart6
	LDA #0
	STA f
.skipL052
.L053 ;  if g = 10 then g = 0

	LDA g
	CMP #10
     BNE .skipL053
.condpart7
	LDA #0
	STA g
.skipL053
.
 ; 

.L054 ;  rem velocidade que o vilao ataca o heroi 

.
 ; 

.L055 ;  a  =  a  +  1  :  if a  <  4 then goto checkfire

	INC a
	LDA a
	CMP #4
     BCS .skipL055
.condpart8
 jmp .checkfire

.skipL055
.L056 ;  a  =  0

	LDA #0
	STA a
.
 ; 

.L057 ;  rem forma que o vilao persegue o heroi 

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

.L058 ;  rem verificando se o tiro saiu do heroi 

.
 ; 

.checkfire
 ; checkfire

.L059 ;  if missile0y > 240 then goto skip

	LDA #240
	CMP missile0y
     BCS .skipL059
.condpart9
 jmp .skip

.skipL059
.L060 ;  missile0y  =  missile0y  -  2  :  goto draw

	LDA missile0y
	SEC
	SBC #2
	STA missile0y
 jmp .draw

.
 ; 

.skip
 ; skip

.L061 ;  rem tiro emitido inicia o jogo e sons de fundo e disparo  

.L062 ;  if joy0fire then missile0y = player0y - 2 : missile0x = player0x + 4 :  goto firesound

 bit INPT4
	BMI .skipL062
.condpart10
	LDA player0y
	SEC
	SBC #2
	STA missile0y
	LDA player0x
	CLC
	ADC #4
	STA missile0x
 jmp .firesound

.skipL062
.
 ; 

.draw
 ; draw

.L063 ;  drawscreen

 jsr drawscreen
.
 ; 

.L064 ;  rem se o tiro acertar o vilao somar pontos ordem crescente surgir outro vilao na tela e som de vilao abatido 

.
 ; 

.L065 ;  if collision(missile0,player1) then score = score + 1 : player1x = rand / 2 : player1y = 0 : missile0y = 255  :  goto pointsound

	bit 	CXM0P
	BPL .skipL065
.condpart11
	SED
	CLC
	LDA score+2
	ADC #$01
	STA score+2
	LDA score+1
	ADC #$00
	STA score+1
	LDA score
	ADC #$00
	STA score
	CLD
 jsr randomize
	lsr
	STA player1x
	LDA #0
	STA player1y
	LDA #255
	STA missile0y
 jmp .pointsound

.skipL065
.
 ; 

.L066 ;  rem se o vilao encostar no heroi som de explosao retorna para o titulo 

.
 ; 

.L067 ;  if collision(player0,player1) goto deadsound  :  then title

	bit 	CXPPMM
 if ((* - .deadsound) < 127) && ((* - .deadsound) > -128)
	bmi .deadsound
 else
	bpl .0skipdeadsound
	jmp .deadsound
.0skipdeadsound
 endif
.
 ; 

.
 ; 

.L068 ;  rem configuracao de limite de tela 

.
 ; 

.L069 ;  if m  =  1  &&  collision(player0,playfield) then player0y  =  player0y  +  1  :  goto skipmove

	LDA m
	CMP #1
     BNE .skipL069
.condpart12
	bit 	CXP0FB
	BPL .skip12then
.condpart13
	INC player0y
 jmp .skipmove

.skip12then
.skipL069
.L070 ;  if m  =  2  &&  collision(player0,playfield) then player0x  =  player0x  +  1  :  goto skipmove

	LDA m
	CMP #2
     BNE .skipL070
.condpart14
	bit 	CXP0FB
	BPL .skip14then
.condpart15
	INC player0x
 jmp .skipmove

.skip14then
.skipL070
.L071 ;  if m  =  3  &&  collision(player0,playfield) then player0y  =  player0y  -  1  :  goto skipmove

	LDA m
	CMP #3
     BNE .skipL071
.condpart16
	bit 	CXP0FB
	BPL .skip16then
.condpart17
	DEC player0y
 jmp .skipmove

.skip16then
.skipL071
.L072 ;  if m  =  4  &&  collision(player0,playfield) then player0x  =  player0x  -  1  :  goto skipmove

	LDA m
	CMP #4
     BNE .skipL072
.condpart18
	bit 	CXP0FB
	BPL .skip18then
.condpart19
	DEC player0x
 jmp .skipmove

.skip18then
.skipL072
.
 ; 

.L073 ;  if n  =  1  &&  collision(player1,playfield) then player1y  =  player1y  +  1  :  goto skipmove

	LDA n
	CMP #1
     BNE .skipL073
.condpart20
	bit 	CXP1FB
	BPL .skip20then
.condpart21
	INC player1y
 jmp .skipmove

.skip20then
.skipL073
.L074 ;  if n  =  2  &&  collision(player1,playfield) then player1x  =  player1x  +  1  :  goto skipmove

	LDA n
	CMP #2
     BNE .skipL074
.condpart22
	bit 	CXP1FB
	BPL .skip22then
.condpart23
	INC player1x
 jmp .skipmove

.skip22then
.skipL074
.L075 ;  if n  =  3  &&  collision(player1,playfield) then player1y  =  player1y  -  1  :  goto skipmove

	LDA n
	CMP #3
     BNE .skipL075
.condpart24
	bit 	CXP1FB
	BPL .skip24then
.condpart25
	DEC player1y
 jmp .skipmove

.skip24then
.skipL075
.L076 ;  if n  =  4  &&  collision(player1,playfield) then player1x  =  player1x  -  1  :  goto skipmove

	LDA n
	CMP #4
     BNE .skipL076
.condpart26
	bit 	CXP1FB
	BPL .skip26then
.condpart27
	DEC player1x
 jmp .skipmove

.skip26then
.skipL076
.
 ; 

.L077 ;  rem configuracao de movimentos do heroi 

.
 ; 

.L078 ;  if joy0up  &&  !collision(player0,playfield) then player0y  =  player0y  -  1  :  m  =  1  :  goto skipmove

 lda #$10
 bit SWCHA
	BNE .skipL078
.condpart28
	bit 	CXP0FB
	BMI .skip28then
.condpart29
	DEC player0y
	LDA #1
	STA m
 jmp .skipmove

.skip28then
.skipL078
.L079 ;  if joy0left  &&  !collision(player0,playfield) then player0x  =  player0x  -  1  :  REFP0  =  8  :  m  =  2  :  goto skipmove

 bit SWCHA
	BVS .skipL079
.condpart30
	bit 	CXP0FB
	BMI .skip30then
.condpart31
	DEC player0x
	LDA #8
	STA REFP0
	LDA #2
	STA m
 jmp .skipmove

.skip30then
.skipL079
.L080 ;  if joy0down  &&  !collision(player0,playfield) then player0y  =  player0y  +  1  :  m  =  3  :  goto skipmove

 lda #$20
 bit SWCHA
	BNE .skipL080
.condpart32
	bit 	CXP0FB
	BMI .skip32then
.condpart33
	INC player0y
	LDA #3
	STA m
 jmp .skipmove

.skip32then
.skipL080
.L081 ;  if joy0right  &&  !collision(player0,playfield) then player0x  =  player0x  +  1  :  m  =  4  :  REFP0  =  0  :  goto skipmove

 bit SWCHA
	BMI .skipL081
.condpart34
	bit 	CXP0FB
	BMI .skip34then
.condpart35
	INC player0x
	LDA #4
	STA m
	LDA #0
	STA REFP0
 jmp .skipmove

.skip34then
.skipL081
.
 ; 

.L082 ;  if joy1up  &&  !collision(player1,playfield) then player1y  =  player1y  -  1  :  n  =  1  :  goto skipmove

 lda #1
 bit SWCHA
	BNE .skipL082
.condpart36
	bit 	CXP1FB
	BMI .skip36then
.condpart37
	DEC player1y
	LDA #1
	STA n
 jmp .skipmove

.skip36then
.skipL082
.L083 ;  if joy1left  &&  !collision(player1,playfield) then player1x  =  player1x  -  1  :  REFP1  =  8  :  n  =  2  :  goto skipmove

 lda #4
 bit SWCHA
	BNE .skipL083
.condpart38
	bit 	CXP1FB
	BMI .skip38then
.condpart39
	DEC player1x
	LDA #8
	STA REFP1
	LDA #2
	STA n
 jmp .skipmove

.skip38then
.skipL083
.L084 ;  if joy1down  &&  !collision(player1,playfield) then player1y  =  player1y  +  1  :  n  =  3  :  goto skipmove

 lda #2
 bit SWCHA
	BNE .skipL084
.condpart40
	bit 	CXP1FB
	BMI .skip40then
.condpart41
	INC player1y
	LDA #3
	STA n
 jmp .skipmove

.skip40then
.skipL084
.L085 ;  if joy1right  &&  !collision(player1,playfield) then player1x  =  player1x  +  1  :  n  =  4  :  REFP1  =  0  :  goto skipmove

 lda #8
 bit SWCHA
	BNE .skipL085
.condpart42
	bit 	CXP1FB
	BMI .skip42then
.condpart43
	INC player1x
	LDA #4
	STA n
	LDA #0
	STA REFP1
 jmp .skipmove

.skip42then
.skipL085
.
 ; 

.skipmove
 ; skipmove

.L086 ;  if player0x  <  player1x then REFP1  =  8

	LDA player0x
	CMP player1x
     BCS .skipL086
.condpart44
	LDA #8
	STA REFP1
.skipL086
.L087 ;  if player0x  >  player1x then REFP1  =  0

	LDA player1x
	CMP player0x
     BCS .skipL087
.condpart45
	LDA #0
	STA REFP1
.skipL087
.L088 ;  if player1x  <  player0x then REFP0  =  8

	LDA player1x
	CMP player0x
     BCS .skipL088
.condpart46
	LDA #8
	STA REFP0
.skipL088
.L089 ;  if player1x  >  player0x then REFP0  =  0

	LDA player0x
	CMP player1x
     BCS .skipL089
.condpart47
	LDA #0
	STA REFP0
.skipL089
.L090 ;  goto main

 jmp .main

.
 ; 

.
 ; 

.L091 ;  rem fim do loop principal 

.
 ; 

.
 ; 

.L092 ;  rem configuracao de sons do jogo 

.
 ; 

.L093 ;  rem som dos pontos ( quando o vilao morre)

.
 ; 

.pointsound
 ; pointsound

.L094 ;  AUDV0  =  15

	LDA #15
	STA AUDV0
.L095 ;  AUDC0  = 8

	LDA #8
	STA AUDC0
.L096 ;  AUDF0  =  3

	LDA #3
	STA AUDF0
.
 ; 

.L097 ;  p  =  p  +  1

	INC p
.L098 ;  drawscreen

 jsr drawscreen
.L099 ;  rem tempo que o som toca 

.L0100 ;  if p  <  8 then pointsound

	LDA p
	CMP #8
 if ((* - .pointsound) < 127) && ((* - .pointsound) > -128)
	bcc .pointsound
 else
	bcs .1skippointsound
	jmp .pointsound
.1skippointsound
 endif
.L0101 ;  p  =  0

	LDA #0
	STA p
.L0102 ;  AUDV0  =  0 :  AUDC0  =  0 :  AUDF0  =  0

	LDA #0
	STA AUDV0
	STA AUDC0
	STA AUDF0
.L0103 ;  goto main

 jmp .main

.
 ; 

.L0104 ;  rem som do tiro 

.
 ; 

.firesound
 ; firesound

.L0105 ;  AUDV0  =  15

	LDA #15
	STA AUDV0
.L0106 ;  AUDC0  = 8

	LDA #8
	STA AUDC0
.L0107 ;  AUDF0  =  18

	LDA #18
	STA AUDF0
.
 ; 

.L0108 ;  rem som de fundo (fica mis facil configurar aqui no tiro) 

.
 ; 

.L0109 ;  AUDV1  =  2

	LDA #2
	STA AUDV1
.L0110 ;  AUDC1  =  2

	LDA #2
	STA AUDC1
.L0111 ;  AUDF1  =  31

	LDA #31
	STA AUDF1
.
 ; 

.L0112 ;  p  =  p  +  1

	INC p
.L0113 ;  drawscreen

 jsr drawscreen
.L0114 ;  rem tempo que o som toca

.L0115 ;  if p  <  5 then firesound

	LDA p
	CMP #5
 if ((* - .firesound) < 127) && ((* - .firesound) > -128)
	bcc .firesound
 else
	bcs .2skipfiresound
	jmp .firesound
.2skipfiresound
 endif
.L0116 ;  p  =  0

	LDA #0
	STA p
.L0117 ;  AUDV0  =  0 :  AUDC0  =  0 :  AUDF0  =  0

	LDA #0
	STA AUDV0
	STA AUDC0
	STA AUDF0
.L0118 ;  goto main

 jmp .main

.
 ; 

.L0119 ;  rem Som do heroi morredo 

.deadsound
 ; deadsound

.L0120 ;  AUDV1  =  15

	LDA #15
	STA AUDV1
.L0121 ;  AUDC1  =  8

	LDA #8
	STA AUDC1
.L0122 ;  AUDF1  =  31

	LDA #31
	STA AUDF1
.L0123 ;  p  =  p  +  1

	INC p
.L0124 ;  drawscreen

 jsr drawscreen
.L0125 ;  rem tempo que o som toca 

.L0126 ;  if p  <  30 then deadsound

	LDA p
	CMP #30
 if ((* - .deadsound) < 127) && ((* - .deadsound) > -128)
	bcc .deadsound
 else
	bcs .3skipdeadsound
	jmp .deadsound
.3skipdeadsound
 endif
.L0127 ;  p  =  0

	LDA #0
	STA p
.L0128 ;  AUDV1  =  0 :  AUDC1  =  0 :  AUDF1  =  0

	LDA #0
	STA AUDV1
	STA AUDC1
	STA AUDF1
.L0129 ;  if a  =  0 then goto title

	LDA a
	CMP #0
     BNE .skipL0129
.condpart48
 jmp .title

.skipL0129
.
 ; 

.L0130 ;  goto main

 jmp .main

.
 ; 

.
 ; 

.L0131 ;  rem fim da programacao  ( Canal Mundo4k)
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player4then_0
	.byte  %01111100
	.byte  %00111000
	.byte  %00010000
	.byte  %00010000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
	.byte  %00000000
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player5then_1
	.byte  %10000001
	.byte  %10011001
	.byte  %10111101
	.byte  %11100111
	.byte  %10111101
	.byte  %10011001
	.byte  %10000001
	.byte  %00000000
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

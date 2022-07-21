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
 
 
 

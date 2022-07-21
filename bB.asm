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

.L013 ;  playfield:

  ifconst pfres
	  ldx #(11>pfres)*(pfres*pfwidth-1)+(11<=pfres)*43
  else
	  ldx #((11*pfwidth-1)*((11*pfwidth-1)<47))+(47*((11*pfwidth-1)>=47))
  endif
	jmp pflabel0
PF_data0
	.byte %00111101, %10111010
	if (pfwidth>2)
	.byte %10111001, %00001011
 endif
	.byte %00100001, %10010010
	if (pfwidth>2)
	.byte %00101001, %00001010
 endif
	.byte %00111001, %10010010
	if (pfwidth>2)
	.byte %10111101, %00001010
 endif
	.byte %00100001, %10010010
	if (pfwidth>2)
	.byte %00100101, %00001010
 endif
	.byte %00100001, %10010011
	if (pfwidth>2)
	.byte %10111101, %00111011
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

.
 ; 

.L028 ;  rem posicao dos personagens na tela 

.
 ; 

.L029 ;  player0x  =  20  :  player0y  =  47

	LDA #20
	STA player0x
	LDA #47
	STA player0y
.L030 ;  player1x  =  130  :  player1y  =  47

	LDA #130
	STA player1x
	LDA #47
	STA player1y
.L031 ;  ballx  =   (  ( rand  &  50 )   +  50 )   :  bally  =   (  ( rand  &  40 )   +  30 ) 

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
.L032 ;  if ballx  <  50  ||  ballx  >  100 then goto skiptitle

	LDA ballx
	CMP #50
     BCS .skipL032
.condpart2
 jmp .condpart3
.skipL032
	LDA #100
	CMP ballx
     BCS .skip1OR
.condpart3
 jmp .skiptitle

.skip1OR
.L033 ;  if bally  <  50  ||  bally  >  100 then goto skiptitle

	LDA bally
	CMP #50
     BCS .skipL033
.condpart4
 jmp .condpart5
.skipL033
	LDA #100
	CMP bally
     BCS .skip2OR
.condpart5
 jmp .skiptitle

.skip2OR
.L034 ;  ballheight  =  3  :  CTRLPF  =  $21

	LDA #3
	STA ballheight
	LDA #$21
	STA CTRLPF
.
 ; 

.L035 ;  rem configuracao do missil saindo do heroi 

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

.L048 ;  rem jogador 1

.
 ; 

.L049 ;  if f  =  10 then player0:

	LDA f
	CMP #10
     BNE .skipL049
.condpart6
	LDX #<player6then_0
	STX player0pointerlo
	LDA #>player6then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skipL049
.L050 ;  if f  =  10 then player0color:

	LDA f
	CMP #10
     BNE .skipL050
.condpart7
	LDX #<playercolor7then_0
	STX player0color
	LDA #>playercolor7then_0
	STA player0color+1
.skipL050
.L051 ;  if f  =  20 then player0:

	LDA f
	CMP #20
     BNE .skipL051
.condpart8
	LDX #<player8then_0
	STX player0pointerlo
	LDA #>player8then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skipL051
.L052 ;  if f  =  20 then player0color:

	LDA f
	CMP #20
     BNE .skipL052
.condpart9
	LDX #<playercolor9then_0
	STX player0color
	LDA #>playercolor9then_0
	STA player0color+1
.skipL052
.
 ; 

.L053 ;  rem jogador 2

.
 ; 

.L054 ;  if g  =  10 then player1:

	LDA g
	CMP #10
     BNE .skipL054
.condpart10
	LDX #<player10then_1
	STX player1pointerlo
	LDA #>player10then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skipL054
.L055 ;  if g  =  10 then player1color:

	LDA g
	CMP #10
     BNE .skipL055
.condpart11
	LDX #<playercolor11then_1
	STX player1color
	LDA #>playercolor11then_1
	STA player1color+1
.skipL055
.L056 ;  if g  =  20 then player1:

	LDA g
	CMP #20
     BNE .skipL056
.condpart12
	LDX #<player12then_1
	STX player1pointerlo
	LDA #>player12then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skipL056
.L057 ;  if g  =  20 then player1color:

	LDA g
	CMP #20
     BNE .skipL057
.condpart13
	LDX #<playercolor13then_1
	STX player1color
	LDA #>playercolor13then_1
	STA player1color+1
.skipL057
.
 ; 

.
 ; 

.L058 ;  if f = 20 then f = 0

	LDA f
	CMP #20
     BNE .skipL058
.condpart14
	LDA #0
	STA f
.skipL058
.L059 ;  if g = 20 then g = 0

	LDA g
	CMP #20
     BNE .skipL059
.condpart15
	LDA #0
	STA g
.skipL059
.
 ; 

.L060 ;  rem velocidade que o vilao ataca o heroi 

.
 ; 

.L061 ;  a  =  a  +  1  :  if a  <  4 then goto checkfire

	INC a
	LDA a
	CMP #4
     BCS .skipL061
.condpart16
 jmp .checkfire

.skipL061
.L062 ;  a  =  0

	LDA #0
	STA a
.
 ; 

.L063 ;  rem forma que o vilao persegue o heroi 

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

.L064 ;  rem verificando se o tiro saiu do heroi 

.
 ; 

.checkfire
 ; checkfire

.
 ; 

.
 ; 

.
 ; 

.skip
 ; skip

.L065 ;  rem tiro emitido inicia o jogo e sons de fundo e disparo  

.
 ; 

.
 ; 

.draw
 ; draw

.L066 ;  drawscreen

 jsr drawscreen
.
 ; 

.L067 ;  rem se o tiro acertar o vilao somar pontos ordem crescente surgir outro vilao na tela e som de vilao abatido 

.
 ; 

.L068 ;  if collision(ball,player0) then score = score + 1 : player1x = rand / 2 : player1y = 0 : missile0y = 255  :  goto pointsound

	bit 	CXP0FB
	BVC .skipL068
.condpart17
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

.skipL068
.
 ; 

.L069 ;  rem se o vilao encostar no heroi som de explosao retorna para o titulo 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L070 ;  rem configuracao de limite de tela 

.
 ; 

.L071 ;  if m  =  1  &&  collision(player0,playfield) then player0y  =  player0y  +  1  :  goto skipmove

	LDA m
	CMP #1
     BNE .skipL071
.condpart18
	bit 	CXP0FB
	BPL .skip18then
.condpart19
	INC player0y
 jmp .skipmove

.skip18then
.skipL071
.L072 ;  if m  =  2  &&  collision(player0,playfield) then player0x  =  player0x  +  1  :  goto skipmove

	LDA m
	CMP #2
     BNE .skipL072
.condpart20
	bit 	CXP0FB
	BPL .skip20then
.condpart21
	INC player0x
 jmp .skipmove

.skip20then
.skipL072
.L073 ;  if m  =  3  &&  collision(player0,playfield) then player0y  =  player0y  -  1  :  goto skipmove

	LDA m
	CMP #3
     BNE .skipL073
.condpart22
	bit 	CXP0FB
	BPL .skip22then
.condpart23
	DEC player0y
 jmp .skipmove

.skip22then
.skipL073
.L074 ;  if m  =  4  &&  collision(player0,playfield) then player0x  =  player0x  -  1  :  goto skipmove

	LDA m
	CMP #4
     BNE .skipL074
.condpart24
	bit 	CXP0FB
	BPL .skip24then
.condpart25
	DEC player0x
 jmp .skipmove

.skip24then
.skipL074
.
 ; 

.L075 ;  if n  =  1  &&  collision(player1,playfield) then player1y  =  player1y  +  1  :  goto skipmove

	LDA n
	CMP #1
     BNE .skipL075
.condpart26
	bit 	CXP1FB
	BPL .skip26then
.condpart27
	INC player1y
 jmp .skipmove

.skip26then
.skipL075
.L076 ;  if n  =  2  &&  collision(player1,playfield) then player1x  =  player1x  +  1  :  goto skipmove

	LDA n
	CMP #2
     BNE .skipL076
.condpart28
	bit 	CXP1FB
	BPL .skip28then
.condpart29
	INC player1x
 jmp .skipmove

.skip28then
.skipL076
.L077 ;  if n  =  3  &&  collision(player1,playfield) then player1y  =  player1y  -  1  :  goto skipmove

	LDA n
	CMP #3
     BNE .skipL077
.condpart30
	bit 	CXP1FB
	BPL .skip30then
.condpart31
	DEC player1y
 jmp .skipmove

.skip30then
.skipL077
.L078 ;  if n  =  4  &&  collision(player1,playfield) then player1x  =  player1x  -  1  :  goto skipmove

	LDA n
	CMP #4
     BNE .skipL078
.condpart32
	bit 	CXP1FB
	BPL .skip32then
.condpart33
	DEC player1x
 jmp .skipmove

.skip32then
.skipL078
.
 ; 

.L079 ;  rem configuracao de movimentos do heroi 

.
 ; 

.L080 ;  if joy0up  &&  !collision(player0,playfield) then player0y  =  player0y  -  1  :  m  =  1  :  goto skipmove

 lda #$10
 bit SWCHA
	BNE .skipL080
.condpart34
	bit 	CXP0FB
	BMI .skip34then
.condpart35
	DEC player0y
	LDA #1
	STA m
 jmp .skipmove

.skip34then
.skipL080
.L081 ;  if joy0left  &&  !collision(player0,playfield) then player0x  =  player0x  -  1  :  REFP0  =  8  :  m  =  2  :  goto skipmove

 bit SWCHA
	BVS .skipL081
.condpart36
	bit 	CXP0FB
	BMI .skip36then
.condpart37
	DEC player0x
	LDA #8
	STA REFP0
	LDA #2
	STA m
 jmp .skipmove

.skip36then
.skipL081
.L082 ;  if joy0down  &&  !collision(player0,playfield) then player0y  =  player0y  +  1  :  m  =  3  :  goto skipmove

 lda #$20
 bit SWCHA
	BNE .skipL082
.condpart38
	bit 	CXP0FB
	BMI .skip38then
.condpart39
	INC player0y
	LDA #3
	STA m
 jmp .skipmove

.skip38then
.skipL082
.L083 ;  if joy0right  &&  !collision(player0,playfield) then player0x  =  player0x  +  1  :  m  =  4  :  REFP0  =  0  :  goto skipmove

 bit SWCHA
	BMI .skipL083
.condpart40
	bit 	CXP0FB
	BMI .skip40then
.condpart41
	INC player0x
	LDA #4
	STA m
	LDA #0
	STA REFP0
 jmp .skipmove

.skip40then
.skipL083
.
 ; 

.L084 ;  if joy1up  &&  !collision(player1,playfield) then player1y  =  player1y  -  1  :  n  =  1  :  goto skipmove

 lda #1
 bit SWCHA
	BNE .skipL084
.condpart42
	bit 	CXP1FB
	BMI .skip42then
.condpart43
	DEC player1y
	LDA #1
	STA n
 jmp .skipmove

.skip42then
.skipL084
.L085 ;  if joy1left  &&  !collision(player1,playfield) then player1x  =  player1x  -  1  :  REFP1  =  8  :  n  =  2  :  goto skipmove

 lda #4
 bit SWCHA
	BNE .skipL085
.condpart44
	bit 	CXP1FB
	BMI .skip44then
.condpart45
	DEC player1x
	LDA #8
	STA REFP1
	LDA #2
	STA n
 jmp .skipmove

.skip44then
.skipL085
.L086 ;  if joy1down  &&  !collision(player1,playfield) then player1y  =  player1y  +  1  :  n  =  3  :  goto skipmove

 lda #2
 bit SWCHA
	BNE .skipL086
.condpart46
	bit 	CXP1FB
	BMI .skip46then
.condpart47
	INC player1y
	LDA #3
	STA n
 jmp .skipmove

.skip46then
.skipL086
.L087 ;  if joy1right  &&  !collision(player1,playfield) then player1x  =  player1x  +  1  :  n  =  4  :  REFP1  =  0  :  goto skipmove

 lda #8
 bit SWCHA
	BNE .skipL087
.condpart48
	bit 	CXP1FB
	BMI .skip48then
.condpart49
	INC player1x
	LDA #4
	STA n
	LDA #0
	STA REFP1
 jmp .skipmove

.skip48then
.skipL087
.
 ; 

.skipmove
 ; skipmove

.L088 ;  if player0x  <  player1x then REFP1  =  8

	LDA player0x
	CMP player1x
     BCS .skipL088
.condpart50
	LDA #8
	STA REFP1
.skipL088
.L089 ;  if player0x  >  player1x then REFP1  =  0

	LDA player1x
	CMP player0x
     BCS .skipL089
.condpart51
	LDA #0
	STA REFP1
.skipL089
.L090 ;  if player1x  <  player0x then REFP0  =  8

	LDA player1x
	CMP player0x
     BCS .skipL090
.condpart52
	LDA #8
	STA REFP0
.skipL090
.L091 ;  if player1x  >  player0x then REFP0  =  0

	LDA player0x
	CMP player1x
     BCS .skipL091
.condpart53
	LDA #0
	STA REFP0
.skipL091
.L092 ;  goto main

 jmp .main

.
 ; 

.
 ; 

.L093 ;  rem fim do loop principal 

.
 ; 

.
 ; 

.L094 ;  rem configuracao de sons do jogo 

.
 ; 

.L095 ;  rem som dos pontos ( quando o vilao morre)

.
 ; 

.pointsound
 ; pointsound

.L096 ;  AUDV0  =  0

	LDA #0
	STA AUDV0
.L097 ;  AUDC0  =  8

	LDA #8
	STA AUDC0
.L098 ;  AUDF0  =  3

	LDA #3
	STA AUDF0
.
 ; 

.L099 ;  p  =  p  +  1

	INC p
.L0100 ;  drawscreen

 jsr drawscreen
.L0101 ;  rem tempo que o som toca 

.L0102 ;  if p  <  8 then pointsound

	LDA p
	CMP #8
 if ((* - .pointsound) < 127) && ((* - .pointsound) > -128)
	bcc .pointsound
 else
	bcs .0skippointsound
	jmp .pointsound
.0skippointsound
 endif
.L0103 ;  p  =  0

	LDA #0
	STA p
.L0104 ;  AUDV0  =  0 :  AUDC0  =  0 :  AUDF0  =  0

	LDA #0
	STA AUDV0
	STA AUDC0
	STA AUDF0
.L0105 ;  goto main

 jmp .main

.
 ; 

.L0106 ;  rem som do tiro 

.
 ; 

.firesound
 ; firesound

.L0107 ;  AUDV0  =  0

	LDA #0
	STA AUDV0
.L0108 ;  AUDC0  =  8

	LDA #8
	STA AUDC0
.L0109 ;  AUDF0  =  18

	LDA #18
	STA AUDF0
.
 ; 

.L0110 ;  rem som de fundo (fica mis facil configurar aqui no tiro) 

.
 ; 

.L0111 ;  AUDV1  =  0

	LDA #0
	STA AUDV1
.L0112 ;  AUDC1  =  2

	LDA #2
	STA AUDC1
.L0113 ;  AUDF1  =  31

	LDA #31
	STA AUDF1
.
 ; 

.L0114 ;  p  =  p  +  1

	INC p
.L0115 ;  drawscreen

 jsr drawscreen
.L0116 ;  rem tempo que o som toca

.L0117 ;  if p  <  5 then firesound

	LDA p
	CMP #5
 if ((* - .firesound) < 127) && ((* - .firesound) > -128)
	bcc .firesound
 else
	bcs .1skipfiresound
	jmp .firesound
.1skipfiresound
 endif
.L0118 ;  p  =  0

	LDA #0
	STA p
.L0119 ;  AUDV0  =  0 :  AUDC0  =  0 :  AUDF0  =  0

	LDA #0
	STA AUDV0
	STA AUDC0
	STA AUDF0
.L0120 ;  goto main

 jmp .main

.
 ; 

.L0121 ;  rem Som do heroi morredo 

.deadsound
 ; deadsound

.L0122 ;  AUDV1  =  0

	LDA #0
	STA AUDV1
.L0123 ;  AUDC1  =  8

	LDA #8
	STA AUDC1
.L0124 ;  AUDF1  =  31

	LDA #31
	STA AUDF1
.L0125 ;  p  =  p  +  1

	INC p
.L0126 ;  drawscreen

 jsr drawscreen
.L0127 ;  rem tempo que o som toca 

.L0128 ;  if p  <  30 then deadsound

	LDA p
	CMP #30
 if ((* - .deadsound) < 127) && ((* - .deadsound) > -128)
	bcc .deadsound
 else
	bcs .2skipdeadsound
	jmp .deadsound
.2skipdeadsound
 endif
.L0129 ;  p  =  0

	LDA #0
	STA p
.L0130 ;  AUDV1  =  0 :  AUDC1  =  0 :  AUDF1  =  0

	LDA #0
	STA AUDV1
	STA AUDC1
	STA AUDF1
.L0131 ;  if a  =  0 then goto title

	LDA a
	CMP #0
     BNE .skipL0131
.condpart54
 jmp .title

.skipL0131
.
 ; 

.L0132 ;  goto main

 jmp .main

.
 ; 

.
 ; 

.L0133 ;  rem fim da programacao  ( Canal Mundo4k)
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
playercolor7then_0
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
player8then_0
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
playercolor9then_0
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
player10then_1
	.byte         %00100100
	.byte         %00100100
	.byte         %00011000
	.byte         %00011010
	.byte         %00111100
	.byte         %01011000
	.byte         %00010000
	.byte         %00011000
 if (<*) > (<(*+8))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playercolor11then_1
	.byte     $40;
	.byte     $40;
	.byte     $40;
	.byte     $40;
	.byte     $40;
	.byte     $40;
	.byte     $40;
	.byte     $40;
	.byte     
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player12then_1
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
playercolor13then_1
	.byte     $40;
	.byte     $40;
	.byte     $40;
	.byte     $40;
	.byte     $40;
	.byte     $40;
	.byte     $40;
	.byte     $40;
 if ECHOFIRST
       echo "    ",[(scoretable - *)]d , "bytes of ROM space left")
 endif 
ECHOFIRST = 1
 
 
 

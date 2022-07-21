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
.L041 ;  n  =  0

	LDA #0
	STA n
.
 ; 

.L042 ;  rem loop principal 

.
 ; 

.main
 ; main

.
 ; 

.L043 ;  rem cor dos personagens e da base do canhao (heroi)

.
 ; 

.L044 ;  COLUP1  =  $00

	LDA #$00
	STA COLUP1
.L045 ;  COLUP0  =  $0E

	LDA #$0E
	STA COLUP0
.L046 ;  COLUPF  =  $90

	LDA #$90
	STA COLUPF
.L047 ;  f = f + 1

	INC f
.L048 ;  g = g + 1

	INC g
.
 ; 

.L049 ;  rem jogador 1

.
 ; 

.L050 ;  if f  =  10  &&  n  =  0 then player0:

	LDA f
	CMP #10
     BNE .skipL050
.condpart6
	LDA n
	CMP #0
     BNE .skip6then
.condpart7
	LDX #<player7then_0
	STX player0pointerlo
	LDA #>player7then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip6then
.skipL050
.L051 ;  if f  =  10  ||  n  =  0 then player0color:

	LDA f
	CMP #10
     BNE .skipL051
.condpart8
 jmp .condpart9
.skipL051
	LDA n
	CMP #0
     BNE .skip4OR
.condpart9
	LDX #<playercolor9then_0
	STX player0color
	LDA #>playercolor9then_0
	STA player0color+1
.skip4OR
.L052 ;  if f  =  20  ||  n  =  0 then player0:

	LDA f
	CMP #20
     BNE .skipL052
.condpart10
 jmp .condpart11
.skipL052
	LDA n
	CMP #0
     BNE .skip5OR
.condpart11
	LDX #<player11then_0
	STX player0pointerlo
	LDA #>player11then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip5OR
.L053 ;  if f  =  20  ||  n  =  0 then player0color:

	LDA f
	CMP #20
     BNE .skipL053
.condpart12
 jmp .condpart13
.skipL053
	LDA n
	CMP #0
     BNE .skip6OR
.condpart13
	LDX #<playercolor13then_0
	STX player0color
	LDA #>playercolor13then_0
	STA player0color+1
.skip6OR
.
 ; 

.L054 ;  if f  =  10  ||  o  =  1 then player0:

	LDA f
	CMP #10
     BNE .skipL054
.condpart14
 jmp .condpart15
.skipL054
	LDA o
	CMP #1
     BNE .skip7OR
.condpart15
	LDX #<player15then_0
	STX player0pointerlo
	LDA #>player15then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip7OR
.L055 ;  if f  =  10  ||  o  =  1 then player0color:

	LDA f
	CMP #10
     BNE .skipL055
.condpart16
 jmp .condpart17
.skipL055
	LDA o
	CMP #1
     BNE .skip8OR
.condpart17
	LDX #<playercolor17then_0
	STX player0color
	LDA #>playercolor17then_0
	STA player0color+1
.skip8OR
.L056 ;  if f  =  20  ||  o  =  1 then player0:

	LDA f
	CMP #20
     BNE .skipL056
.condpart18
 jmp .condpart19
.skipL056
	LDA o
	CMP #1
     BNE .skip9OR
.condpart19
	LDX #<player19then_0
	STX player0pointerlo
	LDA #>player19then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip9OR
.L057 ;  if f  =  20  ||  o  =  1 then player0color:

	LDA f
	CMP #20
     BNE .skipL057
.condpart20
 jmp .condpart21
.skipL057
	LDA o
	CMP #1
     BNE .skip10OR
.condpart21
	LDX #<playercolor21then_0
	STX player0color
	LDA #>playercolor21then_0
	STA player0color+1
.skip10OR
.L058 ;  if f  =  30  ||  o  =  1 then player0:

	LDA f
	CMP #30
     BNE .skipL058
.condpart22
 jmp .condpart23
.skipL058
	LDA o
	CMP #1
     BNE .skip11OR
.condpart23
	LDX #<player23then_0
	STX player0pointerlo
	LDA #>player23then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip11OR
.L059 ;  if f  =  30  ||  o  =  1 then player0color:

	LDA f
	CMP #30
     BNE .skipL059
.condpart24
 jmp .condpart25
.skipL059
	LDA o
	CMP #1
     BNE .skip12OR
.condpart25
	LDX #<playercolor25then_0
	STX player0color
	LDA #>playercolor25then_0
	STA player0color+1
.skip12OR
.L060 ;  if f  =  40  ||  o  =  1 then player0:

	LDA f
	CMP #40
     BNE .skipL060
.condpart26
 jmp .condpart27
.skipL060
	LDA o
	CMP #1
     BNE .skip13OR
.condpart27
	LDX #<player27then_0
	STX player0pointerlo
	LDA #>player27then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip13OR
.L061 ;  if f  =  40  ||  o  =  1 then player0color:

	LDA f
	CMP #40
     BNE .skipL061
.condpart28
 jmp .condpart29
.skipL061
	LDA o
	CMP #1
     BNE .skip14OR
.condpart29
	LDX #<playercolor29then_0
	STX player0color
	LDA #>playercolor29then_0
	STA player0color+1
.skip14OR
.L062 ;  if f  =  50  ||  o  =  1 then player0:

	LDA f
	CMP #50
     BNE .skipL062
.condpart30
 jmp .condpart31
.skipL062
	LDA o
	CMP #1
     BNE .skip15OR
.condpart31
	LDX #<player31then_0
	STX player0pointerlo
	LDA #>player31then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip15OR
.L063 ;  if f  =  50  ||  o  =  1 then player0color:

	LDA f
	CMP #50
     BNE .skipL063
.condpart32
 jmp .condpart33
.skipL063
	LDA o
	CMP #1
     BNE .skip16OR
.condpart33
	LDX #<playercolor33then_0
	STX player0color
	LDA #>playercolor33then_0
	STA player0color+1
.skip16OR
.
 ; 

.L064 ;  rem jogador 2

.
 ; 

.L065 ;  if g  =  10  ||  o  =  0 then player1:

	LDA g
	CMP #10
     BNE .skipL065
.condpart34
 jmp .condpart35
.skipL065
	LDA o
	CMP #0
     BNE .skip17OR
.condpart35
	LDX #<player35then_1
	STX player1pointerlo
	LDA #>player35then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skip17OR
.L066 ;  if g  =  10  ||  o  =  0 then player1color:

	LDA g
	CMP #10
     BNE .skipL066
.condpart36
 jmp .condpart37
.skipL066
	LDA o
	CMP #0
     BNE .skip18OR
.condpart37
	LDX #<playercolor37then_1
	STX player1color
	LDA #>playercolor37then_1
	STA player1color+1
.skip18OR
.L067 ;  if g  =  20  ||  o  =  0 then player1:

	LDA g
	CMP #20
     BNE .skipL067
.condpart38
 jmp .condpart39
.skipL067
	LDA o
	CMP #0
     BNE .skip19OR
.condpart39
	LDX #<player39then_1
	STX player1pointerlo
	LDA #>player39then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skip19OR
.L068 ;  if g  =  20  ||  o  =  0 then player1color:

	LDA g
	CMP #20
     BNE .skipL068
.condpart40
 jmp .condpart41
.skipL068
	LDA o
	CMP #0
     BNE .skip20OR
.condpart41
	LDX #<playercolor41then_1
	STX player1color
	LDA #>playercolor41then_1
	STA player1color+1
.skip20OR
.
 ; 

.
 ; 

.L069 ;  if f = 50 then f = 0

	LDA f
	CMP #50
     BNE .skipL069
.condpart42
	LDA #0
	STA f
.skipL069
.L070 ;  if g = 20 then g = 0

	LDA g
	CMP #20
     BNE .skipL070
.condpart43
	LDA #0
	STA g
.skipL070
.
 ; 

.L071 ;  rem velocidade que o vilao ataca o heroi 

.
 ; 

.L072 ;  a  =  a  +  1  :  if a  <  4 then goto checkfire

	INC a
	LDA a
	CMP #4
     BCS .skipL072
.condpart44
 jmp .checkfire

.skipL072
.L073 ;  a  =  0

	LDA #0
	STA a
.
 ; 

.L074 ;  rem forma que o vilao persegue o heroi 

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

.L075 ;  rem verificando se o tiro saiu do heroi 

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

.L076 ;  rem tiro emitido inicia o jogo e sons de fundo e disparo  

.
 ; 

.
 ; 

.draw
 ; draw

.L077 ;  drawscreen

 jsr drawscreen
.
 ; 

.L078 ;  rem se o tiro acertar o vilao somar pontos ordem crescente surgir outro vilao na tela e som de vilao abatido 

.
 ; 

.
 ; 

.
 ; 

.L079 ;  rem se o vilao encostar no heroi som de explosao retorna para o titulo 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L080 ;  rem configuracao de limite de tela 

.
 ; 

.L081 ;  if m  =  1  &&  collision(player0,playfield) then player0y  =  player0y  +  1  :  goto skipmove

	LDA m
	CMP #1
     BNE .skipL081
.condpart45
	bit 	CXP0FB
	BPL .skip45then
.condpart46
	INC player0y
 jmp .skipmove

.skip45then
.skipL081
.L082 ;  if m  =  2  &&  collision(player0,playfield) then player0x  =  player0x  +  1  :  goto skipmove

	LDA m
	CMP #2
     BNE .skipL082
.condpart47
	bit 	CXP0FB
	BPL .skip47then
.condpart48
	INC player0x
 jmp .skipmove

.skip47then
.skipL082
.L083 ;  if m  =  3  &&  collision(player0,playfield) then player0y  =  player0y  -  1  :  goto skipmove

	LDA m
	CMP #3
     BNE .skipL083
.condpart49
	bit 	CXP0FB
	BPL .skip49then
.condpart50
	DEC player0y
 jmp .skipmove

.skip49then
.skipL083
.L084 ;  if m  =  4  &&  collision(player0,playfield) then player0x  =  player0x  -  1  :  goto skipmove

	LDA m
	CMP #4
     BNE .skipL084
.condpart51
	bit 	CXP0FB
	BPL .skip51then
.condpart52
	DEC player0x
 jmp .skipmove

.skip51then
.skipL084
.
 ; 

.L085 ;  if n  =  1  &&  collision(player1,playfield) then player1y  =  player1y  +  1  :  goto skipmove

	LDA n
	CMP #1
     BNE .skipL085
.condpart53
	bit 	CXP1FB
	BPL .skip53then
.condpart54
	INC player1y
 jmp .skipmove

.skip53then
.skipL085
.L086 ;  if n  =  2  &&  collision(player1,playfield) then player1x  =  player1x  +  1  :  goto skipmove

	LDA n
	CMP #2
     BNE .skipL086
.condpart55
	bit 	CXP1FB
	BPL .skip55then
.condpart56
	INC player1x
 jmp .skipmove

.skip55then
.skipL086
.L087 ;  if n  =  3  &&  collision(player1,playfield) then player1y  =  player1y  -  1  :  goto skipmove

	LDA n
	CMP #3
     BNE .skipL087
.condpart57
	bit 	CXP1FB
	BPL .skip57then
.condpart58
	DEC player1y
 jmp .skipmove

.skip57then
.skipL087
.L088 ;  if n  =  4  &&  collision(player1,playfield) then player1x  =  player1x  -  1  :  goto skipmove

	LDA n
	CMP #4
     BNE .skipL088
.condpart59
	bit 	CXP1FB
	BPL .skip59then
.condpart60
	DEC player1x
 jmp .skipmove

.skip59then
.skipL088
.
 ; 

.L089 ;  rem configuracao de movimentos do heroi 

.
 ; 

.L090 ;  if joy0up  &&  !collision(player0,playfield) then player0y  =  player0y  -  1  :  m  =  1  :  goto skipmove

 lda #$10
 bit SWCHA
	BNE .skipL090
.condpart61
	bit 	CXP0FB
	BMI .skip61then
.condpart62
	DEC player0y
	LDA #1
	STA m
 jmp .skipmove

.skip61then
.skipL090
.L091 ;  if joy0left  &&  !collision(player0,playfield) then player0x  =  player0x  -  1  :  REFP0  =  8  :  m  =  2  :  goto skipmove

 bit SWCHA
	BVS .skipL091
.condpart63
	bit 	CXP0FB
	BMI .skip63then
.condpart64
	DEC player0x
	LDA #8
	STA REFP0
	LDA #2
	STA m
 jmp .skipmove

.skip63then
.skipL091
.L092 ;  if joy0down  &&  !collision(player0,playfield) then player0y  =  player0y  +  1  :  m  =  3  :  goto skipmove

 lda #$20
 bit SWCHA
	BNE .skipL092
.condpart65
	bit 	CXP0FB
	BMI .skip65then
.condpart66
	INC player0y
	LDA #3
	STA m
 jmp .skipmove

.skip65then
.skipL092
.L093 ;  if joy0right  &&  !collision(player0,playfield) then player0x  =  player0x  +  1  :  m  =  4  :  REFP0  =  0  :  goto skipmove

 bit SWCHA
	BMI .skipL093
.condpart67
	bit 	CXP0FB
	BMI .skip67then
.condpart68
	INC player0x
	LDA #4
	STA m
	LDA #0
	STA REFP0
 jmp .skipmove

.skip67then
.skipL093
.
 ; 

.L094 ;  if joy1up  &&  !collision(player1,playfield) then player1y  =  player1y  -  1  :  n  =  1  :  goto skipmove

 lda #1
 bit SWCHA
	BNE .skipL094
.condpart69
	bit 	CXP1FB
	BMI .skip69then
.condpart70
	DEC player1y
	LDA #1
	STA n
 jmp .skipmove

.skip69then
.skipL094
.L095 ;  if joy1left  &&  !collision(player1,playfield) then player1x  =  player1x  -  1  :  REFP1  =  8  :  n  =  2  :  goto skipmove

 lda #4
 bit SWCHA
	BNE .skipL095
.condpart71
	bit 	CXP1FB
	BMI .skip71then
.condpart72
	DEC player1x
	LDA #8
	STA REFP1
	LDA #2
	STA n
 jmp .skipmove

.skip71then
.skipL095
.L096 ;  if joy1down  &&  !collision(player1,playfield) then player1y  =  player1y  +  1  :  n  =  3  :  goto skipmove

 lda #2
 bit SWCHA
	BNE .skipL096
.condpart73
	bit 	CXP1FB
	BMI .skip73then
.condpart74
	INC player1y
	LDA #3
	STA n
 jmp .skipmove

.skip73then
.skipL096
.L097 ;  if joy1right  &&  !collision(player1,playfield) then player1x  =  player1x  +  1  :  n  =  4  :  REFP1  =  0  :  goto skipmove

 lda #8
 bit SWCHA
	BNE .skipL097
.condpart75
	bit 	CXP1FB
	BMI .skip75then
.condpart76
	INC player1x
	LDA #4
	STA n
	LDA #0
	STA REFP1
 jmp .skipmove

.skip75then
.skipL097
.
 ; 

.L098 ;  if collision(ball,player0) then score = score + 1  :  o  =  1  :  n  =  1 :  goto pointsound

	bit 	CXP0FB
	BVC .skipL098
.condpart77
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
	LDA #1
	STA o
	STA n
 jmp .pointsound

.skipL098
.
 ; 

.skipmove
 ; skipmove

.L099 ;  if player0x  <  player1x then REFP1  =  8

	LDA player0x
	CMP player1x
     BCS .skipL099
.condpart78
	LDA #8
	STA REFP1
.skipL099
.L0100 ;  if player0x  >  player1x then REFP1  =  0

	LDA player1x
	CMP player0x
     BCS .skipL0100
.condpart79
	LDA #0
	STA REFP1
.skipL0100
.L0101 ;  if player1x  <  player0x then REFP0  =  8

	LDA player1x
	CMP player0x
     BCS .skipL0101
.condpart80
	LDA #8
	STA REFP0
.skipL0101
.L0102 ;  if player1x  >  player0x then REFP0  =  0

	LDA player0x
	CMP player1x
     BCS .skipL0102
.condpart81
	LDA #0
	STA REFP0
.skipL0102
.L0103 ;  goto main

 jmp .main

.
 ; 

.
 ; 

.L0104 ;  rem fim do loop principal 

.
 ; 

.
 ; 

.L0105 ;  rem configuracao de sons do jogo 

.
 ; 

.L0106 ;  rem som dos pontos ( quando o vilao morre)

.
 ; 

.pointsound
 ; pointsound

.L0107 ;  AUDV0  =  0

	LDA #0
	STA AUDV0
.L0108 ;  AUDC0  =  8

	LDA #8
	STA AUDC0
.L0109 ;  AUDF0  =  3

	LDA #3
	STA AUDF0
.
 ; 

.L0110 ;  p  =  p  +  1

	INC p
.L0111 ;  drawscreen

 jsr drawscreen
.L0112 ;  rem tempo que o som toca 

.L0113 ;  if p  <  8 then pointsound

	LDA p
	CMP #8
 if ((* - .pointsound) < 127) && ((* - .pointsound) > -128)
	bcc .pointsound
 else
	bcs .0skippointsound
	jmp .pointsound
.0skippointsound
 endif
.L0114 ;  p  =  0

	LDA #0
	STA p
.L0115 ;  AUDV0  =  0 :  AUDC0  =  0 :  AUDF0  =  0

	LDA #0
	STA AUDV0
	STA AUDC0
	STA AUDF0
.L0116 ;  goto main

 jmp .main

.
 ; 

.L0117 ;  rem som do tiro 

.
 ; 

.firesound
 ; firesound

.L0118 ;  AUDV0  =  0

	LDA #0
	STA AUDV0
.L0119 ;  AUDC0  =  8

	LDA #8
	STA AUDC0
.L0120 ;  AUDF0  =  18

	LDA #18
	STA AUDF0
.
 ; 

.L0121 ;  rem som de fundo (fica mis facil configurar aqui no tiro) 

.
 ; 

.L0122 ;  AUDV1  =  0

	LDA #0
	STA AUDV1
.L0123 ;  AUDC1  =  2

	LDA #2
	STA AUDC1
.L0124 ;  AUDF1  =  31

	LDA #31
	STA AUDF1
.
 ; 

.L0125 ;  p  =  p  +  1

	INC p
.L0126 ;  drawscreen

 jsr drawscreen
.L0127 ;  rem tempo que o som toca

.L0128 ;  if p  <  5 then firesound

	LDA p
	CMP #5
 if ((* - .firesound) < 127) && ((* - .firesound) > -128)
	bcc .firesound
 else
	bcs .1skipfiresound
	jmp .firesound
.1skipfiresound
 endif
.L0129 ;  p  =  0

	LDA #0
	STA p
.L0130 ;  AUDV0  =  0 :  AUDC0  =  0 :  AUDF0  =  0

	LDA #0
	STA AUDV0
	STA AUDC0
	STA AUDF0
.L0131 ;  goto main

 jmp .main

.
 ; 

.L0132 ;  rem Som do heroi morredo 

.deadsound
 ; deadsound

.L0133 ;  AUDV1  =  0

	LDA #0
	STA AUDV1
.L0134 ;  AUDC1  =  8

	LDA #8
	STA AUDC1
.L0135 ;  AUDF1  =  31

	LDA #31
	STA AUDF1
.L0136 ;  p  =  p  +  1

	INC p
.L0137 ;  drawscreen

 jsr drawscreen
.L0138 ;  rem tempo que o som toca 

.L0139 ;  if p  <  30 then deadsound

	LDA p
	CMP #30
 if ((* - .deadsound) < 127) && ((* - .deadsound) > -128)
	bcc .deadsound
 else
	bcs .2skipdeadsound
	jmp .deadsound
.2skipdeadsound
 endif
.L0140 ;  p  =  0

	LDA #0
	STA p
.L0141 ;  AUDV1  =  0 :  AUDC1  =  0 :  AUDF1  =  0

	LDA #0
	STA AUDV1
	STA AUDC1
	STA AUDF1
.L0142 ;  if a  =  0 then goto title

	LDA a
	CMP #0
     BNE .skipL0142
.condpart82
 jmp .title

.skipL0142
.
 ; 

.L0143 ;  goto main

 jmp .main

.
 ; 

.
 ; 

.L0144 ;  rem fim da programacao  ( Canal Mundo4k)
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player7then_0
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
player11then_0
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
playercolor13then_0
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
player15then_0
	.byte         %00100100
	.byte         %00100100
	.byte         %00011001
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
playercolor17then_0
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
player19then_0
	.byte         %01000010
	.byte         %00100101
	.byte         %00011000
	.byte         %00011010
	.byte         %01111100
	.byte         %00011000
	.byte         %00010000
	.byte         %00011000
 if (<*) > (<(*+8))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playercolor21then_0
	.byte     
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
player23then_0
	.byte         %00100101
	.byte         %00100100
	.byte         %00011000
	.byte         %01011010
	.byte         %00111100
	.byte         %00011000
	.byte         %00010000
	.byte         %00011000
 if (<*) > (<(*+8))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playercolor25then_0
	.byte 
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
player27then_0
	.byte         %01000010
	.byte         %00100101
	.byte         %00011000
	.byte         %00011010
	.byte         %01111100
	.byte         %00011000
	.byte         %00010000
	.byte         %00011000
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
playercolor29then_0
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
player31then_0
	.byte         %00100100
	.byte         %00100100
	.byte         %00011001
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
playercolor33then_0
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
player35then_1
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
playercolor37then_1
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     
 if (<*) > (<(*+7))
	repeat ($100-<*)
	.byte 0
	repend
	endif
player39then_1
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
playercolor41then_1
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
	.byte     $34;
 if ECHOFIRST
       echo "    ",[(scoretable - *)]d , "bytes of ROM space left")
 endif 
ECHOFIRST = 1
 
 
 

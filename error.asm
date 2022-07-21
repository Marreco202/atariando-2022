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

.L05 ;  rem titulo 

.
 ; 

.title
 ; title

.L06 ;  playfield:

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

.L07 ;  rem cor do titulo e fundo da tela 

.
 ; 

.L08 ;  COLUBK  =  216

	LDA #216
	STA COLUBK
.L09 ;  COLUPF  =  $90

	LDA #$90
	STA COLUPF
.L010 ;  drawscreen

 jsr drawscreen
.
 ; 

.L011 ;  rem quando finalizar o game, esconder os personagens fora da tela 

.
 ; 

.L012 ;  player0x  =  1  :  player0y  =  1

	LDA #1
	STA player0x
	STA player0y
.L013 ;  player1x  =  1  :  player1y  =  1

	LDA #1
	STA player1x
	STA player1y
.
 ; 

.L014 ;  rem se o acionado o botao, pular o titulo 

.
 ; 

.L015 ;  if joy0fire  ||  joy1fire then goto skiptitle

 bit INPT4
	BMI .skipL015
.condpart0
 jmp .condpart1
.skipL015
 bit INPT5
	BMI .skip0OR
.condpart1
 jmp .skiptitle

.skip0OR
.
 ; 

.L016 ;  rem se nao acionado o botao, permanecer no titulo 

.
 ; 

.L017 ;  goto title

 jmp .title

.
 ; 

.L018 ;  rem inicio do loop principal 

.
 ; 

.skiptitle
 ; skiptitle

.
 ; 

.L019 ;  rem tela de jogo inicial (apos o titulo )

.
 ; 

.L020 ;  playfield:

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

.L021 ;  rem posicao dos personagens na tela 

.
 ; 

.L022 ;  player0x  =  20  :  player0y  =  47

	LDA #20
	STA player0x
	LDA #47
	STA player0y
.L023 ;  player1x  =  130  :  player1y  =  47

	LDA #130
	STA player1x
	LDA #47
	STA player1y
.L024 ;  ballx  =   (  ( rand  &  50 )   +  50 )   :  bally  =   (  ( rand  &  40 )   +  30 ) 

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
.L025 ;  if ballx  <  50  ||  ballx  >  100 then goto skiptitle

	LDA ballx
	CMP #50
     BCS .skipL025
.condpart2
 jmp .condpart3
.skipL025
	LDA #100
	CMP ballx
     BCS .skip1OR
.condpart3
 jmp .skiptitle

.skip1OR
.L026 ;  if bally  <  50  ||  bally  >  100 then goto skiptitle

	LDA bally
	CMP #50
     BCS .skipL026
.condpart4
 jmp .condpart5
.skipL026
	LDA #100
	CMP bally
     BCS .skip2OR
.condpart5
 jmp .skiptitle

.skip2OR
.L027 ;  ballheight  =  3  :  CTRLPF  =  $21

	LDA #3
	STA ballheight
	LDA #$21
	STA CTRLPF
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

.L028 ;  rem cor do fundo da tela 

.
 ; 

.L029 ;  COLUBK  =  216

	LDA #216
	STA COLUBK
.
 ; 

.L030 ;  rem configuracao das contagens de pontos e cor do score 

.
 ; 

.L031 ;  score  =  00000  :  scorecolor  =  $0E

	LDA #$00
	STA score+2
	LDA #$00
	STA score+1
	LDA #$00
	STA score
	LDA #$0E
	STA scorecolor
.L032 ;  m  =  0

	LDA #0
	STA m
.L033 ;  n  =  0

	LDA #0
	STA n
.L034 ;  p  =  0

	LDA #0
	STA p
.L035 ;  q  =  0

	LDA #0
	STA q
.
 ; 

.L036 ;  rem loop principal 

.
 ; 

.main
 ; main

.
 ; 

.L037 ;  rem cor dos personagens e da base do canhao (heroi)

.
 ; 

.L038 ;  COLUP1  =  $1E

	LDA #$1E
	STA COLUP1
.L039 ;  COLUP0  =  $0E

	LDA #$0E
	STA COLUP0
.L040 ;  COLUPF  =  $90

	LDA #$90
	STA COLUPF
.L041 ;  f = f + 1

	INC f
.L042 ;  g = g + 1

	INC g
.
 ; 

.L043 ;  rem jogador 1

.
 ; 

.L044 ;  if f  =  10  &&  q  =  0 then player0:

	LDA f
	CMP #10
     BNE .skipL044
.condpart6
	LDA q
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
.skipL044
.L045 ;  if f  =  10  &&  q  =  0 then player0color:

	LDA f
	CMP #10
     BNE .skipL045
.condpart8
	LDA q
	CMP #0
     BNE .skip8then
.condpart9
	LDX #<playercolor9then_0
	STX player0color
	LDA #>playercolor9then_0
	STA player0color+1
.skip8then
.skipL045
.L046 ;  if f  =  20  &&  q  =  0 then player0:

	LDA f
	CMP #20
     BNE .skipL046
.condpart10
	LDA q
	CMP #0
     BNE .skip10then
.condpart11
	LDX #<player11then_0
	STX player0pointerlo
	LDA #>player11then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip10then
.skipL046
.L047 ;  if f  =  20  &&  q  =  0 then player0color:

	LDA f
	CMP #20
     BNE .skipL047
.condpart12
	LDA q
	CMP #0
     BNE .skip12then
.condpart13
	LDX #<playercolor13then_0
	STX player0color
	LDA #>playercolor13then_0
	STA player0color+1
.skip12then
.skipL047
.
 ; 

.L048 ;  if f  =  10  &&  q  =  1 then player0:

	LDA f
	CMP #10
     BNE .skipL048
.condpart14
	LDA q
	CMP #1
     BNE .skip14then
.condpart15
	LDX #<player15then_0
	STX player0pointerlo
	LDA #>player15then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip14then
.skipL048
.L049 ;  if f  =  10  &&  q  =  1 then player0color:

	LDA f
	CMP #10
     BNE .skipL049
.condpart16
	LDA q
	CMP #1
     BNE .skip16then
.condpart17
	LDX #<playercolor17then_0
	STX player0color
	LDA #>playercolor17then_0
	STA player0color+1
.skip16then
.skipL049
.L050 ;  if f  =  20  &&  q  =  1 then player0:

	LDA f
	CMP #20
     BNE .skipL050
.condpart18
	LDA q
	CMP #1
     BNE .skip18then
.condpart19
	LDX #<player19then_0
	STX player0pointerlo
	LDA #>player19then_0
	STA player0pointerhi
	LDA #7
	STA player0height
.skip18then
.skipL050
.L051 ;  if f  =  20  &&  q  =  1 then player0color:

	LDA f
	CMP #20
     BNE .skipL051
.condpart20
	LDA q
	CMP #1
     BNE .skip20then
.condpart21
	LDX #<playercolor21then_0
	STX player0color
	LDA #>playercolor21then_0
	STA player0color+1
.skip20then
.skipL051
.
 ; 

.L052 ;  rem jogador 2

.
 ; 

.L053 ;  if g  =  10  &&  p  =  0 then player1:

	LDA g
	CMP #10
     BNE .skipL053
.condpart22
	LDA p
	CMP #0
     BNE .skip22then
.condpart23
	LDX #<player23then_1
	STX player1pointerlo
	LDA #>player23then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skip22then
.skipL053
.L054 ;  if g  =  10  &&  p  =  0 then player1color:

	LDA g
	CMP #10
     BNE .skipL054
.condpart24
	LDA p
	CMP #0
     BNE .skip24then
.condpart25
	LDX #<playercolor25then_1
	STX player1color
	LDA #>playercolor25then_1
	STA player1color+1
.skip24then
.skipL054
.L055 ;  if g  =  20  &&  p  =  0 then player1:

	LDA g
	CMP #20
     BNE .skipL055
.condpart26
	LDA p
	CMP #0
     BNE .skip26then
.condpart27
	LDX #<player27then_1
	STX player1pointerlo
	LDA #>player27then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skip26then
.skipL055
.L056 ;  if g  =  20  &&  p  =  0 then player1color:

	LDA g
	CMP #20
     BNE .skipL056
.condpart28
	LDA p
	CMP #0
     BNE .skip28then
.condpart29
	LDX #<playercolor29then_1
	STX player1color
	LDA #>playercolor29then_1
	STA player1color+1
.skip28then
.skipL056
.
 ; 

.L057 ;  if g  =  10  &&  p  =  1 then player1:

	LDA g
	CMP #10
     BNE .skipL057
.condpart30
	LDA p
	CMP #1
     BNE .skip30then
.condpart31
	LDX #<player31then_1
	STX player1pointerlo
	LDA #>player31then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skip30then
.skipL057
.L058 ;  if g  =  10  &&  p  =  1 then player1color:

	LDA g
	CMP #10
     BNE .skipL058
.condpart32
	LDA p
	CMP #1
     BNE .skip32then
.condpart33
	LDX #<playercolor33then_1
	STX player1color
	LDA #>playercolor33then_1
	STA player1color+1
.skip32then
.skipL058
.L059 ;  if g  =  20  &&  p  =  1 then player1:

	LDA g
	CMP #20
     BNE .skipL059
.condpart34
	LDA p
	CMP #1
     BNE .skip34then
.condpart35
	LDX #<player35then_1
	STX player1pointerlo
	LDA #>player35then_1
	STA player1pointerhi
	LDA #7
	STA player1height
.skip34then
.skipL059
.L060 ;  if g  =  20  &&  p  =  1 then player1color:

	LDA g
	CMP #20
     BNE .skipL060
.condpart36
	LDA p
	CMP #1
     BNE .skip36then
.condpart37
	LDX #<playercolor37then_1
	STX player1color
	LDA #>playercolor37then_1
	STA player1color+1
.skip36then
.skipL060
.
 ; 

.L061 ;  if f = 20 then f = 0

	LDA f
	CMP #20
     BNE .skipL061
.condpart38
	LDA #0
	STA f
.skipL061
.L062 ;  if g = 20 then g = 0

	LDA g
	CMP #20
     BNE .skipL062
.condpart39
	LDA #0
	STA g
.skipL062
.
 ; 

.L063 ;  rem velocidade  

.
 ; 

.L064 ;  rem a = a + 1 : if a < 4 then goto checkfire

.L065 ;  rem a = 0

.
 ; 

.L066 ;  rem forma que o vilao persegue o heroi 

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

.L067 ;  rem verificando se o tiro saiu do heroi 

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

.L068 ;  rem tiro emitido inicia o jogo e sons de fundo e disparo  

.
 ; 

.
 ; 

.draw
 ; draw

.L069 ;  drawscreen

 jsr drawscreen
.
 ; 

.L070 ;  rem se o tiro acertar o vilao somar pontos ordem crescente surgir outro vilao na tela e som de vilao abatido 

.
 ; 

.
 ; 

.
 ; 

.L071 ;  rem se o vilao encostar no heroi som de explosao retorna para o titulo 

.
 ; 

.
 ; 

.
 ; 

.
 ; 

.L072 ;  rem configuracao de limite de tela 

.
 ; 

.L073 ;  if m  =  1  &&  collision(player0,playfield) then player0y  =  player0y  +  1  :  goto skipmove

	LDA m
	CMP #1
     BNE .skipL073
.condpart40
	bit 	CXP0FB
	BPL .skip40then
.condpart41
	INC player0y
 jmp .skipmove

.skip40then
.skipL073
.L074 ;  if m  =  2  &&  collision(player0,playfield) then player0x  =  player0x  +  1  :  goto skipmove

	LDA m
	CMP #2
     BNE .skipL074
.condpart42
	bit 	CXP0FB
	BPL .skip42then
.condpart43
	INC player0x
 jmp .skipmove

.skip42then
.skipL074
.L075 ;  if m  =  3  &&  collision(player0,playfield) then player0y  =  player0y  -  1  :  goto skipmove

	LDA m
	CMP #3
     BNE .skipL075
.condpart44
	bit 	CXP0FB
	BPL .skip44then
.condpart45
	DEC player0y
 jmp .skipmove

.skip44then
.skipL075
.L076 ;  if m  =  4  &&  collision(player0,playfield) then player0x  =  player0x  -  1  :  goto skipmove

	LDA m
	CMP #4
     BNE .skipL076
.condpart46
	bit 	CXP0FB
	BPL .skip46then
.condpart47
	DEC player0x
 jmp .skipmove

.skip46then
.skipL076
.
 ; 

.L077 ;  if n  =  1  &&  collision(player1,playfield) then player1y  =  player1y  +  1  :  goto skipmove

	LDA n
	CMP #1
     BNE .skipL077
.condpart48
	bit 	CXP1FB
	BPL .skip48then
.condpart49
	INC player1y
 jmp .skipmove

.skip48then
.skipL077
.L078 ;  if n  =  2  &&  collision(player1,playfield) then player1x  =  player1x  +  1  :  goto skipmove

	LDA n
	CMP #2
     BNE .skipL078
.condpart50
	bit 	CXP1FB
	BPL .skip50then
.condpart51
	INC player1x
 jmp .skipmove

.skip50then
.skipL078
.L079 ;  if n  =  3  &&  collision(player1,playfield) then player1y  =  player1y  -  1  :  goto skipmove

	LDA n
	CMP #3
     BNE .skipL079
.condpart52
	bit 	CXP1FB
	BPL .skip52then
.condpart53
	DEC player1y
 jmp .skipmove

.skip52then
.skipL079
.L080 ;  if n  =  4  &&  collision(player1,playfield) then player1x  =  player1x  -  1  :  goto skipmove

	LDA n
	CMP #4
     BNE .skipL080
.condpart54
	bit 	CXP1FB
	BPL .skip54then
.condpart55
	DEC player1x
 jmp .skipmove

.skip54then
.skipL080
.
 ; 

.L081 ;  rem configuracao de movimentos

.
 ; 

.L082 ;  if joy0up  &&  !collision(player0,playfield) then player0y  =  player0y  -  1  :  m  =  1  :  goto skipmove

 lda #$10
 bit SWCHA
	BNE .skipL082
.condpart56
	bit 	CXP0FB
	BMI .skip56then
.condpart57
	DEC player0y
	LDA #1
	STA m
 jmp .skipmove

.skip56then
.skipL082
.L083 ;  if joy0left  &&  !collision(player0,playfield) then player0x  =  player0x  -  1  :  REFP0  =  8  :  m  =  2  :  goto skipmove

 bit SWCHA
	BVS .skipL083
.condpart58
	bit 	CXP0FB
	BMI .skip58then
.condpart59
	DEC player0x
	LDA #8
	STA REFP0
	LDA #2
	STA m
 jmp .skipmove

.skip58then
.skipL083
.L084 ;  if joy0down  &&  !collision(player0,playfield) then player0y  =  player0y  +  1  :  m  =  3  :  goto skipmove

 lda #$20
 bit SWCHA
	BNE .skipL084
.condpart60
	bit 	CXP0FB
	BMI .skip60then
.condpart61
	INC player0y
	LDA #3
	STA m
 jmp .skipmove

.skip60then
.skipL084
.L085 ;  if joy0right  &&  !collision(player0,playfield) then player0x  =  player0x  +  1  :  m  =  4  :  REFP0  =  0  :  goto skipmove

 bit SWCHA
	BMI .skipL085
.condpart62
	bit 	CXP0FB
	BMI .skip62then
.condpart63
	INC player0x
	LDA #4
	STA m
	LDA #0
	STA REFP0
 jmp .skipmove

.skip62then
.skipL085
.
 ; 

.L086 ;  if joy1up  &&  !collision(player1,playfield) then player1y  =  player1y  -  1  :  n  =  1  :  goto skipmove

 lda #1
 bit SWCHA
	BNE .skipL086
.condpart64
	bit 	CXP1FB
	BMI .skip64then
.condpart65
	DEC player1y
	LDA #1
	STA n
 jmp .skipmove

.skip64then
.skipL086
.L087 ;  if joy1left  &&  !collision(player1,playfield) then player1x  =  player1x  -  1  :  REFP1  =  8  :  n  =  2  :  goto skipmove

 lda #4
 bit SWCHA
	BNE .skipL087
.condpart66
	bit 	CXP1FB
	BMI .skip66then
.condpart67
	DEC player1x
	LDA #8
	STA REFP1
	LDA #2
	STA n
 jmp .skipmove

.skip66then
.skipL087
.L088 ;  if joy1down  &&  !collision(player1,playfield) then player1y  =  player1y  +  1  :  n  =  3  :  goto skipmove

 lda #2
 bit SWCHA
	BNE .skipL088
.condpart68
	bit 	CXP1FB
	BMI .skip68then
.condpart69
	INC player1y
	LDA #3
	STA n
 jmp .skipmove

.skip68then
.skipL088
.L089 ;  if joy1right  &&  !collision(player1,playfield) then player1x  =  player1x  +  1  :  n  =  4  :  REFP1  =  0  :  goto skipmove

 lda #8
 bit SWCHA
	BNE .skipL089
.condpart70
	bit 	CXP1FB
	BMI .skip70then
.condpart71
	INC player1x
	LDA #4
	STA n
	LDA #0
	STA REFP1
 jmp .skipmove

.skip70then
.skipL089
.
 ; 

.L090 ;  if collision(ball,player0) then p  =  0  :  q  =  1  :  ballx  =  100  :  bally  =  130

	bit 	CXP0FB
	BVC .skipL090
.condpart72
	LDA #0
	STA p
	LDA #1
	STA q
	LDA #100
	STA ballx
	LDA #130
	STA bally
.skipL090
.L091 ;  if collision(ball,player1) then p  =  1  :  q  =  0  :  ballx  =  100  :  bally  =  130

	bit 	CXP1FB
	BVC .skipL091
.condpart73
	LDA #1
	STA p
	LDA #0
	STA q
	LDA #100
	STA ballx
	LDA #130
	STA bally
.skipL091
.L092 ;  if  (  collision(player0,player1)  &&   (  p  =  0  )   &&   (  q  =  1  )   )  then p  =  1  :  q  =  0  :  player0x  =  player0x  -  10


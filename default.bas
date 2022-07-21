 rem Generated 14/03/2016 17:44:53 by Visual bB Version 1.0.0.554
 rem *********************************** 
 rem *<M4K video aula>                  *
 rem *<add som no game>               *
 rem *<CanalMundo4k>                   *
 rem <canalmundo4k@gmail.com>
 rem *<license free >                        *
 rem ***********************************

 rem configuracao geral ( tamanho da rom sistemar de cor  da tv ) 

 set tv ntsc
 set romsize 4k
 set smartbranching on

 rem titulo 

title 
 playfield:
 ..XXXX.X.X.XXX.XX.XXX..XXX.X....
 ..X....X.X..X..X..X.X..X.X.X....
 ..XXX..X.X..X..XX.XXXX.X.X.X....
 ..X....X.X..X..X..X..X.X.X.X....
 ..X....XXX..X..XX.XXXX.XXX.XXX..
 ................................
 .....XXX..XXX.XXX.XXX..XXX......
 .....X.X..X.X.X.X.X.X..X.X......
 .....XXXX.XX..XXX.XXXX.X.X......
 .....XX.X.X.X.X.X.X..X.X.X......
 .....XXXX.X.X.X.X.XXXX.XXX......
end

 rem cor do titulo e fundo da tela 

 COLUBK = 216
 COLUPF = $90
 drawscreen

 rem quando finalizar o game esconder os personagens fora da tela 

 player0x = 1 : player0y = 1
 player1x = 1 : player1y = 1

 rem se o acionado o botao de tiro pular o titulo 

 if joy0fire || joy1fire then goto skiptitle

 rem se nao acionado o botao de tiro permanecer no titulo 

 goto title

 rem inicio do loop principal 

skiptitle

 rem tela de jogo inicial (apos o titulo )

 playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 X..............................X
 X..............................X
 X..............................X
 ................................
 ................................
 ................................
 X..............................X
 X..............................X
 X..............................X
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end


 rem posicao dos personagens na tela 

 player0x = 20 : player0y = 47
 player1x = 130 : player1y = 47 
 ballx = ((rand & 50) + 50) : bally = ((rand & 40) + 30) 
 if ballx < 50 || ballx > 100 then goto skiptitle
 if bally < 50 || bally > 100 then goto skiptitle
 ballheight = 3 : CTRLPF = $21

 rem configuracao do missil saindo do heroi 

 ; missile0height = 4  : missile0y = 255


 rem cor do fundo da tela 

 COLUBK = 216

 rem configuracao das contagens de pontos e cor do score 

 score = 00000 :  scorecolor = $0E
 m = 0

 rem loop principal 

main

 rem cor dos personagens e da base do canhao (heroi)

 COLUP1 = $00
 COLUP0 = $0E
 COLUPF = $90
 f=f+1
 g=g+1

 rem jogador 1

 if f = 10 then player0:
        %00100100
        %00100100
        %00011000
        %00011010
        %00111100
        %01011000
        %00010000
        %00011000
end
 if f = 10 then player0color:
    $0E;
    $0E;
    $0E;
    $0E;
    $0E;
    $0E;
    $0E;
    $0E;
end
 if f = 20 then player0:
        %01000010
        %00100100
        %00011000
        %01011000
        %00111100
        %00011010
        %00010000
        %00011000
end
 if f = 20 then player0color:
    $0E;
    $0E;
    $0E;
    $0E;
    $0E;
    $0E;
    $0E;
    $0E;
end

 rem jogador 2

 if g = 10 then player1:
        %00100100
        %00100100
        %00011000
        %00011010
        %00111100
        %01011000
        %00010000
        %00011000
end
 if g = 10 then player1color:
    $40;
    $40;
    $40;
    $40;
    $40;
    $40;
    $40;
    $40;
    
end
 if g = 20 then player1:
        %01000010
        %00100100
        %00011000
        %01011000
        %00111100
        %00011010
        %00010000
        %00011000
end
 if g = 20 then player1color:
    $40;
    $40;
    $40;
    $40;
    $40;
    $40;
    $40;
    $40;
end


 if f=20 then f=0
 if g=20 then g=0

 rem velocidade que o vilao ataca o heroi 

 a = a + 1 : if a < 4 then goto checkfire
 a = 0

 rem forma que o vilao persegue o heroi 

 ; if player1y < player0y then player1y = player1y + 1
 ; if player1y > player0y then player1y = player1y - 1
 ; if player1x < player0x then player1x = player1x + 1
 ; if player1x > player0x then player1x = player1x - 1
 ; player1x = player1x : player1y = player1y


 rem verificando se o tiro saiu do heroi 

checkfire
 ; if missile0y>240 then goto skip
 ; missile0y = missile0y - 2 : goto draw

skip
 rem tiro emitido inicia o jogo e sons de fundo e disparo  
 ; if joy0fire then missile0y=player0y-2:missile0x=player0x+4: goto firesound

draw
 drawscreen

 rem se o tiro acertar o vilao somar pontos ordem crescente surgir outro vilao na tela e som de vilao abatido 

 if collision(ball,player0) then score=score+1:player1x=rand/2:player1y=0:missile0y=255 : goto pointsound

 rem se o vilao encostar no heroi som de explosao retorna para o titulo 

 ; if collision(player0,player1) goto deadsound : then title


 rem configuracao de limite de tela 

 if m = 1 && collision(player0,playfield) then player0y = player0y + 1 : goto skipmove
 if m = 2 && collision(player0,playfield) then player0x = player0x + 1 : goto skipmove
 if m = 3 && collision(player0,playfield) then player0y = player0y - 1 : goto skipmove
 if m = 4 && collision(player0,playfield) then player0x = player0x - 1 : goto skipmove

 if n = 1 && collision(player1,playfield) then player1y = player1y + 1 : goto skipmove
 if n = 2 && collision(player1,playfield) then player1x = player1x + 1 : goto skipmove
 if n = 3 && collision(player1,playfield) then player1y = player1y - 1 : goto skipmove
 if n = 4 && collision(player1,playfield) then player1x = player1x - 1 : goto skipmove

 rem configuracao de movimentos do heroi 

 if joy0up && !collision(player0,playfield) then player0y = player0y - 1 : m = 1 : goto skipmove
 if joy0left  && !collision(player0,playfield) then player0x = player0x - 1 :  REFP0 = 8 : m = 2 : goto skipmove
 if joy0down  && !collision(player0,playfield) then player0y = player0y + 1  : m = 3 : goto skipmove
 if joy0right  && !collision(player0,playfield) then player0x = player0x + 1 :  m = 4 : REFP0 = 0 : goto skipmove

 if joy1up && !collision(player1,playfield) then player1y = player1y - 1 : n = 1 : goto skipmove
 if joy1left  && !collision(player1,playfield) then player1x = player1x - 1 :  REFP1 = 8 : n = 2 : goto skipmove
 if joy1down  && !collision(player1,playfield) then player1y = player1y + 1  : n = 3 : goto skipmove
 if joy1right  && !collision(player1,playfield) then player1x = player1x + 1 :  n = 4 : REFP1 = 0 : goto skipmove

skipmove
 if player0x < player1x then REFP1 = 8
 if player0x > player1x then REFP1 = 0
 if player1x < player0x then REFP0 = 8
 if player1x > player0x then REFP0 = 0
 goto main


  rem fim do loop principal 


  rem configuracao de sons do jogo 

  rem som dos pontos ( quando o vilao morre)

pointsound
 AUDV0 = 0
 AUDC0 = 8
 AUDF0 = 3 

  p = p + 1
 drawscreen
 rem tempo que o som toca 
 if p < 8 then pointsound
 p = 0
 AUDV0 = 0: AUDC0 = 0: AUDF0 = 0
 goto main

  rem som do tiro 

firesound
 AUDV0 = 0
 AUDC0 = 8
 AUDF0 = 18

  rem som de fundo (fica mis facil configurar aqui no tiro) 

 AUDV1 = 0
 AUDC1 =  2
 AUDF1 = 31

    p = p + 1
 drawscreen
 rem tempo que o som toca
 if p < 5 then firesound
 p = 0
 AUDV0 = 0: AUDC0 = 0: AUDF0 = 0
 goto main

 rem Som do heroi morredo 
deadsound
 AUDV1 = 0
 AUDC1 = 8
 AUDF1 = 31
 p = p + 1
 drawscreen
 rem tempo que o som toca 
 if p < 30 then deadsound
 p = 0
 AUDV1 = 0: AUDC1 = 0: AUDF1 = 0
 if a = 0 then goto title 

 goto main
 
 
 rem fim da programacao  ( Canal Mundo4k)

; Programa de Teste 1
; Autores Luana, Michele, Rodrigo

LOAD R2 3;	R2 RECEBE 10
LOAD R3 4;	R1 RECEBE 5
BRANCH 5;	PULA PARA A LINHA 5
MEM 10;		COLOCA 10 NA MEMORIA NESTA POSICAO
MEM 5;		COLOCA 5 NA MEMORIA NESTA POSICAO
ADD R1 R2 R3;	R1 RECEBE A SOMA DE R2+R3
SUB R1 R2 R3;	R1 RECEBE A SUBTRACAO DE R2-R3
AND R0 R1 R3;	R0 RECEBE A AND DE R2 COM R3
OR R0 R1 R3;	R0 RECEBE A OR DE R2 COM R3
STORE 24 R0;	SALVA O VALOR DE R0 NA LINHA 24
NOP;
NOP;
LOAD R2 17;	R2 RECEBE 1
LOAD R3 18;	R3 RECEBE 1
SUB R0 R2 R3;	R0 RECEBE A SUBTRACAO DE R2-R3
BZERO 19;	PULA PARA A LINHA 19 SE O RESULTADO FOR ZERO
NOP;
MEM 1;		COLOCA 1 NA MEMORIA NESTA POSICAO
MEM 1;		COLOCA 1 NA MEMORIA NESTA POSICAO
SUB R3 R0 R2;
BNEG 23;	PULA PARA A LINHA 23 SE O RESULTADO FOR NEGATIVO
NOP;
HALT;		FINALIZA O PROGRAMA
BRANCH 22;	PULA PARA A LINHA 22


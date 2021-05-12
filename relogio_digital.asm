;
; Programa de varredura de displays de 7 segmentos
;
DSP1      equ       P2.0
DSP2      equ       P2.1
DSP3      equ       P2.2
DSP4      equ       P2.3
DSP0      equ       P2.4
DSP5      equ       P2.5
DSP6      equ       P2.6
DSP7      equ       P2.7
CH0	equ	P3.0  ; Mostra data
DDS       equ       P3.1  ; Mostra da semana  DOM, SEG, TER, QUA, QUI, SEX, SAB	
AJS       equ       P3.2  ; Zera Segundo
AJM       equ       P3.3  ; Ajuste Minuto
AJH       equ       P3.4  ; Ajuste Hora
AJD       equ       P3.5  ; Ajuste Dia
AJME      equ       P3.6  ; Ajuste M�s
AJA       equ       P3.7  ; Ajuste Ano	

          dseg      at 8
;                          HORA   DATA
COD0:     ds        1     ; US     UA
COD1:     ds        1     ; DS     DA
COD2:     ds        1     ; .      -
COD3:     ds        1     ; UM     UM
COD4:     ds        1     ; DM     DM
COD5:     ds        1     ; .      -
COD6:     ds        1     ; UH     UD
COD7:     ds        1     ; DH     DD
	
SEGUND:	ds	1   ; Ocupa 1 bytes
MIN:	ds	1
HORA:	ds	1
DIA:	ds	1   ;
MES:	ds	1   ; Calcular dia da semana
ANO:	ds	1   ;
DIASEMANA:ds	1


          cseg      at 0
inicio:   clr       DSP0      ; desliga display
          setb      DSP1      ; desliga display
          setb      DSP2      ; desliga display
          setb      DSP3      ; desliga display
          setb      DSP4      ; desliga display
          setb      DSP5      ; desliga display
          setb      DSP6      ; desliga display
          setb      DSP7      ; desliga display
	mov	SEGUND,#0
	mov	MIN,#0
	mov	HORA,#12
	mov	DIA,#26
	mov	MES,#4
	mov	ANO,#21
          
volta:    jnb       DSP0,rot1
          jnb       DSP1,rot2
          jnb       DSP2,rot3
          jnb       DSP3,rot4
          jnb       DSP4,rot5
          jnb       DSP5,rot6
          jnb       DSP6,rot7
          jnb       DSP7,rot0

rot1:     setb      DSP0
          mov       P0,COD1
          clr       DSP1
          jmp       encontro
          
rot2:     setb      DSP1
          mov       P0,COD2
          clr       DSP2
          jmp       encontro
          
rot3:     setb      DSP2
          mov       P0,COD3
          clr       DSP3
          jmp       encontro
          
rot4:     setb      DSP3
          mov       P0,COD4
          clr       DSP4
          jmp       encontro
          
rot5:     setb      DSP4
          mov       P0,COD5
          clr       DSP5
          jmp       encontro
          
rot6:     setb      DSP5
          mov       P0,COD6
          clr       DSP6
          jmp       encontro
          
rot7:     setb      DSP6
          mov       P0,COD7
          clr       DSP7
          jmp       encontro
          
rot0:     setb      DSP7
          mov       P0,COD0
          clr       DSP0
          jmp       encontro
;=====================================================          
encontro: mov       r6,#6	; Delay  2,08ms para um clock de 12Mhz
L1:       mov	r5,#172
	djnz	r5,$	
	djnz	r6,L1          
;=====================================================          
	jnb	CH0,mostradata
;=====================================================          
	mov	a,SEGUND
	mov	b,#10
	div	ab	; Q fica a dezena, R fica b unidade
	mov	dptr,#tabela
	movc	a,@a+dptr ; Pega o c�digo em 7 segmentos
	mov	COD1,a	;   DS
	mov	a,b
	movc	a,@a+dptr ; Pega o c�digo em 7 segmentos
	mov	COD0,a	;   US
	mov	COD2,#7Fh ; .
	mov	a,MIN
	mov	b,#10
	div	ab	; Q fica a dezena, R fica b unidade
	mov	dptr,#tabela
	movc	a,@a+dptr ; Pega o c�digo em 7 segmentos
	mov	COD4,a	;   DM
	mov	a,b
	movc	a,@a+dptr ; Pega o c�digo em 7 segmentos
	mov	COD3,a	;   UM
	mov	COD5,#7Fh	;   DS
	mov	a,HORA
	mov	b,#10
	div	ab	; Q fica a dezena, R fica b unidade
	mov	dptr,#tabela
	movc	a,@a+dptr ; Pega o c�digo em 7 segmentos
	mov	COD7,a	;   DH
	mov	a,b
	movc	a,@a+dptr ; Pega o c�digo em 7 segmentos
	mov	COD6,a	;   UH
	jmp	encontrow
;=====================================================          
mostradata:
	mov	a,ANO
	mov	b,#10
	div	ab	; Q fica a dezena, R fica b unidade
	mov	dptr,#tabela
	movc	a,@a+dptr ; Pega o c�digo em 7 segmentos
	mov	COD1,a	;   DS
	mov	a,b
	movc	a,@a+dptr ; Pega o c�digo em 7 segmentos
	mov	COD0,a	;   US
	mov	COD2,#0bFh ; . 
	mov	a,MES
	mov	b,#10
	div	ab	; Q fica a dezena, R fica b unidade
	mov	dptr,#tabela
	movc	a,@a+dptr ; Pega o c�digo em 7 segmentos
	mov	COD4,a	;   DM
	mov	a,b
	movc	a,@a+dptr ; Pega o c�digo em 7 segmentos
	mov	COD3,a	;   UM
	mov	COD5,#0bFh	;   DS
	mov	a,DIA
	mov	b,#10
	div	ab	; Q fica a dezena, R fica b unidade
	mov	dptr,#tabela
	movc	a,@a+dptr ; Pega o c�digo em 7 segmentos
	mov	COD7,a	;   DH
	mov	a,b
	movc	a,@a+dptr ; Pega o c�digo em 7 segmentos
	mov	COD6,a	;   UH
	jmp	encontrow
;=====================================================          
encontrow:
;   R4 HIGH = 1 R3 LOW = E0h
	inc	r3
	mov	a,r3
	jnz	pula
	inc	r4
;=====================================================          
	
pula:	mov	a,r3
	cjne	a,#low(480),difww
	mov	a,r4
	cjne	a,#high(480),difww
	jmp	igual
	
difww:	jc	encontro1x
;=====================================================          
igual:	mov	r3,#0
	mov	r4,#0
;=====================================================          
	
	inc	SEGUND
	MOV	a,SEGUND
	cjne	a,#60,dif60
	jmp	zeraseg    ; � Igual
dif60:	jc	encontro1x  ; � menor
                               ; � Maior
zeraseg:	mov	SEGUND,#0
	inc	MIN
	MOV	a,MIN
	cjne	a,#60,dif602
	jmp	zeramin    ; � Igual
dif602:	jc	encontro1x  ; � menor
                               ; � Maior
zeramin:	mov	MIN,#0
	inc	HORA
	MOV	a,HORA
	cjne	a,#24,dif24
	jmp	zerahora    ; � Igual
encontro1x:
	jmp	encontro1
dif24:	jc	encontro1x  ; � menor
 	
zerahora:	mov	HORA,#0
	inc	DIA
	mov	a,MES
	cjne	a,#1,testefev
	jmp	mes31
testefev:	cjne	a,#2,testemar
	jmp	mesfev
testemar:	cjne	a,#3,testeabr
	jmp	mes31
testeabr:	cjne	a,#4,testemai
	jmp	mes30
testemai:	cjne	a,#5,testejun
	jmp	mes31
testejun:	cjne	a,#6,testejul
	jmp	mes30
testejul:	cjne	a,#7,testeago
	jmp	mes31
testeago:	cjne	a,#8,testeset
	jmp	mes31
testeset:	cjne	a,#9,testeout
	jmp	mes30
testeout:	cjne	a,#10,testenov
	jmp	mes31
testenov:	cjne	a,#11,testedez
	jmp	mes30
testedez:	cjne	a,#12,encontro1

	mov	a,dia
	cjne	a,#31,dif31
	jmp	encontro1
dif31:	jc	encontro1
	mov	DIA,#1
	mov	MES,#1
	
	inc	ANO
	mov	a,ANO
	cjne	a,#99,dif99
	jmp	encontro1
dif99:	jc	encontro1
	mov	ANO,#0
	jmp	encontro1

mes30:	mov	a,DIA
	cjne	a,#30,dif30
	jmp	encontro1
dif30:	jc	encontro1
	mov	DIA,#1
	inc	MES
	jmp	encontro1
	
mes31:	mov	a,DIA
	cjne	a,#31,dif31x
	jmp	encontro1
dif31x:	jc	encontro1
	mov	DIA,#1
	inc	MES
	jmp	encontro1
	
mesfev:	mov	a,ANO
	mov	b,#4
	div	ab
	mov	a,b
	jz	anobissexto
	mov	a,DIA
	cjne	a,#28,dif28
	jmp	encontro1
dif28:	jc	encontro1
	mov	DIA,#1
	inc	MES
	jmp	encontro1
	
anobissexto:
	mov	a,DIA
	cjne	a,#29,dif29
	jmp	encontro1
dif29:	jc	encontro1
	mov	DIA,#1
	inc	MES
	jmp	encontro1

encontro1:
	JMP	volta
;=====================================================          


tabela:	db	0c0h	; 0 c�digo do zero
	db	0f9h      ; 1 
	db	0a4h      ; 2 
	db	0b0h      ; 3 
	db	099h      ; 4 
	db	092h      ; 5 
	db	082h      ; 6 
	db	0f8h      ; 7 
	db	080h      ; 8 
	db	090h      ; 9           
          end
          
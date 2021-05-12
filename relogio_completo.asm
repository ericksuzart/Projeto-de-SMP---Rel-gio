;
; Programa de varredura de displays de 7 segmentos
;

; Pin declaration:

DISPLAY_0       equ     P2.4
DISPLAY_1       equ     P2.0
DISPLAY_2       equ     P2.1
DISPLAY_3       equ     P2.2
DISPLAY_4       equ     P2.3
DISPLAY_5       equ     P2.5
DISPLAY_6       equ     P2.6
DISPLAY_7       equ     P2.7
BOTAO_DATA      equ     P3.0    ; Mostra data nos displays
DIAS_SEMANA     equ     P3.1    ; Mostra da semana: DOM, SEG, TER, QUA, QUI, SEX, SAB.
AJUSTE_SEG      equ     P3.2    ; Zera SegundOo
AJUSTE_MIN      equ     P3.3    ; Ajuste Minuto
AJUSTE_HORA     equ     P3.4    ; Ajuste Hora
AJUSTE_DIAS     equ     P3.5    ; Ajuste DiaS
AJUSTE_MES      equ     P3.6    ; Ajuste Mês
AJUSTE_ANO      equ     P3.7    ; Ajuste Ano

; DATA SEGMENT:
dseg	at 8

;                        HORAS   DATA
COD0:
        ds      1       ;  US     UA
COD1:
        ds      1       ;  DS     DA
COD2:
        ds      1       ;  .      -
COD3:
        ds      1       ;  UM     UM
COD4:
        ds      1       ;  DM     DM
COD5:
        ds      1       ;  .      -
COD6:
        ds      1       ;  UH     UD
COD7:
        ds      1       ;  DH     DD

SEGUNDOS:
        ds      1       ; Ocupa 1 bytes
MINUTOS:
        ds      1
HORAS:
        ds      1
DIAS:
        ds      1
MESES:
        ds      1       ; Calcular dia da semana
ANOS:
        ds      1
DIASEMANA:
        ds      1

; CODE SEGMENT:
cseg	at 0

; ======================================
;            Reset do relógio
; ======================================
Reset:
        clr     DISPLAY_0       ; liga display 0
        setb    DISPLAY_1       ; desliga display 1
        setb    DISPLAY_2       ; desliga display 2
        setb    DISPLAY_3       ; desliga display 3
        setb    DISPLAY_4       ; desliga display 4
        setb    DISPLAY_5       ; desliga display 5
        setb    DISPLAY_6       ; desliga display 6
        setb    DISPLAY_7       ; desliga display 7

        mov     SEGUNDOS, #0    ; zera segundos
        mov     MINUTOS, #0     ; zera minutos
        mov     HORAS, #12      ; define hora inicial = 12
        mov     DIAS, #26       ; define dia inicial = 26
        mov     MESES, #4       ; define mês inicial = 4
        mov     ANOS, #21       ; define ano inicial = 21

; ======================================
;         Varredura do display
; ======================================
Varredura_Display:
        jnb     DISPLAY_0, Set_D0       ; caso DISPLAY_0 ativo, seta display 0
        jnb     DISPLAY_1, Set_D1       ; caso DISPLAY_1 ativo, seta display 1
        jnb     DISPLAY_2, Set_D2       ; caso DISPLAY_2 ativo, seta display 2
        jnb     DISPLAY_3, Set_D3       ; caso DISPLAY_3 ativo, seta display 3
        jnb     DISPLAY_4, Set_D4       ; caso DISPLAY_4 ativo, seta display 4
        jnb     DISPLAY_5, Set_D5       ; caso DISPLAY_5 ativo, seta display 5
        jnb     DISPLAY_6, Set_D6       ; caso DISPLAY_6 ativo, seta display 6
        jnb     DISPLAY_7, Set_D7       ; caso DISPLAY_7 ativo, seta display 7

Set_D0:
        setb    DISPLAY_0
        mov     P0, COD0
        clr     DISPLAY_1
        jmp     Delay

Set_D1:
        setb    DISPLAY_1
        mov     P0, COD1
        clr     DISPLAY_2
        jmp     Delay
                  
Set_D2:
        setb    DISPLAY_2
        mov     P0, COD2
        clr     DISPLAY_3
        jmp     Delay
                  
Set_D3:
        setb    DISPLAY_3
        mov     P0, COD3
        clr     DISPLAY_4
        jmp     Delay

Set_D4:
        setb    DISPLAY_4
        mov     P0, COD4
        clr     DISPLAY_5
        jmp     Delay

Set_D5:
        setb    DISPLAY_5
        mov     P0, COD5
        clr     DISPLAY_6
        jmp     Delay

Set_D6:
        setb    DISPLAY_6
        mov     P0, COD6
        clr     DISPLAY_7
        jmp     Delay

Set_D7:
        setb    DISPLAY_7
        mov     P0, COD7
        clr     DISPLAY_0
        jmp     Delay

; ======================================
;            Delay de 2.08 ms
; ======================================
Delay:
        mov     r6,#6           ; Delay  2,08ms para um clock de 12Mhz
L1:
        mov     r5,#172
        djnz    r5,$
        djnz    r6,L1


; Caso o botão esteja pressionado, mostrar data
        jnb	BOTAO_DATA, MostraData
; Caso o botão não seja pressionado, mostrar horas

; ======================================
;      Mostrar horas no display
; ======================================
        mov     a, SEGUNDOS
        mov     b, #10
        div     ab              ; Quociente: dezena (a), Resto: unidade (b)
        mov     dptr, #tabela
        movc    a, @a+dptr      ; Pega o código em 7 segmentos
        mov     COD1, a         ; Dezena de segundo
        mov     a,b
        movc    a,@a+dptr       ; Pega o código em 7 segmentos
        mov     COD0, a         ; Unidade de segundo
        mov     COD2,#7Fh       ; .
        mov     a,MINUTOS
        mov     b,#10
        div     ab              ; Quociente: dezena (a), Resto: unidade (b)
        mov     dptr,#tabela
        movc    a,@a+dptr       ; Pega o código em 7 segmentos
        mov     COD4,a          ; Dezena de minutos
        mov     a,b
        movc    a,@a+dptr       ; Pega o código em 7 segmentos
        mov     COD3, a         ; Unidade de minutos
        mov     COD5,#7Fh       ; .
        mov     a,HORAS
        mov     b,#10
        div     ab              ; Quociente: dezena (a), Resto: unidade (b)
        mov     dptr,#tabela
        movc    a,@a+dptr       ; Pega o código em 7 segmentos
        mov     COD7, a         ; Dezena de horas
        mov     a,b
        movc    a,@a+dptr       ; Pega o código em 7 segmentos
        mov     COD6, a         ; Unidade de horas
        jmp     IncrementaContador

; ======================================
;         Mostrar data no display
; ======================================
MostraData:
        mov     a,ANOS
        mov     b,#10
        div     ab              ; Quociente: dezena (a), Resto: unidade (b)
        mov     dptr,#tabela
        movc    a,@a+dptr       ; Pega o código em 7 segmentos
        mov     COD1,a          ; Dezena de dia
        mov     a,b
        movc    a,@a+dptr       ; Pega o código em 7 segmentos
        mov     COD0,a          ; Unidade de dia
        mov     COD2,#0bFh      ; - 
        mov     a,MESES
        mov     b,#10
        div     ab              ; Quociente: dezena (a), Resto: unidade (b)
        mov     dptr,#tabela
        movc    a,@a+dptr       ; Pega o código em 7 segmentos
        mov     COD4, a         ; Dezena de mẽs
        mov     a,b
        movc    a,@a+dptr       ; Pega o código em 7 segmentos
        mov     COD3, a         ; Unidade de mẽs
        mov     COD5,#0bFh      ; -
        mov     a,DIAS
        mov     b,#10
        div     ab              ; Quociente: dezena (a), Resto: unidade (b)
        mov     dptr,#tabela
        movc    a,@a+dptr       ; Pega o código em 7 segmentos
        mov     COD7, a         ; Dezena de ano
        mov     a,b
        movc    a,@a+dptr       ; Pega o código em 7 segmentos
        mov     COD6, a         ; Unidade de ano
        jmp     IncrementaContador

; ======================================
;         Incrementa contador
; ======================================
IncrementaContador:
;   R4 HIGH = 1 R3 LOW = E0h
        inc     r3
        mov     a,r3
        jnz     LoopDoContador
        inc     r4

LoopDoContador:
        mov     a,r3
        cjne    a,#low(480),difww
        mov     a,r4
        cjne    a,#high(480),difww
        jmp     igual

difww:
        jc      encontro1x
;=====================================================          
igual:
        mov     r3,#0
        mov     r4,#0
;=====================================================          

        inc     SEGUNDOS
        MOV     a,SEGUNDOS
        cjne    a,#60,dif60
        jmp     zeraseg    ; � Igual
dif60:	jc	encontro1x  ; � menor
                                                                                                                         ; � Maior
zeraseg:	mov	SEGUNDOS,#0
        inc	MINUTOS
        MOV	a,MINUTOS
        cjne	a,#60,dif602
        jmp	zeramin    ; � Igual
dif602:	jc	encontro1x  ; � menor
                                                                                                                         ; � Maior
zeramin:	mov	MINUTOS,#0
        inc	HORAS
        MOV	a,HORAS
        cjne	a,#24,dif24
        jmp	zerahora    ; � Igual
encontro1x:
        jmp	encontro1
dif24:	jc	encontro1x  ; � menor
         
zerahora:	mov	HORAS,#0
        inc	DIAS
        mov	a,MESES
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

        mov	a,diaS
        cjne	a,#31,dif31
        jmp	encontro1
dif31:	jc	encontro1
        mov	DIAS,#1
        mov	MESES,#1
        
        inc	ANOS
        mov	a,ANOS
        cjne	a,#99,dif99
        jmp	encontro1
dif99:	jc	encontro1
        mov	ANOS,#0
        jmp	encontro1

mes30:	mov	a,DIAS
        cjne	a,#30,dif30
        jmp	encontro1
dif30:	jc	encontro1
        mov	DIAS,#1
        inc	MESES
        jmp	encontro1
        
mes31:	mov	a,DIAS
        cjne	a,#31,dif31x
        jmp	encontro1
dif31x:	jc	encontro1
        mov	DIAS,#1
        inc	MESES
        jmp	encontro1
        
mesfev:	mov	a,ANOS
        mov	b,#4
        div	ab
        mov	a,b
        jz	anobissexto
        mov	a,DIAS
        cjne	a,#28,dif28
        jmp	encontro1
dif28:	jc	encontro1
        mov	DIAS,#1
        inc	MESES
        jmp	encontro1
        
anobissexto:
        mov	a,DIAS
        cjne	a,#29,dif29
        jmp	encontro1
dif29:	jc	encontro1
        mov	DIAS,#1
        inc	MESES
        jmp	encontro1

encontro1:
        JMP	Varredura_Display
;=====================================================          


tabela:	db	0c0h	; 0 código do zero
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

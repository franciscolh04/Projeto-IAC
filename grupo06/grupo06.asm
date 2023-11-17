; *********************************************************************************
; * IST-UL
;
; * Grupo 06
; * ist1106970 - Francisco Lourenço Heleno
; * ist1106074 - Rodrigo Salvador dos Santos Perestrelo
; * ist1106494 - Mafalda Szolnoky Ramos Pinto Dias
;
; * Módulo:    grupo06.asm
; * Descrição: Este programa visa dar resposta à versão final do projeto de IAC.
; *********************************************************************************


; *********************************************************************************
; * Constantes
; *********************************************************************************
COMANDOS                   EQU 6000H           ; endereço de base dos comandos do MediaCenter

;Teclado
TEC_LIN                    EQU 0C000H          ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL                    EQU 0E000H          ; endereço das colunas do teclado (periférico PIN)
MASCARA                    EQU 0FH             ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
MASCARA_3                  EQU 03H             ; para isolar os 2 bits de menor peso, ao ler o valor da energia
TECLA_0                    EQU 0	           ; tecla 0 em hexadecimal
TECLA_1                    EQU 1	           ; tecla 1 em hexadecimal
TECLA_2                    EQU 2	           ; tecla 2 em hexadecimal
TECLA_C                    EQU 12	           ; tecla C em hexadecimal
TECLA_D                    EQU 13	           ; tecla D em hexadecimal
TECLA_E                    EQU 14	           ; tecla E em hexadecimal
TECLA_NAO_RELEVANTE        EQU 16	           ; valor em hexadecimal para uma tecla não relevante para o jogo


;SONS/VÍDEOS
SOM_INICIO						   	  EQU 0     ; som de início
SOM_COLISAO_ASTEROIDE_MINERAVEL   	  EQU 1		; som de colisão com um asteroide minerável
SOM_COLISAO_ASTEROIDE_NAO_MINERAVEL   EQU 2		; som de colisão com um asteroide não minerável
SOM_COLISAO_NAVE                      EQU 3		; som de colisão do asteroide com a nave
SOM_SONDA      		                  EQU 4     ; som da sonda a ser disparada
SOM_JOGO_TERMINADO					  EQU 5		; som de jogo terminado
SOM_SEM_ENERGIA                       EQU 6		; som de fim de energia
SOM_DE_PAUSA                          EQU 7		; som do modo de pausa
AUDIO_JOGO                            EQU 8	    ; som do jogo


;DESENHAR
DEFINE_LINHA             EQU COMANDOS + 0AH     ; endereço do comando para definir a linha
DEFINE_COLUNA            EQU COMANDOS + 0CH     ; endereço do comando para definir a coluna
DEFINE_PIXEL             EQU COMANDOS + 12H     ; endereço do comando para escrever um pixel


; ECRÃ
APAGA_AVISO               EQU COMANDOS + 40H     ; endereço do comando para apagar o aviso de nenhum cenário selecionado
SELECIONA_ECRA            EQU COMANDOS + 04H     ; endereço do comando para selecionar o ecrã especificado
APAGA_ECRÃ                EQU COMANDOS + 02H     ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO   EQU COMANDOS + 42H     ; endereço do comando para selecionar uma imagem de fundo
APAGA_CENARIO_FRONTAL     EQU COMANDOS + 44H	 ; endereço do comando para apagar cenário frontal
SELECIONA_CENARIO_FRONTAL EQU COMANDOS + 46H     ; endereço do comando para selecionar uma imagem de fundo

;AUDIO
TOCA_SOM				EQU COMANDOS + 5AH      ; endereço do comando para tocar um som
VIDEO_SOM_LOOP          EQU COMANDOS + 5CH      ; endereço do comando para reproduzir som/vídeo em loop
PAUSA_VIDEO_SOM         EQU COMANDOS + 5EH      ; endereço do comando para pausar a reprodução de um som/vídeo
CONTINUA_VIDEO_SOM      EQU COMANDOS + 60H      ; endereço do comando para continuar som/vídeo em pausa
PARA_VIDEO_SOM          EQU COMANDOS + 66H      ; endereço do comando para parar som/vídeo em loop

;Displays
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)

;Constantes
ZERO                            EQU 0       ; constante zero em hexadecimal
UM                              EQU 1       ; constante um em hexadecimal
DOIS                            EQU 2       ; constante dois em hexadecimal
QUATRO                          EQU 0004H   ; constante 4 em hexadecimal
CINCO                           EQU 0005H   ; constante 5 em hexadecimal
NOVE                            EQU 0009H   ; constante 9 em hexadecimal
DEZ                             EQU 010H    ; constante 10 em hexadecimal
ENERGIA_INICIAL_DECIMAL         EQU 100     ; constante 100 em decimal
ENERGIA_INICIAL_HEXADECIMAL     EQU 0100H   ; constante 100 em hexadecimal
A                               EQU 0AH     ; constante A em hexadecimal
B                               EQU 0BH     ; constante B em hexadecimal
SOMA_9                          EQU 06H     ; valor a somar no caso da MASCARA
TAMANHO_PILHA		            EQU 100H    ; tamanho da pilha
FATOR_DIVISAO                   EQU 1000    ; fator de divisão para converter um número de 16 bits em 4 dígitos
N_ASTEROIDES                    EQU 4       ; número de asteróides


;Dimensões/Posições
LINHA_NAVE       EQU  31             ; linha da nave
COLUNA_NAVE      EQU  25             ; coluna da nave
LARGURA_NAVE     EQU  15             ; largura da nave
ALTURA_NAVE      EQU  5              ; altura da nave

LINHA_ASTEROIDE     EQU 5           ; linha do asteroide
LARGURA_ASTEROIDE   EQU 5           ; largura do asteroide
ALTURA_ASTEROIDE    EQU 5           ; altura do asteroide
LIMITE_ASTEROIDE 	EQU 37          ; linha limite para desenhar o asteroide

COLUNA_ASTEROIDE_0  EQU 30          ; coluna inicial do asteroide da esquerda
COLUNA_ASTEROIDE_1  EQU 1			; coluna inicial do asteroide do meio
COLUNA_ASTEROIDE_2  EQU 57          ; coluna inicial do asteroide da direita

LINHA_SONDA         EQU 24          ; linha da sonda
LARGURA_SONDA       EQU 1           ; largura da sonda
ALTURA_SONDA        EQU 1           ; altura da sonda
N_SONDAS            EQU 3           ; número de sondas que podem ser desenhados no ecrã
LIMITE_SONDA        EQU 11          ; linha limite para desenhar a sonda

MENOS_UM			EQU -1			; sentido de movimento da linha das sondas


COLUNA_SONDA_0      EQU   26       ; coluna da sonda 0
COLUNA_SONDA_1      EQU   32       ; coluna da sonda 1
COLUNA_SONDA_2      EQU   38       ; coluna da sonda 2

LINHA_PAINEL        	EQU 30     ; linha do painel
COLUNA_PAINEL       	EQU 29     ; coluna do painel
LARGURA_PAINEL      	EQU 7      ; largura do painel
ALTURA_PAINEL       	EQU 2      ; altura do painel

;Cores
VERMELHO         			EQU 0FF00H          ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
AZUL             			EQU 0F0BDH          ; cor do pixel: azul em ARGB (opaco e vermelho no máximo, verde e azul a 0)
VERDE						EQU 0F0F0H			; cor do pixel: verde em ARGB
AMARELO                     EQU 0F990H			; cor do pixel: amarelo em ARGB
COR_ASTEROIDE    			EQU 0F3F4H          ; cor do asteroide em ARGB
COR_SONDA        			EQU 0FF90H          ; cor do pixel da sonda em ARGB
COR_NAVE					EQU 0F233H          ; cor do pixel da nave em ARGB
COR_PAINEL                  EQU 0F529H          ; cor do pixel do painel em ARGB


; *********************************************************************************
; * Dados 
; *********************************************************************************
PLACE		1000H			
pilha:		
	STACK TAMANHO_PILHA			    		; espaço reservado para a pilha do processo "programa principal"
SP_inicial_prog_princ:		    	; este é o endereço com que o SP deste processo deve ser inicializado
						
	STACK TAMANHO_PILHA			    		; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:					; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA * N_SONDAS  		; espaço reservado para a pilha do processo "sonda"
SP_inicial_sonda:					; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK TAMANHO_PILHA						; espaço reservado para a pilha do processo "energia"
SP_inicial_energia:					; este é o endereço com que o SP deste processo deve ser inicializado

    STACK TAMANHO_PILHA			        	; espaço reservado para a pilha do processo "painel_controlo"
SP_inicial_painel_controlo:			; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA						; espaço reservado para a pilha do processo "asteroide_0"
SP_inicial_asteroide_0:				; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA						; espaço reservado para a pilha do processo "asteriode_1"
SP_inicial_asteroide_1:				; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA						; espaço reservado para a pilha do processo "asteroide_2"
SP_inicial_asteroide_2:				; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA						; espaço reservado para a pilha do processo "asteroide_3"
SP_inicial_asteroide_3:				; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA * N_ASTEROIDES 		; espaço reservado para a pilha do processo "asteroides"
SP_inicial_asteroides:				; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA						; espaço reservado para a pilha do processo "colisoes"
SP_inicial_colisoes:				; este é o endereço com que o SP deste processo deve ser inicializado

    STACK TAMANHO_PILHA						; espaço reservado para a pilha do processo "tecla_0"
SP_inicial_tecla_0:					; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA						; espaço reservado para a pilha do processo "iniciar_jogo"
SP_inicial_iniciar_jogo:			; este é o endereço com que o SP deste processo deve ser inicializado

    STACK TAMANHO_PILHA						; espaço reservado para a pilha do processo "pausar_jogo"
SP_inicial_pausar_jogo:				; este é o endereço com que o SP deste processo deve ser inicializado

    STACK TAMANHO_PILHA						; espaço reservado para a pilha do processo "terminar_jogo"
SP_inicial_terminar_jogo:			; este é o endereço com que o SP deste processo deve ser inicializado


linha_sonda:				; linha em que cada sonda está (inicializada a 0)
	WORD ZERO
	WORD ZERO
	WORD ZERO

coluna_sonda:               ; coluna em que cada sonda está (inicializada com as colunas iniciais)
    WORD COLUNA_SONDA_0
    WORD COLUNA_SONDA_1
    WORD COLUNA_SONDA_2

linha_sonda_inicial:				; linha inicial das sondas
	WORD LINHA_SONDA
	WORD LINHA_SONDA
	WORD LINHA_SONDA

coluna_sonda_inicial:               ; coluna inicial das sondas
    WORD COLUNA_SONDA_0
    WORD COLUNA_SONDA_1
    WORD COLUNA_SONDA_2

linha_asteroide:				; linha em que cada asteroide está
	WORD LINHA_ASTEROIDE
	WORD LINHA_ASTEROIDE
	WORD LINHA_ASTEROIDE
	WORD LINHA_ASTEROIDE

coluna_asteroide:               ; coluna em que cada asteroide está
    WORD ZERO
    WORD ZERO
    WORD ZERO
	WORD ZERO
                              
sentido_movimento_linhas_sondas:			; sentido movimento da linha de cada sonda (+1 para a direita, -1 para a esquerda)
	WORD MENOS_UM
	WORD MENOS_UM
	WORD MENOS_UM

sentido_movimento_linhas_asteroides:		; sentido movimento da linha de cada asteroide (+1 para a direita, -1 para a esquerda)
	WORD UM
	WORD UM
	WORD UM
	WORD UM

sentido_movimento_colunas_sondas:			; sentido movimento da coluna de cada sonda (+1 para a direita, 0 igual, -1 para a esquerda)
	WORD MENOS_UM
	WORD ZERO
	WORD UM

PADRAO_PAINEL_CONTROLO:						; padrão inicial do painel de controlo
	WORD UM


FORMA_ALEATORIA:							; forma aleatória dos asteroides
	WORD UM

POSICAO_ALEATORIA:							; posição aleatória dos asteroides
	WORD UM

COLUNA_DIRECAO_ASTEROIDES:					; posições iniciais dos asteroides
	WORD LINHA_ASTEROIDE
	WORD LINHA_ASTEROIDE
	WORD LINHA_ASTEROIDE
	WORD LINHA_ASTEROIDE


energia_memoria:                       	 	; energia do display
    WORD ENERGIA_INICIAL_DECIMAL

;Tabela das rotinas de interrupção
tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
	WORD rot_int_1			; rotina de atendimento da interrupção 1
	WORD rot_int_2			; rotina de atendimento da interrupção 2
	WORD rot_int_3			; rotina de atendimento da interrupção 3
	
evento_int:							; LOCK para a rotina de interrupção comunicar aos processos que a interrupção ocorreu
    LOCK 0							; relógio asteroides
	LOCK 0				            ; relógio sondas
    LOCK 0        					; relógio energia
    LOCK 0							; relógio nave

tecla_carregada:					; LOCK para o teclado comunicar aos restantes processos que tecla detetou
	LOCK TECLA_NAO_RELEVANTE				

ESTADO_SONDA:      ; ZERO - sonda normal; UM - sonda após colisão
	WORD ZERO
	WORD ZERO
	WORD ZERO

ESTADO_ASTEROIDE:  ; ZERO - asteroide normal; UM - asteroide a explodir; DOIS - asteroide destruído
	WORD ZERO
	WORD ZERO
	WORD ZERO
	WORD ZERO

TIPO_ASTEROIDES: ;ZERO - não minerável; UM - minerável, DOIS - minerável a explodir
	WORD ZERO
	WORD ZERO
	WORD ZERO
	WORD ZERO
	
flags_sondas: ; ZERO - sonda inativa; UM - sonda ativa
	WORD ZERO
	WORD ZERO
	WORD ZERO

flags_asteroides: ; ZERO - asteroide inativo; UM - asteroide ativo
	WORD ZERO
	WORD ZERO
	WORD ZERO
	WORD ZERO

ESTADO_JOGO: ; (ZERO->MODO DE INÍCIO ; UM->MODO DE JOGO; DOIS->MODO DE PAUSA; 3->MODO DE FIM DE JOGO)
    WORD ZERO	

LINHA_TESTAR: ; guarda a linha a ser testada no teclado (começa da 4ªlinha)
    WORD 8	

DEF_PAINEL_DE_CONTROLO:                                   ; tabela que define a nave (largura, altura, pixels)
    WORD        LARGURA_NAVE
    WORD        ALTURA_NAVE
	WORD		0, 0, VERMELHO, VERMELHO,VERMELHO,VERMELHO,VERMELHO,VERMELHO,VERMELHO,VERMELHO,VERMELHO,VERMELHO,VERMELHO, 0, 0
	WORD		0, VERMELHO, COR_PAINEL, COR_PAINEL,COR_PAINEL,COR_PAINEL,COR_PAINEL,COR_PAINEL,COR_PAINEL,COR_PAINEL,COR_PAINEL, COR_PAINEL, COR_PAINEL, VERMELHO, 0
	WORD 		VERMELHO, COR_PAINEL, COR_PAINEL,COR_PAINEL, 0, 0, 0, 0, 0, 0, 0, COR_PAINEL, COR_PAINEL, COR_PAINEL, VERMELHO
	WORD 		VERMELHO, COR_PAINEL, COR_PAINEL,COR_PAINEL, 0, 0, 0, 0, 0, 0, 0, COR_PAINEL, COR_PAINEL, COR_PAINEL, VERMELHO
	WORD		VERMELHO, COR_PAINEL, COR_PAINEL, COR_PAINEL, COR_PAINEL, COR_PAINEL, COR_PAINEL, COR_PAINEL, COR_PAINEL, COR_PAINEL, COR_PAINEL, COR_PAINEL, COR_PAINEL, COR_PAINEL, VERMELHO

DEF_NAVE:                                   ; tabela que define a nave (largura, altura, pixels)
    WORD        LARGURA_NAVE
    WORD        ALTURA_NAVE
	WORD		VERMELHO, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, COR_NAVE, VERMELHO
	WORD 		VERMELHO, COR_NAVE, COR_NAVE,COR_NAVE, 0, 0, 0, 0, 0, 0, 0, COR_NAVE, COR_NAVE, COR_NAVE, VERMELHO
	WORD 		VERMELHO, COR_NAVE, COR_NAVE,COR_NAVE, 0, 0, 0, 0, 0, 0, 0, COR_NAVE, COR_NAVE, COR_NAVE, VERMELHO
	WORD		0, VERMELHO, COR_NAVE, COR_NAVE,COR_NAVE,COR_NAVE,COR_NAVE,COR_NAVE,COR_NAVE,COR_NAVE,COR_NAVE, COR_NAVE, COR_NAVE, VERMELHO, 0
	WORD		0, 0, VERMELHO, VERMELHO,VERMELHO,VERMELHO,VERMELHO,VERMELHO,VERMELHO,VERMELHO,VERMELHO,VERMELHO,VERMELHO, 0, 0


DEF_ASTEROIDE_NAO_MINERAVEL:                              ; tabela que define o asteroide (largura, altura, pixels)
    WORD        LARGURA_ASTEROIDE
    WORD        ALTURA_ASTEROIDE
    WORD        VERMELHO, 0, VERMELHO, 0, VERMELHO
	WORD		0, VERMELHO, VERMELHO, VERMELHO, 0
	WORD		VERMELHO, VERMELHO, 0, VERMELHO, VERMELHO
	WORD		0, VERMELHO, VERMELHO, VERMELHO, 0
	WORD        VERMELHO, 0, VERMELHO, 0, VERMELHO

DEF_ASTEROIDE_DESTRUIDO:								  ; tabela que define o asteroide destruído (largura, altura, pixels)
	WORD		LARGURA_ASTEROIDE
	WORD		ALTURA_ASTEROIDE
	WORD		0, AZUL,0, AZUL,0
	WORD		AZUL,0,AZUL,0, AZUL
	WORD		0, AZUL,0, AZUL,0
	WORD		AZUL,0,AZUL,0, AZUL
	WORD		0, AZUL,0, AZUL,0

DEF_SONDA:                                  ; tabela que define a sonda (largura, altura, pixel)
    WORD        LARGURA_SONDA
    WORD        ALTURA_SONDA
    WORD        COR_SONDA

DEF_ASTEROIDE_MINERAVEL:                   ; tabela que define o asteroide minerável (largura, altura, pixels)
	WORD		LARGURA_ASTEROIDE
	WORD		ALTURA_ASTEROIDE
	WORD 		0, VERDE, VERDE, VERDE, 0
	WORD		VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		VERDE, VERDE, VERDE, VERDE, VERDE
	WORD		VERDE, VERDE, VERDE, VERDE, VERDE
	WORD 		0, VERDE, VERDE, VERDE, 0

DEF_ASTEROIDE_DIMINUI_1:                 ; tabela que define o asteroide diminuído uma vez (largura, altura, pixels)
	WORD		3
	WORD		3
	WORD		VERDE, VERDE, VERDE
	WORD 		VERDE, VERDE, VERDE
	WORD		VERDE, VERDE, VERDE

DEF_ASTEROIDE_DIMINUI_2:        		  ; tabela que define o asteroide diminuído duas vezes (largura, altura, pixels)
	WORD		1
	WORD		1
	WORD		VERDE

DEF_PAINEL_DE_CONTROLO_1:                 ; tabela que define o primeiro padrão do painel de controlo (largura, altura, pixels)
    WORD        LARGURA_PAINEL
    WORD        ALTURA_PAINEL
    WORD        VERDE, COR_PAINEL, VERMELHO, VERDE, AMARELO, AZUL, COR_PAINEL 
    WORD        COR_PAINEL, VERMELHO, VERDE, COR_PAINEL, VERDE, COR_PAINEL, COR_PAINEL

DEF_PAINEL_DE_CONTROLO_2:				  ; tabela que define o segundo padrão do painel de controlo (largura, altura, pixels)
    WORD        LARGURA_PAINEL
    WORD        ALTURA_PAINEL
    WORD        COR_PAINEL, AMARELO, COR_PAINEL, AZUL, AMARELO, VERDE, COR_PAINEL
    WORD        AZUL, COR_PAINEL, AMARELO, VERDE, COR_PAINEL, AZUL, COR_PAINEL

DEF_PAINEL_DE_CONTROLO_3: 				  ; tabela que define o terceiro padrão do painel de controlo (largura, altura, pixels)
    WORD        LARGURA_PAINEL
    WORD        ALTURA_PAINEL
    WORD        VERDE, COR_PAINEL, VERMELHO, COR_PAINEL, COR_PAINEL, AZUL, COR_PAINEL
    WORD        VERDE, VERMELHO, COR_PAINEL, COR_PAINEL, COR_PAINEL, COR_PAINEL, AMARELO

DEF_PAINEL_DE_CONTROLO_4: 				  ; tabela que define o quarto padrão do painel de controlo (largura, altura, pixels)
    WORD        LARGURA_PAINEL
    WORD        ALTURA_PAINEL
    WORD        AMARELO, COR_PAINEL, COR_PAINEL, AMARELO, COR_PAINEL, VERMELHO, COR_PAINEL
    WORD        AZUL, COR_PAINEL, AMARELO, VERDE, VERMELHO, COR_PAINEL, COR_PAINEL

DEF_PAINEL_DE_CONTROLO_5:  				  ; tabela que define o quinto padrão do painel de controlo (largura, altura, pixels)
    WORD        LARGURA_PAINEL
    WORD        ALTURA_PAINEL
    WORD        VERDE, AMARELO, VERMELHO, VERDE, AMARELO, AZUL, VERMELHO
    WORD        COR_PAINEL, VERMELHO, VERDE, AMARELO, COR_PAINEL, VERMELHO, COR_PAINEL

DEF_PAINEL_DE_CONTROLO_6: 				  ; tabela que define o sexto padrão do painel de controlo (largura, altura, pixels)
    WORD        LARGURA_PAINEL
    WORD        ALTURA_PAINEL
    WORD        AMARELO, AZUL, COR_PAINEL, VERDE, COR_PAINEL, COR_PAINEL, VERMELHO
    WORD        AZUL, COR_PAINEL, VERDE, COR_PAINEL, COR_PAINEL, VERMELHO, AMARELO

DEF_PAINEL_DE_CONTROLO_7: 				  ; tabela que define o sétimo padrão do painel de controlo (largura, altura, pixels)
    WORD        LARGURA_PAINEL
    WORD        ALTURA_PAINEL
    WORD        AZUL, VERMELHO, VERDE, AMARELO, VERDE, VERMELHO, AMARELO
    WORD        VERDE, AMARELO, VERMELHO, VERDE, AMARELO, AZUL, VERMELHO

DEF_PAINEL_DE_CONTROLO_8: 				  ; tabela que define o oitavo padrão do painel de controlo (largura, altura, pixels)
    WORD        LARGURA_PAINEL
    WORD        ALTURA_PAINEL
    WORD        AMARELO, VERDE, COR_PAINEL, VERDE, COR_PAINEL, VERDE, AMARELO
    WORD        AMARELO, COR_PAINEL, VERDE, AMARELO, VERDE, COR_PAINEL, VERDE


; *********************************************************************************
; * Código
; *********************************************************************************
    PLACE   0               ; o código tem de começar em 0000H

inicio:
    MOV  SP, SP_inicial_prog_princ ; inicializa SP 
							
	MOV  BTE, tab						; inicializa BTE (registo de Base da Tabela de Exceções)

    MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado 
    MOV  [APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados

	MOV R2, 1
	MOV [SELECIONA_CENARIO_FUNDO], R2	; seleciona o cenário de fundo do modo inicial do jogo

	MOV  R3, 0
	MOV  [DISPLAYS], R3        			; inicializa o display a 0
	
	EI0									; permite interrupções 0
	EI1									; permite interrupções 1
	EI2									; permite interrupções 2
	EI3									; permite interrupções 3
	EI					; permite interrupções (geral)
						; a partir daqui, qualquer interrupção que ocorra usa
						; a pilha do processo que estiver a correr nessa altura


	;processo do teclado
	CALL	teclado					            ; cria o processo teclado
	
	CALL    energia                             ; cria o processo energia
    CALL	asteroide_0			                ; cria o processo asteroide_0
	CALL	asteroide_1			                ; cria o processo asteroide_1
	CALL	asteroide_2			                ; cria o processo asteroide_2
	CALL	asteroide_3			                ; cria o processo asteroide_3
    CALL    painel_controlo		                ; cria o processo painel_controlo
	CALL    colisao			                    ; cria o processo colisao
	
	;processos das teclas
	CALL	dispara_sonda			; cria o processo dispara_sonda
    CALL    iniciar_jogo			; cria o processo iniciar_jogo
	CALL    pausar_jogo			    ; cria o processo pausar_jogo
	CALL    terminar_jogo           ; cria o processo terminar_jogo


; **********************************************************************
; Processo
;
; TECLADO - Processo que deteta quando se carrega numa tecla do teclado.
;           Faz leitura às teclas de uma linha do teclado e 
;           atualiza o LOCK no endereço tecla_carregada, com a 
;           tecla lida.
;
; **********************************************************************
PROCESS SP_inicial_teclado	
						
teclado:
	MOV  R0, TEC_LIN             ; endereço do periférico das linhas
	MOV  R1, TEC_COL             ; endereço do periférico das colunas
	MOV  R2, MASCARA             ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

espera_tecla:			         ; ciclo que espera que uma tecla seja pressionada
	WAIT						 ; este ciclo é potencialmente bloqueante, pelo que tem de
								 ; ter um ponto de fuga (aqui pode comutar para outro processo)
    
	MOV R3, [LINHA_TESTAR]	     ; guarda linha a testar no teclado
	SHR R3, 1                    ; muda a linha a testar
	MOV	[LINHA_TESTAR], R3	     ; guarda a linha do teclado que vai ser testada
	MOV R4, 0		             ; valor da 4ª linha do teclado
	CMP	R3, R4				     ; verifica se está entre as linhas a testar (1ª a 4ª)
	JNZ	continua_teclado         ; se não estiver, continua a testar as linhas do teclado
	MOV	R3, 8				     ; reseta a linha a testar para a 1ª linha do teclado
	MOV	[LINHA_TESTAR], R3	     ; guarda a linha do teclado que vai ser testada

continua_teclado:
	MOVB [R0], R3                ; escreve no periférico de saída (linhas)
	MOVB R4, [R1]                ; ler do periférico de entrada (colunas)
	
;verifica se houve tecla pressionada
	AND  R4, R2                  ; elimina bits para além dos bits 0-3
	CMP R4, 0                    ; Há alguma tecla pressionada?
	JZ espera_tecla     		 ; reseta o processo se não houver tecla pressionada

	MOV R5, 0                    ; inicializa o contador do valor da tecla a 0

obtem_linha:                     
    SHR R3, 1                    ; faz shift right para testar a próxima linha
	JZ obtem_coluna              ; quando o nº linhas já foi contado, vai contar o nº da coluna
    ADD R5, 1                    ; aumenta o nº da linha
    JMP obtem_linha              ; volta a testar a próxima linha

obtem_coluna:                    
    SHR R4, 1                    ; faz shift right para testar a próxima coluna
    JZ valor_tecla             	 ; quando o nº colunas ja foi contado, sai
    ADD R3, 1                    ; aumenta o nº da coluna
    JMP obtem_coluna       		 ; volta a testar a próxima coluna
	      
valor_tecla:                     ; 4 * linha + coluna
    SHL R5, 2                    ; multiplica o número da linha por 4
    ADD R5, R3                   ; adiciona o valor da coluna ao valor da tecla
	MOV R4, R5                   ; guarda o valor do tecla calculado
	MOV [tecla_carregada], R4    ; guarda o valor da tecla carregada

ha_tecla:
	MOVB [R0], R3                ; escreve no periférico de saída (linhas)
	MOVB R4, [R1]                ; ler do periférico de entrada (colunas)

	AND  R4, R2                  ; elimina bits para além dos bits 0-3
	CMP R4, 0                    ; verifica se existe uma tecla premida
	JNZ	ha_tecla		         ; se ainda houver uma tecla premida, espera até não haver

	JMP	espera_tecla
; **********************************************************************



; **********************************************************************
; Processo
;
; ENERGIA - Processo que decrementa a energia do jogo periodicamente.
;
; **********************************************************************
PROCESS SP_inicial_energia

energia:
	YIELD 	                            ; este ciclo é potencialmente bloqueante, pelo que tem de
                                        ; ter um ponto de fuga (aqui pode comutar para outro processo)
    
	MOV  R1, [evento_int + 4]		    ; ativa a interrupção

    MOV R0, [ESTADO_JOGO]
	CMP R0, UM						    ; verifica se o jogo está em modo de jogo
	JNZ energia     				    ; se não estiver, não decrementa a energia

    MOV R1,energia_memoria
	MOV R0, [R1]		 			    ; guarda o valor atual de energia no display 
	SUB R0, 3					 	    ; decresce 3 ao valor atual de energia
    MOV [R1], R0					    ; guarda o novo valor de energia na memória
	
    CALL converte_valor_display        	; calcula o valor a mostrar no display

	CMP R0, 0                           ; verifica se a energia chegou a 0
	JLE  nave_sem_energia               ; se sim, a nave ficou sem energia e o jogo acaba

	JMP energia                         ; volta ao início do ciclo

nave_sem_energia:						; se a energia chegar a 0, o jogo acaba
	MOV R1, 0							
	MOV [DISPLAYS], R1					; coloca a 0 o valor a mostrar no display

	MOV R1, AUDIO_JOGO                  
	MOV [PARA_VIDEO_SOM], R1			; para o som do jogo

	MOV R1, SOM_SEM_ENERGIA
	MOV [TOCA_SOM], R1					; toca o som de ficar sem energia

	MOV R1, 4							
	MOV R0, ESTADO_JOGO                 
	MOV [R0], R1                        ; coloca o jogo em modo de fim de jogo
    MOV [APAGA_ECRÃ], R1				; apaga o ecrã e todos os pixeis desenhados			
	MOV [SELECIONA_CENARIO_FUNDO], R1	; coloca o cenario de fundo no fundo de fim de jogo

	MOV  R1, [evento_int + 4]			; ativa a interrupção
										; faz assim o compasso de espera para alternar o estado e cenario do jogo novamente

	MOV R1, 0
	MOV R0, ESTADO_JOGO                 
	MOV [R0], R1						; coloca o jogo em modo inicial de jogo
	MOV R1,1
	MOV [SELECIONA_CENARIO_FUNDO], R1	; coloca o cenario de fundo para o inicial de jogo
	MOV R1, ENERGIA_INICIAL_DECIMAL
	MOV [energia_memoria], R1           ; reseta a energia_memoria para o valor inicial

	JMP energia
; **********************************************************************
; **********************************************************************
; CONVERTE_VALOR_DISPLAY - Tranforma um valor em hexadecimal noutro valor
;                    que é lido corretamente como decimal no display
; Argumentos:   R0 - valor a converter
;               R1 - valor das unidades
;               R2 - valor das dezenas
;				R4 - 2º operando nos cálculos
;				R5 - variavel auxiliar
;
; Retorna: 		R6 - valor a mostrar no display
; **********************************************************************
converte_valor_display:
	PUSH	R0
	PUSH    R1
	PUSH	R2
	PUSH	R4
	PUSH	R5
	PUSH    R6
    PUSH    R7
; inicializações:
    MOV R7, DISPLAYS
	MOV R0, [energia_memoria] 	; guarda o valor atual de energia
	MOV R1, 0					; inicializa as unidades e as dezenas a 0
	MOV R2, 0
	MOV R4, 10					; inicializa o 2º operando nos cálculos a 10
	MOV R6, 0					; inicializa o variavel que vai ter o valor do display a 0
; display_unidades:
	MOV R5, R0					; guarda o valor original na variavel auxiliar
	MOD R5, R4					; resto da divisão do valor original por 10
	MOV R1, R5					; guarda o resto no registo das unidades
; display_dezenas:
	SUB R0, R5					; valor original - resto da divisão por 10
	DIV R0, R4					; divisão do valor atual por 10
	MOV R5, R0					; guarda o valor atual na variavel auxiliar
	MOD R5, R4					; resto da divisão do valor atual por 10
	MOV R2, R5					; guarda o resto no registo das dezenas
; display_centenas:
	SUB R0, R5					; valor atual - resto da divisão por 10
	DIV R0, R4					; divisão do valor atual por 10
	MOV	R5, R0					; guarda o valor atual na variavel auxiliar
	MOD	R5, R4					; resto da divisão do valor atual por 10

	SHL R2, 4					; move o valor das das dezenas para os digitos 7-4 (em binário)
	SHL R5, 8					; move o valor das centenas para os digitos 11-8 (em binário)
	ADD R6, R1					; soma as unidades ao valor final
	ADD R6, R2					; soma as dezenas ao valor final
	ADD R6, R5					; soma as centenas ao valor final

fim_converte_valor_display:	
	MOV [R7], R6 				; mostra o valor final no display
    POP		R7
	POP     R6
	POP		R5
	POP		R4
	POP		R2
    POP 	R1
	POP		R0
	RET
; **********************************************************************



; **********************************************************************
; Processo
;
; PAINEL_CONTROLO - Processo que desenha e altera o painel de controlo.
;
; **********************************************************************
PROCESS SP_inicial_painel_controlo

painel_controlo:
	YIELD                                   ; este ciclo é potencialmente bloqueante, pelo que tem de
                                            ; ter um ponto de fuga (aqui pode comutar para outro processo)

	MOV R0, [ESTADO_JOGO]
	CMP R0, 1								; verifica se o jogo está em modo de jogo
	JNZ painel_controlo						; se não estiver, volta ao início do ciclo

	MOV  R1, LINHA_NAVE         			; linha da nave
    MOV  R2, COLUNA_NAVE        			; coluna da nave
    MOV  R4, DEF_NAVE           			; endereço da tabela que define a nave
    CALL    desenha_figura     				; desenha a nave

	MOV  R1, LINHA_PAINEL         			; linha do painel de controlo
    MOV  R2, COLUNA_PAINEL        			; coluna do painel de controlo
    MOV  R4, DEF_PAINEL_DE_CONTROLO_1		; endereço da tabela que define o primeiro painel de controlo
    CALL    desenha_figura      			; desenha o primeiro painel de controlo

 painel_controlo_ciclo:
	MOV  R1, [evento_int + 6]				; ativa a interrupção	

	MOV R0, [ESTADO_JOGO]					; modo do jogo pode mudar durante o ciclo
	CMP R0, 1								; para impedir que um padrao do painel de controlo seja desenhado caso o jogo seja terminado
	JNZ painel_controlo						; durante o ciclo, e necessário fazer esta verificação

	MOV  R1, LINHA_PAINEL         			; linha do painel de controlo
    MOV  R2, COLUNA_PAINEL        			; coluna do painel de controlo
	MOV  R5, [PADRAO_PAINEL_CONTROLO]
	ADD  R5, 1								; incrementa o numero do padrão a desenhar
	MOV [PADRAO_PAINEL_CONTROLO], R5		; atualiza o numero do padrão a desenhar
	CALL escolhe_padrao						; escolhe o padrão a desenhar
	CALL desenha_figura						; desenha o padrão escolhido

	JMP painel_controlo_ciclo    	        ; volta ao início do ciclo


; **********************************************************************
; escolhe_padrao: escolhe o padrão a desenhar (alternadamente)
;
; Retorna: R4 - endereço da tabela que define o padrão a desenhar
; **********************************************************************
escolhe_padrao:						        
	PUSH R1
	PUSH R2

	MOV R1, [PADRAO_PAINEL_CONTROLO]
	MOV R4, DEF_PAINEL_DE_CONTROLO_1
	CMP R1, 1
	JZ sai_padrao
	MOV R4, DEF_PAINEL_DE_CONTROLO_2
	CMP R1, 2
	JZ sai_padrao
	MOV R4, DEF_PAINEL_DE_CONTROLO_3
	CMP R1, 3
	JZ sai_padrao
	MOV R4, DEF_PAINEL_DE_CONTROLO_4
	CMP R1, 4
	JZ sai_padrao
	MOV R4, DEF_PAINEL_DE_CONTROLO_5
	CMP R1, 5
	JZ sai_padrao
	MOV R4, DEF_PAINEL_DE_CONTROLO_6
	CMP R1, 6
	JZ sai_padrao
	MOV R4, DEF_PAINEL_DE_CONTROLO_7
	CMP R1, 7
	JZ sai_padrao
	MOV R4, DEF_PAINEL_DE_CONTROLO_8
	MOV R2, 8
	CMP R1, R2
	JZ sai_padrao
	MOV R1, 1							    ; se o padrão for o 8º, volta ao primeiro
	MOV [PADRAO_PAINEL_CONTROLO], R1

 sai_padrao:
	POP R2
	POP R1
	RET
; **********************************************************************
; **********************************************************************
; DESENHA_FIGURA - Desenha uma figura na linha e coluna indicadas
;               com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha da figura
;               R2 - coluna da figura
;               R4 - tabela que define a figura
;
; **********************************************************************
desenha_figura: 
    PUSH    R1              
    PUSH    R2   
    PUSH    R3   
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7
    MOV     R5, [R4]                ; obtém a largura da figura
    MOV     R7, [R4]                ; guardar o valor original da largura
    ADD     R4, 2                   ; endereço da cor do 1º pixel (2 porque a largura é uma word)
    MOV     R6, [R4]                ; obtém a altura da figura
    ADD     R4, 2                   ; endereço da cor do 1º pixel (2 porque a altura é uma word)
    CALL    desenha_linhas          ; desenha as linhas da figura
    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    RET

; **********************************************************************
; DESENHA_LINHAS - Desenha, uma a uma, as linhas da figura.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - endereço da cor do 1º pixel da figura
;               R5 - largura da figura
;               R6 - altura da figura
;
; **********************************************************************
desenha_linhas:                  
    MOV   R3, [R4]              ; obtém a cor do próximo pixel da figura
    CALL  escreve_pixel         ; escreve cada pixel da linha atual da figura
    ADD   R4, 2                 ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD   R2, 1                 ; próxima coluna
    SUB   R5, 1                 ; menos uma coluna para tratar
    JNZ   desenha_linhas        ; continua até percorrer toda a largura da figura
    CALL  proxima_linha       	; passa para a próxima linha da figura
    SUB   R6, 1                 ; menos uma linha para tratar
    JNZ   desenha_linhas        ; continua até percorrer toda a altura da figura
    RET


; **********************************************************************
; PROXIMA_LINHA - Passa para a próxima linha da figura.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R7 - largura da figura
;
; Retorna:      R1 - linha seguinte
; **********************************************************************
proxima_linha:
    MOV   R5, R7                ; obtém o valor inicial da largura
    SUB   R1, 1                 ; próxima linha
    SUB   R2, R7                ; volta à coluna original
    RET

; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
    MOV  [DEFINE_LINHA], R1     ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2    ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3     ; altera a cor do pixel na linha e coluna já selecionadas
    RET


; **********************************************************************
; APAGA_FIGURA - Apaga uma figura na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - endereço da tabela que define a figura
;
; **********************************************************************
apaga_figura:
    PUSH    R1
    PUSH    R2   
    PUSH    R3   
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7
    MOV     R5, [R4]                ; obtém a largura da figura
    MOV     R7, [R4]                ; guardar o valor original da largura
    ADD     R4, 2                   ; endereço da cor do 1º pixel (2 porque a largura é uma word)
    MOV     R6, [R4]                ; obtém a altura da figura
    ADD     R4, 2                   ; endereço da cor do 1º pixel (2 porque a altura é uma word)
    CALL    apaga_linhas            ; apaga as linhas da figura
    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    RET

; **********************************************************************
; APAGA_LINHAS - Apaga as linhas da figura.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - endereço da tabela que define a figura
;               R5 - largura da figura
;               R6 - altura da figura
;
; **********************************************************************
apaga_linhas:
    MOV   R3, 0                 ; cor para apagar o próximo pixel da figura                 
    CALL  escreve_pixel         ; escreve cada pixel da linha atual da figura
    ADD   R4, 2                 ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD   R2, 1                 ; próxima coluna
    SUB   R5, 1                 ; menos uma coluna para tratar
    JNZ   apaga_linhas          ; continua até percorrer toda a largura da figura
    CALL  proxima_linha         ; passa para a próxima linha da figura
    SUB   R6, 1                 ; menos uma linha para tratar
    JNZ   apaga_linhas          ; continua até percorrer toda a altura da figura
    RET
; **********************************************************************
; **********************************************************************



; **********************************************************************
; Processo
;
; ASTEROIDE_0 - Processo que chama a instância 0 do processo asteroides
;
; **********************************************************************
PROCESS SP_inicial_asteroide_0

asteroide_0:
	YIELD
	MOV R2, [ESTADO_JOGO]
	CMP R2, 1						; verifica se o jogo está em modo de jogo
	JNZ asteroide_0					; se não estiver, não continua o processo

	MOV R11, 0						; inicializa R11 com o valor para chamar a instância 0 do processo asteroides
	MOV R10, flags_asteroides		; verifica se o asteroide já está ativo
	MOV R9, [R10]
	CMP R9, UM
	JZ asteroide_0					; se estiver, não continua o processo

	MOV R1, UM
	MOV [R10],R1					; coloca na flag que o asteroide está ativo

	CALL asteroides					; chama o processo asteroides
	JMP asteroide_0


; **********************************************************************
; Processo
;
; ASTEROIDE_1 - Processo que chama a instância 1 do processo asteroides
;
; **********************************************************************
PROCESS SP_inicial_asteroide_1

asteroide_1:
	YIELD
	MOV R2, [ESTADO_JOGO]
	CMP R2, 1						; verifica se o jogo está em modo de jogo
	JNZ asteroide_1					; se não estiver, não continua o processo

	MOV R11, 1						; inicializa R11 com o valor para chamar a instância 1 do processo asteroides
	MOV R10, flags_asteroides		; verifica se o asteroide já está ativo
	MOV R9, [R10+2]
	CMP R9, UM
	JZ asteroide_1					; se estiver, não continua o processo

	MOV R1, UM
	MOV [R10+2],R1					; coloca na flag que o asteroide está ativo

	CALL asteroides					; chama o processo asteroides
	JMP asteroide_1



; **********************************************************************
; Processo
;
; ASTEROIDE_2 - Processo que chama a instância 2 do processo asteroides
;
; **********************************************************************
PROCESS SP_inicial_asteroide_2

asteroide_2:
	YIELD
	MOV R2, [ESTADO_JOGO]
	CMP R2, 1						; verifica se o jogo está em modo de jogo
	JNZ asteroide_2					; se não estiver, não continua o processo

	MOV R11, 2						; inicializa R11 com o valor para chamar a instância correta do processo asteroides
	MOV R10, flags_asteroides		; verifica se o asteroide já está ativo
	MOV R9, [R10+4]
	CMP R9, UM
	JZ asteroide_2					; se estiver, não continua o processo

	MOV R1, UM
	MOV [R10+4],R1					; coloca na flag que o asteroide está ativo

	CALL asteroides					; chama o processo asteroides
	JMP asteroide_2



; **********************************************************************
; Processo
;
; ASTEROIDE_3 - Processo que chama a instância 3 do processo asteroides
;
; **********************************************************************
PROCESS SP_inicial_asteroide_3

asteroide_3:
	YIELD
	MOV R2, [ESTADO_JOGO]
	CMP R2, 1						; verifica se o jogo está em modo de jogo
	JNZ asteroide_3					; se não estiver, não continua o processo

	MOV R11, 3						; inicializa R11 com o valor para chamar a instância correta do processo asteroides
	MOV R10, flags_asteroides		; verifica se o asteroide já está ativo
	MOV R9, [R10+6]
	CMP R9, UM
	JZ asteroide_3					; se estiver, não continua o processo

	MOV R1, UM
	MOV [R10+6],R1					; coloca na flag que o asteroide está ativo

	CALL asteroides					; chama o processo asteroides
	JMP asteroide_3

; **********************************************************************
; Processo
;
; ASTEROIDES - Processo que desenha os asteroides.
;
; **********************************************************************
PROCESS SP_inicial_asteroides

asteroides:
	MOV  R10, 	R11			; cópia do nº de instância do processo
					; multiplica por 2 porque as tabelas são de WORDS
	SHL R10, 1
	; desenha o asteroide na sua posição inicial
	MOV 	R9, linha_asteroide

	CALL valores_aleatorios
	CALL escolhe_posicao_asteroides		; descobre coluna e direção aleatórias
										; R7 coluna 
										; R8 sentido das colunas
    MOV     R1, [R9+R10]     			; linha atual do asteroide

    MOV     R2, R7   					; coluna atual do asteroide

	MOV  R9, sentido_movimento_linhas_asteroides

	CALL escolhe_tipo_asteroide
	MOV  R7, [R9+R10]			; sentido de movimento inicial de cada asteroide
								; NOTA - Cada processo tem a sua cópia própria do R7
								;	    A tabela sentido_movimento é usada para obter o sentido inicial,
								;	    mas a partir daí o R7 de cada processo "asteroide" mantém o sentido respetivo
	MOV R5, R8					; sentido de movimento da coluna

ciclo_asteroide:
	YIELD

	MOV R0, [ESTADO_JOGO]
	CMP R0, DOIS					; verifica se o jogo foi pausado
	JZ ciclo_asteroide				; se foi pausado, não continua o processo

	CMP R0, UM						; verifica se o jogo foi interrompido
	JNZ sai_2						; se foi interrompido, termina o processo

	MOV R3, ESTADO_ASTEROIDE		
	MOV R11, [R3+R10]				; estado atual do asteroide
	MOV R3, DOIS
	CMP R3, R11						; verifica se o estado é dois, ou seja, se o asteroide já explodiu
	JZ sai_2						; se sim sai do processo dos asteroides

	CMP R11, ZERO					; verifica se o estado é zero, ou seja, o asteroide está normal
	JZ normal						; continua o processo normalmente

	MOV R3, ESTADO_ASTEROIDE
	MOV R11, DOIS						
	MOV [R3+R10],R11        		; muda o estado do asteroide para dois, ou seja, já explodiu
	CALL tipo_asteroide				; vai descobrir o tipo de asteroide
	
 normal:
	CALL	desenha_figura			; desenha o asteroide a partir da tabela, na sua posição atual
	MOV R11, linha_asteroide
	MOV [R11+R10], R1 				; linha atual do asteroide
	MOV R11, coluna_asteroide
	MOV [R11+R10], R2				; coluna atual do asteroide

	MOV  R9, evento_int				; 
	MOV  R3, [R9]					; lê o LOCK desta instância (bloqueia até a rotina de interrupção
									; respetiva escrever neste LOCK)
									; Quando bloqueia, passa o controlo para outro processo
									; Como não há valor a transmitir, o registo pode ser um qualquer

	CALL	apaga_figura			; apaga o asteroide na sua posição corrente


	MOV R11, ESTADO_ASTEROIDE
	MOV R3, [R11+ R10]				; estado atual do asteroide
	CMP R3, 1						; verifica se o asteroide está a explodir
	JZ ciclo_asteroide				; se sim, não vai alterar a sua posição, continua o ciclo
	MOV	R6, [R4]					; obtém a largura do boneco
	ADD	R1, R7						; incrementa a linha do asteroide
	ADD R2, R5						; incrementa a coluna do asteroide

	MOV R3, LIMITE_ASTEROIDE
	CMP R1, R3						
	JZ  sai_2						; verifica se a sonda chegou ao limite dos seus movimentos
   
	JMP ciclo_asteroide				; se não chegou ao limite, continua o ciclo

 sai_2:
	MOV R3, ESTADO_ASTEROIDE
	MOV R11, ZERO
	MOV [R3+R10],R11				; inicializa o estado do asteroide a zero (normal)
	MOV R1, linha_asteroide
	MOV R2, 5
	MOV [R1+ R10], R2				; inicializa a linha do asteroide
	MOV R1, coluna_asteroide
	MOV R2, 0
	MOV [R1 + R10], R2				; inicializa a coluna do asteroide
	MOV R9, flags_asteroides	
	MOV R1, ZERO
	MOV [R9+R10], R1 				; reseta a flag da sonda para inativa
	MOV R2, COLUNA_DIRECAO_ASTEROIDES
	MOV R3, 5
	MOV [R2+ R10], R3				; inicializa as linhas iniciais do asteroide
	RET


; ***********************************************************************************
; TIPO_ASTEROIDE: Descobre o tipo de asteroide e muda R4 para a tabela 
;				  que define a explosão do asteroide.
; Argumentos: 	R10 - número do asteroide
; Retorna: 		R4 - tabela que define a explosão do asteroide
; ***********************************************************************************
tipo_asteroide:							
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R5
	PUSH R6
	PUSH R7
	MOV R1, TIPO_ASTEROIDES						; tipos de asteroides
	MOV R2, [R1+R10]							; descobre o tipo de asteroide
	CMP R2, 1									; verifica se o tipo é mineravel e ainda não explodiu
	JZ mineravel_1						

	CMP R2, 2									; verifica se o estado é dois, minerável mas está a explodir (já fez a primeira animação)
	JZ mineravel_2						
												; o tipo é 0, ou seja, é asteroide não minerável
	MOV R5, SOM_COLISAO_ASTEROIDE_NAO_MINERAVEL	
	MOV [TOCA_SOM], R5							; toca o som de explosão do asteroide não minerável
	MOV R4, DEF_ASTEROIDE_DESTRUIDO			; tabela que define a explosão do asteroide não minerável

	JMP sai_3

 mineravel_2:
	MOV R4, DEF_ASTEROIDE_DIMINUI_2			; tabela que define a segunda animação da explosão do asteroide minerável
	JMP sai_3

 mineravel_1:
	MOV R5, SOM_COLISAO_ASTEROIDE_MINERAVEL		
	MOV [TOCA_SOM], R5							; toca o som da explosão do asteroide minerável

	MOV R5, energia_memoria						; energia da nave
	MOV R6, [R5]								
	MOV R7, 25									; adiciona 25 à energia da nave
	ADD R6, R7
	MOV [R5], R6

	MOV R4, DEF_ASTEROIDE_DIMINUI_1			; tabela que define a primeira animação da explosão do asteroide minerável
	MOV R2,2
	MOV [R1+R10], R2							; atualiza o tipo de asteroide para dois (já fez a primeira animação)
	MOV R2, ESTADO_ASTEROIDE					
	MOV R3, 1			
	MOV [R2+R10], R3							; atualiza o estado do asteroide para um (está a explodir)

 sai_3:
	POP R7						
	POP R6
	POP R5
	POP R3
	POP R2
	POP R1
	RET


;***************************************************************************************
; valores_aleatorios - Calcula os valores aleatórios para a forma e posição do asteroide
;***************************************************************************************
valores_aleatorios:
	PUSH R0
	PUSH R1
	MOV  R1, TEC_COL              ; endereço do periférico das colunas
	MOVB R0, [R1]                 ; ler do periférico de entrada
	SHR  R0, 4                    ; deslocar 4 bits para a direita
	CALL forma_aleatoria          ; calcula o valor aleatório para a forma do asteroide
	CALL posicao_aleatoria        ; calcula o valor aleatório para o movimento do asteroide
	POP R1
	POP R0
	RET

;***********************************************************************************
; FORMA_ALEATORIA - Calcula o valor aleatório para a forma do asteroide
; Argumentos: 	R0 - valor aleatório para a forma do asteroide
;
;***********************************************************************************
forma_aleatoria:
	PUSH R0
	PUSH R1
	PUSH R2
	MOV  R2, FORMA_ALEATORIA      ; word correspondente à forma aleatória do asteroide
	MOV  R1, MASCARA_3            ; máscara para isolar 2 bits de menor peso
	AND  R0, R1					  ; aplicação da máscara
	MOV  [R2], R0				  ; escreve na memória o valor correspondente à forma
	POP  R2
	POP  R1
	POP R0
	RET

;***********************************************************************************
; POSICAO_ALEATORIA - Calcula o valor aleatório para a posição do asteroide
; Argumentos: 	R0 - valor aleatório para a posição do asteroide
;
;***********************************************************************************
posicao_aleatoria:
	PUSH R0
	PUSH R1
	PUSH R2
	MOV R2, POSICAO_ALEATORIA   ; word correspondente à posição aleatória do asteroide
	MOV R1, CINCO				; valor para fazer o resto da divisão inteira
	MOD R0, R1					; número aleatório de 0 a 4
	MOV [R2], R0				; escreve na memória o valor correspondente à posição
	POP R2
	POP R1
	POP R0
	RET

;************************************************************************************************
; ESCOLHE_TIPO_ASTEROIDE - Escolhe aleatoriamente o tipo de asteroide
; Retorna: 	R4 - tabela que define o tipo do asteroide
;************************************************************************************************
escolhe_tipo_asteroide:					  	
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R5
	MOV R1, [FORMA_ALEATORIA]             	; número aleatório
	MOV R2, 0                          
	MOV R4, DEF_ASTEROIDE_MINERAVEL       	; tabela do asteroide minerável
	MOV R5, TIPO_ASTEROIDES				  	; tipos de asteroides
	MOV R3, 1
	CMP R1, R2                            	; compara o número aleatório com um
	JZ sai_escolhe_asteroides          	  	; se for igual, asteroide minerável
	MOV R4, DEF_ASTEROIDE_NAO_MINERAVEL    	; se não for igual, asteroide não minerável
	MOV R3, 0
 sai_escolhe_asteroides:
	MOV [R5+R10], R3					  	; atualiza o tipo de asteroide (UM - mineravel; ZERO - não mineravel)
	POP R5
	POP R3
	POP R2
	POP R1 
	RET

;************************************************************************************************
; VERIFICAR_POSICOES_IGUAIS - Verifica se algum asteroide já tem a mesma coluna-direção inicial e,
;                             nesse caso, gera uma nova coluna-direção inicial.
;************************************************************************************************
verifica_posicoes_iguais:				; verifica se algum asteroide já tem a mesma coluna-direção inicial
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	MOV R5, 8							; número de asteroides multiplicado por dois porque cada word ocupa dois bits
	MOV R1, [POSICAO_ALEATORIA]			; coluna-direção do asteroide que estamos a testar
	MOV R3, 0							; contador de asteroides
	MOV R2, COLUNA_DIRECAO_ASTEROIDES	; coluna-direção inicial dos asteroides

 ciclo_posicoes_iguais:
	MOV R4 , [R2+R3]					; coluna-direção do asteroide 
	CMP R4, R1							; verifica se a coluna_posição já está ocupada
	JZ iguais							; se a coluna-posição for igual a outra 
	ADD R3, 2							; próximo asteroide

	CMP R3, R5							; verifica se já comparou com todos os asteroides
	JZ fim_posicoes_iguais				; acaba a verificação
	JMP ciclo_posicoes_iguais			; repete o ciclo para o próximo asteroide

 iguais:	
	CALL valores_aleatorios				; número aletório novo
	CALL verifica_posicoes_iguais		; volta a verificar se a coluna-posição já está ocupada por outro asteroide

 fim_posicoes_iguais:
 	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	RET

;************************************************************************************************
; ESCOLHE_POSICAO_ASTEROIDES - Calcula a posição e direção inicial dos asteroides.
; Retorna: 	R7 - coluna do asteroide
;          	R8 - sentido das colunas do movimento dos asteroides
;************************************************************************************************
escolhe_posicao_asteroides:
	PUSH R1
	PUSH R2
	PUSH R3
	CALL verifica_posicoes_iguais
	MOV R1, [POSICAO_ALEATORIA]
	MOV R2, 1
	MOV R7, COLUNA_ASTEROIDE_0                   ; coluna do asteroide
	MOV R8, 0						;sentido das colunas do movimento dos asteroides 
	CMP R2, R1
	JZ  sai_escolhe_posicao
	MOV R2, 2
	MOV R7, COLUNA_ASTEROIDE_0                   ; coluna do asteroide
	MOV R8, 1						;sentido das colunas do movimento dos asteroides 
	CMP R2, R1
	JZ  sai_escolhe_posicao
	MOV R2, 3
	MOV R7, COLUNA_ASTEROIDE_0                    ; coluna do asteroide
	MOV R8, -1						;sentido das colunas do movimento dos asteroides 
	CMP R2, R1
	JZ  sai_escolhe_posicao
	MOV R2, 4
	MOV R7, COLUNA_ASTEROIDE_1                   ; coluna do asteroide
	MOV R8, 1						;sentido das colunas do movimento dos asteroides 
	CMP R2, R1
	JZ  sai_escolhe_posicao
	MOV R2, 0
	MOV R7, COLUNA_ASTEROIDE_2                   ; coluna do asteroide
	MOV R8, -1						;sentido das colunas do movimento dos asteroides 
	CMP R2, R1
	JZ  sai_escolhe_posicao
 sai_escolhe_posicao:
	MOV R3, COLUNA_DIRECAO_ASTEROIDES
	MOV [R3+R10], R1
	POP R3
	POP R2
	POP R1
	RET 

;******************************************************************************************************************************



; **********************************************************************
; Processo
;
; COLISAO - Processo que trata das colisões entre os vários elementos do jogo.
;
; **********************************************************************
PROCESS SP_inicial_colisoes

colisao:
	YIELD
	MOV R0, [ESTADO_JOGO]
	CMP R0, 1
	JNZ colisao
	MOV R1, linha_asteroide
	MOV R11, 0					; inicializa-se o R11
	MOV R2, coluna_asteroide
	MOV R3, ZERO
	SUB R3, 1
	SUB R1, 2
	SUB R2, 2

loop_testa_colisao:
	YIELD
	ADD R1, 2            ; linha do próximo asteróide
	ADD R2, 2            ; coluna do próximo asteróide
	ADD R3, 1			 ; contador de asteróides
	CMP R3, QUATRO       ; verifica se já foram testados os 4 asteróides
	JZ  colisao          ; se sim, volta ao início do ciclo

	; se não, testa as colisões

	; colisão das sondas com os asteróides
	CALL testa_colisao_asteroides_nave
	CMP R11, 1								; se R11 for igual a 1 então há colisão
	JNZ colisao_sondas						; se não há colisão com a nave vai-se testar a colisão do asteroide com as sondas

	MOV R5, AUDIO_JOGO			
	MOV [PARA_VIDEO_SOM], R5				; para o som de fundo do jogo

	MOV R5, SOM_COLISAO_NAVE	
	MOV [TOCA_SOM], R5						; toca o som de colisão com a nave

	CALL acaba_jogo							; acaba o jogo
	JMP colisao					

	; colisão dos asteróides com a nave
 colisao_sondas:
	CALL testa_colisao_sondas_asteroides
	CMP R11, 1								; se R11 for igual a 1 então há colisão
	JNZ loop_testa_colisao					; volta se a testar para o proximo asterodie

	CALL elimina_asteroide					; muda propriedades do asteróide
	JMP colisao

;**************************************************************************************
; TESTA_COLISAO_SONDAS_ASTEROIDES - Testa se há colisão entre as sondas e os asteróides
; Argumentos: 	R0 - linha da sonda
;				R1 - linha do asteroide
;				R2 - coluna do asteroide
;				R3 - coluna da sonda
;
; Retorna: 		R11 - indicador de colisão
;**************************************************************************************
testa_colisao_sondas_asteroides:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	MOV R4, ZERO
	MOV R0, linha_sonda
	MOV R3, coluna_sonda

 repete:
	MOV R5, [R0]			; linha da sonda
	MOV R6, [R1]			; linha do asteroide
	MOV R7, [R2]			; coluna do asteroide
	MOV R8, [R3]			; coluna da sonda

 esquerda:
	CMP R8, R7
	JLE proxima_sonda          ; se a sonda estiver à esquerda do asteróide, não há colisão
 direita:
	ADD R7, LARGURA_ASTEROIDE
	CMP R8, R7
	JGE proxima_sonda          ; se a sonda estiver à direita do asteróide, não há colisão
 baixo:
	CMP R5, R6
	JGE proxima_sonda          ; se a sonda estiver abaixo do asteróide, não há colisão
 cima:
	SUB R6, ALTURA_ASTEROIDE
	CMP R5, R6
	JLE proxima_sonda          ; se a sonda estiver acima do asteróide, não há colisão

	JMP ha_colisao             ; se nenhuma das condições anteriores se verifica, há colisão

 proxima_sonda: 
	ADD R4, 1
	CMP R4, N_SONDAS
	JZ testa_colisao_sondas_asteroides_fim  ; se já foram testadas as 4 sondas, sai
	ADD R0, 2                				; linha da próxima sonda
	ADD R3, 2                				; coluna da próxima sonda
	JMP repete
 testa_colisao_sondas_asteroides_fim:
	POP R3
	POP R2
	POP R1
	POP R0
	RET

 ha_colisao:
	MOV R11, 1								; se há colisão, então R11 passa a 1
	SHL R4, 1								; multiplica-se o número da sonda por 2 para aceder ao estado da sonda
	MOV R5, ESTADO_SONDA 	
	MOV R6, UM
	MOV [R5+R4], R6							; atualiza o estado da sonda para 1 (após colisão)				
	JMP testa_colisao_sondas_asteroides_fim

;************************************************************************************
; ELIMINA_ASTEROIDE - Muda as propriedades do asteróide após colisão com a nave
; Argumentos: 	R3 - número do asteróide
; 
;************************************************************************************
elimina_asteroide:
	PUSH R3
	PUSH R4
	PUSH R6
	PUSH R7
	MOV R6, R3					; número do asteroide
	MOV R7, 1
	SHL R6, 1
	MOV R4, ESTADO_ASTEROIDE
	MOV [R4+R6], R7				;atualiza o estado do asteroide para 1 (está a explodir)
	POP R7
	POP R6
	POP R4
	POP R3
	RET

;************************************************************************************
; TESTA_COLISAO_ASTEROIDES_NAVE - Testa se há colisão entre os asteróides e a nave.
; Argumentos: 	R1 - linha do asteroide
;				R2 - coluna do asteroide
;
; Retorna: 		R11 - indicador de colisão
;************************************************************************************
testa_colisao_asteroides_nave:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	MOV R6, [R1]			;linha do asteroide
	MOV R7, [R2]			;coluna do asteroide
	MOV R8, COLUNA_NAVE
	MOV R5, LINHA_NAVE

esquerda_nave:
	ADD R7, LARGURA_ASTEROIDE
	CMP R7, R8
	JLE testa_colisao_asteroides_nave_fim       ; se o asteroide estiver à esquerda da nave, não há colisão
 direita_nave:
	MOV R4, LARGURA_NAVE
	SUB R7, LARGURA_ASTEROIDE
	ADD R8, R4
	CMP R7, R8
	JGE testa_colisao_asteroides_nave_fim       ; se o asteroide estiver à direita da nave, não há colisão
 cima_nave:
	SUB R5, ALTURA_NAVE
	CMP R6, R5
	JLE testa_colisao_asteroides_nave_fim       ; se o asteroide estiver acima da nave, não há colisão

	JMP ha_colisao_nave        					; se nenhuma das condições anteriores se verifica, há colisão

 testa_colisao_asteroides_nave_fim:
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

ha_colisao_nave:
	MOV R11, 1									; se há colisão, então R11 passa a 1
	JMP testa_colisao_asteroides_nave_fim

;*************************************************************************************
; acaba_jogo - Termina o jogo atual e volta ao menu inicial
;*************************************************************************************
acaba_jogo:
	PUSH R0
	PUSH R1
	MOV R1, 3
    MOV R0, ESTADO_JOGO
    MOV [R0], R1                         ; coloca o jogo em modo de fim de jogo
    MOV [APAGA_ECRÃ], R1                 ; apaga o ecrã e todos os pixeis desenhados
    MOV [SELECIONA_CENARIO_FUNDO], R1    ; coloca o cenário de fundo no fundo de fim de jogo

    MOV  R1, [evento_int + 4]            ; ativa a interrupção
                                         ; faz assim o compasso de espera para alternar o estado e cenário do jogo novamente

    MOV R1, 0
    MOV R0, ESTADO_JOGO
    MOV [R0], R1                         ; coloca o jogo em modo inicial de jogo
    MOV R1,1
    MOV [SELECIONA_CENARIO_FUNDO], R1    ; coloca o cenário de fundo para o inicial de jogo
    MOV R1, ENERGIA_INICIAL_DECIMAL
    MOV [energia_memoria], R1            ; reseta a energia_memoria para o valor inicial
	POP R1
	POP R0
	RET
;***********************************************************************



; **********************************************************************
; Processo
;
; TECLA_0 - Processo que ativa a sonda 0
;
; **********************************************************************
PROCESS SP_inicial_tecla_0

dispara_sonda:
    MOV R0, [tecla_carregada]		; verifica se a tecla que foi premida foi a tecla 0, 1 ou 2

	MOV R1, 0
	CMP R0, R1
	JZ sai_verificacoes						; se foi a tecla 0, continua o processo

	MOV R1, 1
	CMP R0, R1
	JZ sai_verificacoes						; se foi a tecla 1, continua o processo

	MOV R1, 2
	CMP R0, R1
	JNZ dispara_sonda						; se não foi a tecla 2, não continua o processo

 sai_verificacoes:
	MOV R2, [ESTADO_JOGO]
	CMP R2, 1							; verifica se o jogo está em modo de jogo
	JNZ dispara_sonda					; se não estiver, não continua o processo

    MOV R1, R0
    SHL R1, 1

	MOV R11, R0							; inicializa R11 com o valor para chamar a instância correta do processo sonda
	MOV R10, flags_sondas				; verifica se a sonda já está ativa
	MOV R9, [R10+R1]
	CMP R9, 1
	JZ dispara_sonda					; se estiver, não continua o processo

	MOV R3, UM
	MOV [R10+R1],R3						; coloca na flag que a sonda está ativa

	MOV R5, SOM_SONDA
	MOV [TOCA_SOM], R5					; toca o som do disparo da sonda

    CALL sonda							; chama o processo sonda
	JMP dispara_sonda
; **********************************************************************
; **********************************************************************
; Processo
; 
; SONDA - Processo que implementa o comportamento da sonda.
;
; **********************************************************************
PROCESS SP_inicial_sonda

sonda:
	
	MOV  R10, R11				; cópia do nº de instância do processo
	SHL  R10, 1					; multiplica por 2 porque as tabelas são de WORDS

	;retira 5 ao valor da energia devido ao lançar de uma sonda
	MOV R1,energia_memoria
	MOV R0, [R1]		 		; guarda o valor atual de energia no display 
	SUB R0, 5					; decresce 5 ao valor atual de energia
    MOV [R1], R0				; guarda o novo valor de energia na memória

	; desenha o boneco na sua posição inicial
	MOV 	R9, linha_sonda_inicial
	MOV 	R8, coluna_sonda_inicial
    MOV     R1, [R9+R10]     	; linha atual da sonda
    MOV     R2, [R8+R10]   		; coluna atual da sonda
    MOV     R4, DEF_SONDA       ; endereço da tabela que define a sonda

	MOV  R9, sentido_movimento_linhas_sondas
	MOV  R8, sentido_movimento_colunas_sondas
	MOV  R7, [R9+R10]			; sentido de movimento inicial de cada boneco
								; NOTA - Cada processo tem a sua cópia própria do R7
								;	    A tabela sentido_movimento é usada para obter o sentido inicial,
								;	    mas a partir daí o R7 de cada processo "boneco" mantém o sentido respetivo
	MOV R5, [R8+R10]

ciclo_sonda:
	YIELD

	MOV R0, [ESTADO_JOGO]
	CMP R0, 2						; verifica se o jogo foi pausado
	JZ ciclo_sonda					; se foi pausado, não continua o processo

	CMP R0, 1						; verifica se o jogo foi interrompido
	JNZ sai							; se foi interrompido, termina o processo

	CALL	desenha_figura			; desenha a sonda a partir da tabela, na sua posição atual

	MOV R11, linha_sonda
	MOV [R11+R10], R1 		; atualiza a linha da sonda
	MOV R11, coluna_sonda
	MOV [R11+R10], R2		; atualiza a coluna da sonda

	MOV  R9, evento_int
	MOV  R3, [R9+2]					; lê o LOCK desta instância (bloqueia até a rotina de interrupção
									; respetiva escrever neste LOCK)
									; Quando bloqueia, passa o controlo para outro processo
									; Como não há valor a transmitir, o registo pode ser um qualquer

	CALL	apaga_figura			; apaga a sonda na sua posição corrente

	MOV	R6, [R4]					; obtém a largura da sonda
	ADD	R1, R7						; incrementa a linha da sonda
	ADD R2, R5						; incrementa a coluna da sonda



	MOV R3, LIMITE_SONDA
	CMP R1, R3						
	JZ  sai						; verifica se a sonda chegou ao limite dos seus movimentos
	MOV R11, ESTADO_SONDA
	MOV R3, [R11+R10]
	CMP R3, 1					; verifica se houve colisão com asteroide
	JZ sai

	JMP ciclo_sonda				; se não chegou ao limite, continua o ciclo

 sai:
	MOV R1,0
	MOV [R11+R10], R1
	MOV R1, 0
	MOV R11, linha_sonda
	MOV [R11+R10], R1 			; atualiza a linha da sonda
	MOV R2, 0
	MOV R11, coluna_sonda
	MOV [R11+R10], R2			; atualiza a coluna da sonda
	MOV R9, flags_sondas	
	MOV R1, ZERO
	MOV [R9+R10], R1 			; reseta a flag da sonda para inativa
	RET
; **********************************************************************



; **********************************************************************
; Processo
;
; iniciar_jogo - Processo que coloca o jogo em modo de jogo.
;
; **********************************************************************
PROCESS SP_inicial_iniciar_jogo

iniciar_jogo:
	YIELD

	MOV R0, [tecla_carregada]            	; verifica se a tecla que foi premida foi a tecla C
	MOV R1, TECLA_C
	CMP R0, R1
	JNZ iniciar_jogo

	MOV R0, [ESTADO_JOGO]                 	; verifica se o jogo está em modo de início
	CMP R0, 0
	JNZ iniciar_jogo							  	; se não estiver, não faz nada

	MOV R0, SOM_INICIO
	MOV [TOCA_SOM], R0					  	; toca o som de início

	MOV R0, AUDIO_JOGO
	MOV [VIDEO_SOM_LOOP], R0			  	; ativa o áudio de jogo

	MOV R1, ENERGIA_INICIAL_HEXADECIMAL	  
	MOV [DISPLAYS], R1					    ; coloca o valor inicial de energia no display

	MOV R1, 1
	MOV R0, ESTADO_JOGO
	MOV [R0], R1							; coloca o jogo em modo de jogo
	
	MOV R1,0
    MOV [APAGA_CENARIO_FRONTAL], R1			; apaga o cenário atual
	MOV [SELECIONA_CENARIO_FUNDO], R1		; atualiza o cenário de fundo

	JMP iniciar_jogo
; **********************************************************************

; **********************************************************************
; Processo
;
; pausar_jogo - Processo que coloca o jogo em modo de pausa.
;
; **********************************************************************
PROCESS SP_inicial_pausar_jogo

pausar_jogo:
	YIELD

	MOV R0, [tecla_carregada]			; verifica se a tecla que foi premida foi a tecla D
	MOV R1, TECLA_D
	CMP R0, R1
	JNZ pausar_jogo

	MOV R0, [ESTADO_JOGO]				; verifica se o jogo está em modo de pausa
	CMP R0, 2
	JZ unpause							; se estiver em modo de pausa, coloca o jogo em modo de jogo

	MOV R0, [ESTADO_JOGO]				; verifica se o jogo está em modo de jogo
	CMP R0, 1
	JNZ pausar_jogo

	MOV R1, SOM_DE_PAUSA
	MOV [TOCA_SOM], R1					; toca o som de pausa

	MOV R1, AUDIO_JOGO
	MOV [PAUSA_VIDEO_SOM], R1			; pausa o áudio de jogo

	MOV R1, 2							; se estiver em modo de jogo, coloca o jogo em modo de pausa
	MOV [ESTADO_JOGO], R1
	MOV [SELECIONA_CENARIO_FRONTAL], R1 ; atualiza o cenário de fundo para o cenário de pausa

	JMP pausar_jogo

 unpause:
    MOV R1, 1							; se estiver em modo de pausa, coloca o jogo em modo de jogo
	MOV [ESTADO_JOGO], R1

	MOV R1, AUDIO_JOGO
	MOV [CONTINUA_VIDEO_SOM], R1		; continua o áudio de jogo

	MOV R1,0							
	MOV [APAGA_CENARIO_FRONTAL], R1		; volta a colocar o cenário de fundo de jogo

	JMP pausar_jogo
; **********************************************************************

; **********************************************************************
; Processo
;
; terminar_jogo - Processo que acaba o jogo.
;
; **********************************************************************
PROCESS SP_inicial_terminar_jogo

terminar_jogo:
	YIELD

	MOV R0, [tecla_carregada]			; verifica se a tecla que foi premida foi a tecla E
	MOV R1, TECLA_E
	CMP R0, R1
	JNZ terminar_jogo

	MOV R0, [ESTADO_JOGO]				; verifica se o jogo está em modo de início
	CMP R0, 0
	JZ  terminar_jogo							; se estiver, não faz nada

	MOV R0, [ESTADO_JOGO]				; verifica se o jogo está em modo de fim de jogo
	CMP R0, 3
	JZ  terminar_jogo							; se estiver, não faz nada

	MOV R1, AUDIO_JOGO
	MOV [PARA_VIDEO_SOM], R1			; para o áudio de jogo

	MOV R1, SOM_JOGO_TERMINADO
	MOV [TOCA_SOM], R1					; toca o som de fim de jogo

	MOV R1, 5
	MOV R0, ESTADO_JOGO					
	MOV [R0], R1						; coloca o jogo em modo de fim de jogo
	MOV [APAGA_ECRÃ], R1							
	MOV [APAGA_CENARIO_FRONTAL], R1		
	MOV [SELECIONA_CENARIO_FUNDO], R1	; atualiza o cenário de fundo para o cenário de fim de jogo

	MOV  R1, [evento_int + 4]			; ativa a interrupção

	MOV R1, 0
	MOV R0, ESTADO_JOGO					
	MOV [R0], R1						; coloca o jogo em modo de início
	MOV R1,1
	MOV [SELECIONA_CENARIO_FUNDO], R1	; atualiza o cenário de fundo para o cenário de início

	MOV R1, ENERGIA_INICIAL_DECIMAL
	MOV [energia_memoria], R1			; reinicia o valor da energia na memória para o valor inicial

	JMP terminar_jogo
; **********************************************************************



; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
rot_int_0:
	PUSH	R1
	MOV  R1, evento_int
	MOV	[R1], R2	; desbloqueia processo boneco (qualquer registo serve)
					; O valor a somar ao R1 (base da tabela dos LOCKs) é
					; o dobro do número da interrupção, pois a tabela é de WORDs
	POP	R1
	RFE

; **********************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 1
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
rot_int_1:
	PUSH	R1
	MOV  R1, evento_int
	MOV	[R1+2], R2	; desbloqueia processo boneco (qualquer registo serve)
					; O valor a somar ao R1 (base da tabela dos LOCKs) é
					; o dobro do número da interrupção, pois a tabela é de WORDs
	POP	R1
	RFE

; **********************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 2
;			Faz simplesmente uma escrita no LOCK que o processo energia lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
rot_int_2:
	PUSH	R1
	MOV  R1, evento_int
	MOV	[R1+4], R2	; desbloqueia processo energia
					; O valor a somar ao R1 (base da tabela dos LOCKs) é
					; o dobro do número da interrupção, pois a tabela é de WORDs
    POP R1
	RFE
; **********************************************************************


; **********************************************************************
; ROT_INT_3 - 	Rotina de atendimento da interrupção 3
;			Faz simplesmente uma escrita no LOCK que o processo boneco lê.
;			Como basta indicar que a interrupção ocorreu (não há mais
;			informação a transmitir), basta a escrita em si, pelo que
;			o registo usado, bem como o seu valor, é irrelevante
; **********************************************************************
rot_int_3:
	PUSH	R1
	MOV  R1, evento_int
	MOV	[R1+6], R2	; desbloqueia processo do painel de controlo
					; O valor a somar ao R1 (base da tabela dos LOCKs) é
					; o dobro do número da interrupção, pois a tabela é de WORDs
    POP R1
	RFE

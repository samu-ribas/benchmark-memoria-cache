#!/bin/bash

# resolve o conflito entre o printf  e  awk.
export LC_NUMERIC=C 

# arquivos gerados
OUTPUT_CSV="resultados.csv"
PLOT_FILE="grafico_cache.png"

# intervalo 
INICIO=0
FIM=12000
PASSO=50
REPETICOES=10

echo "Tamanho,Linhas_ms,Colunas_ms" > $OUTPUT_CSV

for ((s=INICIO; s<=FIM; s+=PASSO)); do
    
    # compilação 
    if ! gcc tempoLinhas.c -o exe_linhas -DTAM=$s; then
        echo "Erro na compilação de Linhas!"
        exit 1
    fi
    if ! gcc tempoColunas.c -o exe_colunas -DTAM=$s; then
        echo "Erro na compilação de Colunas!"
        exit 1
    fi

    echo -ne "Matriz ${s}x${s}: Rodando... \r"

    # variáveis para guardar a lista de tempos 
    LISTA_LIN=""
    LISTA_COL=""

    #repetições
    for ((k=1; k<=REPETICOES; k++)); do
        #executa
        RAW_LIN=$(./exe_linhas)
        RAW_COL=$(./exe_colunas)

        #captura apenas o numero
        VAL_LIN=$(echo "$RAW_LIN" | grep "RESULTADO:" | awk '{print $2}')
        VAL_COL=$(echo "$RAW_COL" | grep "RESULTADO:" | awk '{print $2}')
	
        if [ -z "$VAL_LIN" ]; then VAL_LIN=0; fi
        if [ -z "$VAL_COL" ]; then VAL_COL=0; fi

        # acumula na lista
        LISTA_LIN="$LISTA_LIN $VAL_LIN"
        LISTA_COL="$LISTA_COL $VAL_COL"
    done

    # calcula a média de uma vez só 
    # soma tudo e divide pelo número de itens
    MEDIA_LIN=$(echo $LISTA_LIN | awk '{s=0; for(i=1;i<=NF;i++) s+=$i; print s/NF}')
    MEDIA_COL=$(echo $LISTA_COL | awk '{s=0; for(i=1;i<=NF;i++) s+=$i; print s/NF}')

    # salva no CSV
    echo "$s,$MEDIA_LIN,$MEDIA_COL" >> $OUTPUT_CSV
    
    echo -ne "Matriz ${s}x${s}: Média Linhas=${MEDIA_LIN}ms | Média Colunas=${MEDIA_COL}ms      \n"
done

echo -e "\n--- Testes finalizados"

gnuplot <<- EOF
    set terminal pngcairo size 1024,768 enhanced font 'Verdana,10'
    set output '$PLOT_FILE'
    set title "Impacto da Cache: Acesso Linear vs Colunar (Média de $REPETICOES execuções)"
    set xlabel "Tamanho da Matriz (TAM)"
    set ylabel "Tempo Médio de Execução (ms)"
    set datafile separator ","
    set grid
    set key left top
    plot '$OUTPUT_CSV' using 1:2 with lines lw 2 title 'Otimizado (Linhas)', \
         '$OUTPUT_CSV' using 1:3 with lines lw 2 title 'Não-Otimizado (Colunas)'
EOF

echo "Verifique: $PLOT_FILE"
rm exe_linhas exe_colunas

/*
    esse código funde a lógica de medição de tempo com acesso sequencial por linhas
    que favorece a cache 
*/
#include<stdlib.h>
#include<sys/time.h>
#include<stdio.h>

#ifndef TAM
#define TAM 2000
#endif 

typedef struct pixel{
    unsigned int r, g, b;
}pixel; 

pixel **color;

int main()
{
    double ti, tf, tempo; // ti = tempo inicial // tf = tempo final
    struct timeval tempo_inicio , tempo_fim;
    int i, j;

    color = (pixel **)malloc(TAM * sizeof(pixel *));

    if(!color){
        printf("Erro: Falta de memória para alocar as linhas\n");
        return 1;
    }

    // Aloca as colunas para cada linha
    for(i=0 ; i<TAM ; i++){
        color[i] = (pixel *)malloc(TAM * sizeof(pixel));
        if(!color[i]){
            printf("Erro: Falta de memória na linhas %d\n", i);
            return 1;
        }
    }
    // marca  o tempo inicial
    gettimeofday(&tempo_inicio , NULL); 

    // acessa a matriz linha por linha
    for(i=0 ; i<TAM ; i++){
        for(j=0 ; j<TAM ; j++)
            color[i][j].r = (color[i][j].r + color[i][j].g + color[i][j].b) / 3;
    }
    // marca o tempo final
    gettimeofday(&tempo_fim, NULL);

    tf = (double)tempo_fim.tv_usec + ((double)tempo_fim.tv_sec *(1000000.0));
    ti = (double)tempo_inicio.tv_usec + ((double)tempo_inicio.tv_sec *(1000000.0));
    // convertendo tempo p/ milissegundos
    tempo = (tf - ti) / 1000 ;
    printf("RESULTADO: %.3f\n", tempo);
    for(i = 0; i < TAM; i++)
        free(color[i]);
    free(color);
    return 0;
}
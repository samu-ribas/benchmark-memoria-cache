# ⚡ Análise de Desempenho: Localidade de Memória e Cache

Este projeto demonstra empiricamente o impacto da **Hierarquia de Memória** e da **Localidade Espacial** no desempenho de algoritmos computacionais. O experimento compara tempos de execução de acessos matriciais otimizados (por linhas) versus não-otimizados (por colunas) em linguagem C.

## 📋 Sobre o Projeto

Embora ambos os algoritmos possuam a mesma complexidade assintótica ($O(N^2)$), a forma como os dados são acessados na memória física altera drasticamente o tempo de execução. Este repositório prova a existência do **Gargalo de Memória (Memory Wall)** e a importância de escrever código amigável à Cache (*Cache-Friendly*).

### O Experimento
Foram desenvolvidos dois programas em C utilizando **alocação dinâmica de memória** (`malloc` com ponteiros para ponteiros) para processar grandes matrizes de pixels (`struct pixel {r,g,b}`):

1.  **Row-Major (Otimizado):** Acessa a memória sequencialmente (`matriz[i][j]`). Aproveita o *Hardware Prefetcher* e maximiza **Cache Hits**.
2.  **Column-Major (Não-Otimizado):** Acessa a memória com grandes saltos (`matriz[j][i]`). Invalida a Cache L1/L2/L3 e gera excessivos **Cache Misses** e **TLB Misses**.

## 🛠️ Tecnologias Utilizadas

* **Linguagem C:** Para manipulação direta de memória e ponteiros.
* **Shell Script (Bash):** Para
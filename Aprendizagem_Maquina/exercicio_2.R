##### EXERCICIO 1 - TÓPICOS EM APRENDIZADO DE MÁQUINA E SUAS APLICAÇÕES #######
##### ALUNO: FELIPPE GALDINO SILVA


# ÁRVORE DE DECISÃO

library(dplyr)


#### Criando o DataFrame


# Dados
Condicao <- c("1","0","1","1","0","0")
Embarque <- c("S","S","S","S","S","S")
Genero <- c("F","M","M","F","F","M")
Fam1 <- c(1,0,1,1,1,1)
Fam2 <- c(0,2,2,2,0,0)
Tarifa <- c(221.34, 26.55, 26.55, 151.55, 151.55, 151.55)

titanic_df <- data.frame(Condicao,
                         Embarque,
                         Genero,
                         Fam1,
                         Fam2,
                         Tarifa)



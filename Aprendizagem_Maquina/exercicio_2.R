##### EXERCICIO 2 - TÓPICOS EM APRENDIZADO DE MÁQUINA E SUAS APLICAÇÕES #######
##### ALUNO: FELIPPE GALDINO SILVA


# ÁRVORE DE DECISÃO

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


# Checando o dataframe

titanic_df


########################################################

# Entropia é a medida da incerteza do dado
# Ganho de INformação é a redução da Entropia


# Ganho de info = Entropia do sistema antes da divisão - Entropia do sist. depois a divisão


# Calculando entropia


entropia <- function(data_column){
  classes_atr <- unique(data_column)
  total <- length(data_column)

  num_classes <- data.frame("Classe" = character(),
                            "Ocorrencias" = numeric(),
                            "Es_valor" = numeric())
  for(cl in classes_atr){
    ocorrencias <- sum(data_column == cl)

    p = ocorrencias/total

    e_valor = - p * log2(p)

    num_classes <- rbind(num_classes, data.frame(cl, ocorrencias, e_valor))
  }
  sum(num_classes$e_valor)
}



split_data <- function(data_frame, coluna, limiar){
  left <- data_frame[data_frame[,coluna] < limiar,]
  right <- data_frame[data_frame[,coluna] >= limiar,]
  result <- list(left, right)
  result
}


define_limiar <- function(valores){
  n_valores <- length(valores) - 1

  novos_valores <- list()
  for(n in 1:n_valores){
    limiar <- mean(valores[n] + valores[n+1])/2
    novos_valores[n] = limiar
  }
  novos_valores
}


entropia_num <- function(left, right){
  left_side = nrow(left)
  right_side = nrow(right)

  total = left_side + right_side
  p_left = left_side/total
  p_right = right_side/total

  H = (-p_left * log2(p_left)) + (- p_right * log2(p_right))

  # if H is NaN, thats no value for either left or right side...
  if(is.nan(H)){
    H <- 0
  }

  return(H)
}



limiares = data.frame(limiar = numeric(),
                      left_side = numeric(),
                      right_side = numeric(),
                      H = numeric(),
                      GI = numeric())


entropia_por_limiar <- function(data_frame, coluna){

  valores_ordenados <- sort(unique(data_frame[,coluna]))
  valores_ordenados <- vapply(valores_ordenados, floor,0)

  valores_ordenados <- define_limiar(valores_ordenados)

  for(valor in valores_ordenados){
    splitted_data <- split_data(data_frame, coluna, valor)
    left_part <- splitted_data[[1]]
    right_part <- splitted_data[[2]]

    H = entropia_num(left_part, right_part)

    H_limiar = data.frame(limiar = valor,
                          left_side = nrow(left_part),
                          right_side = nrow(right_part),
                          H = H,
                          GI = 1 - H)

    limiares <- rbind(limiares, H_limiar)
  }
  limiares
}



### USANDO RPART

library(rpart)
library(rattle)

titanic_tree <- rpart(
  Condicao ~ Fam1 + Fam2 + Tarifa + Genero,
  data = titanic_df,
  method = "class",
  control = rpart.control(minsplit = 1,
                          minbucket = 1,
                          cp = 0.001)
)


fancyRpartPlot(titanic_tree, caption = NULL)


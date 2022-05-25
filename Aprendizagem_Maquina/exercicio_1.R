##### EXERCICIO 1 - TÓPICOS EM APRENDIZADO DE MÁQUINA E SUAS APLICAÇÕES #######
##### ALUNO: FELIPPE GALDINO SILVA


## GERANDO OS DADOS ##

# Função Mackey-Glass
mackey_glass <- function(xn, x_lag){
  x_mg <- ((0.2 * x_lag) / (1 + x_lag^10)) - 0.1*xn
  x_mg
}

# Configuração Inicial

x0 = 1.2
tau = 17
delta_t = 0.1
n_times = 1000

X = vector(mode="numeric", length=n_times)
T_vec = vector(mode="numeric", length=n_times)

X[1] <- x0
T_vec[1] <- 0

for(tempo in 1:(n_times-1)){

  xn = X[tempo]
  tn = T_vec[tempo]

  lag = tempo - tau
  x_lag <- ifelse(lag <= 0, 0, X[lag])



  k1 = mackey_glass(xn, tn)
  k2 = mackey_glass(xn + delta_t/2, x_lag + delta_t/2*k1)
  k3 = mackey_glass(xn + delta_t/2, x_lag + delta_t/2*k1)
  k4 = mackey_glass(xn + delta_t, x_lag + k3*delta_t)

  t_n_1 = tn + delta_t

  x_n_1 = xn + (k1 + 2*k2 + 2*k3 + k4)/6

  X[tempo+1] <- x_n_1
  T_vec[tempo+1] <- t_n_1

}


### FORMULA 2

for(tempo in 1:(n_times-1)){

  xn = X[tempo]
  tn = T_vec[tempo]

  lag = tempo - tau
  x_lag <- ifelse(lag <= 0, 0, X[lag])


  k1 = mackey_glass(xn, x_lag)
  k2 = mackey_glass(xn + k1*delta_t/2, x_lag + delta_t/2)
  k3 = mackey_glass(xn + k2*delta_t/2, x_lag + delta_t/2)
  k4 = mackey_glass(xn + k3*delta_t, x_lag + delta_t)

  t_n_1 = tn + delta_t

  x_n_1 = xn + (k1 + 2*k2 + 2*k3 + k4)/6

  X[tempo+1] <- x_n_1
  T_vec[tempo+1] <- t_n_1

}


##############################################################

# Checando a série

plot(X, type="l")




### FORMULA 3 WIKIPEDIA
# https://pt.wikipedia.org/wiki/M%C3%A9todo_de_Runge-Kutta

for(tempo in 1:(n_times-1)){

  xn = X[tempo]
  tn = T_vec[tempo]

  lag = tempo - tau
  x_lag <- ifelse(lag <= 0, 0, X[lag])


  k1 = mackey_glass(xn, x_lag)
  k2 = mackey_glass(xn + delta_t/2, x_lag + k1*2)
  k3 = mackey_glass(xn + delta_t/2, x_lag + k2/2)
  k4 = mackey_glass(xn + delta_t, x_lag + k3*delta_t)

  t_n_1 = tn + delta_t

  x_n_1 = xn + (k1 + 2*k2 + 2*k3 + k4)/6

  X[tempo+1] <- x_n_1
  T_vec[tempo+1] <- t_n_1

}


##############################################################

# Checando a série

plot(X, type="l")

# Gggplot

library(ggplot2)


teste_treino <- data.frame(x = c(25, 1.3),
                           y = c(75,1.3),
                           text = c("Base Treino", "Base Teste"))

plot_rk4 <- ggplot(data=data.frame(X = X, Tempo = T_vec), aes(x=Tempo, y=X)) +
            geom_line(colour='blue') +
            geom_vline(xintercept=50) +
            labs(
              title = "Série Completa",
              x = "Tempo",
              y = "X",
            ) +
            annotate("text", x=25, y = 1.35, label = "Base Treino") +
            annotate("text", x=75, y = 1.35, label = "Base Teste") +
            theme_minimal()


############## PARTE 2 #########################
###### CRIANDO O MODELO ########################


library(keras)
library(dplyr)

X.treino <- X[1:500]
X.teste <- X[501:1000]

# Criando os valores de entrada:

get_lag_value <- function(vec, lag){

  size_vec = length(vec)
  X_lagged <- vector(mode="numeric", length=size_vec)

  for(tempo in 1:(size_vec-1)){
    idx = tempo - lag
    x_lag <- ifelse(idx <= 0, 0, vec[idx])

    X_lagged[tempo] <- x_lag

  }
  X_lagged
}

get_lag_value_frente <- function(vec, lag){

  size_vec = length(vec)
  X_lagged <- vector(mode="numeric", length=size_vec)

  for(tempo in 1:(size_vec-1)){
    idx = tempo + lag
    x_lag <- ifelse(idx > size_vec, 0, vec[idx])

    X_lagged[tempo] <- x_lag

  }
  X_lagged
}


X_18 <- get_lag_value(X.treino, 18)
X_12 <- get_lag_value(X.treino, 12)
X_6 <- get_lag_value(X.treino, 6)
X_ <- X.treino

X_out_6 <- get_lag_value_frente(X.treino, 6)


input_data <- matrix(c(X_18, X_12, X_6, X_),
                     nrow = 500,
                     ncol=4,
                     byrow = FALSE)

# One Hot Encoding
input_data.labels <- to_categorical(input_data)
output_data.labels <- to_categorical(X_out_6)

# Checando os labels
print(input_data.labels)

modelo <- keras_model_sequential()

modelo %>% layer_dense(units=12, activation = 'tanh', input_shape = c(4)) %>%
            layer_dense(units = 2, activation = 'tanh')


# Compilação

modelo %>% compile(loss='mse',
                   optimizer='adam',
                   metrics='accuracy')


# Fit model

history <- modelo %>%
              fit(input_data,
                  input_data.labels,
                  epoch = 400,
                  batch_size = 32,
                  validation_split = 0.2)









library(kerasR)

mod <- Sequential()

# Input
mod$add(Dense(units = 12, input_shape = 4))

# Funcao de ativacao
mod$add(Activation("tanh"))

# Output
mod$add(Dense(units = 1))

# Compilando o modelo...

keras_compile(mod,  loss = 'mse', optimizer = "RMSprop")



history <- keras_fit(
  mod,
  input_data,
  as.matrix(X_out_6),
  epochs = 500,
  batch_size = 5
)


mod$weights





# One Hot Encoding

X.treinoClasse <- to_categorical(X.treino)
X.testeClasse <- to_categorical(X.teste)

# tanh

modelo <- keras_model_sequential()

modelo %>%
  layer_dense(units = 12, activation = 'tanh', input_shape = c(500)) %>%
  layer_dense(units = 12, activation = 'tanh', input_shape = c(500)) %>%
  layer_dense(units = 12, activation = 'tanh', input_shape = c(1)) %>%
  layer_dense(units = 12, activation = 'tanh', input_shape = c(1))

history <- modelo %>% fit(
  X_18,
  X_12,
  X_6,
  X_out_6,
  epochs = 200,
  batch_size = 5,
  validation_split = 0.2
)

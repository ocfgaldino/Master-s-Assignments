##### EXERCICIO 1 - TÓPICOS EM APRENDIZADO DE MÁQUINA E SUAS APLICAÇÕES #######
##### ALUNO: FELIPPE GALDINO SILVA


## GERANDO OS DADOS ##


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


  k1 = mackey_glass(xn, x_lag)
  k2 = mackey_glass(xn + delta_t/2, x_lag + k1/2)
  k3 = mackey_glass(xn + delta_t/2, x_lag + k2/2)
  k4 = mackey_glass(xn + delta_t, x_lag + k3)

  t_n_1 = tn + delta_t

  x_n_1 = xn + (k1 + 2*k2 + 2*k3 + k4)/6

  X[tempo+1] <- x_n_1
  T_vec[tempo+1] <- t_n_1

}

##############################################################

# Checando a série

plot(X, type="l")





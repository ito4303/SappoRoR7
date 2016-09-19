##
## RStanによる状態空間モデル
## SappoRo.R #7
##

library(dlm)
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

set.seed(1234)

## データ
data(Nile)
stan_data <- list(N = length(Nile),
                  y = matrix(c(Nile), 1),
                  m0 = 1000,
                  C0 = matrix(1e4, 1, 1))
fit <- stan("dlm1.stan", data = stan_data,
             pars = c("s2"), seed = 1,
             iter = 2000, warmup = 1000)
print(fit)

s2 <- get_posterior_mean(fit, pars = "s2")[, "mean-all chains"]


##
## 2階差分
##

stan_data <- list(N = length(Nile),
                  y = matrix(c(Nile), 1),
                  m0 = c(1000, 10),
                  C0 = matrix(c(1e7, 0, 0, 1e7), 2, 2))
fit <- stan("dlm2.stan", data = stan_data,
            pars = c("s2"), seed = 1,
            iter = 2000, warmup = 1000)
print(fit)

s2 <- get_posterior_mean(fit, pars = "s2")[, "mean-all chains"]

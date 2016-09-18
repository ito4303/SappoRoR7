##
## RStanによる状態空間モデル
## SappoRo.R #7
##

library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())


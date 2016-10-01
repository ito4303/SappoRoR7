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
## http://statmodeling.hatenablog.com/entry/state-space-model-many-terms
## で使用されているデータ
## library(readr)
## data <- read_tsv(url("http://kasugano.sakura.ne.jp/images/old/data_20131226.txt"))

## ナイル川のデータ
data(Nile)

## Stanにわたすデータのリスト
stan_data <- list(N = length(Nile),
                  y = matrix(Nile, 1),
                  m0 = 100,
                  C0 = matrix(100, 1, 1))

## あてはめ
fit <- stan("dlm1.stan", data = stan_data,
             pars = c("s2"), seed = 1,
            iter = 2000, warmup = 1000)

## 結果表示
print(fit)

## パラメータの事後平均をとりだす
s2 <- get_posterior_mean(fit, pars = "s2")[, "mean-all chains"]

## dlmでのモデル定義
buildFunc <- function(theta) {
    dlmModPoly(order = 1, dV = theta[1], dW = theta[2])
}

## Stanで推定したパラメータを適用
mod <- buildFunc(s2)

## カルマンスムーザー
smo <- dlmSmooth(Nile, mod)

## グラフ表示
plot(Nile, type = "l",
     xlab = "Year", ylab = "Flow", las = 1)
lines(smo$s, col = 2)


##
## 2階差分
##

## Stanにわたすデータのリスト
stan_data <- list(N = length(Nile),
                  y = matrix(Nile, 1),
                  m0 = c(100, 1),
                  C0 = matrix(c(1e7, 0, 0, 1e7), 2, 2))

## あてはめ
fit <- stan("dlm2.stan", data = stan_data,
            pars = c("s2"), seed = 1,
            iter = 2000, warmup = 1000)

## 結果表示
print(fit)

## パラメータの事後平均をとりだす
s2 <- get_posterior_mean(fit, pars = "s2")[, "mean-all chains"]

## dlmでのモデル定義
buildFunc <- function(theta) {
    dlmModPoly(order = 2, dV = theta[1], dW = theta[2:3])
}
mod <- buildFunc(s2)

## カルマンスムーザー
smo <- dlmSmooth(Nile, mod)

## グラフ表示
par(mfrow = c(2, 1))
plot(Nile, type = "l",
     xlab = "Year", ylab = "Flow", las = 1)
## Level成分
lines(smo$s[, 1], col = 2)

## Slope成分
plot(smo$s[, 2], type = "l", col = 2,
     xlab = "Year", ylab = "Slope", las = 1)

par(mfrow = c(1, 1))

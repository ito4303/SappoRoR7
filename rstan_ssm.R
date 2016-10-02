##
## RStanによる状態空間モデル
## SappoRo.R #7
##

library(dlm)
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

set.seed(1234)

## グラフの設定
width <- 10 / 2.54
height <- 7.5 / 2.54
point <- 10

## ナイル川のデータ
data(Nile)

pdf("Nile.pdf", width = width, height = height, pointsize = point)
plot(Nile, las = 1, xlab = "Year", ylab = "Flow")
dev.off()

##
## ローカルレベルモデル
##

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
s2 <- get_posterior_mean(fit, pars = "s2")
s2.mean <- s2[, "mean-all chains"]

## Stanで推定したパラメータをつかって、dlmのモデル定義
mod <- dlmModPoly(order = 1, dV = s2.mean[1], dW = s2.mean[2])

## カルマンスムーザー
smo <- dlmSmooth(Nile, mod)

## グラフ表示
pdf("dlm1_smooth.pdf", width = width, height = height, pointsize = point)
plot(Nile, type = "l",
     xlab = "Year", ylab = "Flow", las = 1)
lines(smo$s, col = 2)
dev.off()

## カルマンフィルター
filt <- dlmFilter(Nile, mod)

## 状態
m <- filt$m[-1]

## 予測
## 予測する年数
nyear <- 10

## 予測期間の初期値の設定
m0(mod) <- tail(m, 1)
C0(mod) <- diag(1) * s2[2]

fore <- dlmForecast(mod, nAhead = nyear)

## 観測値の予測の80%信頼区間
lim <- outer(sapply(fore$Q, function(x) sqrt(diag(x))),
             qnorm(c(0.1, 0.9))) +
       cbind(fore$f, fore$f)

pdf("dlm1_predict.pdf", width = width, height = height, pointsize = point)
plot(Nile, type = "l",
     xlim = c(start(Nile)[1], end(Nile)[1] + nyear),
     ylim = c(min(lim, Nile), max(lim, Nile)),
     xlab = "Year", ylab = "Flow", las = 1)

lines(x = (end(Nile)[1] + 1):(end(Nile)[1] + nyear),
      y = fore$f[, 1], col = 4, lty = 2)
for (i in 1:2)
    lines(x = (end(Nile)[1] + 1):(end(Nile)[1] + nyear),
          y = lim[, i], col = 4, lty = 2)
dev.off()

##
## トレンドモデル
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
mod <- dlmModPoly(order = 2, dV = s2[1], dW = s2[2:3])

## カルマンスムーザー
smo <- dlmSmooth(Nile, mod)

## グラフ表示
pdf("dlm2_smooth.pdf", width = width, height = height, pointsize = point)
par(mfrow = c(2, 1), mai = c(0.5, 1, 0.1, 0.4))
plot(Nile, type = "l",
     xlab = "Year", ylab = "Flow", las = 1)
## Level成分
lines(smo$s[, 1], col = 2)

## Slope成分
plot(smo$s[, 2], type = "l", col = 2,
     xlab = "Year", ylab = "Slope", las = 1)
dev.off()

## カルマンフィルター
filt <- dlmFilter(Nile, mod)

## 状態
m <- filt$m[-1, ]

## 予測
## 予測する年数
nyear <- 10

## 予測期間の初期値の設定
m0(mod) <- m[length(Nile), ]
C0(mod) <- diag(2) * s2[2:3]

fore <- dlmForecast(mod, nAhead = nyear)

## 観測値の予測の80%信頼区間
lim <- outer(sapply(fore$Q, function(x) sqrt(diag(x))),
             qnorm(c(0.1, 0.9))) +
       cbind(fore$f, fore$f)

pdf("dlm2_predict.pdf", width = width, height = height, pointsize = point)
plot(Nile, type = "l",
     xlim = c(start(Nile)[1], end(Nile)[1] + nyear),
     ylim = c(min(lim, Nile), max(lim, Nile)),
     xlab = "Year", ylab = "Flow", las = 1)

lines(x = (end(Nile)[1] + 1):(end(Nile)[1] + nyear),
      y = fore$f[, 1], col = 4, lty = 2)
for (i in 1:2)
    lines(x = (end(Nile)[1] + 1):(end(Nile)[1] + nyear),
          y = lim[, i], col = 4, lty = 2)
dev.off()

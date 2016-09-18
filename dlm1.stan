// 1階差分モデル

data {
  int<lower=0>  N;  // レコードの数
  matrix[1, N]  y;  // データ
}

transformed data {
  matrix[1, 1]  F;
  matrix[1, 1]  G;
  vector[1]     m0;
  cov_matrix[1] C0;

  F[1, 1] = 1;
  G[1, 1] = 1;
  m0[1] = 1000;
  C0[1, 1] = 100;
}

parameters {
  real<lower=0> sigma[2];
}

transformed parameters {
  vector[1]     V;
  cov_matrix[1] W;

  V[1] <- sigma[1]^2;
  W[1, 1] <- sigma[2]^2;
}

model {
  y ~ gaussian_dlm_obs(F, G, V, W, m0, C0);
}

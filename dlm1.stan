// 1階差分モデル

data {
  int<lower=0>  N;   // レコードの数
  matrix[1, N]  y;   // データ
  real          m0; // 状態の初期値
  cov_matrix[1] C0; // 共分散の初期値
}

transformed data {
  matrix[1, 1]  F;
  matrix[1, 1]  G;
  vector[1]     vm0;

  F[1, 1] = 1;
  G[1, 1] = 1;
  vm0[1] = m0;
}

parameters {
  real<lower=0> s2[2];
}

transformed parameters {
  vector[1]     V;
  cov_matrix[1] W;

  V[1] = s2[1];
  W[1, 1] = s2[2];
}

model {
  y ~ gaussian_dlm_obs(F, G, V, W, vm0, C0);
}

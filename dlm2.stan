// 2階差分モデル

data {
  int<lower=0>  N;  // レコードの数
  matrix[1, N]  y;  // データ
  vector[2]     m0;
  cov_matrix[2] C0;
}

transformed data {
  matrix[2, 1]  F;
  matrix[2, 2]  G;

  // F
  F[1, 1] = 1;
  F[2, 1] = 0;

  // G
  G[1, 1] = 1;
  G[1, 2] = 1;
  G[2, 1] = 0;
  G[2, 2] = 1;
}

parameters {
  real<lower=0> s2[3];
}

transformed parameters {
  vector[1]     V;
  cov_matrix[2] W;

  V[1] = s2[1];
  W[1, 1] = s2[2];
  W[1, 2] = 0;
  W[2, 1] = 0;
  W[2, 2] = s2[3];
}

model {
  y ~ gaussian_dlm_obs(F, G, V, W, m0, C0);
}

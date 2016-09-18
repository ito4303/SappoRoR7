// 2階差分モデル

data {
  int<lower=0>  N;  // レコードの数
  matrix[1, N]  y;  // データ
}

transformed data {
  matrix[2, 1]  F;
  matrix[2, 2]  G;
  vector[2]     m0;
  cov_matrix[2] C0;

  # F
  F[1, 1] = 1;
  F[2, 1] = 0;

  # G
  G[1, 1] = 1;
  G[1, 2] = 1;
  G[2, 1] = 0;
  G[2, 2] = 1;

  # m0
  m0[1] = 0;
  m0[2] = 0;

  # C0
  C0[1, 1] = 1.0e+7;
  C0[1, 2] = 0;
  C0[2, 1] = 0;
  C0[2, 2] = 1.0e+7;
}

parameters {
  real<lower=0> sigma[3];
}

transformed parameters {
  vector[1]     V;
  cov_matrix[2] W;

  V[1] = sigma[1]^2;
  W[1, 1] = sigma[2]^2;
  W[1, 2] = 0;
  W[2, 1] = 0;
  W[2, 2] = sigma[3]^2;
}

model {
  y ~ gaussian_dlm_obs(F, G, V, W, m0, C0);
}

// トレンドモデル

data {
  int<lower=0>  N;  // レコードの数
  matrix[1, N]  Y;  // データ
  vector[2]     M0;
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
  vector[1]     v;
  cov_matrix[2] w;

  v[1] = s2[1];
  w[1, 1] = s2[2];
  w[1, 2] = 0;
  w[2, 1] = 0;
  w[2, 2] = s2[3];
}

model {
  Y ~ gaussian_dlm_obs(F, G, v, w, M0, C0);
}

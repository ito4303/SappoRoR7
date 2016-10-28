// ローカルレベルモデル

data {
  int<lower=0>  N;   // データ点の数
  matrix[1, N]  Y;   // データ
  real          M0;  // 状態の初期値
  cov_matrix[1] C0;  // 共分散の初期値
}

transformed data {
  matrix[1, 1]  F;
  matrix[1, 1]  G;
  vector[1]     m0; // サイズ1のベクトル

  F[1, 1] = 1;
  G[1, 1] = 1;
  m0[1] = M0;
}

parameters {
  real<lower=0> s2[2];
}

transformed parameters {
  vector[1]     v;
  cov_matrix[1] w;

  v[1] = s2[1];
  w[1, 1] = s2[2];
}

model {
  Y ~ gaussian_dlm_obs(F, G, v, w, m0, C0);
}

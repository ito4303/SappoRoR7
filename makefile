all: rstan_ssm.pdf rstan_ssm.Rout

rstan_ssm.pdf: rstan_ssm.tex rstan_ssm.Rout ssm.pdf ssm2.pdf Nile.pdf dlm1_smooth.pdf dlm1_predict.pdf dlm2_smooth.pdf dlm2_predict.pdf
	simpdftex platex --mode dvipdfmx $<
rstan_ssm.Rout: rstan_ssm.R dlm1.stan dlm2.stan
	R CMD BATCH $<
Nile.pdf: rstan_ssm.R dlm1.stan
	R CMD BATCH $<
dlm1_smooth.pdf: rstan_ssm.R dlm1.stan
	R CMD BATCH $<
dlm1_predict.pdf: rstan_ssm.R dlm1.stan
	R CMD BATCH $<
dlm2_smooth.pdf: rstan_ssm.R dlm2.stan
	R CMD BATCH $<
dlm2_predict.pdf: rstan_ssm.R dlm2.stan
	R CMD BATCH $<

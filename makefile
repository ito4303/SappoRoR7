all: rstan_ssm.pdf rstan_ssm.Rout

rstan_ssm.pdf: rstan_ssm.tex
	simpdftex platex --mode dvipdfmx $<
rstan_ssm.Rout: rstan_ssm.R dlm1.stan dlm2.stan
	R CMD BATCH $<

k <- 5
n <- 10

cat("model
{
  theta ~ dbeta(1,1) 
  k ~ dbin(theta,n)
  
}", file = "rate1.txt")

myinits <- list(
  list(theta = 0.1),
  list(theta = 0.9)
)

library(rjags)
jags.m <- jags.model(file = 'rate1.txt',
                   data = list("k"=k,
                               "n"=n),
                   inits = myinits,
                   n.chains = 2,
                   n.adapt = 100)

parameters <- c("theta")

samps <- coda.samples( jags.m, 
                       parameters, 
                       n.iter=2000,
                       n.burnin=1,
                       n.thin=1)

library(bayesplot)
mcmc_dens_overlay(samps)

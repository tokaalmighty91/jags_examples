
x <- c(rnorm(10))
n <- length(x)

cat("model{
  for (i in 1:n){
    x[i] ~ dnorm(mu, lambda)
  }
  mu ~ dnorm(0, .001)
  sigma ~ dunif(0, 10)
  lambda <- 1/pow(sigma,2)
}", file = "Gaussian.txt")


myinits <- list(
  list(mu = 0, sigma = 10)
)


library(rjags)
jags.gaussian <- jags.model(file = 'Gaussian.txt',
                          data = list("x" = x,
                                      "n" = n),
                          inits = myinits,
                          n.chains = 1,
                          n.adapt = 100)

parameters <- c("mu", "sigma")

samps <- coda.samples( jags.gaussian, 
                       parameters, 
                       n.iter=2000,
                       n.burnin=1,
                       n.thin=100)

library(bayesplot)
mcmc_hex(samps, pars = c("mu", "sigma"))

x <- c(-27.02, 3.57, 8.191, 9.898, 9.603)
n <- length(x)

cat("model
{
    for (i in 1:n){
      x[i] ~ dnorm(mu, lambda[i])}
      
    mu ~ dnorm(0, .001)
    
    for (i in 1:n){
      lambda[i] ~ dgamma(.001, .001) #make proper distribution
      sigma[i] <- 1/sqrt(lambda[i])
    }
    
}", file = '7scientists.txt')

myinits <- list(
  list(mu = 0, lambda = rep(1,n))
)


library(rjags)
jags.7scientists <- jags.model(file = '7scientists.txt',
                            data = list("x" = x,
                                        "n" = n),
                            inits = myinits,
                            n.chains = 1,
                            n.adapt = 100)

parameters <- c("mu", "sigma")

samps <- coda.samples( jags.7scientists, 
                       parameters, 
                       n.iter=2000,
                       n.burnin=1,
                       n.thin=100)

library(bayesplot)
#mcmc_hex(samps, pars = c("mu", "sigma"))
par(mar=c(1,1,1,1))
plot(samps)

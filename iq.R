x <- matrix(c(90, 95, 100, 105, 110, 115, 150, 155, 160),
            nrow = 3, ncol = 3, byrow = T)
n <- row(x)
m <- ncol(x)


cat(" model
{
    for (i in 1:n){
        for (j in 1:m){
            x[i,j] ~ dnorm(mu[i], lambda)
      }
    }
    
    sigma ~ dunif(0, 100)
    lambda <-1/pow(sigma, 2)
    for (i in 1:n){
        mu[j] ~ dunif(0, 300)
    }
}", file = 'iq.txt')

myinits <- list(
  list(mu = rep(100,n), sigma = 1)
)


library(rjags)
jags.iq <- jags.model(file = 'iq.txt',
                      data = list("x" = x,
                                  "n" = n,
                                  "m" = m),
                      inits = myinits,
                      n.chains = 1,
                      n.adapt = 100)

parameters <- c("mu", "sigma")

samps <- coda.samples( jags.iq, 
                       parameters, 
                       n.iter=2000,
                       n.burnin=1,
                       n.thin=1)

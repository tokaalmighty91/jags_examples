k <- 5
n <- 10

data <- list("k", "n")

library(jags)

cat("model
{
  theta ~ dbeta(1,1) 
  k ~ dbin(theta,n)
  
}", file = "rate1.txt")

myinits <- list(
  list(theta = 0.1),
  list(theta = 0.9)
)

jags <- jags.model(file = 'rate1.txt',
                   data = data,
                   inits = myinits,
                   n.chains = 2,
                   n.adapt = 100)

parameters <- c("theta")

samps <- coda.samples( jags.model, parameters, 
                       n.iter=10000 )
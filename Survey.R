k <- c(16, 18, 22, 15, 17)
nmax <- 500
m <-length(k)

cat("model{
  for (i in 1:m){
    k[i] ~ dbin(theta,n)
  }
  theta ~ dbeta(1,1)
  n ~ dcat(p[])
  for (i in 1:nmax){
    p[i] <- 1/nmax
  }
}", file = "Survey.txt")

library(rjags)

myinits <- list(
  list(theta = .5, n = nmax/2),
  list(theta = .1, n = 1)
)

jags.survey <- jags.model(file = 'Survey.txt',
                     data = list("k"=k,
                                 "nmax"=nmax,
                                 "m"=m),
                     inits = myinits,
                     n.chains = 2,
                     n.adapt = 100)

parameters <- c("theta", "n")

samps <- coda.samples( jags.survey, 
                       parameters, 
                       n.iter=5000,
                       n.burnin=1,
                       n.thin=100)

library(bayesplot)

par(mar=c(5,5,1,1)) #set figure margin

#some fun ways to visualize parameter distribution
#https://cran.r-project.org/web/packages/bayesplot/vignettes/plotting-mcmc-draws.html

mcmc_trace(samps, pars = c("n", "theta"))
mcmc_hist(samps) #plot parameters seperately
mcmc_scatter(samps, pars = c("n", "theta"), 
             size = 1.5, alpha = 0.5) #joint distributions
mcmc_hex(samps, pars = c("theta", "n")) #hexgon heatmap

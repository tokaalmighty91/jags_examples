library(rjags)
library(R2jags)

k<-5 
n<-10 
data <- list("k", "n") 
myinits <- list( 
  list(theta = 0.1), #chain 1 starting value 
  list(theta = 0.9)) #chain 2 starting value 
parameters <- c("theta") 
samples <- jags.model(data, 
                 inits=myinits, 
                 parameters, 
                 model.file ="Rate_1.txt", 
                 n.chains=2, n.iter=20000, 
                 n.burnin=1, 
                 n.thin=1, 
                 DIC=T, 
                 bugs.directory=bugsdir, 
                 codaPkg=F, debug=F) 


source("SEmInR_Gillespie_FCT.R")
source("RESuDe_FCT.R")
source("utils.R")

pop_size <- 1e5
I.init = 2

DOL.days = 8
DOI.days = 8
GI_mean = 12.8
GI_var = 12.8

# DOL.days = 2
# DOI.days = 2
# GI_mean = 3.2
# GI_var = 3.2

# DOL.days = 4
# DOI.days = 4
# GI_mean = 6.4
# GI_var = 6.4


GI_span = 20

horizon.days <- 300
horizon.years <- horizon.days / 365

R0 <- 3


resude  <- RESuDe.generate.data(pop_size = pop_size, 
								I.init = I.init,
								R0 = R0, 
								alpha = 0, 
								kappa = 0.00, 
								GI_span = GI_span, 
								GI_mean = GI_mean, 
								GI_var = GI_var,
								horizon = horizon.days,
								seed=123)


seir <- simul.SEmInR(horizon.years = horizon.years,# horizon of the simulation 
					 DOL.days=DOL.days,     # duration of latency in DAYS
					 DOI.days=DOI.days,     # duration of infectiousness in DAYS
					 R0=R0,
					 pop.size=pop_size,     # population size (Population size needs to be very large for convergence stochastic -> deterministic)
					 nE = 5,           # Number of "exposed" compartment for Erlang distribution
					 nI = 5,           # Number of "infectious" compartment for Erlang distribution
					 I.init=I.init,       # Initial number of infectious individuals
					 n.MC = 1,
					 time.bucket = 1/365,     # Aggregation of all events in a time bucket unit
					 remove.fizzles = FALSE,
					 thres.fizz = 0.1,        # Threshold (fraction of max incidence) to identify fizzles
					 do.adaptivetau = TRUE,
					 epsilon = 0.05,
					 seed = 123,
					 save.to.Rdata.file = TRUE 
) 

par(mfrow=c(1,1))

plot(x=seir$inc$tb, y=seir$inc$inc, typ='l',log='y')
lines(x=resude$time, y=resude$I, col='red')

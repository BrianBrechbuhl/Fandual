install.packages("Rglpk")
library(Rglpk)

#Load Data
final <- read.csv("data/fandual_week18.csv")

# objective:
obj <- final$fantasy_points

# number of variables
num.players <- length(final$player)

# the vars are represented as booleans
var.types <- rep("B", num.players)

# the constraints
matrix <- rbind(
		  as.numeric(final$position == "QB"), # num QB
           as.numeric(final$position == "RB"), # num RB
           as.numeric(final$position == "WR"), # num WR
           as.numeric(final$position == "TE"), # num TE
           as.numeric(final$position == "DEF"),# num DEF
           as.numeric(final$position == "K"),  # num K
           diag(final$defensive_risk), #as.numeric(final$defensive_risk)
           final$salary)               # player cost

direction <- c("==",
               "==",
               "==",
               "==",
               #"==",
               #"==",
               rep("<=", num.players),
               "<=")

rhs <- c(1, # Quartbacks
         2, # Running Backs
         3, # Wide Receivers
         1, # Tight Ends
         1, # Defense
         1, # K
         rep(32, num.players), #32 high risk, 1 low risk
         60000) # Team Salary
     
sol <- Rglpk_solve_LP(obj = obj, mat = matrix, dir = direction, rhs = rhs, types = var.types, max = TRUE)
                     
final[sol$solution==1,]
sum(final[sol$solution==1,3])
sum(final[sol$solution==1,4])

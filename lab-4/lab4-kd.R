
# install.packages("statnet")
# install.packages("readxl")
# install.packages("ergm")

library(statnet)
library(readxl)
library(ergm)
library(tidyverse)

#reported collaborations and frequency of collaborations
leader_nodes <- read_csv("data/school-leader-nodes.csv")
leader_edges <- read_csv("data/school-leader-edges.csv")

leader_nodes
leader_edges

?as.network # . in function usually means it's an older function

# combine edges & nodes, said was directed - tbl_graph; here using as.network b/c network models require a particular format from statnet package
leader_network <- as.network(leader_edges,
                             vertices = leader_nodes) #include vertices bc contain additional characteristics/attributes we may want to examine

class(leader_network) # query to tell us what type of object this is
# want to ensure we made a network object; correct
class(leader_nodes) # table dataframe, table, or dataframe for comparison

leader_network # directed; loop would be similar to a twitter thread, where you're responding to yourself. none here; no missing data; multiple - only one tie to each person (e.g., don't mention one collaborator more than once, but could if there were different types of ties) 

###### ERGM 1 ###### 
# ensure reproducibility of our model
set.seed(589) 

# fit our ergm model 
ergm_mod_1 <-ergm(leader_network ~ edges + mutual) 
#dv is leader_network (network itself)
# have to include edges in model; need to account for how many are in network (otherwise will estimate with edges of varying sizes, smaller and larger than actual) # mutual - test for more/less reciprocity than by chance; control variable for network-level 
ergm_mod_1
# get summary statistics for our model
summary(ergm_mod_1)
# reciprocity (mutual) is a factor in model
# edges - when negative - indicator of a sparse network; not very dense (not likely to form ties by chance, more likely something else is at play)


###### ERGM 2 ###### 
# fit our ergm model 
ergm_mod_2 <- ergm(leader_network ~ edges + mutual + nodematch('male') + nodematch('district_site')) 
#nodematch - tests for homophily (birds of a feather, shared characteristics more likely to have connections than those without)
ergm_mod_2
# summary statistics for our model
summary(ergm_mod_2)
# gender not a factor, but being at school- or district-level is factor


###### ERGM 3 ###### 
# fit our ergm model 
ergm_mod_3 <- ergm(leader_network ~ edges + 
                     mutual + 
                     nodematch('male') + # could use nodefactor here, if did, would test if being male had relationship with having more ties vs. males more likely to have ties with other males with nodematch
                     nodematch('district_site') + 
                     nodecov('trust')) #nodecov - numerical variables; the higher the number goes, are you more likely to form ties with other people? 
# get summary statistics for our model
summary(ergm_mod_3)


#### also, usually include another factor in all ergm models: transitivity (didn't include here bc computationally intensive)




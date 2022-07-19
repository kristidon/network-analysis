
install.packages("ggraph")
library(tidyverse)
library(igraph)
library(tidygraph)
library(ggraph)
library(skimr)

ccss_ties <- read_csv("data/ccss-edgelist.csv")
ccss_nodes <- read_csv("data/ccss-nodelist.csv")

ccss_network <- tbl_graph(edges = ccss_ties,
                          nodes = ccss_nodes,
                          directed=TRUE)

ggraph(ccss_network, layout = "fr") + 
  geom_edge_link(arrow = arrow(length = unit(1, 'mm')), 
                 end_cap = circle(3, 'mm'),
                 start_cap = circle(3, 'mm'),
                 alpha = .1) +
  geom_node_point(aes(size = local_size())) +
  geom_node_text(aes(label = actors,
                     size = local_size()),
                 repel=TRUE) +
  theme_graph()

autograph(ccss_network)
ccss_network

# components from igraph package, saying only want to look at strong components
components(ccss_network, mode = c("strong"))
# 92 components when only look at ties connected to one another
# also 92 notes; so no strong ties 

clique_num(ccss_network)
cliques(ccss_network, min = 4, max = NULL)
# minimum number needed for clique is 3

# identify who's most and least connected & then identify actor centrality in a variable
# taking ccss_network & send to function in tidygraph called activate. tells r to activate note list and create new variables. centrality - how many ties going to and from actor; in-degree = #s ties toward actor; out-degree= # ties from actor to others. degree overall tie counts # in & out (would have "all" in mode instead of "in" or "out"). local size = number of unique people connected to 
ccss_network <- ccss_network |>
  activate(nodes) |>
  mutate(in_degree = centrality_degree(mode = "in"),
         out_degree = centrality_degree(mode = "out"))

ccss_network

# activate - only options are nodes or edges, which we defined above in line 12-14
degree_table <- ccss_network |>
  activate(nodes) |>
  mutate(in_degree = centrality_degree(mode = "in"),
         out_degree = centrality_degree(mode = "out")) |>
  as_tibble()


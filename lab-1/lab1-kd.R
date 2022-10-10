
# install.packages(readxl)
library(tidyverse)
library(tidygraph)
library(ggraph)
library(readxl)

?read_excel
getwd()
student_nodes <- read_excel("data/student-attributes.xlsx")
student_edges <- read_excel("data/student-edgelist.xlsx")

view(student_nodes)
view(student_edges)

student_network <- tbl_graph(edges = student_edges, nodes = student_nodes, directed = TRUE)

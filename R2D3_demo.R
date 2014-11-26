install.packages("devtools")
library("devtools")

install_github("jamesthomson/R2D3")
library("R2D3")


#Force Directed Plot
data(celebs)

colnames(celebs$celebs) <-('name', 'group')
colnames(celeb$relationshps) <-c('source','target')

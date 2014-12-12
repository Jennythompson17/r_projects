##rTextTools demo based on this: http://journal.r-project.org/archive/2013-1/collingwood-jurka-boydstun-etal.pdf##

##Install dependencies and load packages##
install.packages("RTextTools")
install.packages("tm")

##Load USCongress dataset - comes with RTextTools##
data(USCongress)

## CREATE THE DOCUMENT-TERM MATRIX##
doc_matrix <- create_matrix(USCongress$text, language="english", removeNumbers=TRUE,
                            stemWords=TRUE, removeSparseTerms=.998)

## Create the container and divide test set from training set##
container <- create_container(doc_matrix, USCongress$major, trainSize=1:4000,testSize=4001:4449, virgin=FALSE)

## Apply Support Vector Machine, glmnet and maximum entropy models ##
SVM <- train_model(container,"SVM")
GLMNET <- train_model(container,"GLMNET")
MAXENT <- train_model(container,"MAXENT")
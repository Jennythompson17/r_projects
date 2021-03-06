##rTextTools demo based on this: http://journal.r-project.org/archive/2013-1/collingwood-jurka-boydstun-etal.pdf##

##Install dependencies and load packages##
install.packages("RTextTools")
install.packages("tm")

library("RTextTools")
library("tm")

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

###my computer didn't like the Max entropy model and kept crashing so I'm going to leave it out ##
##MAXENT <- train_model(container,"MAXENT")##

##Classifying...##
SVM_CLASSIFY <-classify_model(container, SVM)
GLMNET_CLASSIFY <-classify_model(container, GLMNET)

##Analysing output##
analytics <-create_analytics(container, cbind(SVM_CLASSIFY, GLMNET_CLASSIFY))

summary(analytics)

##Create Confusion Matrix##
table(true = analytics@document_summary$MANUAL_CODE, predict = analytics@document_summary$SVM_LABEL)
table(true = analytics@document_summary$MANUAL_CODE, predict = analytics@document_summary$GLMNET_LABEL)

# Plot SVM Recall to see which labels are poor##
x <- as.numeric(rownames(analytics@algorithm_summary))[-20]
y <- analytics@algorithm_summary$SVM_RECALL[-20]

plot(x, y, type="l", lwd=3, main="Support Vector Machine Topic Accuracy", ylab="Recall Accuracy", xlab="Topic")
abline(h=.75, lwd=2, col="maroon")
text(x, y, adj=1.2)




##Create the data.fram Summaries##
topic_summary <-analytics@label_summary
alg_summary <- analytics@algorithm_summary
ens_summary <-analytics@ensemble_summary
doc_summary <-analytics@document_summary

##Create ensemble summary##
create_ensembleSummary(analytics@document_summary)

##Cross-validation##
SVM <-cross_validate(container, 4, "SVM")
GLMNET <-cross_validate(container, 4, "GLMNET")

##Export to CSV so that we can manually code low confidence posts##
write.csv(analytics@document_summary, "DocumentSummary.csv")







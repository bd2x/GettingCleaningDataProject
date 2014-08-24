## Getting and Cleaning Data - Project
################################################

setwd("~/AeroFS/SF/001Lrn/003DataScience/Coursera-Resources/Coursera-JHU-GettingCleaningDataAug2014/Project/UCI HAR Dataset/test")
test_data <- read.table("X_test.txt")
test_activity <- read.table("y_test.txt")
test_subjects <- read.table("subject_test.txt")
setwd("~/AeroFS/SF/001Lrn/003DataScience/Coursera-Resources/Coursera-JHU-GettingCleaningDataAug2014/Project/UCI HAR Dataset/train")
train_data <- read.table("X_train.txt")
train_activity <- read.table("y_train.txt")
train_subjects <- read.table("subject_train.txt")

###############################################
##1. Merges the training and the test sets to create one data set.
merged_data <- rbind(train_data, test_data)
dim(merged_data)
## [1] 10299 561 ## 10,299 rows and 561 columns
setwd("~/AeroFS/SF/001Lrn/003DataScience/Coursera-Resources/Coursera-JHU-GettingCleaningDataAug2014/Project/UCI HAR Dataset")
feat_labels <- read.table("features.txt")
feat_labels <- as.data.frame(feat_labels[,2], row.names=NULL)
feat_labels <- t(feat_labels)
colnames(merged_data) <- feat_labels
dim(merged_data)
## [1] 10299 561 ## 10,299 rows and 561 columns

################################################
##2. Extracts only the measurements on mean and standard deviation for each measurement
all_means <- merged_data[,grep("mean",colnames(merged_data))]
dim(all_means)
## [1] 10299 46 ## 10,299 rows and 46 columns
#head(all_means)
all_std <- merged_data[,grep("std",colnames(merged_data))]
dim(all_std)
## [1] 10299 33 ## 10,299 rows and 33 columns
#head(all_std)
mergedMeanStd <- cbind(all_means, all_std)
dim(mergedMeanStd)
## [1] 10299 79 ## 10,299 rows and 46+33=79 columns
#head(mergedMeanStd)

##################################################
##3 and 4. Uses descriptive activity names to name activities in the data set
activity <- rbind(train_activity, test_activity)
activity[activity==1] <-"Walking"
activity[activity==2] <-"WalkingUpstairs"
activity[activity==3] <-"WalkingDownstairs"
activity[activity==4] <-"Sitting"
activity[activity==5] <-"Standing"
activity[activity==6] <-"Laying"
subjectID <- rbind(train_subjects, test_subjects)

######################################################
##Col names for the raw data are quite descriptive. The only "tidying" required is 
##to remove special characters like "-" and "()"
##4. Appropriately labels the dataset with descriptive names
subjAct <- cbind(subjectID, activity)
colnames(subjAct) <- c("subjectID", "Activity")
descNames <- colnames(mergedMeanStd)
descNames <- gsub("-","_",descNames)
descNames <- gsub("\\()","",descNames)
tidy_data <- cbind(subjAct, mergedMeanStd)
colnames(tidy_data) <- c(colnames(subjAct),descNames)
dim(tidy_data)
## [1] 10299 81 ## 10,299 rows and 81 columns

#########################################################
##5. Create a second, independent tidy data set with the average of each variable for
##   activity and each subject.
## Aggregate the data for each subject by each activity. Use mean to aggregate.
aggTd <- aggregate(tidy_data, by=list(tidy_data$subjectID, tidy_data$Activity),FUN=mean,na.rm=TRUE)
dim(aggTd)
## [1] 180 83 ## 180 rows and 83 columns
## Remove original columns of subject ID and activity which are changed due to aggregation
aggTd$subjectID <- NULL
aggTd$Activity <- NULL
##Rename the newly introduced aggregated columns
colnames(aggTd)[1] <- "SubjectID"
colnames(aggTd)[2] <- "Activity"
dim(aggTd)
## [1] 180 81 ## 180 rows and 81 columns

write.table(aggTd, file="second_tidy_data_set.txt", row.name=FALSE)
head(aggTd)

####################################################
##Generating a data dictionary or code book for all numeric factors
codeBook <- NULL
for (i in 1: ncol(aggTd)){
          varNumber <- i
          varName <- names(aggTd[i])
          varType <- class(aggTd[,i])
          if(varType == "numeric" | varType == "integer"){
          a <- range(aggTd[,i])
          varRange <- paste(round(a[1],5),"to", round(a[2],5))
          }
          else{
          varRange <- levels(as.factor(aggTd[,i]))
          #varRange <- paste(b[1],",",b[2],",",b[3],",",b[4],",",b[5],",",b[6])
          }
          codeBook <- rbind(codeBook,data.frame(varNumber, varName, varType, varRange))
}
write.csv(codeBook,file="codeBook.csv", row.names=FALSE)
##########END########
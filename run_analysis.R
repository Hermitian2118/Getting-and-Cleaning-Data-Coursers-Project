library (dplyr)
library(reshape2)
#File download Verification.
if(!file.exists("./data")){dir.create("./data")}

#Assingning file to fileUrl1 and fileUrl2
fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileUrl2 <- "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"

#Download and Unzip file
download.file(fileUrl1,destfile = "./data/Datasets.zip", method = "curl")
download.file(fileUrl2,destfile = "./data/UCI HAR.txt",method = "curl")
reviews <- unzip("./data/Datasets.zip"); UCI <- read.table("./UCI.txt")
head(reviews,2)

#
activity_labels <- read.table("./UCI HAR.txt")
#Data Column names
features <- read.table("./UCI HAR.txt")

# X and Y test data 
Xtest <- read.table("./UCI HAR/test/Xtest.txt")
Ytest <- read.table("./UCI HAR/test/Ytest.txt")
SubTest <- read.table("./UCI HAR/test/SubTest.txt")

# X and Y train data
Xtrain <- read.table("./UCI HAR/train/Xtrain.txt")
Ytrain <- read.table("./UCI HAR/train/Ytrain.txt")
SubTrain <- read.table("./UCI HAR/train/SubTrain.txt")

#Merges the training and the test sets to create one data set
xTOTAL <- rbind(Xtest, Xtrain)
yTOTAL <- rbind(Ytest, Ytrain)
SubTOTAL <- rbind(SubTrain, SubTest)

#Extract only measurement of mean and standard deviation
MeanStd_only <- grepl("mean|std",features)

names(X_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
Xtest = Xtest[,MeanStd_only]

# Load activity labels
Ytest[,2] = activity_labels[Ytest[,1]]
names(Ytest) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind data
testdata <- cbind(as.data.table(SubTEst), Ytest, Xtest)


names(Xtrain) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
Xtrain = Xtrain[,MeanStd_only]

# Load activity data
Ytrain[,2] = activity_labels[Ytrain[,1]]
names(Ytrain) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Binding data
train_data <- cbind(as.data.table(subject_train), Ytrain, Xtrain)

# Merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Creates a second,independent tidy data set
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt",row.names = FALSE)

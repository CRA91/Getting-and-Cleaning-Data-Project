library(reshape2)
library(plyr)

#1. Merges the training and the test sets to create one data set.
#________________________________________________________________

# 1.1 Downloading data
filename <- "dataset.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filename)



#1.2 Extracting and Merging data

#Xinfo
X_train <- read.table(unz(filename, "UCI HAR Dataset/train/X_train.txt"))
X_test <- read.table(unz(filename, "UCI HAR Dataset/test/X_test.txt"))
X<-rbind(X_train,X_test)

#Yinfo
Y_train <- read.table(unz(filename, "UCI HAR Dataset/train/y_train.txt"))
Y_test <- read.table(unz(filename, "UCI HAR Dataset/test/y_test.txt"))
Y<-rbind(Y_train,Y_test)

#Subject
Subject_train <- read.table(unz(filename, "UCI HAR Dataset/train/subject_train.txt"))
Subject_test <- read.table(unz(filename, "UCI HAR Dataset/test/subject_test.txt"))
Subject<-rbind(Subject_train,Subject_test)


#General data
Activity_Labels <- read.table(unz(filename, "UCI HAR Dataset/activity_labels.txt"))
Features <- read.table(unz(filename, "UCI HAR Dataset/features.txt"))
#_____________________________________________________________________

#_____________________________________________________________________
#2 Extracts only the measurements on the mean and standard deviation for each measurement

#2.1 Searching for mean and sandard deviation
FeaturesFilter <- grep(".*-mean.*|.*-std.*", Features[,2])

#2.2 Changing X
X<-X[,FeaturesFilter]

#2.3 REASSIGNING AND MERGING
Datacompleted<-cbind(Subject,Y,X)
#____________________________________________________________________

#_____________________________________________________________________
#3 Uses descriptive activity names to name the activities in the data set
#4 Appropriately label the data set with descriptive variable names


temp<-Datacompleted[, 2]
Datacompleted[, 2] <- Activity_Labels[temp, 2]

#3.1 and 4.1 Giving names
names(Datacompleted) <- c("Subjects","Activities",Features[FeaturesFilter,2])
#_____________________________________________________________________

#_____________________________________________________________________
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data = ddply(Datacompleted, c("Subjects","Activities"), colwise(mean))

write.table(tidy_data, "tidy_data.txt", row.name=FALSE)


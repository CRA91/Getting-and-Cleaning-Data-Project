# Getting-and-Cleaning-Data-Project
The code used in this project is located in the file run_analysis.R, the sources of this project are the following:

# Sources
The file **getdata_projectfiles_UCI HAR Dataset** contains all the base information that is required to this project, that is integrated for:

**Test files:** This files are composed by X_test and y_test that are some files required to merge, it's a part of all the information desired.

**Train files:** This files are composed by X_train and y_traind that are the second part of the  files required to merge.

**features_info.txt:** Shows information about the variables used on the feature vector.

**features.txt:** List of all features.

**activity_labels.txt:** Links the class labels with their activity name.

#Looking at run_analysis
This file contains all the code required to getting and cleaning the data, its composed by the following sections:

*1. Merges the training and the test sets to create one data set.*
* 1.1 Downloading data* This part downloads the files required from the URL specified.
 
filename <- "dataset.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filename)

*1.2 Extracting and Merging data* this parts begins to order the data and starts to combine the test and train information as required in the step 1 of the project

**Xinfo**

X_train <- read.table(unz(filename, "UCI HAR Dataset/train/X_train.txt"))
X_test <- read.table(unz(filename, "UCI HAR Dataset/test/X_test.txt"))
X<-rbind(X_train,X_test)

**Yinfo** 

Y_train <- read.table(unz(filename, "UCI HAR Dataset/train/y_train.txt"))
Y_test <- read.table(unz(filename, "UCI HAR Dataset/test/y_test.txt"))
Y<-rbind(Y_train,Y_test)

**Subject** 

Subject_train <- read.table(unz(filename, "UCI HAR Dataset/train/subject_train.txt"))
Subject_test <- read.table(unz(filename, "UCI HAR Dataset/test/subject_test.txt"))
Subject<-rbind(Subject_train,Subject_test)


**General data** 

Activity_Labels <- read.table(unz(filename, "UCI HAR Dataset/activity_labels.txt"))
Features <- read.table(unz(filename, "UCI HAR Dataset/features.txt"))

*2 Extracts only the measurements on the mean and standard deviation for each measurement*
*2.1 Searching for mean and sandard deviation* this part extracts only mean and standard deviation fields
FeaturesFilter <- grep(".*-mean.*|.*-std.*", Features[,2])

*2.2 Changing X* this part filtes the X values letting only the fields with mean and standard deviation data.
X<-X[,FeaturesFilter]

*2.3 REASSIGNING AND MERGING* This part merges all the data required form the subject ID to the activities until the Variables values that are stored in X
Datacompleted<-cbind(Subject,Y,X)

*3 Uses descriptive activity names to name the activities in the data set
4 Appropriately label the data set with descriptive variable names* This part only extract the names of the variables from the features file and assign them to the new data frame Datacompleted that has all the information desired.

temp<-Datacompleted[, 2]
Datacompleted[, 2] <- Activity_Labels[temp, 2]
names(Datacompleted) <- c("Subjects","Activities",Features[FeaturesFilter,2])

*5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.* This creates the tidy dataset required usin the ddply function, using the colwise parameter that specifies that the function stored in parentheses is apply to columns.

tidy_data = ddply(Datacompleted, c("Subjects","Activities"), colwise(mean))

The following code line just saves the tidy data in an independent txt file.

write.table(tidy_data, "tidy_data.txt", row.name=FALSE)

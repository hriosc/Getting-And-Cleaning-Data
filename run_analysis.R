library(reshape2)

filename <- "getdata_dataset.zip"


fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl,filename,method = "auto")

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


# Step 1 Merges the training and the test sets to create one data set.
trainY <- read.table("UCI HAR Dataset/train/y_train.txt")
trainX <- read.table("UCI HAR Dataset/train/x_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
testX <- read.table("UCI HAR Dataset/test/X_test.txt")
testY <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

dataX <- rbind(trainX, testX)
dataY <- rbind(trainY, testY)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

## Step 2
## Extracts only the measurements on the mean and 
## standard deviation for each measurement.

features <- read.table("UCI HAR Dataset/features.txt")

## get only the needed data, get columns of interes and correct names
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
dataX <- dataX[, mean_std_features ]
names(dataX) <- features[mean_std_features , 2]

## Step 3 Use descriptive activity names 
## to name the activities in the data set

activitiesData <- read.table("UCI HAR Dataset/activity_labels.txt")
dataY[, 1] <- activitiesData[dataY[, 1], 2]
names(dataY) <- "activity"

# Step 4 give appropiate names

names(subject_data) <- "subject"
all_data <- cbind(dataX, dataY, subject_data)

##From the data set in step 4, creates a second, 
## independent tidy data set with the average of each variable for
## each activity and each subject.

averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "tidy_data.txt", row.name=FALSE)






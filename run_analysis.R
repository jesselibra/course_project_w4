## Load datasets
if(!file.exists("./data")){dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
path <- "./data/project.zip"
download.file(url,path)
unzip(zipfile = "./data/project.zip", exdir = "./data")

## 1. Merges the training and the test sets to create one data set.
  ## Reading feature vector
    features <- read.table("./data/UCI HAR Dataset/features.txt")
  ## Reading activity labels
    activityLbs = read.table("./data/UCI HAR Dataset/activity_labels.txt")
  ## read in train data
    x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
    y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
    sub_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

  colnames(x_train) <- features[,2]
  colnames(y_train) <- "activityId"
  colnames(sub_train) <- "subjectId"
  
train<- cbind(sub_train,y_train,x_train)

  # read in test data
  x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
  y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
  sub_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
  
  colnames(x_test) <- features[,2]
  colnames(y_test) <- "activityId"
  colnames(sub_test) <- "subjectId"
  
test <- cbind(sub_test, y_test, x_test)
dataset <-rbind(train,test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
library(dplyr)
  colnames <- colnames(dataset)
  ## create a t-f vector of column names that have mean or std in them
  x<- grepl("mean|std",colnames)
  ## select all the columns necessary, subsetting by x
  datasetms<- select(dataset,subjectId, activityId, colnames[x])

  
## 3. Uses descriptive activity names to name the activities in the data set
  join <- inner_join(datasetms, activityLbs, by = c("activityId" = "V1"))
  join <- rename(join, activity = V2)

## 4. Appropriately labels the data set with descriptive variable names, done in #1.
  
  
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
   datasummary <-tibble(aggregate(join, by = list(join$subjectId, join$activity), FUN=mean, na.rm=TRUE))
  
   write.table(datasummary, "dataset_clean.txt", row.names = FALSE)
   

  
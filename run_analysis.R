library(dplyr)

# download dataset
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "dataset.zip"
if (!file.exists(zipFile)) {
    download.file(zipUrl, zipFile, mode = "wb")
}


# unzip dataset
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
    unzip(zipFile)
}


# read files
trainingSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(dataPath, "train", "X_train.txt"))
trainingActivity <- read.table(file.path(dataPath, "train", "y_train.txt"))

testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataPath, "test", "X_test.txt"))
testActivity <- read.table(file.path(dataPath, "test", "y_test.txt"))

features <- read.table(file.path(dataPath, "features.txt"), as.is = T)
activities <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activities) <- c("activityid", "activitylabel")


# making a single data table
humanActivity <- rbind(
    cbind(trainingSubjects, trainingValues, trainingActivity),
    cbind(testSubjects, testValues, testActivity)
)


# assign column names
colnames(humanActivity) <- c("subject", features[, 2], "activity")

# only keeping a limited amount of columns based on their name
columnsToKeep <- grepl("subject|activity|mean|std", colnames(humanActivity))
humanActivity <- humanActivity[, columnsToKeep]

# making factor levels
humanActivity$activity <- factor(humanActivity$activity, levels = activities[, 1], labels = activities[, 2])

# retrieiving column names
humanActivityCols <- colnames(humanActivity)

# make colnames appropriately
humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)
humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)
humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)

# use new labels as column names
colnames(humanActivity) <- humanActivityCols

# Create another tidy set with the average of each variable per activity and per subject
humanActivityMeans <- humanActivity %>% 
    group_by(subject, activity) %>%
    summarise_all(funs(mean))

# write file "result_data.txt"
write.table(humanActivityMeans, "result_data.txt", row.names = FALSE, quote = FALSE)

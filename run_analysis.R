## 1.Merges the training and the test sets to create one data set
df_train <- read.table('./train/X_train.txt')
df_test <- read.table('./test/X_test.txt')
df <- rbind(df_train, df_test)


## 2.Extracts only the measurements on the mean and standard deviation for each measurement
df_label <- read.table('./features.txt')
features_label <- tolower(df_label$V2)
colnames(df) <- features_label
cols_mean_sd <- colnames(df)[grepl('\\-(mean|std|meanfreq)', colnames(df))]


## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names.
df_mean_sd <- df[, cols_mean_sd]
colnames(df_mean_sd) <- gsub('\\(\\)', '', cols_mean_sd)

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
mean_data <- apply(df_mean_sd, 2, mean)

## write result data into a txt file
write.table(mean_data, file = 'result_data.txt', col.names = F, row.names = F, quote = F)

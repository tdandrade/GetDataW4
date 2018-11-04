# 1. The submitted data set is tidy.
# 2. The Github repo contains the required scripts.
# 3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
# 4. The README that explains the analysis files is clear and understandable.

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 1) Download and 2) unpack data sources:
library(data.table)
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./getdata_projectfiles_UCI HAR Dataset.zip')){
  download.file(fileurl,'./getdata_projectfiles_UCI HAR Dataset.zip', mode = 'wb')
  unzip("getdata_projectfiles_UCI HAR Dataset.zip", exdir = getwd())
}

# 3) getting features data
features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])
# 3) getting train data
data.train.x <- read.table('./UCI HAR Dataset/train/X_train.txt')
data.train.activity <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
data.train.subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')
# 3) getting activity data
data.train <-  data.frame(data.train.subject, data.train.activity, data.train.x)
names(data.train) <- c(c('subject', 'activity'), features)
# 3) getting test data
data.test.x <- read.table('./UCI HAR Dataset/test/X_test.txt')
data.test.activity <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
data.test.subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')
# 3) getting activity test data
data.test <-  data.frame(data.test.subject, data.test.activity, data.test.x)
names(data.test) <- c(c('subject', 'activity'), features)
# 4) Merges the training and the test sets to create one data set
data.all <- rbind(data.train, data.test)
# 5) Extracts only the measurements on the mean and standard deviation for each measurement
mean_std.select <- grep('mean|std', features)
data.sub <- data.all[,c(1,2,mean_std.select + 2)]
# 6) Uses descriptive activity names to name the activities in the data set
activity.labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity.labels <- as.character(activity.labels[,2])
data.sub$activity <- activity.labels[data.sub$activity]
# 7) Appropriately labels the data set with descriptive variable names
name.new <- names(data.sub)
name.new <- gsub("[(][)]", "", name.new)
name.new <- gsub("^t", "TimeDomain_", name.new)
name.new <- gsub("^f", "FrequencyDomain_", name.new)
name.new <- gsub("Acc", "Accelerometer", name.new)
name.new <- gsub("Gyro", "Gyroscope", name.new)s
name.new <- gsub("Mag", "Magnitude", name.new)
name.new <- gsub("-mean-", "_Mean_", name.new)
name.new <- gsub("-std-", "_StandardDeviation_", name.new)
name.new <- gsub("-", "_", name.new)
names(data.sub) <- name.new
# 8) From the data set in step before, creates a second, independent tidy data set with the average of each variable for each activity and each subject
data.tidy <- aggregate(data.sub[,3:81], by = list(activity = data.sub$activity, subject = data.sub$subject),FUN = mean)
# 9) Write data to file
write.table(x = data.tidy, file = "data_tidy.txt", row.names = FALSE)

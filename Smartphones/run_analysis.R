rm(list = ls(all = TRUE))
library(plyr) # load plyr first, then dplyr 
library(data.table) # a prockage that handles dataframe better
library(dplyr) # for fancy data table manipulations and organization

#download the file and put it in the data folder
if (!file.exists("data")) {
        dir.create("data")
}
temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
unzip(temp, list = TRUE) #This provides the list of variables and I choose the ones that are applicable for this data set

# 1.Create one dataset 
colnames <- c()
col <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"))
colnames <- col[,2]
colnames <- make.names(colnames, unique=TRUE, allow_=TRUE)

Xtest <- read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"))
colnames(Xtest) <- colnames
ytestLab <- read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"))
colnames(ytestLab) <- c("Activity")
subjectsTest <- read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"))
colnames(subjectsTest) <- c("Subject")
test <- cbind(subjectsTest, ytestLab, Xtest)

Xtrain <- read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"))
colnames(Xtrain) <- colnames
ytrainLab <- read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"))
colnames(ytrainLab) <- c("Activity")
subjectsTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"))
colnames(subjectsTrain) <- c("Subject")
train <- cbind(subjectsTrain, ytrainLab, Xtrain)

data <- rbind(test, train)
dat <- tbl_df(data)
rm("data")

# 2. Extract only the measurements on the mean and standard deviation for each 
# measurement
dat2 <- select(dat, Subject, Activity, contains("mean"), contains("std"))
dat2 <- group_by(dat2, Subject & Activity)

# 3. Use descriptive activity names to name the activities in the data set
dat2$Activity <- as.character(dat2$Activity)
dat2$Activity[dat2$Activity == 1] <- "Walking"
dat2$Activity[dat2$Activity == 2] <- "WALKING_UPSTAIRS"
dat2$Activity[dat2$Activity == 3] <- "WALKING_DOWNSTAIRS"
dat2$Activity[dat2$Activity == 4] <- "SITTING"
dat2$Activity[dat2$Activity == 5] <- "STANDING"
dat2$Activity[dat2$Activity == 6] <- "LAYING"
dat2$Activity <- as.factor(dat2$Activity)

# 4. Appropriately labels the data set with descriptive variable names.
names(dat2)<-gsub("^t", "time", names(dat2))
names(dat2)<-gsub("^f", "frequency", names(dat2))
names(dat2)<-gsub("Acc", "Accelerometer", names(dat2))
names(dat2)<-gsub("Gyro", "Gyroscope", names(dat2))
names(dat2)<-gsub("Mag", "Magnitude", names(dat2))
names(dat2)<-gsub("BodyBody", "Body", names(dat2))
names(dat2)<-gsub("...", "-", names(dat2), fixed=TRUE)

# Change names of participants:
dat2$Subject <- as.character(dat2$Subject)
dat2$Subject[dat2$Subject == 1] <- "Subject 1"
dat2$Subject[dat2$Subject == 2] <- "Subject 2"
dat2$Subject[dat2$Subject == 3] <- "Subject 3"
dat2$Subject[dat2$Subject == 4] <- "Subject 4"
dat2$Subject[dat2$Subject == 5] <- "Subject 5"
dat2$Subject[dat2$Subject == 6] <- "Subject 6"
dat2$Subject[dat2$Subject == 7] <- "Subject 7"
dat2$Subject[dat2$Subject == 8] <- "Subject 8"
dat2$Subject[dat2$Subject == 9] <- "Subject 9"
dat2$Subject[dat2$Subject == 10] <- "Subject 10"
dat2$Subject[dat2$Subject == 11] <- "Subject 11"
dat2$Subject[dat2$Subject == 12] <- "Subject 12"
dat2$Subject[dat2$Subject == 13] <- "Subject 13"
dat2$Subject[dat2$Subject == 14] <- "Subject 14"
dat2$Subject[dat2$Subject == 15] <- "Subject 15"
dat2$Subject[dat2$Subject == 16] <- "Subject 16"
dat2$Subject[dat2$Subject == 17] <- "Subject 17"
dat2$Subject[dat2$Subject == 18] <- "Subject 18"
dat2$Subject[dat2$Subject == 19] <- "Subject 19"
dat2$Subject[dat2$Subject == 20] <- "Subject 20"
dat2$Subject[dat2$Subject == 21] <- "Subject 21"
dat2$Subject[dat2$Subject == 22] <- "Subject 22"
dat2$Subject[dat2$Subject == 23] <- "Subject 23"
dat2$Subject[dat2$Subject == 24] <- "Subject 24"
dat2$Subject[dat2$Subject == 25] <- "Subject 25"
dat2$Subject[dat2$Subject == 26] <- "Subject 26"
dat2$Subject[dat2$Subject == 27] <- "Subject 27"
dat2$Subject[dat2$Subject == 28] <- "Subject 28"
dat2$Subject[dat2$Subject == 29] <- "Subject 29"
dat2$Subject[dat2$Subject == 30] <- "Subject 30"
dat2$Subject <- as.factor(dat2$Subject)

# 5.create a tidy data set with the average of each variable fro each activity
# and each subject
dat2<-aggregate(. ~Subject + Activity, dat2, mean)
dat2<-dat2[order(dat2$Subject,dat2$Activity),]
write.table(dat2, file = "tidydata.txt",row.name=FALSE)

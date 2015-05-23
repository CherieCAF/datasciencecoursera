---
title: "README.md"
author: "Cherie"
date: "Friday, March 20, 2015"
output: html_document
---

The purpose of this project is to demonstrate our ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.
We were required to submit: 
1) a tidy data set as described below, 
2) a link to a Github repository with your script for performing the analysis, and 
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
4) a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

The project makes use of the Human Activity Recognition Using Smartphones Dataset

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

From the original dataset the following files are used:
=========================================

- 'features_info.txt': Shows information about the variables used on the feature vector

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
=======

The following packages are installed:
```{r}
library(plyr) # load plyr first, then dplyr 
library(data.table) # a prockage that handles dataframe better
library(dplyr) # for fancy data table manipulations and organization
```

The dataset is downloaded into a temp file using the provided URL and is then 
unzipped.
```{r}
temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2
FUCI%20HAR%20Dataset.zip",temp)
unzip(temp, list = TRUE) #This provides the list of variables and I choose the 
ones that are applicable for this data set
```

Column names are read from the text file named "features.txt".
```{r}
colnames <- c()
col <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"))
colnames <- col[,2]
colnames <- make.names(colnames, unique=TRUE, allow_=TRUE)
```

The Subject, Activity and features from both the Test and Train datasets are 
all combined in one dataset named "dat". 
```{r}
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
```

Only the measurements on the mean and standard deviation for each 
measurement and group by Subject and Activity were extracted:
```{r}
dat2 <- select(dat, Subject, Activity, contains("mean"), contains("std"))
dat2 <- group_by(dat2, Subject & Activity)
```

Changes were made to provide descriptive names for ativities, variables and 
subjects.
```{r}
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
```

Finally, a tidy data set named "tidydata", as a text file, is created with the average 
of each variable for each activity and each subject.
```{r}
dat2<-aggregate(. ~Subject + Activity, dat2, mean)
dat2<-dat2[order(dat2$Subject,dat2$Activity),]
write.table(dat2, file = "tidydata.txt",row.name=FALSE)
```

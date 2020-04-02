#-----Peer Graded Assignment - Getting and Cleaning Data-----#

# Uncomment the first lines if you dont't have the dataset
# fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(fileURL, destfile = "./Datasets/PeerGradedAssignment.zip")
# 
# unzip(zipfile = "./Datasets/PeerGradedAssignment.zip", exdir =  "./Datasets/SamsungWearablesDataset")
setwd("C:/Users/Intel/Documents/Datasets/SamsungWearablesDataset/UCI HAR Dataset")

#-----Importing the Data-----#
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
s_train <- read.table("./train/subject_train.txt")

x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
s_test <- read.table("./test/subject_test.txt")

activities <- read.table("./activity_labels.txt")

#-----Importing column names and making them more understandable-----#
featureList <- read.table("./features.txt")# File containing the column Names
columnNames <- as.character(featureList[, 2]) # as.character() is important!!!
columnNames <- gsub("Acc", "Accelerometer", columnNames)
columnNames <- gsub("^t", "TimeDomain", columnNames)
columnNames <- gsub("^f", "FrequencyDomain", columnNames)
columnNames <- gsub("Mag", "Magnitude", columnNames)
columnNames <- gsub("Freq", "Frequency", columnNames)
columnNames <- gsub("std", "StandardDeviation", columnNames)
rm(featureList)

#-----Merging the training and test datasets-----#
x_merged <- rbind(x_train, x_test)
y_merged <- rbind(y_train, y_test)
s_merged <- rbind(s_train, s_test)

rm(x_train, x_test, y_train, y_test, s_train, s_test)

complete_data <- cbind(s_merged, x_merged, y_merged)
#CAREFUL!!! Here, the order is {subject, xdata, ydata} and not {xdata, ydata, subject}
rm(x_merged, y_merged, s_merged)

#-----Giving Proper Column Names-----#
colnames(complete_data) <- c("subject", columnNames, "activity")

#-----Removing all columns which don't have mean or sd values-----#
columnsToKeep <- grep("subject|activity|mean|StandardDeviation", colnames(complete_data))

#-----Giving Proper Names to the Columns-----#
complete_data <- complete_data[, columnsToKeep]
complete_data$activity <- factor(complete_data$activity, levels = activities[, 1], labels = activities[, 2])

rm(activities)

#-----Creating the Tidy Table-----#
library(dplyr)
#tidyTable <- group_by(complete_data, subject, activity)
tidyTable <- complete_data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
             
# output to file "tidy_data.txt"
write.table(tidyTable, "tidytable.txt", row.names = FALSE, 
            quote = FALSE)

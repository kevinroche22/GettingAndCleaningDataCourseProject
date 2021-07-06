#########
# Tasks #
#########

# 1. Merge the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation 
#    for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy 
#    data set with the average of each variable for each activity and 
#    each subject.

## Load packages
library(tidyverse)

#################
# Load datasets #
#################

## Features and Activity data
activity <- read.table("Data/activity_labels.txt", col.names = c("activity", "activity"))
features <- read.table("Data/features.txt", col.names = c("n", "features"))

## Training Data
xTrainData <- read.table("Data/X_train.txt", col.names = features$features) 
yTrainData <- read.table("Data/y_train.txt", col.names = "activity") 
subjectTrainData <- read.table("Data/subject_train.txt", col.names = "subject")

## Testing Data
xTestData <- read.table("Data/X_test.txt", col.names = features$features)
yTestData <- read.table("Data/y_test.txt", col.names = "activity")
subjectTestData <- read.table("Data/subject_test.txt", col.names = "subject")

##################
# Merge datasets #
##################

## Merge individual sets
xData <- bind_rows(xTestData, xTrainData)
yData <- bind_rows(yTestData, yTrainData)
subjectData <- bind_rows(subjectTestData, subjectTrainData)

## Merge into one dataset
completeData <- bind_cols(xData, yData, subjectData)

#############################
# Retrieve only mean and sd #
#############################

tidyData <- completeData %>% 
        select(subject, activity, contains("mean"), contains("std"))

###################
# Name activities #
###################

tidyData$activity <- activity[tidyData$activity, 2] 

#################
# Label dataset #
#################

## Define character vector of clean column names
tidyDataColNames <- names(tidyData) %>% 
        str_replace_all("^t", "time") %>% 
        str_replace_all("^f", "frequency") %>% 
        str_replace_all("Acc", "Accelerator") %>% 
        str_replace_all("Mag", "Magnitude") %>% 
        str_replace_all("Gyro", "Gyroscope") %>% 
        str_replace_all("BodyBody", "Body") %>%
        str_replace_all("tBody", "TimeBody") %>%
        str_replace_all("\\.", "") %>%
        str_replace_all("std", "Std") %>%
        str_replace_all("mean", "Mean")

## Apply to tidy dataset
colnames(tidyData) <- tidyDataColNames

## Rename angle gravity variables for consistent formatting
tidyData <- tidyData %>% 
        rename("angleGravityMeanX" = "angleXgravityMean") %>%
        rename("angleGravityMeanY" = "angleYgravityMean") %>%
        rename("angleGravityMeanZ" = "angleZgravityMean")

###################################
# Average by activity and subject #
###################################

finalData <- tidyData %>% 
        group_by(activity, subject) %>%
        summarise_all(mean) # Returns 180 obs - 6 activities x 30 subjects

write.table(finalData, "GettingAndCleaningDataFinal.txt", row.names=FALSE)

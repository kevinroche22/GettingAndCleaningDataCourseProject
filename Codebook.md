The run_analysis.R script follows the five steps outlined in the repository's README file.

# Read in data

* ***features <- features.txt*** - 561x2 dimensions
  * List of all features. 
* ***activities <- activity_labels.txt*** - 6x2 dimensions
  * Links the class labels with their activity name.
* ***subject_test <- subject_test.txt*** - 2947x1 dimensions
  * Subject test set.
* ***x_test <- X_test.txt*** - 2947x561 dimensions
  * Test set.
* ***y_test <- y_test.txt*** - 2947x1 dimensions
  * Test labels.
* ***subject_train <- subject_train.txt*** - 7352x1 dimensions
  * Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* ***x_train <- X_train.txt*** - 7352 rowsx561 dimensions
  * Training set.
* ***y_train <- y_train.txt*** - 7352 rowsx1 dimensions
  * Training labels.

# Merge data

* ***xData*** - 10299x561 dimensions - merges x_train and x_test using dplyr's bind_rows function
* ***yData*** - 10299x1 dimensions - merges y_train and y_test using dplyr's bind_rows function
* ***subjectData*** - 10299x1 dimensions - merges subject_train and subject_test using dplyr's bind_rows function
* ***completeData*** - 10299x563 dimensions - merges xData, yData, subjectData using dplyr's bind_cols function

# Extract only the measurements on the mean and standard deviation

* ***tidyData*** - 10299x88 dimensions - select only columns subject, code, and measurements on mean and standard deviation from completeData

# Name activities

* Replace activity code column with corresponding activity from activity file:
  * 1 - WALKING
  * 2 - WALKING_UPSTAIRS
  * 3 - WALKING_DOWNSTAIRS
  * 4 - SITTING
  * 5 - STANDING
  * 6 - LAYING

# Label with descriptive variable names

* Done in such a way that all variable names are descriptive and in camelCase:
  * columns that started with "t" instead start with "time"
  * columns that started with "f" instead start with "frequency"
  * "Acc" became "Accelerator"
  * "Mag" became "Magnitude"
  * "Gyro" became "Gyroscope"
  * "BodyBody" became "Body"
  * "tBody" became "TimeBody"
  * periods were removed from variable names
  * "std" became "Std"
  * "mean" became "Mean"

# Final dataset with averages by subject and activity

* ***finalData*** - 180x88 dimensions - groups each variable by subject and activity and then takes the mean of each observations. There are 30 subjects and 6 activities, so there should by (30x6 =) 180 observations.
* This data was exported into "GettingAndCleaningDataFinal.txt" file.
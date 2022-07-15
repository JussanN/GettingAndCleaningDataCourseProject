# Code book

## Project Description
The purpose of this project is to show how to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.
This is accomplished by the `run_analysis.R` script that does the following:

1. Download the datasets from the link above and unzip it.

2. Merges the training and the test sets to create one data set.

3. Extracts only the measurements on the mean and standard deviation for each measurement.

4. Uses descriptive activity names to name the activities in the data set

5. Appropriately labels the data set with descriptive variable names.

6. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Tidy dataset

The final tidy dataset contains 11,880 observations and 4 variables and can be found in csv `tidy_data_human_activity.csv` or in txt `tidy_data_human_activity.txt`.

### Description of the variables in the Tidy dataset

| Variable name      | Description |
| ----------- | ----------- |
| activity_subject     | Subject ID (1,2, ..., 30. 30 subjects in total).      |
| activity_name   | Activity name (WALKING, LAYING, etc. 6 activities in total).        |
| measurement_type   | Measurement coming from the accelerometer and gyroscope.        |
| mean   | Average of each variable for each activity and each subject.        |


#### Variable `activity_subject`
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each volunteer has a unique Subject ID (30 subjects in total).

#### Variable `activity_name`
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 

#### Variable `measurement_type`
This variable is based on the measurement coming from the accelerometer and gyroscope:

- `t` stands for Time domain and `f` for Frequency domain signal.
- `Body` and `Gravity` are the Acceleration signals.
- `Acc` stands for Accelerometer and `Gyro` for Gyroscope which are instruments that measured the signal (Accelerometer or Gyroscope).
- `Jerk` is the Jerk signal.
- `Mag` is the Magnitude of the signals.
- `Mean` stands for Mean value and `Std` for Standard deviation.
-  `X`, `Y`, or `Z` are the 3-axial signals in the X, Y and Z directions respectively.

#### Variable `mean`
Average of each variable for each activity and each subject.

#### Tidy dataset preview

```{r}
df_final_csv <- read.csv("tidy_data_human_activity.csv", header = TRUE)
head(df_final_csv)

##  activity_subject activity_name  measurement_type       mean
##                1        LAYING fBodyAccJerkMeanX -0.9570739
##                1        LAYING fBodyAccJerkMeanY -0.9224626
##                1        LAYING fBodyAccJerkMeanZ -0.9480609
##                1        LAYING  fBodyAccJerkStdX -0.9641607
##                1        LAYING  fBodyAccJerkStdY -0.9322179
##                1        LAYING  fBodyAccJerkStdZ -0.9605870
```
#### Tiny dataset structure

```{r}
str(df_final_csv)

## 'data.frame':	11880 obs. of  4 variables:
## $ activity_subject: int  1 1 1 1 1 1 1 1 1 1 ...
## $ activity_name   : chr  "LAYING" "LAYING" "LAYING" "LAYING" ...
## $ measurement_type: chr  "fBodyAccJerkMeanX" "fBodyAccJerkMeanY" "fBodyAccJerkMeanZ" "fBodyAccJerkStdX" ...
## $ mean            : num  -0.957 -0.922 -0.948 -0.964 -0.932 ...
```

### Sources
A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 


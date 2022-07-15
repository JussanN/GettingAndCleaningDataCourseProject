# Getting And Cleaning Data Course Project

## Introduction

One of the most exciting areas in all of data science right is [wearable computing](https://en.wikipedia.org/wiki/Wearable_computer). Companies are racing to develop the most advanced algorithms to attract new users. The data used in this project represents data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project:

 https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

## Project goal

The purpose of this project is to show how to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. This is accomplished by the `run_analysis.R`script that does the following: 

1. Dowload the datasets from the link above and unzip it.

2. Merges the training and the test sets to create one data set.

3. Extracts only the measurements on the mean and standard deviation for each measurement. 

4. Uses descriptive activity names to name the activities in the data set

5. Appropriately labels the data set with descriptive variable names. 

6. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## How the differents scripts work and how they are connected

`run_analysis.R` contains the full code and can be run to reproduce the results.

`CodeBook.md` describes the variables, the data, and transformations performed to clean up the data.

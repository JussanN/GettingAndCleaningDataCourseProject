########### Loading libraries ###########
#Load utils library to donwload files from internet.
library(utils)

#Load data.table library which is a faster way to manipulate dataframes.
library(data.table)

#Load dplyr to work with data manipulation in pipe form
library(dplyr)

#Load dplyr to make data tidy
library(tidyr)

######################################
########### 0 Reading data ###########

#Donwload file from URL and save it as dataset.zip
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./dataset.zip", method = "curl")

#unzip the dataset.zip 
unzip("dataset.zip")

#save UCI HAR Dataset folder path to path variable and list all files in that folder
path <- file.path("./", "UCI HAR Dataset") 
list.files(path, recursive = TRUE)

#read the subject files saving it in a dataframe
df_subject_train <- read.table(file.path(path, "train", "subject_train.txt"))
dim(df_subject_train) #checking dimensions
df_subject_test <- read.table(file.path(path, "test", "subject_test.txt"))
dim(df_subject_test) #checking dimensions

#read activity lables files saving it in a dataframe
df_label_train <- read.table(file.path(path, "train", "y_train.txt"))
dim(df_label_train) #checking dimensions
df_label_test <- read.table(file.path(path, "test", "y_test.txt"))
dim(df_label_test) #checking dimensions

#read training and test set files saving it in a dataframe
df_set_train <- read.table(file.path(path, "train", "x_train.txt"))
dim(df_set_train) #checking dimensions
df_set_test <- read.table(file.path(path, "test", "x_test.txt"))
dim(df_set_test) #checking dimensions

#Now that we read all the dataset files, we move to the next step which is merging
#them creating single dataset.

############################################################
########### 1 Merging training and test datasets ###########

#merging subject ids
df_subject_all <- rbind(df_subject_train, df_subject_test)
dim(df_subject_all) #checking dimensions
unique(df_subject_all$V1) #checking unique values
setnames(df_subject_all, "V1", "activity_subject") #changing column name
names(df_subject_all) #checking new column name

#merging activity labels
df_label_all <- rbind(df_label_train, df_label_test)
dim(df_label_all) #checking unique values
unique(df_label_all$V1)
setnames(df_label_all, "V1", "activity_number") #changing column name
names(df_label_all) #checking new column name


#merging training and test sets
df_set_all <- rbind(df_set_train, df_set_test)
dim(df_set_all) #checking unique values

#building the final dataframe
df_all_aux <- cbind(df_subject_all, df_label_all)
df_all <- cbind(df_all_aux, df_set_all)
dim(df_all) #checking unique values

#The final dataset has 10,299 observations and 563 variables;
#The first two variables are the activity_subject and the activity_number respectively;
#The other 561 variables correspond to the variables detailed in the features.txt.
#So next step is to extract the mean and standard deviation 
#for each measurement.


#####################################################################################
########### 2 Extracting mean and standard deviation for each measurement ########### 

df_feature <- read.table(file.path(path, "features.txt"))
dim(df_feature)
setnames(df_feature, c("V1", "V2"), c("feature_number", "feature_variable")) #changing column names
names(df_feature) #checking new column name

#Each measurement (FeatureNumber) in the df_feature corresponds to the columns
#V1-V561 in the df_all. So below a match based on FeatureNumber's row number
#and the numbers in V1-V561 is performed by:

#pasting the word V in front of each row of df_feature
df_feature$feature_number <- paste0("V", df_feature$feature_number)
head(df_feature) 

#then matching the dataframes based on the rows from df_feature and columns from df_all
#note that we only consider positioning 3:563 position so to keep subject and label
#in the df_all dataset

names(df_all)[3:563] <- df_feature$feature_variable[match(names(df_all)[3:563], df_feature$feature_number)]
head(df_all)
names(df_all)

#now we can extract only the mean and standard deviation columns
#with grepl function; We also kept activity_subject and activity_number.
df_extract <- df_all[ , grepl("activity_subject|activity_number|\\bmean()\\b|\\bstd()\\b", names(df_all))]
names(df_extract)

#df_extract contains only the measurements on mean and standard deviation.
#Next step is to name the activities in the df_extract dataset


#################################################################################
########### 3 Using descriptive activity names to name the activities ###########

#First we load the activity_lables.txt to find the corresponding number to 
#to the activity
df_activity_number <- read.table(file.path(path, "activity_labels.txt"))
dim(df_activity_number) #checking dimensions
setnames(df_activity_number, c("V1", "V2"), c("activity_number", "activity_name")) #changing column names
names(df_activity_number) #checking new column name

#then we merge datasets df_extract and df_activity_number
#based on the activity number to getting the activity name for each activity number.

df_extract_activity <- merge(df_extract, df_activity_number, by.x = "activity_number", by.y = "activity_number", all = TRUE) 
dim(df_extract_activity)
names(df_extract_activity)

#finally we reorder columns to have the subject and activity first,
#then the measurement variables

df_extract_activity <- df_extract_activity[, c(2, 1, 69, 3:68)]
str(df_extract_activity)


############################################################################################
########### 4 Appropriately labels the data set with descriptive variable names. ###########

#First we print the column names to check patterns and help to label the variable names
names(df_extract_activity)

#Then we convert first letter of mean in std in upper case and remove - and ().
names(df_extract_activity) <- gsub("-m", "-M", names(df_extract_activity))
names(df_extract_activity) <- gsub("-s", "-S", names(df_extract_activity))
names(df_extract_activity) <- gsub("-", "", names(df_extract_activity))
names(df_extract_activity) <- gsub("[()]", "", names(df_extract_activity))

#For more information about the columns and variables, please, check the CodeBook.md.


###############################################################################
########### 5 From the data set in step 4, creates a second, independent tidy data set 
########### with the average of each variable for each activity and each subject. ###########

#First we create a copy of the data set in step 4 (df_extract_activity) to df

df <- df_extract_activity

#using functions from the package dplyr compute the average of each variable
#for each activity and each subject. Then we pivot measurement variable columns 
#to measurement_type and mean columns making data tidy.

df_final <- df %>% select(-c(activity_number)) %>%
                   group_by(activity_subject, activity_name) %>%
                   summarise_all(mean) %>%
                   gather(key = "measurement_type", value = "mean", 3:68) %>%
                   arrange(activity_subject, activity_name, measurement_type)

#checking final tidy data
View(df_final)


#########################################################################
########### Saving and reading final tidy data in txt and csv ###########

#Write final tidy data from R to a txt file 
write.table(df_final, file = "tidy_data_human_activity.txt", sep = "\t", col.names = TRUE, row.names = FALSE)

#Write final tidy data from R to a csv file 
write.csv(df_final, file = "tidy_data_human_activity.csv", row.names = FALSE)


#Read final tidy data in txt file 
df_final_txt <- read.table(file = "tidy_data_human_activity.txt", sep = "\t", header = TRUE)
head(df_final_txt)

#Read final tidy data in csv file 
df_final_csv <- read.csv("tidy_data_human_activity.csv", header = TRUE)
head(df_final_csv)


#t - Time domain signals, f - Frequence domain signals
#Mean. value
#Std: Standard deviation
#Accelerometer 3 axial XYZ
#Gyroscope  3 axial XYZ
#Jerk signal
#Body linear acceleration 
#Mag euclidian norm
#XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
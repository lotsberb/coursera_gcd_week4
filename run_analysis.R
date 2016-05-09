# This script assumes the UCI HAR Dataset files are present in a directory named "UCI HAR Dataset"
# present at the same location as this script.  It further assumes the structure of the UCI HAR Dataset
# directory is unchanged from the original source.  The following files are required:
#  |-- run_analysis.R
#  |-- UCI HAR Dataset
#           |-- activity_labels.txt
#           |-- features.txt
#           |-- test
#                 |-- X_test.txt
#                 |-- y_test.txt
#                 |-- subject_test.txt
#           |-- train
#                 |-- X_test.txt
#                 |-- y_test.txt
#                 |-- subject_test.txt
#
#
# Description of data files (??? may be 'test' or 'train' depending on the data set chosen):
#
# X_???.txt : - main data file containing all data records of interest
#              - no headers
#              - 561 fixed width columns of 16 characters each
#              - each column consists of a leading space, another space or negative sign, and a numeric value in scientific notation
#
# y_???.txt : - contains numeric indicators of what activity was being performed
#             - data rows parallel the X_???.txt file
#
# subject_???.txt : - contains numeric indicators of which subject the data is associated with
#                   - data rows parallel the X_???.txt file
#
# features.txt : - contains what amount to column headers for the 561 columns of data in the X_???.txt files
#
# activity_labels.txt : - contains activity names with corresponding numbers
#                       - numbers correspond to those found in the y_???.txt files, so activity numbers can be mapped to activity names

# Load the required libraries
library(data.table)
library(dplyr)

# Read the column names from features.txt
col_names<-fread("UCI HAR Dataset/features.txt")

# Read both the test and train data from X_???.txt and merge them into a single data table
test_data<-fread("UCI HAR Dataset/test/X_test.txt", col.names=col_names[[2]])
train_data<-fread("UCI HAR Dataset/train/X_train.txt", col.names=col_names[[2]])
all_data<-rbind(test_data,train_data)


# Read the numeric activity indicators from y_???.txt and merge them together
test_activity<-fread("UCI HAR Dataset/test/y_test.txt")
train_activity<-fread("UCI HAR Dataset/train/y_train.txt")
all_activity<-rbind(test_activity,train_activity)

# Read the activity names from activity_labels.txt and convert the activity numbers to names
activity_names<-fread("UCI HAR Dataset/activity_labels.txt")
mapped_activities<-mapvalues(all_activity[[1]], from=activity_names[[1]], to=activity_names[[2]])

# Add the activity names to the data table
all_data$activity<-mapped_activities

# Read the subject labels from subject_???.txt and merge them together
test_subjects<-fread("UCI HAR Dataset/test/subject_test.txt")
train_subjects<-fread("UCI HAR Dataset/train/subject_train.txt")
all_subjects<-rbind(test_subjects, train_subjects)

# Add the subject labels to the data table
all_data$subject<-all_subjects[[1]]

# Get a list of column numbers for the main data set identifying the mean and standard deviation columns,
# as well as activity and subject
required_cols<-grep("mean|std|activity|subject", names(all_data))

# Extract all the mean and standard deviation measurements into a separate table
mean_stddev_output<-all_data[,required_cols, with=FALSE]

# Arrange the output data by activity and subject
mean_stddev_output<-arrange(mean_stddev_output,activity,subject)

# Write the output to a file
write.table(mean_stddev_output, file="mean_stddev_output.txt", row.names=FALSE)

# Generate a summary table containing the average of each variable (column) for each combination of activity and subject
mean_stddev_averages<-mean_stddev_output %>% group_by(activity,subject) %>% summarize_each(funs(mean))

# Write the summary table to a file
write.table(mean_stddev_averages, file="mean_stddev_averages.txt", row.names=FALSE)

# Release memory we don't need anymore
rm("col_names")
rm("test_data")
rm("train_data")
rm("test_activity")
rm("train_activity")
rm("all_activity")
rm("activity_names")
rm("mapped_activities")
rm("test_subjects")
rm("train_subjects")
rm("all_subjects")
rm("required_cols")
rm("all_data")

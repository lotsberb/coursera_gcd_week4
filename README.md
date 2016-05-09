# Coursera Getting & Cleaning Data Week 4

## Overview
The run_analysis.R script processes a human activity data set consisting of accelerometer data collected from smartphones carried by a set of subjects while performing various activities.  The script produces two output files:
1. A consolidation of all means and standard deviations from the original data set, including activity and subject number
2. A summary of the above data containing averages of each measurement type for all activity+subject combination

## Source Data Files
The run_analysis.R script assumes the UCI HAR Dataset files are present in a directory named "UCI HAR Dataset"
present at the same location as the script.  It further assumes the structure of the UCI HAR Dataset
directory is unchanged from the original source.  The following files are required:
 |-- run_analysis.R
 |-- UCI HAR Dataset
          |-- activity_labels.txt
          |-- features.txt
          |-- test
                |-- X_test.txt
                |-- y_test.txt
                |-- subject_test.txt
          |-- train
                |-- X_test.txt
                |-- y_test.txt
                |-- subject_test.txt

Description of data files (where ??? may be 'test' or 'train' depending on the data set chosen):

X_???.txt : - main data file containing all data records of interest
            - no headers
            - 561 fixed width columns of 16 characters each
            - each column consists of a leading space, another space or negative sign, and a numeric value in scientific notation

y_???.txt : - contains numeric indicators of what activity was being performed
            - data rows parallel the X_???.txt file

subject_???.txt : - contains numeric indicators of which subject the data is associated with
                  - data rows parallel the X_???.txt file

features.txt : - contains what amount to column headers for the 561 columns of data in the X_???.txt files

activity_labels.txt : - contains activity names with corresponding numbers
                      - numbers correspond to those found in the y_???.txt files, so activity numbers can be mapped to activity names
                      
## run_analysis.R Script Description
The run_analysis.R script is thoroughly commented so see the script itself for detailed line-by-line comments.  A high level functional description of the actions performed by the script is as follows:
- load any required libraries used by the script
- read the column headers to be used for the final data
- read the test and train data files and merge them together
- read and merge the test and train activity indicator files
- convert activity number to corresponding activity names
- add the activity information to the main data table
- read and merge the subject indicator files and add them to the main data table
- extract the columns containing mean and standard deviation values for all the different measurements from the main data set (as well as the activity and subject columns) and save them to a separate output file
- summarize the output file generated in the previous step to show the averages of each measurement type where values are grouped by activity+subject combinations.
- save the average summary to another output file


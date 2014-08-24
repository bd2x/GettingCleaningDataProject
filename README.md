###########
My README File
08/23/2014
###########

This README file describes the steps taken to generate the final "second_tidy_data_set.txt" from the raw original datasets available from http://archive.ics.uci.edu/ml/machine-learning-databases/00240/

The zip file from the above location was downloaded and unzipped into its own folder UCI HAR Dataset. It contains two subfolders: Test and Train which is where the training and testing data are located. We are ignoring the "Inertial Signals" folders found in these datasets for all subsequent calculations.

Train data Folder
X_train.txt: 7352 records x 561 features = raw data of accelerations and velocities
y_train.txt: 7352 records x 1 = activity labels belonging to 6 activities 
subject_train.txt: 7352 records x 1 = subject id belonging to 30 subjects

Test data Folder
X_test.txt: 2947 records x 561 features = raw data of accelerations and velocities
y_test.txt: 2947 records x 1 = activity labels belonging to 6 activities 
subject_test.txt: 2947 records x 1 = subject id belonging to 30 subjects

features.txt: 561 channels of accelerations and velocities x 2 columns: 1st column is channel ID, 2nd column is channel description

Task 1:
Attach X_train.txt and X_test.txt using row binding (rbind) to get a table of dim 10299 x 561 --> merged_data
Read the features.txt data and assign the 561 entries from its column 2 as column labels to the merged_data

Task 2:
Extract only the measurements on mean and standard deviation for each measurement by "grep"ping on the "mean" and "std" characters in the colnames of merged_data to obtain a new table of dim 10299 x 79 --> mergedMeanStd

Tasks 3 and 4:
Use descriptive activity names to name activities in the data set
Replace column 2 (ActivityLabel) values from numbers [1:6] to corresponding activity names such as "Walking", "Sitting" etc
Finally, the column names for the raw data are quite descriptive by default. The only "tidying" required is to remove special characters like "-" and "()" in order to appropriately label the dataset with descriptive names.

Task 5 
Create a second, independent tidy data set with the average of each variable for activity and each subject. Here we aggregate the data for each subject by each activity by using "mean" to aggregate. This results in a compacted data set of 180 rows (= 30 subjects x 6 activities) and 81 columns. The columns contain mean values of the various accelerometer and gyroscope signals averaged across each activity for each subject. 

FINAL second_tidy_data_set.txt has 180 rows by 81 columns whose details are provided in the accompanying codeBook.csv file.
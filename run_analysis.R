# run_analysis.R
#
# script for peer project for Getting and Cleaning Data
# offered on:  Coursera.org
# offered by:  John Hopkins University
#              Bloomberg School of Public Health
# Instructor:  Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD
#
# Purpose :    This scrip reads in a series of data file based on a collection
#              set, of activity measurement obtain from a Samsun Galaxy S then
#              parses the data creating a tidy data set, which is then analysed
#              to produce a seperate data set that is a collection of means for the
#              points that are of interest.
#
# input file structure:  The files must be in a data directory with two subdirectories
#                        called test and training. The data directory must contain
#                        the features.txt and activity_lables.txt files. Each of
#                        the sub directories contains three text files (.txt extensions)
#                        and with names that end with "_test" or "_train" depending
#                        the sub directory.
#
#                        The "x" file contains the observations.
#                        The "y" file contains the activity codes
#                        The "subject" file contains the subject ID.
#
#                        The files are delinated by spaces.
#
# output:      The script products two tidy data sets:
#                   data: Is a data frame which contains the combined data set 
#                         from the two sub-directories with the subject and 
#                         activity identified for each collection set. The files
#                         feature names are also cleaned up and presented in a 
#                         more readable form. The features are a sub set of the
#                         orginal collection set of mean and standard deviations
#                         reported.
#                   data.new: which contains the average for each selected feature
#                             selected in the data data frame by subject and activity.
#
# Detials of how the sscript functions can be found in the run_analysis.md file
# in this repo. Detials of the data and selection, naming, filtering and processing
# can be found in the CodBook.md file in this repo.
#

# Read in meta data for both data sets
# feature names
features <- read.table("data/features.txt",
                       col.names=c("var_col","name"),
                       stringsAsFactors = FALSE)
# make variable name all lower case
features$name <- tolower(features$name)
# create the start of good feature names.
features$name <- sub("\\(", ".",features$name)
features$name <- sub("\\)", ".",features$name)
features$name <- sub(",", ".",features$name)
features$name <- sub("-", ".",features$name)
#repeat a second time for names with a second occurance of the special character in them.
features$name <- sub("\\(", ".",features$name)
features$name <- sub("\\)", ".",features$name)
features$name <- sub(",", ".",features$name)
features$name <- sub("-", ".",features$name)
# activity names
activity_names <- read.table("data/activity_labels.txt",
                             col.names = c("key","name"),
                             stringsAsFactors = FALSE)
activity_names$name <- tolower(activity_names$name)

# input the train data set and specific meta data for that set (subject and activity)
training <- read.table("data/train/x_train.txt",
                       col.names=features[,2],
                       stringsAsFactors = FALSE)

train_act <- read.table("data/train/y_train.txt",
                        col.names="key",
                        stringsAsFactors = FALSE)

train_subj <- read.table("data/train/subject_train.txt",
                         col.names="subject",
                         stringsAsFactors = FALSE)

#convert the activity code to readable tags
for (index in 1:nrow(train_act)){
     train_act$key[index] <- activity_names$name[as.numeric(train_act$key[index])]
}
names(train_act) <- "activity"

# create a single train data frame to use
training <- cbind(train_act,training)
training <- cbind(train_subj,training)

# create a new data frame containing the desired features
train_new <- training[,c(grep("subject",names(training)),
                         grep("activity",names(training)),
                         grep("\\.mean\\.\\.", names(training)),
                         grep("\\.std\\.\\.",  names(training))
)
]

# repeat witht he test data set
#read in
test <- read.table("data/test/x_test.txt",
                   col.names=features[,2],
                   stringsAsFactors = FALSE)

test_act <- read.table("data/test/y_test.txt",
                       col.names="key",
                       stringsAsFactors = FALSE)
test_subj <- read.table("data/test/subject_test.txt",
                        col.names="subject",
                        stringsAsFactors = FALSE)

# activities decoded
for (index in 1:nrow(test_act)){
     test_act$key[index] <- activity_names$name[as.numeric(test_act$key[index])]
}
names(test_act) <- "activity"
test <- cbind(test_act,test)
test <- cbind(test_subj,test)

# extract
test_new <- test[,c(grep("subject",names(test)),
                    grep("activity",names(test)),
                    grep("\\.mean\\.\\.", names(test)),
                    grep("\\.std\\.\\.",  names(test))
)
]

# create one data frame combining the test and train dataframes
data <- rbind(train_new,test_new)
#convert the activity labels to factors
data$activity <- as.factor(data$activity)

#finish making readable feature names
names(data) <-sub("^t","TimeDomain.",names(data))
names(data) <-sub("^f","FrequencyDomain.",names(data))
names(data) <- sub("\\.\\.","\\.",names(data))
names(data) <- sub("\\.\\.\\.","\\.",names(data))
names(data) <- sub("\\.\\.","\\.",names(data))
names(data) <- sub("body","Body",names(data))
names(data) <- sub("gravity","Gravity",names(data))
names(data) <- sub("acc","Accelerometer",names(data))
names(data) <- sub("gyro","Gyroscope",names(data))
names(data) <- sub("mean","Mean",names(data))
names(data) <- sub("std","StandardDeviation",names(data))
names(data) <- sub("jerk","Jerk",names(data))
names(data) <- sub("mag","Magnitude",names(data))

# correct a naming convention error in the orginal data set were some variables
# were names "...bodybody..." instead of "...body..." as described in the 
# features_info.txt file subblied with the data
names(data) <- sub("Bodybody","Body",names(data))

# using the tidy 'data' data frame an analysis is conducted producing the 'data.new'
# data frame.
subjects <- unique(data$subject)
activities <- unique(data$activity)
feature <- names(data)[3:68]
data.new <- subset(data, subject == 999999)
for(index_s in seq_along(subjects)){
     for(index_a in seq_along(activities)){
          data.temp <- subset(data, subject == subjects[index_s] & activity == activities[index_a])
          hold <- data.frame(subject = subjects[index_s],
                             activity = activities[index_a])
          for(index_f in 3:68){
               temp <- mean(data.temp[,index_f])
               data.temp.2 <- data.frame(x = temp)
               names(data.temp.2) <- names(data)[index_f]
               hold <- cbind(hold,data.temp.2)               
          }
          data.new  <- rbind(data.new,hold)
     }
}

# clean up assorted variables and temps
rm(temp)
rm(activities)
rm(index)
rm(index_a)
rm(index_f)
rm(index_s)
rm(subjects)
rm(feature)
rm(activity_names)
rm(data.temp)
rm(data.temp.2)
rm(features)
rm(hold)
rm(test)
rm(test_act)
rm(test_new)
rm(test_subj)
rm(train_act)
rm(train_new)
rm(train_subj)
rm(training)

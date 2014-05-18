Project
===
getting and cleaning data - class/peer project
-----
this section has setup information for the project and for RMarkdown

1. sets the tide, figure width and height options for all code chucks unless 
overwriten


```r
opts_chunk$set(tidy = FALSE, fig.width = 5, fig.height = 5)
```



### Importing Data

#### setup
First the column headers need to be obtained. These are in the *features.txt*
file. This file has two data elements, the first identifies the column that the data is
stored in and the second is the data name. 

The names contain "special" figures
such as paranthes commas and dashs, these can cause problems in when they are used
in R. To reduce the possiblity of these causing a problem they will be replaced with
an underscore. Once they have been replaced with an underscore any double underscores will be 
replaced with a single underscore so that no name has more an a single underscore 
in a row. This will need to be accomplished later in the workflow as the special
charaters will assist in identifing the specific row that need to be placed in
the final data set.

This data will be in the **features** data frame.


```r
features <- read.table("data/features.txt",
                       col.names=c("var_col","name"),
                       stringsAsFactors = FALSE)
# make variable name all lower case
features$name <- tolower(features$name)
#
features$name <- sub("\\(", ".",features$name)
features$name <- sub("\\)", ".",features$name)
features$name <- sub(",", ".",features$name)
features$name <- sub("-", ".",features$name)
#repeat a second time for names with a second occurance of the special character in them.
features$name <- sub("\\(", ".",features$name)
features$name <- sub("\\)", ".",features$name)
features$name <- sub(",", ".",features$name)
features$name <- sub("-", ".",features$name)
## convert a double underscore to a single under score. Needs to be repeated to catch 3 underscores becoming 2
#features$name <- sub("..", ".",features$name)
#features$name <- sub("..", ".",features$name)
```

Now the activities names need to be loaded. The area loaded from the file *activity_lables.txt*
the format of this file is that the first column is a key number and the second is the
activity name. 

The will be in a data frame named **activity_names**

```r
activity_names <- read.table("data/activity_labels.txt",
                             col.names = c("key","name"),
                             stringsAsFactors = FALSE)
activity_names$name <- tolower(activity_names$name)
```


### Importing and selection the Training data set
#### importing the training data set
The feature data is read from the *x_train.txt* using the feature labels from the **features** data set
as the column names. This file is read into the **training** data set.

THe activity identifiers are read from the *y_train.txt* file and the column is assinged
the name "key" and placed into the **train_act** data set.

```r

training <- read.table("data/train/x_train.txt",
                       col.names=features[,2],
                       stringsAsFactors = FALSE)

train_act <- read.table("data/train/y_train.txt",
                        col.names="key",
                        stringsAsFactors = FALSE)

train_subj <- read.table("data/train/subject_train.txt",
                         col.names="subject",
                         stringsAsFactors = FALSE)
```


#### Combining the two data sets and converting the activity to human readable form
now we convert the coded activity to a named activity, this is then added to the
**training** data set with a variable name of "activity". The activity column of the 
combined data set is converted to a factor.


```r
for (index in 1:nrow(train_act)){
train_act$key[index] <- activity_names$name[as.numeric(train_act$key[index])]
}
names(train_act) <- "activity"

training <- cbind(train_act,training)
training <- cbind(train_subj,training)
#training$activity  <- as.factor(training$activity)
```


#### extracting the desired data elements

The activity, mean and standard deviation of the measurements are need in the final data set.

Data elements with the term ".mean.." and ".std.." in their name will be selected, This
is equivalent to the orginal names of "mean()" and "std()" lead by and underscore.
The activity column is also selected.

```r
train_new <- training[,c(grep("subject",names(training)),
                         grep("activity",names(training)),
                         grep("\\.mean\\.\\.", names(training)),
                         grep("\\.std\\.\\.",  names(training))
                         )
                      ]
```


### Importing and selecting the test data set

Repeat the above but on test


```r
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

#test$activity  <- as.factor(training$activity)

# extract
test_new <- test[,c(grep("subject",names(test)),
                    grep("activity",names(test)),
                    grep("\\.mean\\.\\.", names(test)),
                    grep("\\.std\\.\\.",  names(test))
                    )
                 ]
```


### Combine the Test and Train dataset
the two data sets generated so far are now combined. Once they are combined the
activity variable is converted to a factor.

```r
data <- rbind(train_new,test_new)
data$activity <- as.factor(data$activity)
```


### Changing the features name

The following naming convention is used for feature names:

1. a dot seperates the domain from the actual measurement name
1. a dot seperates the actual measurement name from the identification of the statistical measurement
1. a dot seperates the statistical measurement from the axis that the measurement is taken

For example TimeDomain.BodyAccelerometer.Mean.x is the feature that indicates the mean
of the Body Acceleratometer measurement in the x axis.

Additionally the names of each section are converted to hump style naming to assist
in readability.

Finally a namming error that resulted in some features having "Bodybody" are changed to 
"Body"

```r
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
```


### Check data

The data should all be between -1 and 1 as the orginal data was normalized in this
range.

```r
str(data)
```

```
## 'data.frame':	10299 obs. of  68 variables:
##  $ subject                                                          : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity                                                         : Factor w/ 6 levels "laying","sitting",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ TimeDomain.BodyAccelerometer.Mean.x                              : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ TimeDomain.BodyAccelerometer.Mean.y                              : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ TimeDomain.BodyAccelerometer.Mean.z                              : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ TimeDomain.GravityAccelerometer.Mean.x                           : num  0.963 0.967 0.967 0.968 0.968 ...
##  $ TimeDomain.GravityAccelerometer.Mean.y                           : num  -0.141 -0.142 -0.142 -0.144 -0.149 ...
##  $ TimeDomain.GravityAccelerometer.Mean.z                           : num  0.1154 0.1094 0.1019 0.0999 0.0945 ...
##  $ TimeDomain.BodyAccelerometerJerk.Mean.x                          : num  0.078 0.074 0.0736 0.0773 0.0734 ...
##  $ TimeDomain.BodyAccelerometerJerk.Mean.y                          : num  0.005 0.00577 0.0031 0.02006 0.01912 ...
##  $ TimeDomain.BodyAccelerometerJerk.Mean.z                          : num  -0.06783 0.02938 -0.00905 -0.00986 0.01678 ...
##  $ TimeDomain.BodyGyroscope.Mean.x                                  : num  -0.0061 -0.0161 -0.0317 -0.0434 -0.034 ...
##  $ TimeDomain.BodyGyroscope.Mean.y                                  : num  -0.0314 -0.0839 -0.1023 -0.0914 -0.0747 ...
##  $ TimeDomain.BodyGyroscope.Mean.z                                  : num  0.1077 0.1006 0.0961 0.0855 0.0774 ...
##  $ TimeDomain.BodyGyroscopeJerk.Mean.x                              : num  -0.0992 -0.1105 -0.1085 -0.0912 -0.0908 ...
##  $ TimeDomain.BodyGyroscopeJerk.Mean.y                              : num  -0.0555 -0.0448 -0.0424 -0.0363 -0.0376 ...
##  $ TimeDomain.BodyGyroscopeJerk.Mean.z                              : num  -0.062 -0.0592 -0.0558 -0.0605 -0.0583 ...
##  $ TimeDomain.BodyAccelerometerMagnitude.Mean.                      : num  -0.959 -0.979 -0.984 -0.987 -0.993 ...
##  $ TimeDomain.GravityAccelerometerMagnitude.Mean.                   : num  -0.959 -0.979 -0.984 -0.987 -0.993 ...
##  $ TimeDomain.BodyAccelerometerJerkMagnitude.Mean.                  : num  -0.993 -0.991 -0.989 -0.993 -0.993 ...
##  $ TimeDomain.BodyGyroscopeMagnitude.Mean.                          : num  -0.969 -0.981 -0.976 -0.982 -0.985 ...
##  $ TimeDomain.BodyGyroscopeJerkMagnitude.Mean.                      : num  -0.994 -0.995 -0.993 -0.996 -0.996 ...
##  $ FrequencyDomain.BodyAccelerometer.Mean.x                         : num  -0.995 -0.997 -0.994 -0.995 -0.997 ...
##  $ FrequencyDomain.BodyAccelerometer.Mean.y                         : num  -0.983 -0.977 -0.973 -0.984 -0.982 ...
##  $ FrequencyDomain.BodyAccelerometer.Mean.z                         : num  -0.939 -0.974 -0.983 -0.991 -0.988 ...
##  $ FrequencyDomain.BodyAccelerometerJerk.Mean.x                     : num  -0.992 -0.995 -0.991 -0.994 -0.996 ...
##  $ FrequencyDomain.BodyAccelerometerJerk.Mean.y                     : num  -0.987 -0.981 -0.982 -0.989 -0.989 ...
##  $ FrequencyDomain.BodyAccelerometerJerk.Mean.z                     : num  -0.99 -0.99 -0.988 -0.991 -0.991 ...
##  $ FrequencyDomain.BodyGyroscope.Mean.x                             : num  -0.987 -0.977 -0.975 -0.987 -0.982 ...
##  $ FrequencyDomain.BodyGyroscope.Mean.y                             : num  -0.982 -0.993 -0.994 -0.994 -0.993 ...
##  $ FrequencyDomain.BodyGyroscope.Mean.z                             : num  -0.99 -0.99 -0.987 -0.987 -0.989 ...
##  $ FrequencyDomain.BodyAccelerometerMagnitude.Mean.                 : num  -0.952 -0.981 -0.988 -0.988 -0.994 ...
##  $ FrequencyDomain.BodyAccelerometerJerkMagnitude.Mean.             : num  -0.994 -0.99 -0.989 -0.993 -0.996 ...
##  $ FrequencyDomain.BodyGyroscopeMagnitude.Mean.                     : num  -0.98 -0.988 -0.989 -0.989 -0.991 ...
##  $ FrequencyDomain.BodyGyroscopeJerkMagnitude.Mean.                 : num  -0.992 -0.996 -0.995 -0.995 -0.995 ...
##  $ TimeDomain.BodyAccelerometer.StandardDeviation.x                 : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ TimeDomain.BodyAccelerometer.StandardDeviation.y                 : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ TimeDomain.BodyAccelerometer.StandardDeviation.z                 : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ TimeDomain.GravityAccelerometer.StandardDeviation.x              : num  -0.985 -0.997 -1 -0.997 -0.998 ...
##  $ TimeDomain.GravityAccelerometer.StandardDeviation.y              : num  -0.982 -0.989 -0.993 -0.981 -0.988 ...
##  $ TimeDomain.GravityAccelerometer.StandardDeviation.z              : num  -0.878 -0.932 -0.993 -0.978 -0.979 ...
##  $ TimeDomain.BodyAccelerometerJerk.StandardDeviation.x             : num  -0.994 -0.996 -0.991 -0.993 -0.996 ...
##  $ TimeDomain.BodyAccelerometerJerk.StandardDeviation.y             : num  -0.988 -0.981 -0.981 -0.988 -0.988 ...
##  $ TimeDomain.BodyAccelerometerJerk.StandardDeviation.z             : num  -0.994 -0.992 -0.99 -0.993 -0.992 ...
##  $ TimeDomain.BodyGyroscope.StandardDeviation.x                     : num  -0.985 -0.983 -0.976 -0.991 -0.985 ...
##  $ TimeDomain.BodyGyroscope.StandardDeviation.y                     : num  -0.977 -0.989 -0.994 -0.992 -0.992 ...
##  $ TimeDomain.BodyGyroscope.StandardDeviation.z                     : num  -0.992 -0.989 -0.986 -0.988 -0.987 ...
##  $ TimeDomain.BodyGyroscopeJerk.StandardDeviation.x                 : num  -0.992 -0.99 -0.988 -0.991 -0.991 ...
##  $ TimeDomain.BodyGyroscopeJerk.StandardDeviation.y                 : num  -0.993 -0.997 -0.996 -0.997 -0.996 ...
##  $ TimeDomain.BodyGyroscopeJerk.StandardDeviation.z                 : num  -0.992 -0.994 -0.992 -0.993 -0.995 ...
##  $ TimeDomain.BodyAccelerometerMagnitude.StandardDeviation.         : num  -0.951 -0.976 -0.988 -0.986 -0.991 ...
##  $ TimeDomain.GravityAccelerometerMagnitude.StandardDeviation.      : num  -0.951 -0.976 -0.988 -0.986 -0.991 ...
##  $ TimeDomain.BodyAccelerometerJerkMagnitude.StandardDeviation.     : num  -0.994 -0.992 -0.99 -0.993 -0.996 ...
##  $ TimeDomain.BodyGyroscopeMagnitude.StandardDeviation.             : num  -0.964 -0.984 -0.986 -0.987 -0.989 ...
##  $ TimeDomain.BodyGyroscopeJerkMagnitude.StandardDeviation.         : num  -0.991 -0.996 -0.995 -0.995 -0.995 ...
##  $ FrequencyDomain.BodyAccelerometer.StandardDeviation.x            : num  -0.995 -0.999 -0.996 -0.996 -0.999 ...
##  $ FrequencyDomain.BodyAccelerometer.StandardDeviation.y            : num  -0.983 -0.975 -0.966 -0.983 -0.98 ...
##  $ FrequencyDomain.BodyAccelerometer.StandardDeviation.z            : num  -0.906 -0.955 -0.977 -0.99 -0.992 ...
##  $ FrequencyDomain.BodyAccelerometerJerk.StandardDeviation.x        : num  -0.996 -0.997 -0.991 -0.991 -0.997 ...
##  $ FrequencyDomain.BodyAccelerometerJerk.StandardDeviation.y        : num  -0.991 -0.982 -0.981 -0.987 -0.989 ...
##  $ FrequencyDomain.BodyAccelerometerJerk.StandardDeviation.z        : num  -0.997 -0.993 -0.99 -0.994 -0.993 ...
##  $ FrequencyDomain.BodyGyroscope.StandardDeviation.x                : num  -0.985 -0.985 -0.977 -0.993 -0.986 ...
##  $ FrequencyDomain.BodyGyroscope.StandardDeviation.y                : num  -0.974 -0.987 -0.993 -0.992 -0.992 ...
##  $ FrequencyDomain.BodyGyroscope.StandardDeviation.z                : num  -0.994 -0.99 -0.987 -0.989 -0.988 ...
##  $ FrequencyDomain.BodyAccelerometerMagnitude.StandardDeviation.    : num  -0.956 -0.976 -0.989 -0.987 -0.99 ...
##  $ FrequencyDomain.BodyAccelerometerJerkMagnitude.StandardDeviation.: num  -0.994 -0.992 -0.991 -0.992 -0.994 ...
##  $ FrequencyDomain.BodyGyroscopeMagnitude.StandardDeviation.        : num  -0.961 -0.983 -0.986 -0.988 -0.989 ...
##  $ FrequencyDomain.BodyGyroscopeJerkMagnitude.StandardDeviation.    : num  -0.991 -0.996 -0.995 -0.995 -0.995 ...
```

```r
summary(data)
```

```
##     subject                   activity   
##  Min.   : 1.0   laying            :1944  
##  1st Qu.: 9.0   sitting           :1777  
##  Median :17.0   standing          :1906  
##  Mean   :16.1   walking           :1722  
##  3rd Qu.:24.0   walking_downstairs:1406  
##  Max.   :30.0   walking_upstairs  :1544  
##  TimeDomain.BodyAccelerometer.Mean.x TimeDomain.BodyAccelerometer.Mean.y
##  Min.   :-1.000                      Min.   :-1.0000                    
##  1st Qu.: 0.263                      1st Qu.:-0.0249                    
##  Median : 0.277                      Median :-0.0172                    
##  Mean   : 0.274                      Mean   :-0.0177                    
##  3rd Qu.: 0.288                      3rd Qu.:-0.0106                    
##  Max.   : 1.000                      Max.   : 1.0000                    
##  TimeDomain.BodyAccelerometer.Mean.z
##  Min.   :-1.0000                    
##  1st Qu.:-0.1210                    
##  Median :-0.1086                    
##  Mean   :-0.1089                    
##  3rd Qu.:-0.0976                    
##  Max.   : 1.0000                    
##  TimeDomain.GravityAccelerometer.Mean.x
##  Min.   :-1.000                        
##  1st Qu.: 0.812                        
##  Median : 0.922                        
##  Mean   : 0.669                        
##  3rd Qu.: 0.955                        
##  Max.   : 1.000                        
##  TimeDomain.GravityAccelerometer.Mean.y
##  Min.   :-1.000                        
##  1st Qu.:-0.243                        
##  Median :-0.144                        
##  Mean   : 0.004                        
##  3rd Qu.: 0.119                        
##  Max.   : 1.000                        
##  TimeDomain.GravityAccelerometer.Mean.z
##  Min.   :-1.0000                       
##  1st Qu.:-0.1167                       
##  Median : 0.0368                       
##  Mean   : 0.0922                       
##  3rd Qu.: 0.2162                       
##  Max.   : 1.0000                       
##  TimeDomain.BodyAccelerometerJerk.Mean.x
##  Min.   :-1.0000                        
##  1st Qu.: 0.0630                        
##  Median : 0.0760                        
##  Mean   : 0.0789                        
##  3rd Qu.: 0.0913                        
##  Max.   : 1.0000                        
##  TimeDomain.BodyAccelerometerJerk.Mean.y
##  Min.   :-1.0000                        
##  1st Qu.:-0.0186                        
##  Median : 0.0108                        
##  Mean   : 0.0079                        
##  3rd Qu.: 0.0335                        
##  Max.   : 1.0000                        
##  TimeDomain.BodyAccelerometerJerk.Mean.z TimeDomain.BodyGyroscope.Mean.x
##  Min.   :-1.0000                         Min.   :-1.0000                
##  1st Qu.:-0.0316                         1st Qu.:-0.0458                
##  Median :-0.0012                         Median :-0.0278                
##  Mean   :-0.0047                         Mean   :-0.0310                
##  3rd Qu.: 0.0246                         3rd Qu.:-0.0106                
##  Max.   : 1.0000                         Max.   : 1.0000                
##  TimeDomain.BodyGyroscope.Mean.y TimeDomain.BodyGyroscope.Mean.z
##  Min.   :-1.0000                 Min.   :-1.0000                
##  1st Qu.:-0.1040                 1st Qu.: 0.0648                
##  Median :-0.0748                 Median : 0.0863                
##  Mean   :-0.0747                 Mean   : 0.0884                
##  3rd Qu.:-0.0511                 3rd Qu.: 0.1104                
##  Max.   : 1.0000                 Max.   : 1.0000                
##  TimeDomain.BodyGyroscopeJerk.Mean.x TimeDomain.BodyGyroscopeJerk.Mean.y
##  Min.   :-1.0000                     Min.   :-1.0000                    
##  1st Qu.:-0.1172                     1st Qu.:-0.0587                    
##  Median :-0.0982                     Median :-0.0406                    
##  Mean   :-0.0967                     Mean   :-0.0423                    
##  3rd Qu.:-0.0793                     3rd Qu.:-0.0252                    
##  Max.   : 1.0000                     Max.   : 1.0000                    
##  TimeDomain.BodyGyroscopeJerk.Mean.z
##  Min.   :-1.0000                    
##  1st Qu.:-0.0794                    
##  Median :-0.0546                    
##  Mean   :-0.0548                    
##  3rd Qu.:-0.0317                    
##  Max.   : 1.0000                    
##  TimeDomain.BodyAccelerometerMagnitude.Mean.
##  Min.   :-1.000                             
##  1st Qu.:-0.982                             
##  Median :-0.875                             
##  Mean   :-0.548                             
##  3rd Qu.:-0.120                             
##  Max.   : 1.000                             
##  TimeDomain.GravityAccelerometerMagnitude.Mean.
##  Min.   :-1.000                                
##  1st Qu.:-0.982                                
##  Median :-0.875                                
##  Mean   :-0.548                                
##  3rd Qu.:-0.120                                
##  Max.   : 1.000                                
##  TimeDomain.BodyAccelerometerJerkMagnitude.Mean.
##  Min.   :-1.000                                 
##  1st Qu.:-0.990                                 
##  Median :-0.948                                 
##  Mean   :-0.649                                 
##  3rd Qu.:-0.296                                 
##  Max.   : 1.000                                 
##  TimeDomain.BodyGyroscopeMagnitude.Mean.
##  Min.   :-1.000                         
##  1st Qu.:-0.978                         
##  Median :-0.822                         
##  Mean   :-0.605                         
##  3rd Qu.:-0.245                         
##  Max.   : 1.000                         
##  TimeDomain.BodyGyroscopeJerkMagnitude.Mean.
##  Min.   :-1.000                             
##  1st Qu.:-0.992                             
##  Median :-0.956                             
##  Mean   :-0.762                             
##  3rd Qu.:-0.550                             
##  Max.   : 1.000                             
##  FrequencyDomain.BodyAccelerometer.Mean.x
##  Min.   :-1.000                          
##  1st Qu.:-0.991                          
##  Median :-0.946                          
##  Mean   :-0.623                          
##  3rd Qu.:-0.265                          
##  Max.   : 1.000                          
##  FrequencyDomain.BodyAccelerometer.Mean.y
##  Min.   :-1.000                          
##  1st Qu.:-0.979                          
##  Median :-0.864                          
##  Mean   :-0.537                          
##  3rd Qu.:-0.103                          
##  Max.   : 1.000                          
##  FrequencyDomain.BodyAccelerometer.Mean.z
##  Min.   :-1.000                          
##  1st Qu.:-0.983                          
##  Median :-0.895                          
##  Mean   :-0.665                          
##  3rd Qu.:-0.366                          
##  Max.   : 1.000                          
##  FrequencyDomain.BodyAccelerometerJerk.Mean.x
##  Min.   :-1.000                              
##  1st Qu.:-0.991                              
##  Median :-0.952                              
##  Mean   :-0.657                              
##  3rd Qu.:-0.327                              
##  Max.   : 1.000                              
##  FrequencyDomain.BodyAccelerometerJerk.Mean.y
##  Min.   :-1.000                              
##  1st Qu.:-0.985                              
##  Median :-0.926                              
##  Mean   :-0.629                              
##  3rd Qu.:-0.264                              
##  Max.   : 1.000                              
##  FrequencyDomain.BodyAccelerometerJerk.Mean.z
##  Min.   :-1.000                              
##  1st Qu.:-0.987                              
##  Median :-0.948                              
##  Mean   :-0.744                              
##  3rd Qu.:-0.513                              
##  Max.   : 1.000                              
##  FrequencyDomain.BodyGyroscope.Mean.x FrequencyDomain.BodyGyroscope.Mean.y
##  Min.   :-1.000                       Min.   :-1.000                      
##  1st Qu.:-0.985                       1st Qu.:-0.985                      
##  Median :-0.892                       Median :-0.920                      
##  Mean   :-0.672                       Mean   :-0.706                      
##  3rd Qu.:-0.384                       3rd Qu.:-0.473                      
##  Max.   : 1.000                       Max.   : 1.000                      
##  FrequencyDomain.BodyGyroscope.Mean.z
##  Min.   :-1.000                      
##  1st Qu.:-0.985                      
##  Median :-0.888                      
##  Mean   :-0.644                      
##  3rd Qu.:-0.323                      
##  Max.   : 1.000                      
##  FrequencyDomain.BodyAccelerometerMagnitude.Mean.
##  Min.   :-1.000                                  
##  1st Qu.:-0.985                                  
##  Median :-0.875                                  
##  Mean   :-0.586                                  
##  3rd Qu.:-0.217                                  
##  Max.   : 1.000                                  
##  FrequencyDomain.BodyAccelerometerJerkMagnitude.Mean.
##  Min.   :-1.000                                      
##  1st Qu.:-0.990                                      
##  Median :-0.929                                      
##  Mean   :-0.621                                      
##  3rd Qu.:-0.260                                      
##  Max.   : 1.000                                      
##  FrequencyDomain.BodyGyroscopeMagnitude.Mean.
##  Min.   :-1.000                              
##  1st Qu.:-0.983                              
##  Median :-0.876                              
##  Mean   :-0.697                              
##  3rd Qu.:-0.451                              
##  Max.   : 1.000                              
##  FrequencyDomain.BodyGyroscopeJerkMagnitude.Mean.
##  Min.   :-1.000                                  
##  1st Qu.:-0.992                                  
##  Median :-0.945                                  
##  Mean   :-0.780                                  
##  3rd Qu.:-0.612                                  
##  Max.   : 1.000                                  
##  TimeDomain.BodyAccelerometer.StandardDeviation.x
##  Min.   :-1.000                                  
##  1st Qu.:-0.992                                  
##  Median :-0.943                                  
##  Mean   :-0.608                                  
##  3rd Qu.:-0.250                                  
##  Max.   : 1.000                                  
##  TimeDomain.BodyAccelerometer.StandardDeviation.y
##  Min.   :-1.0000                                 
##  1st Qu.:-0.9770                                 
##  Median :-0.8350                                 
##  Mean   :-0.5102                                 
##  3rd Qu.:-0.0573                                 
##  Max.   : 1.0000                                 
##  TimeDomain.BodyAccelerometer.StandardDeviation.z
##  Min.   :-1.000                                  
##  1st Qu.:-0.979                                  
##  Median :-0.851                                  
##  Mean   :-0.613                                  
##  3rd Qu.:-0.279                                  
##  Max.   : 1.000                                  
##  TimeDomain.GravityAccelerometer.StandardDeviation.x
##  Min.   :-1.000                                     
##  1st Qu.:-0.995                                     
##  Median :-0.982                                     
##  Mean   :-0.965                                     
##  3rd Qu.:-0.962                                     
##  Max.   : 1.000                                     
##  TimeDomain.GravityAccelerometer.StandardDeviation.y
##  Min.   :-1.000                                     
##  1st Qu.:-0.991                                     
##  Median :-0.976                                     
##  Mean   :-0.954                                     
##  3rd Qu.:-0.946                                     
##  Max.   : 1.000                                     
##  TimeDomain.GravityAccelerometer.StandardDeviation.z
##  Min.   :-1.000                                     
##  1st Qu.:-0.987                                     
##  Median :-0.967                                     
##  Mean   :-0.939                                     
##  3rd Qu.:-0.930                                     
##  Max.   : 1.000                                     
##  TimeDomain.BodyAccelerometerJerk.StandardDeviation.x
##  Min.   :-1.000                                      
##  1st Qu.:-0.991                                      
##  Median :-0.951                                      
##  Mean   :-0.640                                      
##  3rd Qu.:-0.291                                      
##  Max.   : 1.000                                      
##  TimeDomain.BodyAccelerometerJerk.StandardDeviation.y
##  Min.   :-1.000                                      
##  1st Qu.:-0.985                                      
##  Median :-0.925                                      
##  Mean   :-0.608                                      
##  3rd Qu.:-0.222                                      
##  Max.   : 1.000                                      
##  TimeDomain.BodyAccelerometerJerk.StandardDeviation.z
##  Min.   :-1.000                                      
##  1st Qu.:-0.989                                      
##  Median :-0.954                                      
##  Mean   :-0.763                                      
##  3rd Qu.:-0.548                                      
##  Max.   : 1.000                                      
##  TimeDomain.BodyGyroscope.StandardDeviation.x
##  Min.   :-1.000                              
##  1st Qu.:-0.987                              
##  Median :-0.902                              
##  Mean   :-0.721                              
##  3rd Qu.:-0.482                              
##  Max.   : 1.000                              
##  TimeDomain.BodyGyroscope.StandardDeviation.y
##  Min.   :-1.000                              
##  1st Qu.:-0.982                              
##  Median :-0.911                              
##  Mean   :-0.683                              
##  3rd Qu.:-0.446                              
##  Max.   : 1.000                              
##  TimeDomain.BodyGyroscope.StandardDeviation.z
##  Min.   :-1.000                              
##  1st Qu.:-0.985                              
##  Median :-0.882                              
##  Mean   :-0.654                              
##  3rd Qu.:-0.338                              
##  Max.   : 1.000                              
##  TimeDomain.BodyGyroscopeJerk.StandardDeviation.x
##  Min.   :-1.000                                  
##  1st Qu.:-0.991                                  
##  Median :-0.935                                  
##  Mean   :-0.731                                  
##  3rd Qu.:-0.486                                  
##  Max.   : 1.000                                  
##  TimeDomain.BodyGyroscopeJerk.StandardDeviation.y
##  Min.   :-1.000                                  
##  1st Qu.:-0.992                                  
##  Median :-0.955                                  
##  Mean   :-0.786                                  
##  3rd Qu.:-0.627                                  
##  Max.   : 1.000                                  
##  TimeDomain.BodyGyroscopeJerk.StandardDeviation.z
##  Min.   :-1.000                                  
##  1st Qu.:-0.993                                  
##  Median :-0.950                                  
##  Mean   :-0.740                                  
##  3rd Qu.:-0.510                                  
##  Max.   : 1.000                                  
##  TimeDomain.BodyAccelerometerMagnitude.StandardDeviation.
##  Min.   :-1.000                                          
##  1st Qu.:-0.982                                          
##  Median :-0.844                                          
##  Mean   :-0.591                                          
##  3rd Qu.:-0.242                                          
##  Max.   : 1.000                                          
##  TimeDomain.GravityAccelerometerMagnitude.StandardDeviation.
##  Min.   :-1.000                                             
##  1st Qu.:-0.982                                             
##  Median :-0.844                                             
##  Mean   :-0.591                                             
##  3rd Qu.:-0.242                                             
##  Max.   : 1.000                                             
##  TimeDomain.BodyAccelerometerJerkMagnitude.StandardDeviation.
##  Min.   :-1.000                                              
##  1st Qu.:-0.991                                              
##  Median :-0.929                                              
##  Mean   :-0.628                                              
##  3rd Qu.:-0.273                                              
##  Max.   : 1.000                                              
##  TimeDomain.BodyGyroscopeMagnitude.StandardDeviation.
##  Min.   :-1.000                                      
##  1st Qu.:-0.978                                      
##  Median :-0.826                                      
##  Mean   :-0.662                                      
##  3rd Qu.:-0.394                                      
##  Max.   : 1.000                                      
##  TimeDomain.BodyGyroscopeJerkMagnitude.StandardDeviation.
##  Min.   :-1.000                                          
##  1st Qu.:-0.992                                          
##  Median :-0.940                                          
##  Mean   :-0.778                                          
##  3rd Qu.:-0.609                                          
##  Max.   : 1.000                                          
##  FrequencyDomain.BodyAccelerometer.StandardDeviation.x
##  Min.   :-1.000                                       
##  1st Qu.:-0.993                                       
##  Median :-0.942                                       
##  Mean   :-0.603                                       
##  3rd Qu.:-0.249                                       
##  Max.   : 1.000                                       
##  FrequencyDomain.BodyAccelerometer.StandardDeviation.y
##  Min.   :-1.0000                                      
##  1st Qu.:-0.9769                                      
##  Median :-0.8326                                      
##  Mean   :-0.5284                                      
##  3rd Qu.:-0.0922                                      
##  Max.   : 1.0000                                      
##  FrequencyDomain.BodyAccelerometer.StandardDeviation.z
##  Min.   :-1.000                                       
##  1st Qu.:-0.978                                       
##  Median :-0.840                                       
##  Mean   :-0.618                                       
##  3rd Qu.:-0.302                                       
##  Max.   : 1.000                                       
##  FrequencyDomain.BodyAccelerometerJerk.StandardDeviation.x
##  Min.   :-1.000                                           
##  1st Qu.:-0.992                                           
##  Median :-0.956                                           
##  Mean   :-0.655                                           
##  3rd Qu.:-0.320                                           
##  Max.   : 1.000                                           
##  FrequencyDomain.BodyAccelerometerJerk.StandardDeviation.y
##  Min.   :-1.000                                           
##  1st Qu.:-0.987                                           
##  Median :-0.928                                           
##  Mean   :-0.612                                           
##  3rd Qu.:-0.236                                           
##  Max.   : 1.000                                           
##  FrequencyDomain.BodyAccelerometerJerk.StandardDeviation.z
##  Min.   :-1.000                                           
##  1st Qu.:-0.990                                           
##  Median :-0.959                                           
##  Mean   :-0.781                                           
##  3rd Qu.:-0.590                                           
##  Max.   : 1.000                                           
##  FrequencyDomain.BodyGyroscope.StandardDeviation.x
##  Min.   :-1.000                                   
##  1st Qu.:-0.988                                   
##  Median :-0.905                                   
##  Mean   :-0.739                                   
##  3rd Qu.:-0.522                                   
##  Max.   : 1.000                                   
##  FrequencyDomain.BodyGyroscope.StandardDeviation.y
##  Min.   :-1.000                                   
##  1st Qu.:-0.981                                   
##  Median :-0.906                                   
##  Mean   :-0.674                                   
##  3rd Qu.:-0.438                                   
##  Max.   : 1.000                                   
##  FrequencyDomain.BodyGyroscope.StandardDeviation.z
##  Min.   :-1.000                                   
##  1st Qu.:-0.986                                   
##  Median :-0.891                                   
##  Mean   :-0.690                                   
##  3rd Qu.:-0.417                                   
##  Max.   : 1.000                                   
##  FrequencyDomain.BodyAccelerometerMagnitude.StandardDeviation.
##  Min.   :-1.000                                               
##  1st Qu.:-0.983                                               
##  Median :-0.855                                               
##  Mean   :-0.659                                               
##  3rd Qu.:-0.382                                               
##  Max.   : 1.000                                               
##  FrequencyDomain.BodyAccelerometerJerkMagnitude.StandardDeviation.
##  Min.   :-1.000                                                   
##  1st Qu.:-0.991                                                   
##  Median :-0.925                                                   
##  Mean   :-0.640                                                   
##  3rd Qu.:-0.308                                                   
##  Max.   : 1.000                                                   
##  FrequencyDomain.BodyGyroscopeMagnitude.StandardDeviation.
##  Min.   :-1.000                                           
##  1st Qu.:-0.978                                           
##  Median :-0.828                                           
##  Mean   :-0.700                                           
##  3rd Qu.:-0.471                                           
##  Max.   : 1.000                                           
##  FrequencyDomain.BodyGyroscopeJerkMagnitude.StandardDeviation.
##  Min.   :-1.000                                               
##  1st Qu.:-0.993                                               
##  Median :-0.938                                               
##  Mean   :-0.792                                               
##  3rd Qu.:-0.644                                               
##  Max.   : 1.000
```


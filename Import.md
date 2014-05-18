Project
===
getting and cleaning data - class/peer project
-----
this section has setup information for the project and for RMarkdown

1. sets the tide, figure width and height options for all code chucks unless 
overwriten
1. sets the path to the working directory, this will need to be dealt with in the script

```r
opts_chunk$set(tidy = FALSE, fig.width = 5, fig.height = 5)

setwd("c:/Users/Nicholas/Google Drive/R class/getting and cleaning data/Getting-and-cleaning-data/project")
```

```
## Error: cannot change working directory
```

```r
getwd()
```

```
## [1] "C:/Users/Nicholas/Google Drive/R class/getting and cleaning data/Getting-and-cleaning-data-project"
```

### Importing Data

#### setup
First the column headers need to be obtained. These are in the *features.txt*
file. This file has two data elements, the first identifies the column that the data is
stored in and the second is the data name. The names contain "special" figures
such as paranthes commas and dashs, these can cause problems in when they are used
in R. To reduce the possiblity of these causing a problem they will be replaced with
an underscore. Once they have been replaced with an underscore any double underscores will be 
replaced with a single underscore so that no name has more an a single underscore 
in a row.

This data will be in the **features** data frame.


```r
features <- read.table("data/features.txt",
                       col.names=c("var_col","name"),
                       stringsAsFactors = FALSE)
# make variable name all lower case
features$name <- tolower(features$name)
#
features$name <- sub("\\(", "_",features$name)
features$name <- sub("\\)", "_",features$name)
features$name <- sub(",", "_",features$name)
features$name <- sub("-", "_",features$name)
#repeat a second time for names with a second occurance of the special character in them.
features$name <- sub("\\(", "_",features$name)
features$name <- sub("\\)", "_",features$name)
features$name <- sub(",", "_",features$name)
features$name <- sub("-", "_",features$name)
# convert a double underscore to a single under score. Needs to be repeated to catch 3 underscores becoming 2
features$name <- sub("__", "_",features$name)
features$name <- sub("__", "_",features$name)

str(features)
```

```
## 'data.frame':	561 obs. of  2 variables:
##  $ var_col: int  1 2 3 4 5 6 7 8 9 10 ...
##  $ name   : chr  "tbodyacc_mean_x" "tbodyacc_mean_y" "tbodyacc_mean_z" "tbodyacc_std_x" ...
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
str(activity_names)
```

```
## 'data.frame':	6 obs. of  2 variables:
##  $ key : int  1 2 3 4 5 6
##  $ name: chr  "walking" "walking_upstairs" "walking_downstairs" "sitting" ...
```


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
```


### Combining the two data sets and converting the activity to human readable form
now we convert the coded activity to a named activity, this is then added to the
**training** data set with a variable name of "activity". The activity column of the 
combined data set is converted to a factor.


```r
for (index in 1:nrow(train_act)){
train_act$key[index] <- activity_names$name[as.numeric(train_act$key[index])]
}
names(train_act) <- "activity"

training <- cbind(train_act,training)
training$activity  <- as.factor(training$activity)
```





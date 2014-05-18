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
First the column headers need to be obtained. These are in the _features.txt_
file. THis file has two data elements, the first identifies the column that the data is
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
features$name <- sub("\\(", "_",features$name)
features$name <- sub("\\)", "_",features$name)
features$name <- sub(",", "_",features$name)
features$name <- sub("-", "_",features$name)
features$name <- sub("\\(", "_",features$name)
features$name <- sub("\\)", "_",features$name)
features$name <- sub(",", "_",features$name)
features$name <- sub("-", "_",features$name)

features$name <- sub("__", "_",features$name)
features$name <- sub("__", "_",features$name)
```

Now the activities names need to be loaded. The area loaded from the file *activity_lables.txt*

The will be in a data frame named **activity_names**

run_analysis.R
=================================
script for peer project for ***Getting and Cleaning Data***

offered on:  Coursera.org

offered by:  John Hopkins University, Bloomberg School of Public Health

Instructor:  Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD

Purpose:      This script reads in a series of data files based on a collection 
set, of activity measurement obtain from a Samsun Galaxy S then parses the data
creating a tidy data set, which is then analysed to produce a seperate tidy data 
set that is a collection of means for the points that are of interest.

Details of the techinical operation of the script can be found in the *run_analysis.md*
file in this repo. Additionally, the repo contain the *run_analysis.Rmd* file that
is the source for the markdown file which can be downloaded and executed on any
computer that supports R and Rmarkdown. HTML files have been suppressed from this
repro due to viewing issues.

## Data source
The data was supplied by the instructures for this course. The orginal source
was the University California, Irvine's  Machine Learning Repository *Human 
Activity Recognition Using Smartphones Data Set* 
(url http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 
which was provided by Reyes_ortiz, Jorge l, etal at the Smartlab - Non Linear 
Complex Systems Laboratory, DITEN Department of the University of Genova.

### Input data structure
The source data must be in the following directory structure off the working 
direcotory that script will be run from. THis structure is as the data set
will install from the sources.

data  (directory)

 |-train
 
 |-test
 
The main data directory contains the two sub direcotries and must also contain
the *"features.txt"* and the  *"activity_labels.txt"* files.

The main directory also contans the *"README.txt"* and *"features_info.txt"*
files. Which are not directly used in the processing of the data. These files
provide information on the orginal data set.

The train sub-directory contains the following files:

1. *"subject_train.txt"* file which contians the coded subject identy for each collection point or data element,
2. *"X_train.txt"* which contain the values of the data set or features, and
3. *"y_train.txt"* which contains the values of the activity that was being preformed for each collection point.

The test sub-directory contains the following files:

1. *"subject_test.txt"* file which contians the coded subject identy for each collection point or data element,
2. *"X_test.txt"* which contain the values of the data set or features, and
3. *"y_test.txt"* which contains the values of the activity that was being preformed for each collection point

Both the train and test sub-directories contian an additional sub-directory call
"Inertial Signals" which contains raw signal data.

## High level overview of script function

When the script is run with in (via the *source* command) it follows a linear 
flow. It first inports data that applies to both the data sets. This data contains
the names of the features that are contained in the data sets. When the feature
names are read in they are also processed to remove special and control characters
that they may contain. THese characters include the ( ) - and , and are 
replaced with a period or full stop '.'. The feature names were also converted 
to all lower case. Also the decoded activities names are inputed at this time. 
The data frames that hold these values are deleted at the end of the script as
they are no longer needed.

The script first inputs and process the train data set. The three files are read
into R when the main data set is read the feature names are used to assign variable 
namess within the data frame that the data is inputted into. 

The activity data from has its code activity converted to phrases that descripe
the activity, these are supplied from the earlier inputed data.

The three data frames are then combined so that each row has its subject code, 
activity description and feature data creating a complete data element.

Using this combined data frame the features that are means and standard deviations
are extracted for each data element along with the subject id and activity
ddescription. This extracted data is stored in a new data frame to be compined 
with a data from that is produced from the test data sets.

At this point in the process the above preformed on the test data set providing 
different data frame that will be combined with the one produced from the train
data set.

At this point the data frames contianing the two extracted data sets are combined
creating the *"data"* data frame. 

The combined data set has the activity variable converted to a factor type varable
to assist if future porcessing. There are 6 levels in the factor named:

1. "laying"
1. "sitting"
1. "standing"
1. "walking"
1. "walking_downstairs"
1. "walking_upstairs"

At this point in the process the variable names of the features are processed
to conform to the naming convention shown below. Also, at this point some data
with names that didn't conform the the orginal authors naming convention as
described in his documentation was discovered, the defect was a repeated "body""
in the feature name, for our purposes this was converted to a single "body".

The final step of the process is computing the mean for each variable for 
each subject by activity. This produces a data set were each line identifies
the subject and the activity being performed adn the mean for each of the
features for every time the subject was performing that activity. THis step
produce the second data frame called "data.new".

At this point the script preforms some house keeping task, primarly deleted
data frames ti produced along with variables that are no longer needed. This was
left to the end of the script to allow for an easy adjustment if in the future 
one or more of these items are needed.

## Data Naming Conventations Used

The same variable naming conventations are used for both data frames. The features
will be described giving the variable nameing convention and general information about the variables. The final data set contains 66 features.

THe other varables are described first and individually.

Variable name|Variable Description    |Data Type    |Data Information|
-------------------|----------------------------------|---------------|----------------|
subject | Subject Identification number.|interger|Range 1 to 30 - there is no data conecting this to an specific individual|
activity|activity being performed during measurement|factor with 6 levels|levels: 
 || | **"laying"**, **"sitting"**, **"standing"**,  **"walking"**, **"walking_downstairs"**, **"walking_upstairs"**
 
The vairable associated with features
        

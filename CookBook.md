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

## Data Naming Conventations Used and a description of the data.

The same variable naming conventations are used for both data frames. The features
will be described giving the variable nameing convention and general information about the variables. The final data set contains 66 features.

THe other varables are described first and individually.

Variable name|Variable Description    |Data Type    |Data Information|
-------------------|----------------------------------|---------------|----------------|
subject | Subject Identification number.|interger|Range 1 to 30 - there is no data conecting this to an specific individual|
activity|activity being performed during measurement|factor with 6 levels|levels:  *laying*, *sitting*, *standing*,  *walking*, *walking_downstairs*, and *walking_upstairs*

 
The vairables associated with features are named in four part seperated by a dot. Additionally the 
first letter of each word within any part is capitilized to add in reading. 

Here are two examples ***FrequencyDomain.BodyGyroscope.StandardDeviation.y*** and
***TimeDomain.BodyGyroscopeJerkMagnitude.StandardDeviation.***

The first part identifies if the variable was dirived from ***Time Domain*** or ***Frequency Domain*** 
data and uses the complete first words without spaces.

The second section has a couple sub section the first identifies if the variable is based on body movement (***Body***) or gravititional accelateration (***Gravity***).

The next thing identified is the source of the identifies which sensor within the
Samsung Galaxy S was used and can have the values of ***Acceleromete***r or ***Gyroscope***.

The final element in the second section identifies if the data was derived from 
jerk or rapid change in motion and this is identified as ***Jerk***.

The third section identifies if the data is a ***Mean*** or a ***Standard Deviation***, again without
spaces. 

The forth and final section identify what axis the motions was measured in and has
the values of ***x***,***y***, or ***z***. Some of the variables do not have a
vector direction so this identifier is not included in the name.

Using the first example the variable name decodes to a standard deviation of the 
measurement from the frequency domain derived gyroscope motion of the body in the 
y axis.

The data from these features was normalized and bounded by the orginal authors to
to lay between -1 and 1.

There is a list of all the features variable names that are included in the final 
data set (**data,new**) for which mean values were computed.

*TimeDomain.BodyAccelerometer.Mean.x                              
*TimeDomain.BodyAccelerometer.Mean.y                              
*TimeDomain.BodyAccelerometer.Mean.z                              
*TimeDomain.GravityAccelerometer.Mean.x                           
*TimeDomain.GravityAccelerometer.Mean.y                           
*TimeDomain.GravityAccelerometer.Mean.z                           
*TimeDomain.BodyAccelerometerJerk.Mean.x                          
*TimeDomain.BodyAccelerometerJerk.Mean.y                          
*TimeDomain.BodyAccelerometerJerk.Mean.z                          
*TimeDomain.BodyGyroscope.Mean.x                                  
*TimeDomain.BodyGyroscope.Mean.y                                  
*TimeDomain.BodyGyroscope.Mean.z                                  
*TimeDomain.BodyGyroscopeJerk.Mean.x                              
*TimeDomain.BodyGyroscopeJerk.Mean.y                              
*TimeDomain.BodyGyroscopeJerk.Mean.z                              
*TimeDomain.BodyAccelerometerMagnitude.Mean.                      
*TimeDomain.GravityAccelerometerMagnitude.Mean.                   
*TimeDomain.BodyAccelerometerJerkMagnitude.Mean.                  
*TimeDomain.BodyGyroscopeMagnitude.Mean.                          
*TimeDomain.BodyGyroscopeJerkMagnitude.Mean.                      
*FrequencyDomain.BodyAccelerometer.Mean.x                         
*FrequencyDomain.BodyAccelerometer.Mean.y                         
**FrequencyDomain.BodyAccelerometer.Mean.z                         
*FrequencyDomain.BodyAccelerometerJerk.Mean.x                     
*FrequencyDomain.BodyAccelerometerJerk.Mean.y                     
*FrequencyDomain.BodyAccelerometerJerk.Mean.z                     
*FrequencyDomain.BodyGyroscope.Mean.x                             
*FrequencyDomain.BodyGyroscope.Mean.y                             
*FrequencyDomain.BodyGyroscope.Mean.z                             
*FrequencyDomain.BodyAccelerometerMagnitude.Mean.                 
*FrequencyDomain.BodyAccelerometerJerkMagnitude.Mean.             
*FrequencyDomain.BodyGyroscopeMagnitude.Mean.                     
*FrequencyDomain.BodyGyroscopeJerkMagnitude.Mean.                 
*TimeDomain.BodyAccelerometer.StandardDeviation.x                 
*TimeDomain.BodyAccelerometer.StandardDeviation.y                 
*TimeDomain.BodyAccelerometer.StandardDeviation.z                 
*TimeDomain.GravityAccelerometer.StandardDeviation.x              
*TimeDomain.GravityAccelerometer.StandardDeviation.y              
*TimeDomain.GravityAccelerometer.StandardDeviation.z              
*TimeDomain.BodyAccelerometerJerk.StandardDeviation.x             
*TimeDomain.BodyAccelerometerJerk.StandardDeviation.y             
*TimeDomain.BodyAccelerometerJerk.StandardDeviation.z             
*TimeDomain.BodyGyroscope.StandardDeviation.x                     
*TimeDomain.BodyGyroscope.StandardDeviation.y                     
*TimeDomain.BodyGyroscope.StandardDeviation.z                     
*TimeDomain.BodyGyroscopeJerk.StandardDeviation.x                 
*imeDomain.BodyGyroscopeJerk.StandardDeviation.y                 
*TimeDomain.BodyGyroscopeJerk.StandardDeviation.z                 
*TimeDomain.BodyAccelerometerMagnitude.StandardDeviation.         
*TimeDomain.GravityAccelerometerMagnitude.StandardDeviation.      
*TimeDomain.BodyAccelerometerJerkMagnitude.StandardDeviation.     
*TimeDomain.BodyGyroscopeMagnitude.StandardDeviation.             
*TimeDomain.BodyGyroscopeJerkMagnitude.StandardDeviation.         
*FrequencyDomain.BodyAccelerometer.StandardDeviation.x            
*FrequencyDomain.BodyAccelerometer.StandardDeviation.y            
*FrequencyDomain.BodyAccelerometer.StandardDeviation.z            
*FrequencyDomain.BodyAccelerometerJerk.StandardDeviation.x        
*FrequencyDomain.BodyAccelerometerJerk.StandardDeviation.y        
*FrequencyDomain.BodyAccelerometerJerk.StandardDeviation.z        
*FrequencyDomain.BodyGyroscope.StandardDeviation.x                
*FrequencyDomain.BodyGyroscope.StandardDeviation.y                
*FrequencyDomain.BodyGyroscope.StandardDeviation.z                
*FrequencyDomain.BodyAccelerometerMagnitude.StandardDeviation.    
*FrequencyDomain.BodyAccelerometerJerkMagnitude.StandardDeviation.
*FrequencyDomain.BodyGyroscopeMagnitude.StandardDeviation.
*FrequencyDomain.BodyGyroscopeJerkMagnitude.StandardDeviation.

### Observation about the published data set as downloaded
THe orginal authors appeared to have repeated variable names in a couple locations
as these were for energy bands and didn't contain mean or standard devation data
that this project was using they duplicate feature/variable names didn't effect
this project and were ignored.
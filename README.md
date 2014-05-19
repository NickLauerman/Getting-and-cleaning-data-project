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

To run this script the data structure below witht he data files must be direct attached
to the working directory with this script in the working directory. The script
is then *sourced* from within **R** with the command ***source(run_analysis)***

Input file structure:  The files must be in a data directory with two subdirectories
called test and training. The data directory must contain the features.txt and 
activity lables.txt files. Each of the sub directories contains three text files 
(.txt extensions) and with names that end with "test" or "train" depending the 
sub directory.


The "x" file contains the observations.

The "y" file contains the activity codes

The "subject" file contains the subject ID.

The files are delinated by spaces.

output:      
 
The script products two tidy data sets:
 
data: Is a data frame which contains the combined data set from the two 
sub-directories with the subject and activity identified for each collection set. 
The files feature names are also cleaned up and presented in a more readable form. 
The features are a sub set of the orginal collection set of mean and standard 
deviations reported.
                         

data.new: which contains the average for each selected feature selected in the 
data data frame by subject and activity.

Details of how the script functions can be found in the run_analysis.md file
in this repo. Details of the data, selection, naming, filtering and processing
along with a high level description of how the code functions can be found in 
the CodeBook.md file in this repo. 

This repro contain the following files:

file|purpose
----|--------
.gitignore|a file used by git to exclude certian files from the git repro.
CodeBook.md|A markdown file that descripes the data processing and data with this project.
Prompt.md|A markdown file that has the instructions for the project.
README.md|This file
run_analysis.R|the R Script for this project (commented)
run_analysis.Rmd|A RMarkdown file that explains the operation of the script that can be run on any computer that supports R and ideally RStudio.
run_analysis.md|A markdown file that shows the code in the script and explains the processing. Produced in RStudio from the *run_analysis.Rmd* file.
data directory|the source data for this analysis.
data_final.txt|A tab delinated copy of the final tidy data set produced.
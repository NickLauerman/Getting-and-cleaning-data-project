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
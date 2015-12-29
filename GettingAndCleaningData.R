# Objective: Extract requisite information from 8 source files. 2 of the files contain ~10,000 
# observations (rows) of ~600 different (columns) gyrometer and accelerometer measurements that were 
# captured by mobile phones that 30 people (subjects) carried while performing different kinds of 
# activities. The other files contain metadata that identified the measurement, the subject and the 
# activity being performed. The assignment was about intelligently assembling the bits and pieces using 
# cross references and then extracting only the mean & standard deviations of each measurement for each 
# activity and each subject. 

library(dplyr)
  
#Sourcing data
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = '.Documents/CourseraDataScience/samsunghar.zip')
unzip("samsunghar.zip")

# The X tables containing the ~10,000 measurements are read and combined here
X_train <- read.table ("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table ("./UCI HAR Dataset/test/X_test.txt")
X_complete <- rbind(X_train, X_test)

# Column (measured variable) names provided are afixed, mean and standard deviation columns
# are extracted and a subset of X files is formed.
features <- read.table ("./UCI HAR Dataset/features.txt")
names(X_complete) <- features$V2
namesWmean <- grep("mean()",names(X_complete), fixed = TRUE, value = TRUE)
namesWstd <- grep("std()",names(X_complete), fixed = TRUE, value = TRUE)
mean <- subset(X_complete, select = c(namesWmean))
std <- subset(X_complete, select = c(namesWstd))
X_subset <- cbind(mean, std)

# Subjects whose activity was measured are read and the column named here
subject_train <- read.table ("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table ("./UCI HAR Dataset/test/subject_test.txt")
subject_complete <- rbind(subject_train, subject_test)
names(subject_complete) <- "subject"

# The Y files identifying the activity codes whose measurements are in the X files are read
# and the column named here
y_train <- read.table ("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table ("./UCI HAR Dataset/test/y_test.txt")
y_complete <- rbind(y_train, y_test)
names(y_complete) <- "activityNo"

# The activity codes to activiy name/ description map is loaded and the column named. 
activity_labels <- read.table ("./UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("activityNo", "activity")

# All the pieces of data are assembled here. 
complete <- cbind (X_subset, subject_complete, y_complete)

# Actitvity labels are applied.
complete <- merge (complete, activity_labels, by.x = "activityNo", by.y = "activityNo", all=TRUE)

# The hyphen and parantheses in the measured variable column names prevent easy usage of 
# the dplyr package. So, these characters are stripped out in the column names. This also
# makes the column names relatively easy to read.
names(complete) <- gsub("-","",names(complete))
names(complete) <- gsub("\\(\\)","",names(complete))

# The final data set is being created in two steps. First by grouping by activity and subject.
# Then, by summarizing to obtain the average of each variable for each activity and each 
# subject. Each of the 66 variables is in its own column. The combination of actvity and 
# the subject performing it is an observation and each one is in a separate row.Thus this 
# is tidy data and meets the criteria laid out in Hadley's white paper at 
# vita.had.co.nz/papers/tidy-data.pdf
grouped <- group_by(complete, activity, subject)
names(grouped)
grouped <- grouped[,-1]

summary <- summarise_each(grouped, funs(mean))
summary

# Lastly, the tidy data is being written out without row names. This files has 180 rows 
# (30 subjects x 6 activities) and 68 columns (1 for subject, 1 for activity and 66 measurements).
write.table(summary, file = "tidyData.txt", row.name = FALSE)

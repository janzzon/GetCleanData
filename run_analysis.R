# Coursera Getting and cleaning data, course project
# https://class.coursera.org/getdata-030/human_grading/view/courses/975114/assessments/3/submissions
# run_analysis.R

# load packages
lapply(c("dplyr","magrittr"), library, character.only = T)

# Location of data
datasetUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# create data directory if missing
if (!file.exists("./data")) dir.create("./data")

# download zipped file if missing
if(!file.exists("data/Dataset.zip")) {
  download.file(datasetUrl, "data/Dataset.zip", method = "curl")
}

# unzip file
unzip("data/Dataset.zip", exdir = "./data")

# read each file as a separate data frame
indat_x_test <- read.table("data/UCI HAR Dataset/test/X_test.txt", stringsAsFactors = F)
indat_y_test <- read.table("data/UCI HAR Dataset/test/y_test.txt", stringsAsFactors = F)
indat_subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = F)
indat_x_train <- read.table("data/UCI HAR Dataset/train/X_train.txt", stringsAsFactors = F)
indat_y_train <- read.table("data/UCI HAR Dataset/train/y_train.txt", stringsAsFactors = F)
indat_subject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = F)
indat_features <- read.table("data/UCI HAR Dataset/features.txt", stringsAsFactors = F)
indat_activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)
names(indat_activity_labels) <- c("act_no","act_name")

# cbind all test an all train-data
df_test <- cbind(indat_x_test, indat_y_test, indat_subject_test)
df_train <- cbind(indat_x_train, indat_y_train, indat_subject_train)

# rbind test and train-data
df_tidy <- rbind (df_test, df_train)

# Make features valid unique column names and assign to data frame
names(indat_features) <- c("col_no","col_name")
indat_features$col_name %<>% make.names(unique = T)
names(df_tidy) <- c(indat_features$col_name,"activity","subject_no")

# replace activity number w. activity name
df_tidy$activity <- sapply(df_tidy$activity, function (x) indat_activity_labels$act_name[indat_activity_labels$act_no == x] )

# create vector w. column names including .mean.., .std.., activity or subject_no
colnames_selection <- df_tidy %>% names %>% grep("\\.mean\\.\\.|\\.std\\.\\.|^activity$|^subject_no$",.)

# create data frame with subject, activity and all mean/std-data
df_std_mean <- df_tidy[,colnames_selection]

# Group by subject and activity, summarise the mean/std-variables
df_avg_grouped <- df_std_mean %>% group_by (subject_no,activity) %>% summarise_each(funs(mean))

# Save the data frame w. summary from previous step.
write.table(df_avg_grouped, "avg_subj_activity.txt", row.names = F)

# For grading, read file above with 'read.table("./avg_subj_activity.txt", header = T)'

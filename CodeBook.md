---
output: html_document
---
# Code Book

Code book for **Coursera Getting and cleaning data, course project**

#### Requirements
Packages dplyr, magrittr and RCurl is needed, install with `install.packages(c("dplyr","magrittr","RCurl"))` if missing

#### What the script `run_analysis.R` does:
* Create a `data` directory in current working directory
* Downloads the zip-file specified in `datasetUrl` and unzip in data folder
* Read from unzipped file and store as separate data frames starting with `indat_`
    + `[x|y][test|train].txt`
    + `subject_[test|train].txt`
    + `features.txt`
    + `activity_labels.txt`
* Binds all data-files (rbind/cbind) and add column names, complete data frame is named `df_tidy`
* Create vector `colnames_selection` with columns containing mean and standard deviation values. Also activity and subject number
* New data frame `df_std_mean` with columns described above.
* Summarise mean value in `df_std_mean` per activity and subject, output is `df_avg_grouped`
* Write `df_avg_grouped` to file `avg_subj_activity.txt` (average per subject and activity) 
  
For grading, read file above with `read.table("./avg_subj_activity.txt", header = T)`

All column names (variables) is documented in the original data:  
`./data/UCI HAR Dataset/README.txt` and `./data/UCI HAR Dataset/features_info.txt`


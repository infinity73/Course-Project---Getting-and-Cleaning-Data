run\_analysis
================

Load packages
-------------

dpyr and tidyr will be used

``` r
library(dplyr)
library(tidyr)
```

Read files
----------

here it is assumed that dataset for the project is already downloaded, unzipped and placed in working directory.

``` r
features <- read.table("UCI HAR Dataset/features.txt")
head(features)
```

    ##   V1                V2
    ## 1  1 tBodyAcc-mean()-X
    ## 2  2 tBodyAcc-mean()-Y
    ## 3  3 tBodyAcc-mean()-Z
    ## 4  4  tBodyAcc-std()-X
    ## 5  5  tBodyAcc-std()-Y
    ## 6  6  tBodyAcc-std()-Z

the dataframe 'features' contains the list of features that were calculated from the data obtained from the gyrometer and accelerometer

``` r
testfeaturevalues <- read.table("UCI HAR Dataset/test/X_test.txt")
testactivityid <- read.table("UCI HAR Dataset/test/y_test.txt")
testsubjectid <- read.table("UCI HAR Dataset/test/subject_test.txt")

trainfeaturevalues <- read.table("UCI HAR Dataset/train/X_train.txt")
trainactivityid <- read.table("UCI HAR Dataset/train/y_train.txt")
trainsubjectid <- read.table("UCI HAR Dataset/train/subject_train.txt")
```

'testfeaturevalues' cantains values of features from test data. 'testactivityid' has id of corresponding activities and 'testsubjectid' has id of corresponding subjects. Train data value analogous to test data values

Merge the datasets
------------------

``` r
testfeaturevalues <- testfeaturevalues %>% mutate(subjectid = testsubjectid[, 1], activityid =                                                      testactivityid$'V1') %>%
                                           select(activityid, subjectid, 1:561)        

trainfeaturevalues <- trainfeaturevalues %>% mutate(subjectid = trainsubjectid[, 1], activityid =                                                     trainactivityid$'V1') %>%
                                             select(activityid, subjectid, 1:561)

joindata <- rbind(trainfeaturevalues, testfeaturevalues) 
dim(joindata)
```

    ## [1] 10299   563

two columns subjectid and activityid added to 'testfeaturevalues' dataframe. Every set of feature values now has corresponding acitvity and subject id in the same dataframe. 'trainfeaturevalues' analogous to 'testfeaturevalues'

the two datasets are row-bound to give a single dataframe containing both the test and train data. result stored in 'joindata'

Extract mean and standard deviation for every measurement
---------------------------------------------------------

``` r
## this stores the indices of features that represent mean and standard deviation measurements  
##from the 'features$V2' column. feature names that END with 'mean()' and 'std()' are taken
reqfeatures <- grep('mean\\()|std\\()', features$V2)

## in 'joindata' feature values start from third column since first two are subject and activity 
##id; so 'reqfeatures' offset by 2. 'select' function from dplyr then used to select columns in 
##'joindata' reperesenting mean and standard deviation measurements by using column indices 
##values store in 'reqfeatures'
reqfeatures <- reqfeatures + 2
joindata <- joindata %>% select(1, 2, reqfeatures)

##names of columns 3 to 68 of joindata replaced by names of features they represent
reqfeatures0 <- reqfeatures - 2
names(joindata)[3:68] <- as.character(features$V2[reqfeatures0])
dim(joindata)
```

    ## [1] 10299    68

``` r
names(joindata)
```

    ##  [1] "activityid"                  "subjectid"                  
    ##  [3] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"          
    ##  [5] "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
    ##  [7] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
    ##  [9] "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
    ## [11] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
    ## [13] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
    ## [15] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"      
    ## [17] "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"       
    ## [19] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
    ## [21] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
    ## [23] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"          
    ## [25] "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
    ## [27] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"     
    ## [29] "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
    ## [31] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
    ## [33] "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
    ## [35] "tGravityAccMag-mean()"       "tGravityAccMag-std()"       
    ## [37] "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
    ## [39] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"         
    ## [41] "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
    ## [43] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
    ## [45] "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"           
    ## [47] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"           
    ## [49] "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
    ## [51] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
    ## [53] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
    ## [55] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
    ## [57] "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"          
    ## [59] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"          
    ## [61] "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
    ## [63] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"  
    ## [65] "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
    ## [67] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()"

Using descriptive activity names
--------------------------------

``` r
joindata$activityid <- gsub('1', 'walking', joindata$activityid)
joindata$activityid <- gsub('2', 'walkupstair', joindata$activityid)
joindata$activityid <- gsub('3', 'walkdownstair', joindata$activityid)
joindata$activityid <- gsub('4', 'sitting', joindata$activityid)
joindata$activityid <- gsub('5', 'standing', joindata$activityid)
joindata$activityid <- gsub('6', 'lying', joindata$activityid)
unique(joindata$activityid)
```

    ## [1] "standing"      "sitting"       "lying"         "walking"      
    ## [5] "walkdownstair" "walkupstair"

acivityid column of joindata now has descriptive names instead of codes 1:6

Label dataset with descriptive variable names
---------------------------------------------

``` r
##features are spread across columns 3:563. They are all put in one column called 'features' and 
##their values put in a column called 'values'. wide data made longer 
joindata <- gather(joindata, feature, value, -(1:2))

##first character of all feature names is either 't' or 'f' showing whether its a time domain or 
##frequency feature value. A '.' is placed after first character and feature name then seperated 
##and a new column 'domain' added. 
joindata$feature <- gsub('^([a-z]{1})', '\\1.\\2', joindata$feature)
joindata <- separate(joindata, feature, into =  c('domain', 'feature'), sep = '\\.')

##some feature names have "body" repeated twice in their names. extra 'body' string removed
joindata$feature <- gsub('^BodyBody', 'Body', joindata$feature)

##"feature" column further seperated into two new columns 'variable' and 'direction' and split 
##using character '-' as marker
joindata <- separate(joindata, feature, into =  c('feature', 'variable', 'direction'), sep = '-')

##a "." is placed in 'feature' column components wherever a lower case and then an upper case 
##character occur together. Reason is that within every component diferent feature names start 
##with an upper case character. then a split is made into columns 'accelerationtype', 
##'instrument', 'jerk', 'euclideanmag' using the "." as a marker
joindata$feature <- gsub('(+[a-z])([A-Z]+)', '\\1.\\2', joindata$feature)
joindata <- separate(joindata, feature, into =  c('accelerationtype', 'instrument', 'jerk', 'euclideanmag'), sep = '\\.')

##in the features where there was no Jerk but only Mag, the Mag got placed in 'jerk' column 
##because of the way we seperated the features column. The two lines below first place the Mag 
##back in 'euclideanmag' column and then place NA in coresponding locations in 'jerk' column
joindata$euclideanmag[joindata$jerk == 'Mag'] <- "Mag" 
joindata$jerk <- gsub('^Mag', NA, joindata$jerk)

## two changes in domain column replacing 't' and 'f' by Time and Freq
joindata$domain <- gsub('t', 'Time', joindata$domain)
joindata$domain <- gsub('f', 'Freq', joindata$domain)

##accelerometer readings are of two types 'body' or 'gravity'. gyrometer has no acceleration  
##typebut the way we have seperated features into columns 'body' appears in 'accelerationtype'  
##columnof gyrometer readings. So indices of rows representing gyrometer readings are stored in 
##'gyrolocations' vector and in those rows accelerationtype set to "NA"
gyrolocations <- grep("Gyro", joindata$instrument)
joindata$accelerationtype[gyrolocations] <- NA

##adjustments in instrument column
joindata$instrument <- gsub('Acc', 'Accelerometer', joindata$instrument)
joindata$instrument <- gsub('Gyro', 'Gyrometer', joindata$instrument)

##adjustments in variable column
joindata$variable <- gsub('mean\\()', 'Mean', joindata$variable)
joindata$variable <- gsub('std\\()', 'SD', joindata$variable)

head(joindata)
```

    ##   activityid subjectid domain accelerationtype    instrument jerk
    ## 1   standing         1   Time             Body Accelerometer <NA>
    ## 2   standing         1   Time             Body Accelerometer <NA>
    ## 3   standing         1   Time             Body Accelerometer <NA>
    ## 4   standing         1   Time             Body Accelerometer <NA>
    ## 5   standing         1   Time             Body Accelerometer <NA>
    ## 6   standing         1   Time             Body Accelerometer <NA>
    ##   euclideanmag variable direction     value
    ## 1         <NA>     Mean         X 0.2885845
    ## 2         <NA>     Mean         X 0.2784188
    ## 3         <NA>     Mean         X 0.2796531
    ## 4         <NA>     Mean         X 0.2791739
    ## 5         <NA>     Mean         X 0.2766288
    ## 6         <NA>     Mean         X 0.2771988

Tidy data
---------

``` r
tidy_data <- joindata %>% group_by(activityid, subjectid, domain, accelerationtype, instrument, 
                            jerk, euclideanmag, variable, direction) %>% 
                    summarize(occurance = n(), average = mean(value))
tidy_data$average <- round(tidy_data$average, 5)
str(tidy_data)
```

    ## Classes 'grouped_df', 'tbl_df', 'tbl' and 'data.frame':  11880 obs. of  11 variables:
    ##  $ activityid      : chr  "lying" "lying" "lying" "lying" ...
    ##  $ subjectid       : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ domain          : chr  "Freq" "Freq" "Freq" "Freq" ...
    ##  $ accelerationtype: chr  "Body" "Body" "Body" "Body" ...
    ##  $ instrument      : chr  "Accelerometer" "Accelerometer" "Accelerometer" "Accelerometer" ...
    ##  $ jerk            : chr  "Jerk" "Jerk" "Jerk" "Jerk" ...
    ##  $ euclideanmag    : chr  "Mag" "Mag" NA NA ...
    ##  $ variable        : chr  "Mean" "SD" "Mean" "Mean" ...
    ##  $ direction       : chr  NA NA "X" "Y" ...
    ##  $ occurance       : int  50 50 50 50 50 50 50 50 50 50 ...
    ##  $ average         : num  -0.933 -0.922 -0.957 -0.922 -0.948 ...
    ##  - attr(*, "vars")=List of 8
    ##   ..$ : symbol activityid
    ##   ..$ : symbol subjectid
    ##   ..$ : symbol domain
    ##   ..$ : symbol accelerationtype
    ##   ..$ : symbol instrument
    ##   ..$ : symbol jerk
    ##   ..$ : symbol euclideanmag
    ##   ..$ : symbol variable
    ##  - attr(*, "drop")= logi TRUE

``` r
head(tidy_data)
```

    ## Source: local data frame [6 x 11]
    ## Groups: activityid, subjectid, domain, accelerationtype, instrument, jerk, euclideanmag, variable [4]
    ## 
    ##   activityid subjectid domain accelerationtype    instrument  jerk
    ##        <chr>     <int>  <chr>            <chr>         <chr> <chr>
    ## 1      lying         1   Freq             Body Accelerometer  Jerk
    ## 2      lying         1   Freq             Body Accelerometer  Jerk
    ## 3      lying         1   Freq             Body Accelerometer  Jerk
    ## 4      lying         1   Freq             Body Accelerometer  Jerk
    ## 5      lying         1   Freq             Body Accelerometer  Jerk
    ## 6      lying         1   Freq             Body Accelerometer  Jerk
    ## # ... with 5 more variables: euclideanmag <chr>, variable <chr>,
    ## #   direction <chr>, occurance <int>, average <dbl>

occurance column shows number of values used to calculate mean.

Tidy data as tab-delimited text file
------------------------------------

``` r
write.table(tidy_data,"tidyData.txt",quote = FALSE, sep="\t\t", col.names = NA)
```

p.s. column names are not aligned very well with the columns.

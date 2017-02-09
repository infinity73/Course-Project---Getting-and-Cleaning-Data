library(dplyr)
library(tidyr)

features <- read.table("UCI HAR Dataset/features.txt")
testfeaturevalues <- read.table("UCI HAR Dataset/test/X_test.txt")
testactivityid <- read.table("UCI HAR Dataset/test/y_test.txt")
testsubjectid <- read.table("UCI HAR Dataset/test/subject_test.txt")

trainfeaturevalues <- read.table("UCI HAR Dataset/train/X_train.txt")
trainactivityid <- read.table("UCI HAR Dataset/train/y_train.txt")
trainsubjectid <- read.table("UCI HAR Dataset/train/subject_train.txt")

testfeaturevalues <- testfeaturevalues %>% mutate(subjectid = testsubjectid[, 1], activityid =                                                      testactivityid$'V1') %>%
        select(activityid, subjectid, 1:561)        

trainfeaturevalues <- trainfeaturevalues %>% mutate(subjectid = trainsubjectid[, 1], activityid =                                                     trainactivityid$'V1') %>%
        select(activityid, subjectid, 1:561)

joindata <- rbind(trainfeaturevalues, testfeaturevalues)

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

joindata$activityid <- gsub('1', 'walking', joindata$activityid)
joindata$activityid <- gsub('2', 'walkupstair', joindata$activityid)
joindata$activityid <- gsub('3', 'walkdownstair', joindata$activityid)
joindata$activityid <- gsub('4', 'sitting', joindata$activityid)
joindata$activityid <- gsub('5', 'standing', joindata$activityid)
joindata$activityid <- gsub('6', 'lying', joindata$activityid)

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

tidy_data <- joindata %>% group_by(activityid, subjectid, domain, accelerationtype, instrument, 
                                   jerk, euclideanmag, variable, direction) %>% 
        summarize(occurance = n(), average = mean(value))
tidy_data$average <- round(tidy_data$average, 5)

write.table(tidy_data,"tidyData.txt",quote = FALSE, sep="\t\t", col.names = NA)



library(reshape2)

# Load label files
activityLabels <- read.table('./Data/activity_labels.txt')
activityLabels$V2 <- as.character(activityLabels$V2)
features <- read.table('./Data/features.txt')

#Extract feature index and feature names
featuresNeededIndex <- features$V1[grepl('.*mean.*|.*std.*',features$V2)]
featuresNames <- features$V2[grepl('.*mean.*|.*std.*',features$V2)]

#Read train datasets, together with their subject and activities
trainDt <- read.table('./Data/train/X_train.txt')[featuresNeededIndex]
trainSubjectDt <- read.table('./Data/train/subject_train.txt')
names(trainSubjectDt) <- c('subject')
trainActivityDt <- read.table('./Data/train/y_train.txt')
names(trainActivityDt) <- c('activity')
names(trainDt) <- featuresNames
trainDt <- cbind(trainSubjectDt, trainActivityDt, trainDt)

#Read test datasets, together with their subject and activities
testDt <- read.table('./Data/test/X_test.txt')[featuresNeededIndex]
testSubjectDt <- read.table('./Data/test/subject_test.txt')
names(testSubjectDt) <- c('subject')
testActivityDt <- read.table('./Data/test/y_test.txt')
names(testActivityDt) <- c('activity')
names(testDt) <- featuresNames
testDt <- cbind(testSubjectDt, testActivityDt, testDt)

#Combine the test dataset and train dataset
allDt <- rbind(trainDt, testDt)

#Convert first two columns into factors
allDt$activity <- factor(allDt$activity, levels=activityLabels$V1, labels = activityLabels$V2)
allDt$subject <- as.factor(allDt$subject)

#melt and cast
allData_Melted <- melt(allDt, id = c('subject','activity'))
allData_Mean <- dcast(allData_Melted, subject+activity ~ variable, mean)

#output the data
write.table(allData_Mean, 'tidy.txt', row.names =FALSE, quote=FALSE)

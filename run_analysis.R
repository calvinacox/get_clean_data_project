#Coursera 
#Getting and Cleaning Data Course Project.
# Calvin A. Cox

##############################

# Downloading files
tech_url <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(tech_url, "wearable_tech.zip", mode="wb")
unzip("wearable_tech.zip")


# Load training data
train_set<-read.table("UCI HAR Dataset/train/X_train.txt")
train_subject<-read.table("UCI HAR Dataset/train/subject_train.txt")
train_activity<-read.table("UCI HAR Dataset/train/y_train.txt")

# Load test data
test_set<-read.table("UCI HAR Dataset/test/X_test.txt")
test_subject<-read.table("UCI HAR Dataset/test/subject_test.txt")
test_activity<-read.table("UCI HAR Dataset/test/y_test.txt")


# load features and activity labels
features<-read.table("UCI HAR Dataset/features.txt")
activity_names<-read.table("UCI HAR Dataset/activity_labels.txt")


# Combine Test and Training data
train_test_combined<-rbind(train_set,test_set)


# Clean and adnd Add features to train_test_combined dataset
features[,2]<-gsub("\\()","",features[,2])
features[,2]<-gsub("\\-","_",features[,2])
features[,2]<-gsub("\\,","_",features[,2])
features[,2]<-gsub("\\(","_",features[,2])
features[,2]<-gsub("\\)","",features[,2])


colnames(train_test_combined)<-features[,2]


# Combine Train and test  activity labels
train_test_activity<-rbind(train_activity,test_activity)

# Substitute train_test_activity with activity names
train_test_activity[, 1] <- activity_names[train_test_activity[, 1], 2]


# Extract Mean and Standard deviation measurements for each observation from train_test_complete
mean_std_columns<-grep("[Mm]ean|std",names(train_test_combined),value=TRUE)
train_test_combined<-subset(train_test_combined,select = mean_std_columns)


# Add train_set_activity column to  train_set_combined
train_test_combined$train_test_activity<-train_test_activity$V1


# Combine subjects from train and test data
train_test_subjects<-rbind(train_subject,test_subject)


# Add subjects to train_test_combined
train_test_combined$train_test_subjects<- train_test_subjects$V1


# Create Dataset with Average of each variable for each activity and subject
tidy_dataset = aggregate(train_test_combined, by=list(subject = train_test_combined$train_test_subjects, activity=train_test_combined$train_test_activity), mean)

# Remove the subject and activity column, since a mean of those has no use
tidy_dataset$train_test_activity = NULL
tidy_dataset$train_test_subjects = NULL

# Write tidy_dataset to text file
write.table(tidy_dataset, "tidy.txt", row.names = FALSE, quote = FALSE)

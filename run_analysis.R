
# setup working directory
pth <- "D:/Dropbox/E-books/Coursera/Getting and Cleaning Data/Project/UCI HAR Dataset"
setwd(pth)

############################
# Step 1 import column names
############################
### import data column names
features <- read.table(paste0(pth, "/features.txt"))

### import activity labels
activity_labels <- read.table(paste0(pth, "/activity_labels.txt"))

### extracts only the measurements on the mean and standard deviation for each measurement.
mean_sd_ind <- grepl("mean|std", features[,2])


#########################################
# Step 2 import and subset training data 
#########################################
train_x <- read.table(paste0(pth, "/train/X_train.txt"))
names(train_x) <- features[,2]
train_x <- train_x[,mean_sd_ind]

train_y <- read.table(paste0(pth, "/train/y_train.txt"))
train_y[,2] <- activity_labels[,2][train_y[,1]]
names(train_y) <- c("Activity_ID", "Activity_Label")

train_subject <- read.table(paste0(pth, "/train/subject_train.txt"))
names(train_subject) = "Subject"

### Bind data
train_full_data <- cbind(train_subject, train_y, train_x)


#########################################
# Step 3 import and subset testing data 
#########################################
test_x <- read.table(paste0(pth, "/test/X_test.txt"))
names(test_x) <- features[,2]
test_x <- test_x[,mean_sd_ind]

test_y <- read.table(paste0(pth, "/test/y_test.txt"))
test_y[,2] <- activity_labels[,2][test_y[,1]]
names(test_y) <- c("Activity_ID", "Activity_Label")

test_subject <- read.table(paste0(pth, "/test/subject_test.txt"))
names(test_subject) <- "Subject"

### Bind data
test_full_data <- cbind(test_subject, test_y, test_x)


##################################################################
# Step 4 Creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject 
##################################################################
# Merge test and train data
train_test_data <- rbind(train_full_data, test_full_data)

# Apply mean function to dataset using dcast function
tidy_data <- aggregate(train_test_data, list(Activity=train_test_data$Activity_Label, Subject=train_test_data$Subject), mean)
tidy_data2 <- tidy_data[,-c(3,5)]

write.table(tidy_data2, file = "tidy_data.txt", row.name=FALSE)
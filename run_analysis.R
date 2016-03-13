### Step 1
# Merge the training and test sets to create one data set

x_train <- read.table(file.path("train", "X_train.txt"))
y_train <- read.table(file.path("train", "y_train.txt"))
subject_train <- read.table(file.path("train", "subject_train.txt"))

x_test <- read.table(file.path("test", "X_test.txt"))
y_test <- read.table(file.path("test", "y_test.txt"))
subject_test <- read.table(file.path("test", "subject_test.txt"))

# create Features data set
Features_data <- rbind(x_train, x_test)

# create Activity data set
Activity_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

### Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt")

# get only columns with mean() or std() in their names
Sub_Data <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
Features_data <- Features_data[, Sub_Data]

# correct the column names
names(Features_data) <- features[Sub_Data, 2]

### Use descriptive activity names to name the activities in the data set
activities <- read.table(file.path("activity_labels.txt"))

# update values with correct activity names
Activity_data[, 1] <- activities[Activity_data[, 1], 2]

# correct column name
names(Activity_data) <- "activity"

### Appropriately label the data set with descriptive variable names
# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
All_Data <- cbind(Features_data, Activity_data, subject_data)

### Create a second, independent tidy data set with the average of each variable for each activity and each subject
###############################################################################
library(plyr)averages_data <- ddply(All_Data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)
#Get the data

if (!file.exists(".data")) {dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,destfile = "./data/Dataset.zip", method = "curl")

#UnZIPPP file

unzip(zipfile = "./data/Dataset.zip", exdir = "./data")

#Get the list of all the files
path<- file.path("./data", "UCI HAR Dataset")
files<- list.files(path, recursive = TRUE)
files

#Next, read data from the files into the variables

#Read activity files
ActivityTest<- read.table(file.path(path, "test", "Y_test.txt"), header = FALSE)
ActivityTrain<- read.table(file.path(path, "train", "Y_train.txt"), header = FALSE)

#Read subject files
SubjectTrain<- read.table(file.path(path,"train", "subject_train.txt"), header = FALSE)
SubjectTest<- read.table(file.path(path,"test", "subject_test.txt"), header = FALSE)

#Read features files

FeaturesTest<- read.table(file.path(path,"test", "X_test.txt"), header = FALSE)
FeaturesTrain<- read.table(file.path(path,"train", "X_train.txt"), header = FALSE)

#Looking at the properties of the variables
str(ActivityTest)
str(ActivityTrain)
str(SubjectTrain)
str(SubjectTest)
str(FeaturesTest)
str(FeaturesTrain)

#Merge the training and the test sets together and create one data set
#Concatenate the data table by rows
dataSubject<- rbind(SubjectTrain,SubjectTest)
dataActivity<- rbind(ActivityTrain, ActivityTest)
dataFeatures<- rbind(FeaturesTest, FeaturesTrain)

# Setting the names to specific variables
names(dataSubject)<- c("subject")
names(dataActivity)<- c("activity")
names(dataFeatures)<- read.table(file.path(path,"features.txt"), head=FALSE)
names(dataFeatures)<- dataFeatures$V2

#Merge the columns to get the data frame
dataCombine<- cbind(dataSubject,dataActivity)
Data<- cbind(dataFeatures, dataCombine)

#Extracting the mean and standard deviation for each measurement
subdataFeaturesNames<- dataFeatures$V2[grep("mean\\(\\)|std\\(\\)", dataFeatures$V2)]

#Subset the data from by selected names of features
selectedNames<- c(as.character(subdataFeaturesNames), "subject", "activity")
Data<- subset(Data,select = selectedNames)

#Check the structure of the DF
str(Data)


#Create a second tidy data set and create output
write.table(Data, file = "DataSummary.txt", row.names = F)

knit2html(codebook.Rmd)

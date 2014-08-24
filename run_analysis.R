##all test and train data files have been extracted to working directory, check for the same
lf<-dir()
if (("X_test.txt" %in% lf) == FALSE | ("X_train.txt" %in% lf) == FALSE) {    stop("Source file unavailable!") }

#Read data files

df_tex<-read.table("X_test.txt")            #Test Data
df_trx<-read.table("X_train.txt")           #Train Data
df_col_names<-read.table("features.txt")    #Var names"
df_trsub<-read.table("subject_train.txt")   #Subject
df_try<-read.table("y_train.txt")           #Training labels
df_tey<-read.table("y_test.txt")            #Test labels
df_tesub<-read.table("subject_test.txt")   #Subject
df_act<-read.table("activity_labels.txt")   #activity



#Column names assignment to data columns
names(df_tex) = df_col_names$V2
names(df_trx) = df_col_names$V2


#Replace activity id with descriptive label names in training labels
df_actlab = merge(df_try,df_act,by.x = "V1", by.y = "V1", all = FALSE)
names(df_actlab) = c("V1","activity")
#add activity label column to training dataset
df_train <- cbind(df_actlab$activity,df_trx)
#Replace activity id with descriptive label names in test labels
df_actlab = merge(df_tey,df_act,by.x = "V1", by.y = "V1", all = FALSE)
names(df_actlab) = c("V1","activity")
#add activity label column to training dataset
df_test <- cbind(df_actlab$activity,df_tex)


##Add subject id column
names(df_trsub) = c("subjectid")
names(df_tesub) = c("subjectid")
df_train = cbind(df_trsub,df_train)
df_test  = cbind(df_tesub,df_test)


##Combine train and test dataset
df_data = rbind(df_train, df_test)
names(df_data)[2] = 'activity'  #fix the column name

##select only the mean and standard deviation columns from the consolidated data set
df_extract = df_data[,c(1,2,grep(("mean|std"),names(df_data)))]

##Get average of all measurment columns for combination of subjectid and activity
df_aggr<- aggregate(.~subjectid + activity,data=df_extract,FUN=mean)

##Clean up names
names(df_aggr) = tolower(gsub("\\(\\)","",names(df_aggr)))  ##get rid of ## and change to lower case

##Write tidy data file to local drive
write.table(df_aggr,file="tidy_data.txt",row.names = FALSE)



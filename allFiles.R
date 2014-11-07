extension <- "csv"
#fileNames <- Sys.glob(path="/home/avnish/R/my_data/Dataset2/test",file.choose(), paste("*.", extension, sep = ""))

fileNames = dir(path="/home/avnish/R/my_data/Dataset2/test", pattern="*.csv", full.names=TRUE)
fileNumbers <- seq(fileNames)
for (fileNumber in fileNumbers) {
  newFileName <-  paste("new-", 
                        sub(paste(".", extension, sep = ""), "", fileNames[fileNumber]), 
                        ".", extension, sep = "")
  
  

P1s1 <- read.csv(fileNames[fileNumber],
                 header = TRUE,
                 sep = ",")#stringsAsFactors = FALSE
#modify data
#P1s1 <- P1s1[-which(P1s1$Action == ""), ] #only action rows=""
#P1s1 <- P1s1[-which(P1s1$ScoreChange !=0), ]
P1s1<- data.frame(P1s1, check.rows=TRUE)
P1s1<-P1s1[,-29] #delete 'Closest_Control' column
P1s1<-P1s1[P1s1$Action =="", ] #delete all non-empty 'Action' column
#column 'eventType', 'MsgIn', 'msgOut', 'Action':blank-->"inf" {type=string}
P1s1$eventType<-as.character(P1s1$eventType)
P1s1$eventType[P1s1$eventType ==""]<-"inf"
P1s1$eventType<-as.factor(P1s1$eventType)

P1s1$MsgIn<-as.character(P1s1$MsgIn)
P1s1$MsgIn[P1s1$MsgIn ==""]<-"inf"
P1s1$MsgIn<-as.factor(P1s1$MsgIn)

P1s1$MsgOut<-as.character(P1s1$MsgOut)
P1s1$MsgOut[P1s1$MsgOut ==""]<-"inf"
P1s1$MsgOut<-as.factor(P1s1$MsgOut)

P1s1$Action<-as.character(P1s1$Action)
P1s1$Action[P1s1$Action ==""]<-"inf"
P1s1$Action<-as.factor(P1s1$Action)

#column 'ScoreChange':blank/NA-->"-123"; 0 remains 0 {type=numeric}
P1s1$ScoreChange[P1s1$ScoreChange ==""]<- 123 #just in case there are blanks
P1s1$ScoreChange[is.na(P1s1$ScoreChange)]<- 123
#check
#P1s1$ScoreChange<-as.factor(P1s1$ScoreChange)
#levels(P1s1$ScoreChange)

#rest of the missing/NA data must be NaN
#for <NA> type, factor-->character-->(NA-->NaN)-->factor
for (i in names(P1s1)[c(28,41,42,50,52,53,61,63,64,72,74,80,81,82,88,89,90,96,97,98,104,105,106,112,113,114,120,121,122,128,129,130,136,137,138,144,145,146,152,154,154,160,161,162,168,169,170,176,177,178,184,185,186,192,193)]){
  P1s1[[i]]<-as.character(P1s1[[i]])
  P1s1[[i]][is.na(P1s1[[i]])]<-NaN
  P1s1[[i]][P1s1[[i]]==""]<-NaN
  P1s1[[i]]<-as.factor(P1s1[[i]])
}

#rest(numeric class) of the NA data
P1s1[is.na(P1s1)]<-NaN
P1s1[P1s1==""]<-NaN

write.table(sample, 
            newFileName,
            append = FALSE,
            quote = FALSE,
            sep = ",",
            row.names = FALSE,
            col.names = TRUE)

}

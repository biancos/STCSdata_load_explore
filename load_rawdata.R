# Author: Serena Bianco
# Date: Thu Jan 17 14:22:57 2019
# --------------
# Author: -
# Date: -
# Modification: -
# --------------


#set the working directory to the folder where you saved all raw data downloaded from stcs.ch
setwd("")

#read the names of all txt file in the working directory into a list
filelist = list.files(pattern = ".*.txt")
#erase txt extension to set the names for the R object
dataname<-as.list(sub(".txt","",filelist))

#Import each txt file in a R dataframe object (it can take some minutes)
temp = list.files(pattern="*.txt")
for (i in 1:length(temp)) assign(dataname[[i]], read.table(temp[i],header= T, sep="~", fill=T, quote=""))



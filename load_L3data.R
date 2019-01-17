# Author: Serena Bianco
# Date: Thu Jan 17 13:20:45 2019
# --------------
# Author:
# Date:
# Modification:
# --------------

#set the path to the folder where you saved all L3 downloaded from stcs.ch
path_rep=""

#Hmisc package provides functions to import SAS,Stata or SPSS files
#the files will be imported as elements of a list
library(Hmisc)
stcs <- sasxport.get(file = path_rep, method = "csv")

#replace . with _ in variables names for each element in the list
for(i in 1:length(stcs)){
  ##replace . with _ in variables names
  colnames(stcs[[i]])<-gsub("[.]", "_",names(stcs[[i]]))
}


#reshape wide to long example for immunology tests

sbblv2<-stcs$sbblv2

#create unique identifiers for reshaping and merging purposes
#Note: the conversion to characters are needed for the functions used below
sbblv2$id2=as.character(1:nrow(sbblv2))
sbblv2$id<-as.character(paste(sbblv2$patid,sbblv2$soascaseid))

#note the wide format for the variable related to immunology tests
names(sbblv2)

library(dplyr)

#susbset for information about the type of test (immu) and related date (immudate)
immuwide<-select(sbblv2,starts_with("immu_"),id2,id)
immuwide <-mutate_all(immuwide,as.character)

immudatewide<-select(sbblv2,starts_with("immudate_"),id2,id)
immudatewide<-mutate_all(immudatewide,as.character)

#number of records for immu and immudate (maximum number of tets taken for a patient in this dataset)
x<-dim(immuwide)[2]-3

#Wide to long
library(tidyr)

#reshape and rearrange
immulong <- gather(immuwide,key = entry,value = immu,immu_0:paste("immu",x,sep = "_"),na.rm = T,factor_key = T)
immulong=immulong[!immulong$immu=="",]
immulong$entry=as.character(immulong$entry)

immudatelong <-gather(immudatewide,key = entry,value = immudate,immudate_0:paste("immudate",x,sep = "_"),na.rm = T,factor_key = T)
immudatelong$entry<-as.character(sub("date","",immudatelong$entry))

#merge back to some relavant information from the original dataset
datalong=left_join(immulong,immudatelong,by=c("id2","id","entry"))
datalong=left_join(datalong,select(sbblv2,patid,soascaseid,centreid,tpxdate,organ,id,id2), by=c("id2","id"))
datalong=arrange(datalong, id)


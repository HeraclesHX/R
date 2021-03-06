#install.packages("reshape2")
install.packages("ggplot2")
require(xlsx)
require(reshape2)
require(stringr)
require(ggplot2)

getwd()
setwd("/Users/Xin/Desktop")

data = read.xlsx(file = "Fujingjing.xlsx", sheetName = "Sheet1", header = T,
                 as.data.frame = T, stringsAsFactors = F)
colnames(data) = c("Bed_ID",  "Name",	"Age",	"Sex",	"Diseases_History",
                   "HBP_COD",	"Date",	"Pressure",	"Rate",	"Drugs",	"Num",
                   "Getup_Pressure",	"Morning_Pressure",	"AfterNoon_Pressure",	"Night_Pressure")
str(data)
data1 = strsplit(data[,12], "/")
data2 = strsplit(data[,13], "/")
data3 = strsplit(data[,14], "/")
data4 = strsplit(data[,15], "/")

# length(data4)


Getup_Pressure_1 = NULL
Getup_Pressure_2 = NULL
Morning_Pressure_1 = NULL
Morning_Pressure_2 = NULL
AfterNoon_Pressure_1 = NULL
AfterNoon_Pressure_2 = NULL
Night_Pressure_1 = NULL
Night_Pressure_2 = NULL

for(i in 1:length(data[,1])){
  Getup_Pressure_1  = c(Getup_Pressure_1 , data1[[i]][1])
  Getup_Pressure_2  = c(Getup_Pressure_2 , data1[[i]][2])
  Morning_Pressure_1  = c(Morning_Pressure_1 , data2[[i]][1])
  Morning_Pressure_2  = c(Morning_Pressure_2 , data2[[i]][2])
  AfterNoon_Pressure_1  = c(AfterNoon_Pressure_1 , data3[[i]][1])
  AfterNoon_Pressure_2  = c(AfterNoon_Pressure_2 , data3[[i]][2])
  Night_Pressure_1  = c(Night_Pressure_1 , data4[[i]][1])
  Night_Pressure_2  = c(Night_Pressure_2 , data4[[i]][2])
}

transNum = function(data){
  data = as.numeric(data)
  return(data)
}

Getup_Pressure_1 = transNum(Getup_Pressure_1)
Getup_Pressure_2 = transNum(Getup_Pressure_2)
Morning_Pressure_1 = transNum(Morning_Pressure_1)
Morning_Pressure_2 = transNum(Morning_Pressure_2)
AfterNoon_Pressure_1 = transNum(AfterNoon_Pressure_1)
AfterNoon_Pressure_2 = transNum(AfterNoon_Pressure_2)
Night_Pressure_1 = transNum(Night_Pressure_1)
Night_Pressure_2 = transNum(Night_Pressure_2)

data2 = cbind(Getup_Pressure_1, Getup_Pressure_2, Morning_Pressure_1, Morning_Pressure_2, 
              AfterNoon_Pressure_1, AfterNoon_Pressure_2, Night_Pressure_1,Night_Pressure_2)

data_m = cbind(data[,1:11], data2)

# data_m = as.data.frame(data_m)
# is.data.frame(data_m)
# write.xlsx2(data_m, "data_m.xlsx", sheetName="Sheet1", 
#            col.names=TRUE)

pf_prod = c("络活喜","苯磺酸氨氯地平")

strsplit(data$Drugs[1], "，")
strsplit(data$Drugs, "，")[[1:2]] %in% pf_prod

logic = function(x){
   any(x %in% pf_prod)
}

criteria = lapply(strsplit(data$Drugs, "，"), logic)
criteria[[2]]

criteria1 = unlist(criteria)
table(criteria1)

# For Pfizer's Products
tgt = subset(data_m[criteria1,], Getup_Pressure_1 <= 135 & Getup_Pressure_2 <= 85)

threeDays = function(tmp){
  string = paste(tmp, sep = "", collapse = "")
  return(string)
}

logic_v = data_m[,c("Getup_Pressure_1", "Getup_Pressure_2") ]
indicator = as.numeric(with(logic_v, Getup_Pressure_1 <= 135 & Getup_Pressure_2 <= 85))
tgt1 = cbind(data_m[,1:11], indicator)


#Now, we apply the the aggregate function. It is very useful in the reshape the data

tgt2 = aggregate(indicator ~ Name, data = tgt1, "threeDays")
normal_flag = str_detect(tgt2[,2], "111")

tgt2 = cbind(tgt2, normal_flag)

demogra = tgt1[,c("Name", "Age", "Sex", "Drugs")]
demogra = unique.data.frame(demogra)

drug_flag = str_detect(demogra[,4], "络活喜")

demogra = cbind(demogra, drug_flag)

final_data = merge.data.frame(demogra, tgt2, by.x = "Name", 
                               by.y = "Name")









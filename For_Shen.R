install.packages("xlsx")
install.packages("stringr")
require(xlsx)
require(stringr)

getwd()
setwd("/Users/Xin/Desktop")

raw.data.independent = read.xlsx("数据.xls",sheetName = "自变量")
raw.data.dependent = read.xlsx("数据.xls",sheetName = "因变量")


raw.data.independent.t = t(raw.data.independent)
raw.data.dependent.t = t(raw.data.dependent)

colname1 = raw.data.independent.t[1,]
colname2 = raw.data.dependent.t[1,]

raw.data.independent.t1 = raw.data.independent.t[-1,]
raw.data.dependent.t1 = raw.data.dependent.t[-1,]

colnames(raw.data.independent.t1) = colname1
# names(raw.data.dependent.t1) = colname2

month = seq(1,12)
month = ifelse(month<10, paste("0", month, sep=""), month)

year.month1 = paste(month[-1], "2011", sep="/")
year.month2 = paste(month[-1], "2012", sep = "/")
year.month3 = paste(month[-1], "2013", sep="/")
year.month4 = paste(month[2:6], "2014", sep = "/")
year.month = c(year.month1, year.month2, year.month3, year.month4)


raw.data.independent.t2 = cbind(year.month, raw.data.independent.t1)
colnames(raw.data.independent.t2)[1] = "Date"

raw.data.dependent.t2 = cbind(year.month, raw.data.dependent.t1)
colnames(raw.data.dependent.t2)[1] = "Date"

raw.data.final = merge(raw.data.dependent.t2, raw.data.independent.t2, 
                       by.x = "Date", by.y = "Date")

colnames(raw.data.final)[2] = "通讯器材类同比"

str(raw.data.final)

raw.data.final[,-1] = as.numeric(raw.data.final[,-1])

install.packages("xlsx")
require(xlsx)

getwd()
setwd("/Users/Xin/Desktop")

raw.data = read.xlsx("数据.xls",sheetName = "自变量")

raw.data.t = t(raw.data)

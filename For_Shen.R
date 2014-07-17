install.packages("xlsx")
install.packages("stringr")
install.packages("randomForest")
require(xlsx)
require(stringr)
require(randomForest)

getwd()
setwd("/Users/Xin/Desktop")

# Phase I: Generate the data for boosting and random forest models #

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

tmp = as.numeric(as.matrix(raw.data.final[,-1]))
raw.data.final.m = cbind(raw.data.final[,1], as.data.frame(matrix(tmp, nrow = 38)))
colnames(raw.data.final.m) = colnames(raw.data.final) 
raw.data.final.m1 = raw.data.final.m
model.name = c("Date", "y", paste("x", seq(1,22), sep=""))
colnames(raw.data.final.m1) = model.name

# standardizing the independent variables #

standardized.vars = scale(raw.data.final.m1[,-c(1, 2)])
cov(standardized.vars)
apply(standardized.vars, 2, mean)
raw.data.final.f = cbind(raw.data.final.m1[,c(1, 2)], standardized.vars)
is.data.frame(raw.data.final.f)

str(raw.data.final.f)
rownames(raw.data.final.f) = raw.data.final.f[["Date"]]



##########################################
#      run the random forest model       #
##########################################

set.seed(1234)

rf.model = randomForest(y ~ ., raw.data.final.f[,-1], ntree = 500)
oob.predict = predict(rf.model) #predict of the OOB observations #
length(oob.predict)
Date = names(oob.predict)
test.predict = data.frame(Date = Date, Predict = oob.predict)

for.mse.r = merge(raw.data.final.f[,c(1, 2)], test.predict,
                  by.x = "Date", by.y = "Date")

mse.rf = mean((for.mse.r[["y"]] - for.mse.r[["Predict"]])^2) # Mean Square Error = 47.03287, the less the better#
rsq.rf = 1 - mse.rf/var(for.mse.r[["y"]]) # Pseduo R Square = 0.31, the larger the better #



Sys.setenv("HADOOP_CMD"="/Users/Xin/Downloads/Software/hadoop-1.2.1/bin/hadoop")
Sys.setenv("HADOOP_STREAMING"="/Users/Xin/Downloads/Software/hadoop-1.2.1/contrib/streaming/hadoop-streaming-1.2.1.jar")
Sys.getenv("HADOOP_CMD")

#install the hadoop packages#

install.packages(c("rJava", "Rcpp", "RJSONIO", "bitops",
                   "digest", "functional", "stringr",
                   "plyr", "reshape2"))

install.packages("/Users/Xin/Downloads/Software/rhadoop/rhdfs_1.0.8.tar.gz", 
                 repos = NULL, type="source")
install.packages("/Users/Xin/Downloads/Software/rhadoop/rhbase_1.2.0.tar.gz", 
                 repos = NULL, type="source")
install.packages("/Users/Xin/Downloads/Software/rhadoop/rmr2_3.1.1.tar.gz", 
                 repos = NULL, type="source")


Sys.setenv("HADOOP_HOME"="/Users/Xin/Downloads/Software/hadoop-1.2.1")
library(rmr2)

map <- function(k,lines) {
  words.list <- strsplit(lines, '\\s')
  words <- unlist(words.list)
  return( keyval(words, 1) )  
}

reduce <- function(word, counts) {
    keyval(word, sum(counts))
}

wordcount <- function (input, output=NULL) {
  mapreduce(input=input, output=output, input.format="text", map=map, reduce=reduce)
}



## read text files from folder wordcount/data
## save result in folder wordcount/out
## Submit job

hdfs.root <- 'wordcount'
hdfs.data <- file.path(hdfs.root, 'data')
hdfs.out <- file.path(hdfs.root, 'out')
out <- wordcount(hdfs.data, hdfs.out)



## Fetch results from HDFS

results <- from.dfs(out)
results.df <- as.data.frame(results, stringsAsFactors=F)
colnames(results.df) <- c('word', 'count')
head(results.df)

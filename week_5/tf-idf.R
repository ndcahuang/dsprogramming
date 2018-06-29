#load requred libraries
library(tm)
#library(tmcn)
library(jsonlite)

#read data via Facebook Graph API for posts later than 2018-06-01
since <- "since=2018-06-10"
token <- "access_token=EAACEdEose0cBAAVZCi2LcJRPas6Ns14ygNNVFcT9loIejqtlR1tNItC9frvLwzNeEr9DYI1Pj9c1qsElnbk9LZAV8VmhX9jfSXYvkMY1HrVAG57eZCzuVKFmC70mH5cT9KXSkrQxqUERuPTNfKSAoNNORAYJsiWtwCbqWCJOqW8zZC8ZAUOZCS5Lrkd5UZACCQZD"
params <- paste(since, token, sep="&")
url <- "https://graph.facebook.com/v3.0/125845680811480/feed?"
source <- paste(url, params, sep="")
raw <- fromJSON(source)
msg <- as.character(raw$data$message)

#convert message to data frame
msg_df <- data.frame(as.list(msg), stringsAsFactors=FALSE)
colnames(msg_df) <- c(1:ncol(msg_df))
inspect(corpus[2])
#convert to corpus and clean up based on multiple criteria
corpus <- Corpus(VectorSource(msg_df))
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, function(word) {gsub("[^\x01-\x7F]", "", word)})
#corpus <- tm_map(corpus, segmentCN, nature = TRUE)
#corpus <- tm_map(corpus, function(word) {gsub("[A-Za-z0-9\r\n]", "", word)})

#perform TF-IDF computation
tdm = TermDocumentMatrix(corpus, control = list(weighting = weightTfIdf))
mtx <- as.matrix(tdm)

write.csv(mtx, "result.csv")
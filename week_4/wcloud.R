library(tmcn)
library(tm)
library(jsonlite)
library(wordcloud)

fb_post <- fromJSON("https://graph.facebook.com/v3.0/136845026417486_1267145630054081/comments?pretty=0&limit=5000&after=MTUxNwZDZD&access_token=EAACEdEose0cBADzvpDpskZA3fLURDBSwzQfxPTeIky46xlaSYmhPtJIyImf9kSEirTSd8ROPSZBgrlx2As5kJuaikBollZB4fvK8HxtaNIzcc2WBh8PI1ZARKnQgPdKd4Pa8dq10fBPDzBF7WyOnD7gDji153qjTILkAa0M3nfzyqaFxXhLu9XpxQijzFhLFPJntXFEDUgZDZD")
fb_comment <- as.character(fb_post$data$message)

comment_db <- Corpus(VectorSource(fb_comment), list(language = NA))
comment_db <- tm_map(comment_db, stripWhitespace)
comment_db <- tm_map(comment_db, removePunctuation)
comment_db <- tm_map(comment_db, removeNumbers)
comment_db <- tm_map(comment_db, function(word) {gsub("[A-Za-z0-9]", "", word)})
comment_db <- tm_map(comment_db, segmentCN, nature = TRUE)
comment_db <- tm_map(comment_db, function(sentence) {
  noun <- lapply(sentence, function(w) {
    w[names(w) == "n"]
  })
  unlist(noun)
})

comment_db <- Corpus(VectorSource(comment_db))

tdm <- TermDocumentMatrix(comment_db, control = list(wordLengths = c(2, Inf)))

m1 <- as.matrix(tdm)
v <- sort(rowSums(m1), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)
par(family = 'STHeiti')

wordcloud(d$word, d$freq, min.freq = 5, random.order = F,
          ordered.colors = F,
          colors = rainbow(length(row.names(m1))), family="Heiti TC Light")
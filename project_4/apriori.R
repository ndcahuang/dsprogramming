install.packages("arules")
data <- read.csv("sample.csv")
data_theater <- data[data$rqhost %in% c("theater-cf.kddi-video.com", "theater.kddi-video.com"), ]
head(data_theater)
data_theater_extracted <- data_theater[, c("locationstr", "result0", "hr", "device")]
data_theater_extracted[, "hr"] <- factor(data_theater_extracted[, "hr"])
str(data_theater_extracted)

require(arules)
apriori_rule <- apriori(data_theater_extracted, parameter = list(minlen=4, supp=0.000001, conf=0.5), appearance = list(default="lhs", rhs=c("result0=Miss")))
inspect(apriori_rule)
apriori_rule_sorted <- sort(apriori_rule, by="count")
inspect(head(apriori_rule_sorted, 20))
#support=A且B/全部
#confidence=B/A
#lift=A且B/A或B
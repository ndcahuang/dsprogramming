install.packages("ggplot2")
install.packages("gridExtra")

library(ggplot2)
require(gridExtra)
library(lattice)
pb = read.table("pb", header = TRUE)

#Question 1
star <- subset(pb, grepl("^[*]", v), select=c(v, f1, f2))
starplot <- ggplot(star, aes(x = f2-f1, y = f1, label= v, color = v, fill=FALSE)) + geom_text() + labs(x = "F2-F1", y = "F1") + theme(legend.position = "none") + xlim(3000, 0) + ylim(1500, 0)
starplot
nstar <- subset(pb, grepl("^[A-Z]", v), select=c(v, f1, f2))
nstarplot <- ggplot(nstar, aes(x = f2-f1, y = f1, label= v, color = v, fill = FALSE)) + geom_text() + labs(x = "F2-F1", y = "F1") + ylim(1500, 0) + xlim(3000, 0) + theme(legend.position = "none")
grid.arrange(starplot, nstarplot, ncol = 2)

#Question 2
combined <- data.frame(mfc=pb$mfc, f0=pb$f0)
fact <- factor(pb$mfc, labels=c("male", "female", "child"))
q2 <- ggplot(combined, aes(x=f0)) + geom_histogram(aes(y=..density.., fill=fact), color="grey80") + facet_grid(mfc~.)
q2

#Question 3
nstarf1 <- subset(pb, grepl("^[A-Z]", v), select = c(v, f1))
q3 <- ggplot(nstarf1, aes(v, f1)) + labs(x = "Vowel", y = "F1") + geom_boxplot() + scale_x_discrete(limits = c("IY", "IH", "EH", "AE", "AH", "UW", "UH", "AO", "ER", "AA")) + scale_y_discrete(limits = c(200, 400, 600, 800, 1000, 1200))
q3

#Question 4
q4 <- ggplot(pb, aes(x = f0, y = f1)) + geom_point() + geom_smooth(method = lm, se = FALSE)
q4
require(XML)
install.packages("XML")
install.packages("knitr")
#data <- xmlTreeParse("http://feeds.bbci.co.uk/news/world/asia/rss.xml")
# xmltop = xmlRoot(data)
# xmlSize(xmltop)
# gsub("<", "", xmltop[[1]][[10]][[1]][[1]])
#xmltop[['channel']][['item']]
# xmltop[['channel']][['item']]

doc = xmlInternalTreeParse("http://feeds.bbci.co.uk/news/world/asia/rss.xml")
doc
items = getNodeSet(doc, "//channel/item")
titles = lapply(items, xpathApply, ".//title", xmlValue)
descriptions = lapply(items, xpathApply, ".//description", xmlValue)
links = lapply(items, xpathApply, ".//link", xmlValue)
dates = lapply(items, xpathApply, ".//pubDate", xmlValue)

titles = unlist(titles)
descriptions = unlist(descriptions)
links = unlist(links)
dates = unlist(dates)

result = data.frame(Title=titles, Description=descriptions, Links=links, Dates=dates)
result

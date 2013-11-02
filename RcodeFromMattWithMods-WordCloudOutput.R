rm(list=ls())


library(twitteR)
library(rjson)
library(wordcloud)
library(tm)


#Twitter API Example
reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "http://api.twitter.com/oauth/access_token"
authURL <- "http://api.twitter.com/oauth/authorize"


#keys from creating the app on your twitter account
consumerKey <- "5RsfFBir080NI2xFinsAKg"
consumerSecret <- "76qKFJK5lgowUWjjZZUnpXOkXUBhpHlWpFtOaDv6TA"


twitCred <- OAuthFactory$new(consumerKey=consumerKey,consumerSecret=consumerSecret,requestURL=reqURL,accessURL=accessURL,authURL=authURL)
download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="cacert.pem")


#go to the website and enter the number given
#you can't copy the texts
twitCred$handshake(cainfo="cacert.pem")


#sets the connection
registerTwitterOAuth(twitCred)


#download tweets by number
cpdList1 <- searchTwitter("chicagoparks", n=1000, cainfo="cacert.pem")
cpdList2 <- searchTwitter("grant park", n=1000, cainfo="cacert.pem")
cpdList3 <- searchTwitter("chicagobeach", n=1000, cainfo="cacert.pem")
cpdList4 <- searchTwitter("north avenue beach", n=1000, cainfo="cacert.pem")
cpdList5 <- searchTwitter("chiacgobeaches", n=1000, cainfo="cacert.pem")
cpdList6 <- searchTwitter("chicagoparkdistrict", n=1000, cainfo="cacert.pem")
cpdList7 <- searchTwitter("rainbowbeach", n=1000, cainfo="cacert.pem")
cpdList8 <- searchTwitter("oak st beach", n=1000, cainfo="cacert.pem")
cpdList9 <- searchTwitter("foster beach", n=1000, cainfo="cacert.pem")
cpdList10 <- searchTwitter("63rd st beach", n=1000, cainfo="cacert.pem")

#download tweets by date range
cpdListTest <- searchTwitter("foster beach", since = '2013-06-26', until = '2013-10-28', n=200, cainfo="cacert.pem")
cpdListTest2 <- searchTwitter("foster beach", user='chicago', n=200, cainfo="cacert.pem")

cpdData <- twListToDF(c(cpdList1, cpdList2,cpdList3,cpdList4,cpdList5,cpdList6,cpdList7,cpdList8,cpdList9,cpdList10 ))

cpdList <-c(cpdList2, cpdList1,cpdList3,cpdList4,cpdList5,cpdList6,cpdList7,cpdList8,cpdList9,cpdList10)
#create a word cloud!
r_stats_text2 <- sapply(cpdList, function(x) x$getText())
#create corpus
r_stats_text_corpus2 <- Corpus(VectorSource(r_stats_text2))
#clean up
r_stats_text_corpus2 <- tm_map(r_stats_text_corpus2, tolower)
r_stats_text_corpus2 <- tm_map(r_stats_text_corpus2, removePunctuation)
r_stats_text_corpus2 <- tm_map(r_stats_text_corpus2, function(x)removeWords(x,stopwords()))
wordcloud(r_stats_text_corpus2, colors = brewer.pal(8,"Dark2"))

#get screenName (user name) list from cpdData frame
screenNameList<-c(cpdData$screenName)

#get user object with all attributes
us<-lookupUsers(screenNameList,cainfo="cacert.pem" )


#declare empty list
fllist1<-{}
fllist2<-{}

#run for loop for any attribute

for (i in 1:length(us)){
  fllist1<-c(fllist1,us[[i]]$screenName)
  fllist2<-c(fllist2,us[[i]]$followersCount)}
  
#Column bind to combine attributes
fllistcombine<-cbind(fllist1,fllist2)

#To get individual attributes for each userName in the list
str(us)



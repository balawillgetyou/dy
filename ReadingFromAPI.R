library(httr)
library(rjson)

myapp <- oauth_app("twitter", key = "wijb9uSoLk2IlJi2kcOtbDo5y", secret = "7SXVMu0uFb4QQFHT6mMB6zKzTSJquKyEKJXxpa6JGNTGv2bCWC")
sig <- sign_oauth1.0(myapp, token = "16510171-x9Ma3jc4qlxv6kvOdkpSZawSWQC20PIuMY3z8gQfS", token_secret = "2VCQrhwjYzDGVW9HjALLbt0EyKQHZP6tk7d6A7Faw5NED")
homeTL <- GET("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=rlangtip&count=5",sig)
#homeTL <- GET("https://api.twitter.com/1.1/statuses/mentions_timeline.json",sig)

json1 <- content(homeTL)
json2 <- jsonlite::fromJSON(toJSON(json1))
json2[1:5,4]

json2
str(json2)


json2[1,1:4]

json1[[5]]

library(rvest)
library(stringr)

# start from the url
startUrl<-"http://www.baidu.com/s?wd=%E6%88%B7%E5%A4%96%E6%97%85%E6%B8%B8%E4%BF%B1%E4%B9%90%E9%83%A8&rsv_spt=1&rsv_iqid=0xa45198d30000b934&issp=1&f=8&rsv_bp=1&rsv_idx=2&ie=utf-8&tn=baiduhome_pg&rsv_enter=0&oq=%E6%88%B7%E5%A4%96%E6%97%85%E6%B8%B8%E4%BF%B1%E4%B9%90%E9%83%A8&rsv_t=a9316GvuS0KPySQNP666s9xA0IItDMmJ5vth8%2BqKyEebolhmRIyOY1Be6eU9ngxsAtky&rsv_pq=aee9999b0000bbf9"
web<-read_html(startUrl,encoding="UTF-8")
urlName<-web %>% html_nodes("h3 a") %>% html_text()
urlMore<-web %>% html_nodes("h3 a") %>% html_attr("href")

# To jump from the current page to the next page
s<-html_session(startUrl)
urlNext<-web %>% html_nodes("div#page a.n") %>% html_attr("href")
nextUrl<-(s %>% jump_to(urlNext))$url

# get the page result
for(urlPart in 1:length(urlMore)){
  (urlConnect<-urlMore[2])
  (urlName[2])
  webConnect<-read_html(urlConnect)
  content<-webConnect %>% html_nodes("div") %>% html_text()
  
  # use regular expression to match the content we need
  library(stringr)
  # match the telephone number
  unlist(str_extract_all(content, "\\s1[3578][.-]? *\\d{5}[.-]? *[.-]?\\d{4}"))
  
  # match the phone number like 0971-6181362
  unlist(str_extract_all(content, "\\d{4}-\\d{7}"))
  
  # match the phone number like 
  unlist(str_extract_all(content, "\\d{3}-\\d{7}\\d{1}?"))
}

# download next page
web<-read_html(nextUrl,encoding="UTF-8")

data<-readLines(urlConnect)

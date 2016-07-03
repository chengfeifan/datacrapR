library(rvest)
library(stringr)
library(stringr)
# start from the url
startUrl<-"http://www.baidu.com/s?wd=%E6%88%B7%E5%A4%96%E6%97%85%E6%B8%B8%E4%BF%B1%E4%B9%90%E9%83%A8&rsv_spt=1&rsv_iqid=0xa45198d30000b934&issp=1&f=8&rsv_bp=1&rsv_idx=2&ie=utf-8&tn=baiduhome_pg&rsv_enter=0&oq=%E6%88%B7%E5%A4%96%E6%97%85%E6%B8%B8%E4%BF%B1%E4%B9%90%E9%83%A8&rsv_t=a9316GvuS0KPySQNP666s9xA0IItDMmJ5vth8%2BqKyEebolhmRIyOY1Be6eU9ngxsAtky&rsv_pq=aee9999b0000bbf9"
currentPage<-1
url<-startUrl

while(1){
  web<-read_html(url,encoding="UTF-8")
  urlName<-web %>% html_nodes("h3 a") %>% html_text()
  urlMore<-web %>% html_nodes("h3 a") %>% html_attr("href")
  
  # To jump from the current page to the next page
  s<-html_session(url)
  if(currentPage==1){
    urlNext<-web %>% html_nodes("div#page a.n") %>% html_attr("href")
  } else{
    urlNext<-web %>% html_nodes("div#page a.n") %>% html_attr("href")
    urlNext<-urlNext[2]
  }
  
  nextUrl<-(s %>% jump_to(urlNext))$url
  
  for(i in 1:length(urlMore)){
    urlConnect<-urlMore[i]
    # (urlName[i])
    webConnect<-try(read_html(urlConnect))
    if(inherits(webConnect,"try-error")){
      
    } else{
      content<-webConnect %>% html_nodes("div") %>% html_text()
      
      Name<-urlName[i]
      # match the telephone number
      cat(Name,file="huwai.txt",append = TRUE)
      teleNumber<-try(unique(unlist(str_extract_all(content, "\\s1[3578][.-]? *\\d{5}[.-]? *[.-]?\\d{4}"))))
      cat("teleNumber: ",teleNumber,"\n")
      cat(teleNumber,file="huwai.txt",append = TRUE)
      # match the phone number like 0971-6181362
      phoneNumber1<-try(unique(unlist(str_extract_all(content, "\\d{4}-\\d{7}\\d{1}?"))))
      cat("phoneNumber1: ",phoneNumber1,"\n")
      cat(phoneNumber1,file="huwai.txt",append = TRUE)
      # match the phone number like 
      phoneNumber2<-try(unique(unlist(str_extract_all(content, "\\d{3}-\\d{7}\\d{1}?"))))
      cat("phoneNumber2: ",phoneNumber2,"\n")
      cat(phoneNumber2,file="huwai.txt",append = TRUE)
      # write the result into file
      cat("\n",file="huwai.txt",append=TRUE)
    }
    
    #     try(write.table(dataInput,file="/Users/cheng/Desktop/huwai.txt",append = TRUE,
    #                 quote=FALSE,sep="\t",row.names=FALSE,col.names=FALSE,fileEncoding = "UTF-8"))
  }
  
  # jump to next url
  url<-nextUrl
  print(currentPage)
  currentPage<-currentPage+1
}


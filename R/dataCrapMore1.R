#' datacrap for lianjia

datacrap<-function(i){
  # i=2
  # show the url of the lianjia 
  urlConnect<-paste("http://bj.lianjia.com/xiaoqu/pg",i,"/",sep="")
  library(rvest)
  library(stringr)
  
  url<-urlConnect
  
  #download the html file by the url
  web<-read_html(url,encoding="UTF-8")
  
  #get the url of the sub page
  urlMore<-web %>% html_nodes("li div.info-panel h2 a") %>% html_attr("href")
  urlMore<-unlist(lapply(urlMore,function(urlShort){
    paste("http://bj.lianjia.com",urlShort,sep="")
  }))
  
  j=1
  while(j < length(urlMore)+1){
    #j=8
    
    # sleep to avoid the Anti reptile 
    Sys.sleep(runif(1,1,5))
    urlAdd<-urlMore[j]
    
    #download the html file
    web<-try(read_html(urlAdd,encoding = "UTF-8"))
    if(inherits(web,"try-error")){
      j=j+1
    }
    else{
      #name of Community
      name<-web %>% html_nodes("div.wrapper div.title.fl a h1") %>% html_text()
      #Location and MapLocation
      Location<-web %>% html_nodes("div.wrapper div.title.fl span") %>% html_text()
      bigLocation<-Location[1]
      smallLocation<-Location[2]
      mapLocation<-web %>% html_nodes("div.wrapper div.title.fl a.actshowMap") %>% html_attr("xiaoqu")
      mapLong<-as.numeric(substr(mapLocation,regexpr("\\[",mapLocation)[1]+1,
                                 regexpr(",",mapLocation)[1]-1))
      mapLat<-as.numeric(substr(mapLocation,regexpr(",",mapLocation)[1]+1,
                                regexpr("\\]",mapLocation)[1]-1))
      #average price of Community 
      price<-web %>% html_nodes("div.res-info.fr div.col-1 div.price-pre span.num") %>% html_text()
      #Construct time of Community
      conTime<-web %>% html_nodes("div div ol li span span.other") %>% html_text()
      conTime<-conTime[1]
      conTime<-as.numeric(substr(conTime,1,4))
      #type developer numBuilding FAR numHouse greenPercent
      allInfo<-web %>% html_nodes("div div ol li span.other") %>% html_text()
      type<-allInfo[2]
      developer<-allInfo[5]
      numBuilding<-allInfo[6]
      numBuilding<-as.numeric(substr(numBuilding,1,nchar(numBuilding)-1))
      FAR<-as.numeric(allInfo[7])
      numHouse<-allInfo[8]
      numHouse<-as.numeric(substr(numHouse,1,nchar(numHouse)-1))
      greenPercent<-allInfo[9]
      numDeal<-web %>% html_nodes("div div.all div.first.fl div.next.fl p span.two") %>% html_text()
      
      dataInput<-data.frame(name,bigLocation,smallLocation,mapLong,mapLat,price,
                            conTime,type,developer,numBuilding,FAR,numHouse,
                            greenPercent,numDeal)
      write.table(dataInput,file="/Users/cheng/Desktop/lianjia.txt",append = TRUE,
                  quote=FALSE,sep="\t",row.names=FALSE,col.names=FALSE,fileEncoding = "UTF-8")
      j=j+1
    }
  }
  return(NULL)
}
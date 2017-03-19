# 用于爬取 上证交易所 （http://www.sse.com.cn/disclosure/listedinfo/regular/）年报数据
# 使用之前需要更改网站输入日期，将其中的“readonly”清除掉
# 将查询设置为 “年报”
# 目前是手动，以后可以改为自动
# 需要输入查询的日期,日期之间的间隔不能超过3年，input_date="2011-01-01"
# 需要知道查询股票的代码，必须是上证公司，也就是以6开头的股票
# 年报按照公司进行划分，一个公司为一个文件夹，且文件夹的名称为上市公司代码
rm(list=ls())
input_code_list<-read.table("/Users/cheng/R-program/sign_CCM/input_code_list.txt",stringsAsFactors = FALSE)
input_code_list<-input_code_list$V1
input_date_start<-read.table("/Users/cheng/R-program/sign_CCM/input_date_start.txt",stringsAsFactors = FALSE)
input_date_start<-input_date_start$V1
input_date_end<-read.table("/Users/cheng/R-program/sign_CCM/input_date_end.txt",stringsAsFactors = FALSE)
input_date_end<-input_date_end$V1
# 新建文件夹，用于存放pdf文件
setwd("/Users/cheng/R-program/sign_CCM/pdf")
for(i in input_code_list){
  dir.create(as.character(i))
}


library(seleniumPipes)
library(rvest)
library(dplyr)
library(stringi)
library(purrr)

# 新建一个session，打开访问的界面
remDr  <- remoteDr(browserName='chrome',port=4444,platform='ANY')
remDr %>% go("http://www.sse.com.cn/disclosure/listedinfo/regular/")

# 主程序，下载pdf文件
for(i in 1:length(input_date_start)){
  input_date_s<-input_date_start[i]
  #输入查询的起始日期
  from_date<-remDr %>% findElement("xpath",".//input[@id='start_date']")
  ##清除原来有的信息
  from_date %>% elementClear()
  from_date %>% elementSendKeys(input_date_s)
  
  input_date_e<-input_date_end[i]
  #输入查询的终止日期
  end_date <- remDr %>% findElement("xpath",".//input[@id='end_date']")
  ## 清除原来有的信息
  end_date %>% elementClear()
  end_date %>% elementSendKeys(input_date_e)
  
  for(j in 1:length(input_code_list)){
    inputCode<-input_code_list[j]
    cat(inputCode,"\n")
    #输入需要查询的证券代码
    input_code <- remDr %>% findElement("xpath",".//input[@id='inputCode']")
    ## 清除原来有的信息
    input_code %>% elementClear()
    input_code %>% elementSendKeys(as.character(inputCode))
    
    #提交查询
    search <- remDr %>% findElement("xpath",".//button[@id='btnQuery']")
    search %>% elementClick()
    
    # 下载页面资源
    remDr %>% getPageSource() -> pg
    
    # 文件名
    pdf_date<- pg %>% html_nodes("#tabs-658545 > div.sse_list_1.list > dl > dd > span") %>% html_text()
    
    # 判断是否有记录
    if(length(pdf_date)!=0){
      pdf_name<- pg %>% html_nodes("#tabs-658545 > div.sse_list_1.list > dl > dd > a") %>% html_text()
      pdf_full_name<-paste(pdf_date,pdf_name,sep='_')
      pdf_full_name_pdf<-paste("/Users/cheng/R-program/sign_CCM/pdf/",inputCode,"/",pdf_full_name,".pdf",sep='')
      
      # 下载文件
      pdf_url<- pg %>% html_nodes("#tabs-658545 > div.sse_list_1.list > dl > dd > a") %>% html_attr("href")
      pdf_full_url<-paste("http://www.sse.com.cn",pdf_url,sep='')
      for(k in 1:length(pdf_full_url)){
        download.file(pdf_full_url[k],destfile =pdf_full_name_pdf[k])
      }
    } 
    
  }
}

#终止session
remDr %>% deleteSession()
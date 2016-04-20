# the main function
source('~/R-program/R-crapNet/dataCrapMore1.R')
i=213
while(i<215){
  cat(paste(i,"\n"))
  x<-try(datacrap(i))
  if(inherits(x, "try-error")){
    cat(paste(i,"\n"),file="/Users/cheng/Desktop/count.txt",append=TRUE)
    i=i+1
  }
  else{
    i=i+1
  }
}
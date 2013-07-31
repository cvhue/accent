library("ggplot2")
accent = (read.csv("~/src/accent/shiny/solution.csv", sep=","))

schedule <- function(df, 
                     lead = names(df)[1],
                     subject = names(df)[2],
                     day = names(df)[3],
                     time = names(df)[4],
                     reverse = FALSE){
  

  lead = names(df)[1]
  subject = names(df)[2]
  day = names(df)[3]
  time = names(df)[4]
  
  if(reverse==TRUE){
    tmp = subject
    subject = lead
    lead = tmp
  }
  df$day.end = df$day+1
  df$time.end = df$time+1
  df$dayf<-factor(df[,day],levels=1:7,labels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"),ordered=TRUE)
  df$timef<-factor(df[,time],levels=rev(1:5),labels=rev(c("8h","10h","13h","15h","17h")),ordered=TRUE)
  
  p = ggplot(df,aes_string(x="dayf", y="timef",fill=subject,xmin=day,xmax="day.end",ymin=time,ymax="time.end")) + geom_rect(colour = "white") + labs(title = "Staff schedule") +  xlab("Day of week") + ylab("") + theme(axis.text.x = element_text( hjust = -3)) + facet_grid(as.formula(sprintf('%s~.',lead)))

  p<- p + labs(title = "Staff schedule") +  xlab("Day of week") + ylab("") + theme(axis.text.x = element_text( hjust = -3))
  
  if(reverse==TRUE){
     p = p + labs(title = "Patient schedule") 
  } 
  
  return(p)
}


#' @title schedula a solution
#'
#' @description schedule a solution
#'
#' @param df dataframe consisting of lead, subject, day and time
#' @return ggplot schedule
#' @export
#'
schedule <- function(df, 
                     lead = names(df)[1],
                     subject = names(df)[2],
                     day = names(df)[3],
                     time = names(df)[4],
                     reverse = FALSE){
  
  require("ggplot2")
  
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
  days = c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")
  timeslots = c("8h","10h","13h","15h","17h")
  df$dayf<-factor(df[,day],levels=1:7,labels=days,ordered=TRUE)
  df$timef<-factor(df[,time],levels=rev(1:5),labels=rev(timeslots),ordered=TRUE)
  
  p = ggplot(df,aes_string(x="dayf", y="timef",fill=subject,xmin=day,xmax="day.end",ymin=time,ymax="time.end")) + 
    geom_rect(colour = "white") + labs(title = "Staff schedule") +  
    xlab("Day of week") + ylab("") + theme(axis.text.x = element_text( hjust = -3)) + 
    facet_grid(as.formula(sprintf('%s~.',lead))) + coord_cartesian(xlim = c(1, 6),ylim=c(1,5)) + 
    scale_y_discrete(limits = rev(timeslots))
  
  p<- p + labs(title = "Staff schedule") +  xlab("Day of week") + ylab("") + theme(axis.text.x = element_text( hjust = -3))
  
  if(reverse==TRUE){
     p = p + labs(title = "Patient schedule") 
  } 
  
  return(p)
}


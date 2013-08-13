#' @title build a solution for the specified model  
#' 
#' @description desc
#' 
#' @param AccentModelSolution
#' 
#' @export 
#' @return  plot with the patient schedule 
#' @example
#' solution <- exampleSolution()
#' 
drawPatientSchedule <- function(solution){
  if("AccentModelSolution" %in% class(solution) == FALSE){
    Log$info("solution is not of type AccentModelSolution.")
    return(NA)
  }
  
  df <- solution$data
  
  df$day.end = df$day+1
  df$time.end = df$time+1
  df$dayf<-factor(df[,day],levels=1:7,labels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"),ordered=TRUE)
  df$timef<-factor(df[,time],levels=rev(1:5),labels=rev(c("8h","10h","13h","15h","17h")),ordered=TRUE)
  str(df$dayf)  
  p <-  ggplot(df, aes(x=dayf,
                       y=timef,
                       fill=patient,
                       xmin=day,
                       xmax=day.end,
                       ymin=time,
                       ymax=time.end))
  
  p <- p + geom_rect(colour = "white") 
  p <- p + labs(title = "Patient schedule") 
  p <- p + xlab("Day of week") 
  p <- p + ylab("") 
  p <- p + theme(axis.text.x = element_text( hjust = -3)) 
  p <- p + facet_grid(~therapist)
  
  p <- p + labs(title = "Staff schedule") 
  p <- p +  xlab("Day of week") 
  p <- p + ylab("") 
  p <- p + theme(axis.text.x = element_text( hjust = -3))
  p
     
}
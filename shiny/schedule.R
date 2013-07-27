library("ggplot2")
accent = (read.csv("~/src/accent/shiny/solution.csv", sep=";"))

schedule <- function (df,
                      lead, 
                      subject, 
                      reverse = FALSE,
                      label.col = names(df)[1] , 
                      leads = names(df)[1] , 
                      subjects = names(df)[2]){
  
  if(!missing(lead)) {
    lead = df
  }

  df$dayf<-factor(df$day,levels=rev(1:7),labels=rev(c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")),ordered=TRUE)
  df$timef<-factor(df$day,levels=rev(1:5),labels=rev(c("8h","10h","13h","15h","17h")),ordered=TRUE)

  p<- ggplot(df, aes(dayf, timef, fill = patients)) + 
    geom_tile(colour = "white") + facet_grid(therapists~.) + labs(title = "Staff schedule") +  xlab("Day of week") + ylab("")
  
  if(reverse == TRUE) {
    p<- ggplot(df, aes(dayf, timef, fill = therapists)) + 
      geom_tile(colour = "white") + facet_grid(patients~.) + labs(title = "Staff schedule") +  xlab("Day of week") + ylab("")
    
  }
  return(p)
}


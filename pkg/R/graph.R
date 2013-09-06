#' @title build a solution for the specified model  
#' 
#' @description desc
#' 
#' @param solution AccentModelSolution
#' @param subset char[] with one or more patients/therapists for which the schedule needs to be generated
#' @param type schedule type one of "patient" or "therapist"
#' @export 
#' @return  plot with the patient schedule 
#' @example
#' input <- randomAccentModelInput()
#' solution <- optimizeAccentModel(input=input)
#' drawSchedule(solution, type="patient")
#' drawSchedule(solution, type="therapist")
#' 
drawSchedule <- function(solution, subset=NULL, type="patient"){

  if("AccentModelSolution" %in% class(solution) == FALSE){
    Log$info("solution is not of type AccentModelSolution.")
    return(NA)
  }

  scheduleTypes <- c("patient", "therapist")
  if((type %in% scheduleTypes) == FALSE){
    Log$info(sprintf("solution type is not in scheduleTypes: %s", paste0(scheduleTypes)))
    return(NA)
  }
  
  # prepare all data needed for plotting the schedules
  plot.data <- list()
  plot.data$df <- solution$data
  plot.data$blocklength <- 1
  
  if(type=="patient"){
    plot.data$facet <- "patient"
    plot.data$fill <- "therapist"
    plot.data$title <- "Patient Schedule"

    if(is.null(subset) == FALSE){
      plot.data$df <- subset(plot.data$df, patient %in% c(subset))
    }
  }

  if(type=="therapist"){
    plot.data$facet <- "therapist"
    plot.data$fill <- "patient"
    plot.data$title <- "Therapist Schedule"
    
    if(is.null(subset) == FALSE){
      plot.data$df <- subset(plot.data$df, therapist %in% c(subset))
    }
  }

  
  plot.data$df <- with(data=plot.data, {
    df$day.end = df$day+1
    df$time.end = df$time+1
    
    df$dayf<-factor(df[,day],
      levels=1:7,
      labels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"),
      ordered=TRUE)
    
    df$timef<-factor(plot.data$df[,time],
      levels=rev(1:5),
      labels=rev(c("8h","10h","13h","15h","17h")),
      ordered=TRUE)
    df  
  })
  
  
  p <-  ggplot(plot.data$df, aes_string(x = "dayf",
                       y = "timef",
                       fill = plot.data$fill,
                       xmin = "day",
                       xmax = "day.end",
                       ymin = "time",
                       ymax = "time.end"))
  
  p <- p + geom_rect(colour = "white") 
  p <- p + labs(title = plot.data$title) 
  p <- p + xlab("Day of week") 
  p <- p + ylab("") 
  p <- p + theme(axis.text.x = element_text( hjust = -3)) 
  p <- p + facet_grid(as.formula(sprintf('%s~.', plot.data$facet)))
  p <- p + xlab("Day of week") 
  p <- p + ylab("") 
  p <- p + theme(axis.text.x = element_text( hjust = -3))
  p
     
}
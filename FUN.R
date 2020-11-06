################# Setting the parameters for the study 

set_parameters <- function(geo = "IR",
                           time = "now 4-H",
                           tz = 0,
                           index = "یا",
                           top = TRUE,
                           rising = TRUE,
                           overwrite = TRUE){
  para <<- list(geo = geo,
                time = time,
                tz = tz,
                index = index,
                top = top, 
                rising = rising,
                overwrite = overwrite)
}

################ setting arguments for gtrends function

get_queries <- function (keywords, parameters = para) { 
        trends <- gtrends(keywords, 
                          geo = para$geo,
                          time = para$time,
                          tz= para$tz)$related_queries
}



check_trends <- function (keywords, parameters = para) { 

        
        trends <- gtrends(keywords, 
                          geo = para$geo,
                          time = para$time,
                          tz = para$tz,
                          onlyInterest = TRUE)$interest_over_time
}


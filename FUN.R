## Version 2.2

################# Setting the parameters for the study 

set_parameters <- function(geo = "IR",
                           time = "now 4-H",
                           tz = 0L,
                           index = "یا",
                           top = TRUE,
                           rising = TRUE,
                           overwrite = TRUE,
                           cores =4L ){
  para <<- list(geo = geo,
                time = time,
                tz = tz,
                index = index,
                top = top, 
                rising = rising,
                overwrite = overwrite,
                cores = cores)
}

################ setting arguments for gtrends function


try_queries <- function (keywords, parameters = para) { 
  queries <- tryCatch(gtrends(keywords, 
                              geo = para$geo,
                              time = para$time,
                              tz= para$tz)$related_queries , 
                      error = function(e) e)
  if (inherits(queries, "error")) Sys.sleep(30) else return(queries)
}



try_trends <- function (keywords, parameters = para) { 
  trends <- tryCatch(gtrends(keywords, 
                             geo = para$geo,
                             time = para$time,
                             tz = para$tz,
                             onlyInterest = TRUE)$interest_over_time %>%
                       within( {
                         hits[hits == "<1"] <- sample(0:1, 1)
                         hits <- as.integer(hits)
                       }), error = function(e) e)
  if (inherits(trends, "error")) Sys.sleep(30) else return(trends)
}
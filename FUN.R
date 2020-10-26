
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
                          onlyInterest = TRUE)$interest_over_time %>%
                within( {
                        hits[hits == "<1"] <- sample(0:1, 1)
                        hits <- as.integer(hits)
        })
}

get_queries <- function (keywords, parameters = para) { 
        
        trends <- gtrends(keywords, 
                          geo = para$geo,
                          time = para$time,
                          tz= para$tz) %>% .$related_queries
}



check_trends <- function (keywords, parameters = para) { 

        
        trends <- gtrends(keywords, 
                          geo = para$geo,
                          time = para$time,
                          tz = para$tz,
                          onlyInterest = TRUE ) 
        trends$interest_over_time$hits[trends$interest_over_time$hits == "<1"] <- 
                                                                        sample(0:1, 1)
        trends$interest_over_time$hits <- as.integer(trends$interest_over_time$hits)
        trends %>% .$interest_over_time
}

get_queries <- function (keywords, parameters = para) { 
        
        trends <- gtrends(keywords, 
                          geo = para$geo,
                          time = para$time,
                          tz= para$tz) 
        Sys.sleep(sample(0:2, 1))
        trends %>% .$related_queries
}



check_trends <- function (keywords, parameters = para) { 

        
        trends <- gtrends(keywords, 
                          geo = para$geo,
                          time = para$time,
                          tz = para$tz,
                          onlyInterest = TRUE ) 
        trends$interest_over_time$hits[trends$interest_over_time$hits == "<1"] <- 0.5
        trends$interest_over_time$hits <- as.numeric(trends$interest_over_time$hits)
        trends %>% .$interest_over_time
}
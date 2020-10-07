
get_queries <- function (keywords, parameters = para) { 
        
        trends <- gtrends(keywords, 
                          gprop = "web",
                          geo = para$geo,
                          time = para$time,) 
        Sys.sleep(2)
        results <- trends$related_queries
}



check_trends <- function (keywords, parameters = para) { 

        
        trends <- gtrends(keywords, 
                          gprop = "web",
                          geo = para$geo,
                          time = para$time,
                          onlyInterest = TRUE ) 
        
        trends$interest_over_time$hits <- as.integer(trends$interest_over_time$hits)
        results <- trends$interest_over_time
}
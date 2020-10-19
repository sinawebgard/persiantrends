########### work in progress
################ getting related queries for a term (or set of up to 5 terms) over time



queries_over_time <- function(week, geo = "IR", keyword = keyword, date = date){
  
  start_date <- date - week * 7
  end_date <- start_date + 7
  time <- paste(start_date, end_date, sep = " ")
  trends <- gtrends(keyword = keyword, geo = "IR", time = time)
  results <- trends$related_queries
  results$time <- time
  results
}

queries.df.historical <- map_dfr(.x = 1:weeks, .f= queries_over_time, keyword = "شجریان",
                                 date = Sys.Date() - 1)
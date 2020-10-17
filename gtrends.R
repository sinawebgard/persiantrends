library(gtrendsR) 
library(dplyr)
library(purrr)
library(stringr)
library(e1071)
source("FUN.R")

if(exists("keywords")){
        keyterms <- keywords
}       else{
        keyterms <- readLines("Data/keywords.csv")
}
if(file.exists("Data/unwanted.csv")) 
        unwanted.queries <- readLines("Data/unwanted.csv")

########################### Setting the parameters#########
para <- list(geo =  "IR", 
             time = "now 4-H",
             tz = -60)

index <- "سایت"         # up to 4 keywords as  benchmarks for trends
scale <- as.character()         #selecting 'rising' and/or 'top' trends
        scale[1] <- "rising"
        scale[2] <- "top"

################# Getting Queries ########################
### getting related queries for all the terms 
        ########in the "keywords" character vector


readline("Press any key to get queries related to your keywords")

keyterms <- split(keyterms, 1: ceiling(length(keyterms) / 5))        
        queries.df <- map_dfr(.x = keyterms, .f = get_queries )
        
        queries.df %>% filter(related_queries %in% scale) %>% .$value %>% 
                unique() %>% setdiff(unwanted.queries) -> queries
        
        
##################### Checking Trends ####################
############ Get relative popularity for calculated queries

readline("Press any key to continue -- it may take few minutes")

group_length <- 5- length(index)
queries <- split(queries, 1: ceiling(length(queries) / group_length))
        
        trending_over_time <- vector()
                for (i in 1:length(queries)) {
                        trending_over_time <- c(index, queries[[i]]) %>% 
                                check_trends() %>% 
                        rbind(trending_over_time)
####### slowing down the iteration 
        sleep_time <- ifelse(i %% 50 == 0, 
                             sample(10:15, 1), 
                             sample(0:2, 1))
        Sys.sleep(sleep_time)
}
trending_over_time <- filter(trending_over_time, !keyword %in% index)
trending_over_time %>% group_by(keyword) %>% 
                        summarise(average = mean(hits, na.rm = TRUE), 
                                median = median(hits, na.rm = TRUE),
                                variance = sd(hits, na.rm = TRUE)^2,
                                skewness = skewness(hits, na.rm = TRUE)) -> 
                                                                trending_topics


################## Exporting Output Data ########################
############## save the data in time-coded csv files and sub-directories

readline("Press any key to create the output files")

if(!dir.exists(paste0("Data/", Sys.Date()))) dir.create(paste0("Data/", Sys.Date()))

gtrends.info <- str_split(para$time, " ") %>% unlist %>% 
        paste(collapse = "_") %>% paste(para$geo, sep = "_")
time.info <- format(Sys.time(), "%d-%b-%Y_%H-%M")

filename.queries <- paste0("Data/", Sys.Date(), "/", time.info, "_", 
                           gtrends.info, "_queries.csv")
filename.data <- paste0("Data/", Sys.Date(), "/", time.info, "_", 
                        gtrends.info, "_data.csv")
filename.trends <- paste0("Data/", Sys.Date(), "/", time.info, "_", 
                          gtrends.info, "_trends.csv")


write.csv(queries.df, filename.queries, fileEncoding = "UTF-8", 
          quote = FALSE, row.names = FALSE)
write.csv(trending_over_time, filename.data, fileEncoding = "UTF-8", 
          quote = FALSE, row.names = FALSE)
write.csv(trending_topics, filename.trends, fileEncoding = "UTF-8", 
          quote = FALSE, row.names = FALSE)
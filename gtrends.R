library(gtrendsR) 
library(dplyr)
library(foreach)
library(doParallel)
library(stringr)
library(e1071)
source("FUN.R")

registerDoParallel(cores = para$cores)

######## Reading Input files #########################

reset_para <- readline("Reset parameters to default values? (y/n) ")
        
if(reset_para == "y" | reset_para == "Y" | !exists("para")) set_parameters()

scale <- vector(mode = "character")
if(para$top) scale <- c(scale, "top")
if(para$rising) scale <- c(scale, "rising")

if(para$overwrite | !exists("keywords")) keywords <- 
        readLines("Data/keywords.csv")
if(para$overwrite & file.exists("Data/unwanted.csv")) unwanted_queries <- 
        readLines("Data/unwanted.csv")
                if(!exists("unwanted_queries")) unwanted.queries <- vector()

        keywords <- paste(keywords, "-آهنگ -سریال -دانلود")

################# Getting Queries ########################
### getting related queries for all the keyterms

        queries.df <- foreach(i = 1:length(keywords), .combine = rbind) %dopar% {
                        get_queries(keywords[[i]])
}
        
        queries.df %>% filter(related_queries %in% scale) %>% .$value %>% 
                unique() %>% setdiff(y = unwanted_queries) -> queries
        
#################### Removing custom unwanted queries ###########
        
        view_queries <- readline("Press y/Y t view queries ")
        if(view_queries == "y" | view_queries == "Y") View(queries)
        
        max_length <- as.integer(readline("maximum length for queries "))
        word_length <- sapply(str_split(queries, " "), length)
        queries <- queries[word_length <= max_length]
        
        repeat{
                omit <- readline("Enter the term you want to remove? ")
                if(omit == "") break
                drop_query <- which(str_detect(queries, omit))
                        if(any(drop_query)) queries <- queries[-drop_query]
        }
        
        
##################### Checking relative hits of queries ####################

### queries can be split to groups of maximum four plus the index term
        ### larger groups are more likely to fail to return status code = 200
        
group_length <- 5 - length(para$index)
suppressWarnings(
        queries <- split(queries, 1: ceiling(length(queries) / group_length))
)

        trending_over_time <- foreach(i = 1:length(queries), 
                                      .combine = rbind) %dopar% {
                        sleep_time <- ifelse(i %% 25 == 0, 
                                           sample(11:20, 1), 
                                           sample(0:2, 1))
                        Sys.sleep(sleep_time) ## slowing down the iteration 
                c(para$index, queries[[i]]) %>% check_trends() 
                        } %>% filter(!keyword %in% para$index)
                        
        trending_topics <- trending_over_time %>% group_by(keyword) %>% 
                                summarise(average = mean(hits, na.rm = TRUE), 
                                        median = median(hits, na.rm = TRUE),
                                        variance = sd(hits, na.rm = TRUE)^2,
                                        skewness = skewness(hits, na.rm = TRUE),
                                        max = max(hits, na.rm = TRUE))


################## Exporting Output Data ########################
############## save the data in time-coded csv files and sub-directories

        
readline("Press any key to create the output files")

if(!dir.exists(paste0("Data/", Sys.Date()))) dir.create(paste0("Data/", Sys.Date()))

gtrends.info <- str_split(para$time, " ") %>% unlist %>% 
        paste(collapse = "_") %>% paste(para$geo, sep = "_")
time.info <- format(Sys.time(), "%d-%b-%Y_%H-%M")

filename.queries <- paste0("Data/", Sys.Date(), "/", time.info, 
                           "_", gtrends.info, "_queries.csv")
filename.data <- paste0("Data/", Sys.Date(), "/", time.info, 
                        "_", gtrends.info, "_data.csv")
filename.trends <- paste0("Data/", Sys.Date(), "/", time.info, 
                          "_", gtrends.info, "_trends.csv")


write.csv(queries.df, filename.queries, fileEncoding = "UTF-8", 
          quote = FALSE, row.names = FALSE)
write.csv(trending_over_time, filename.data, fileEncoding = "UTF-8", 
          quote = FALSE, row.names = FALSE)
write.csv(trending_topics, filename.trends, fileEncoding = "UTF-8", 
          quote = FALSE, row.names = FALSE)
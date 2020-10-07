library(gtrendsR) 
library(dplyr)
library(purrr)
library(stringr)
source("FUN.R")

if(exists("keywords")){
        keyterms <- keywords
}       else{
        keyterms <- readLines("Data/keywords.csv")
}
if(file.exists("Data/unwanted.csv")) 
        unwanted.queries <- readLines("Data/unwanted.csv")

# Setting the parameters
para <- list(geo =  "IR", 
             time = "now 4-H")

index <- "آهنگ"
        scale <- as.character()
scale[1] <- "rising"
scale[2] <- "top"

################# Getting Queries ########################
### getting related queries for all the terms 
        ########in the "keywords" character vector


readline("Press any key to get queries related to your keywords")

        
        queries.df <- map_dfr(.x = keyterms, .f = get_queries )
        
        queries.df %>% filter(related_queries %in% scale) %>% pull(value) %>% 
                unique() %>% setdiff(unwanted.queries) -> queries
        
        
##################### Checking Trends ####################
############ Get relative popularity for calculated queries

readline("Press any key to continue -- it may take few minutes")
        
        trending_over_time <- vector()
                for (i in 1:length(queries)) {
                        trending_over_time <- c(index, queries[i]) %>% 
                                map_dfr(.f = check_trends ) %>% 
                        rbind(trending_over_time)
                        Sys.sleep(2)
                if(round(i/50) == i/50) readline("Press any key to continue")
                }
trending_over_time <- filter(trending_over_time, !keyword %in% index)
trending_over_time %>% group_by(keyword) %>% 
                        summarise(average = mean(hits)) %>%
                                arrange(desc(average)) -> trending_topics


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
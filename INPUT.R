############ Defining Input variables#####################


  keyterms <-
    readLines("Data/keywords.csv")

########## add search operators to keywords and filter unwanted queries#######

keyterms <- paste(keyterms,
                  " -آهنگ -دانلود -سریال")

if (!exists("filter_terms")) filter_terms <- TRUE
if (file.exists("Data/unwanted.csv") &
    filter_terms) unwanted.queries <- readLines("Data/unwanted.csv") else
  unwanted.queries <- vector()

########################### Setting the parameters#########
para <- list(geo =  "IR",
             time = "now 1-H",
             tz = 0)

index <-  c("یا")         # up to 4 keywords as  benchmarks for trends
scale <-
  as.character()         #selecting 'rising' and/or 'top' trends
scale[1] <- "rising"
scale[2] <- "top"
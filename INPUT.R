############ Defining Input variables#####################

if (exists("keywords")) {
  keyterms <- keywords
}       else{
  keyterms <-
    readLines("/home/sina/Projects/persiantrends/Data/keywords.csv")
}
if (!exists("filter_terms")) filter_terms <- TRUE
if (file.exists("/home/sina/Projects/persiantrends/Data/unwanted.csv") &
    filter_terms)
  unwanted.queries <- readLines("/home/sina/Projects/persiantrends/Data/unwanted.csv") else
  unwanted.queries <- vector()

########################### Setting the parameters#########
para <- list(geo =  "IR",
             time = "now 4-H",
             tz = -60)

index <-  "سایت"         # up to 4 keywords as  benchmarks for trends
scale <-
  as.character()         #selecting 'rising' and/or 'top' trends
scale[1] <- "rising"
scale[2] <- "top"
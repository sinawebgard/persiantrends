# Persian Trends via Google Trends

### A project to get the related queries of a set of keywords and check the Google hits of the queries based on their relative popularity

## Latest version

*V2.2*

* Error handling with TryCatch: re-running through iterations if some of the queries return error codes.

*V2.1*

* Using parallel computing in R to process large lists of keywords and queries. The serial version is available as v1.1

*V1.1*

* Splitting keywords, as well as returned queries, into lists of up to five key terms so they can be sent to Google API at the same time


## Codes and Scripts

**FUN.R** contains the functions for downloading Google Trends data, as wrappers for gtrends() function in the package 'gtrendsR', and setting default or custom parameters for the study.

* try_queries() take your key search term and get their related queries for the specified time-frame and geographical parameters. Returens NULL and pause for 5 seconds if encounters an error.

* try_trends() gets a character vector of search terms as its input and check the terms against eachother, returning the interest_over_time as a data frame and ensuring that the 'hits' variable in the data frame will always be an integer vector. Returns NULL and pause for 5 seconds if encounters an error.

* set_parameters() sets parameters for the study:
     * geo (character) country code or sub-code. See 'countries' in gtrendsR package. Default value is "IR".
     * time (character) the time argument for gtrends wrapper functions. Look at ?gtrends for format. Default value is "now 1-4" to look at past four hours.
     * tz (integer) time-zone. A number specifying the minutes the returned dates whould be offset to UTC. Default value is 0.
     * index (character) a vector of up to four benchmark keywords to be compared with queries in order to calculate their relative hits. Default should be keyword with a relatively stable and high search popularity.
     * top (logical) whether top related queries should be included. Default value is TRUE
     rising (logical) whether 'rising' related queries should be included. Default value is TRUE.
     * overwrite (logical) if 'keywords' and/or 'unwated_queries' already exist in the Global Environment, whether these vectors should be overwritten by the values of the input files. Default value is TRUE.
     * cores (integer) number of cores for parallel computing. The default value is 4.

**gtrends.R** the main script, using the functions defined in 'FUN.R' to take a series of key search terms, getting a list of their related queries ('top' queries and/or 'rising), removing irrelevant and unwanted queries before checking each entry against a fixed benchmark (index) to assess its relative popularity within the specified time-frame and geographical parameters. The output of the script will automatically be stored in time-coded csv files in the Data folder.

## Data

All data files are stored in Data directory and its time-coded sub-directories.

### Output Files and Variables

Time-coded sub-directories, containing daily output files, are created automatically.

All filenames contain the follwoing info:

[Date and time of creation]_[Timeframe of Google Trends Search, i.e. 'now 1-d' or 'today 7-d']_[Geographical teritory, ie 'IR' or 'US' or blank for Worldwide]_[the content of the file]

**trends.csv** storing 'trending_topics' data frame. The data frame has two variables:

* keyword: (character) the search query

* average: (numeric) the mean of the related search volume of the query

* median: (numeric)

* variance (numeric)

* skewness (numeric)

* max (integer)

**data.csv** storing 'trending_over_time' data frame. The data frame has 7 variables:

* date: (POSIXct) date/time of the observation

* keyword: (character) entries from 'queries' variable

* hits: (integer) relative search volume of the observation

* time: (character) the specified time-frame of queries; the pre-defined values for the time argument in gtrands() function

* geo: (character) the geographical parameter of the queries; the pre-defined value for the geo argument in gtrands() function

* category: (character) get details with data("categories") from gtrendsR package

**queries.csv** storing 'queries.df' data frame.

* Subject: (character) related correlation between the query ('value') and the keyword

* related_queries: (character) taking two values: 'top' or 'rising'

* value: (character) the related query

* geo: (character) the geographical parameter of the observaton

* keyword: (character) the keyword for which related queries are obtained

### Input Files and variables

**keywwords.csv** contains a series of search terms. Will be used by the main script if $overwrite argument in set_parameters is TRUE (default) or if the object 'keywords' does not exist in the Global Environment.

**unwanted.csv** contains a series of phrases which are redundant or irrelevant to the study, including generic terms, terms with relatively fixed popularity in search, and terms which are irrelevant to the aim of the study but may come up as queries related to your key search terms. Wil be used by the main script if $overwrite argument in set_parameters is TRUE (default). 
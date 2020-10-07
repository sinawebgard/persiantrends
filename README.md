# Persian Trends via Google Trends

### A project to check the related queries of a set of keywords and sort the queries based on their relative popularity


## Codes and Scripts

**FUN.R** contains the functions for downloading Google Trends data. The functions are wrappers for gtrends() from gtrendsR package.

* get_queries() take your key search term and get their related queries in the specified time-frame and geographical parameters.

* check_trends() gets a character vector of search terms as its input and check the terms against eachother, returning the interest_over_time as a data frame and ensuring that the 'hits' variable in the data frame will always be an integer vector.



**gtrends.R** the main script, using the functions defined in 'FUN.R' to take a series of key search terms, getting a list of their related queries ('top' queries and/or 'rising), removing irrelavant queries before checking each entry against a fixed index to assess its relative popularity within the specified time-frame and geographical parameters. The output of the script will automatically be stored in time-coded csv files in the Data folder.

## Data

All data files are stored in Data directory and its time-coded sub-directories.

### Output Files and Variables

Time-coded sub-directories, containing daily output files, are created automatically.

All filenames contain the follwoing info:

[Date and time of creation]_[Timeframe of Google Trends Search, i.e. 'now 1-d' or 'today 7-d']_[Geographical teritory, ie 'IR' or 'US' or blank for Worldwide]_[the content of the file]

**trends.csv** storing 'trending_topics' data frame. The data frame has two variables:

* keyword: (character) the search query

* average: (integer) the mean of the related search volume of the query

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

**keywwords.csv** contains a series of search terms.

**unwanted.csv** contains a series of phrases which are redundant or irrelevant to the study, including generic terms, terms with relatively fixed popularity in search, and terms which are irrelevant to the aim of the study but may come up as queries related to your key search terms.

**Other Input Variables**

**keywords** : (character) a vector of search key terms that can be assigned in the interactive console. If exists will override the content of the 'keywords.csv'

**para**: (list) geographical and coronological parameters to be used as arguments for gtrends queries.

+ $geo (character) geographical parameter, i.e. "IR" or "US" or "" (blank) for Worldwide

+ $time (character) coronological parameter, i.e. "now 1-d", "now 1-H", or "today 7-d"

**index**: (character) a vector of 1 to 4 search terms to check the relative search of our input (keyterms) against them. Should be generic terms with relatively high but stable search volume.

**scale**: (character) a vector defining with related_queries to be kept. Can take either or both of these values: 'rising' and 'top'







#' ---
#' title: Quick Taste of Text Mining
#' author: "Mark Blackmore"
#' date: "`r format(Sys.Date())`"
#' output: github_document
#' ---
#'
#' ### Quick Overview  

# Load qdap
suppressWarnings(
  suppressPackageStartupMessages(
    library(qdap)
  )
)

new_text <- "DataCamp is the first online learning platform that focuses on building the best learning experience specifically for Data Science. We have offices in Boston and Belgium and to date, we trained over 250,000 (aspiring) data scientists in over 150 countries. These data science enthusiasts completed more than 9 million exercises. You can take free beginner courses, or subscribe for $25/month to get access to all premium courses."

# Print new_text to the console
print(new_text)

# Find the 10 most frequent terms: term_count
term_count <- freq_terms(new_text, 10)

# Plot term_count
plot(term_count)

#' ### Load Some Text  

# Import text data
tweets <- read.csv("./data/coffee.csv", stringsAsFactors = FALSE)

# View the structure of tweets
str(tweets)

# Print out the number of rows in tweets
nrow(tweets)

# Isolate text from tweets: coffee_tweets
coffee_tweets <- tweets$text

#' ### Make the Vector a VCrorpus Object (1)  

# Load tm
suppressWarnings(
  suppressPackageStartupMessages(
    library(tm)
    )
)

# Make a vector source: coffee_source
coffee_source <- VectorSource(coffee_tweets)

#' ### Make the Vector a VCrorpus Object (2)  

# Make a volatile corpus: coffee_corpus
coffee_corpus <- VCorpus(coffee_source)

# Print out coffee_corpus
coffee_corpus

# Print data on the 15th tweet in coffee_corpus
coffee_corpus[[15]]

# Print the content of the 15th tweet in coffee_corpus
coffee_corpus[[15]]$content

#' ### Make A VCorpus from a Data frame  



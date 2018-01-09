#' ---
#' title: More Word Visuals
#' author: "Mark Blackmore"
#' date: "`r format(Sys.Date())`"
#' output: 
#'   github_document:
#'     toc: true
#'     
#' ---
#'

# Load Packages
suppressWarnings(
  suppressPackageStartupMessages({
    library(qdap)
    library(tm)
    library(wordcloud)
  })
)

#' ### Find Common Words

# Load Data
coffee_tweets <- read.csv("./data/coffee.csv", stringsAsFactors = FALSE)
chardonnay_tweets <- read.csv("./data/coffee.csv", stringsAsFactors = FALSE)

# Create all_coffee
all_coffee <- paste(coffee_tweets$text, collapse = " ")

# Create all_chardonnay
all_chardonnay <- paste(chardonnay_tweets$text, collapse = " ")

# Create all_tweets
all_tweets <- c(all_coffee, all_chardonnay)

# Convert to a vector source
all_tweets <- VectorSource(all_tweets)

# Create all_corpus
all_corpus <- VCorpus(all_tweets)

#' ### Visualize Common Words

# Cleaning Function
clean_corpus <- function(corpus){
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, c(stopwords("en"), "amp", "glass", "chardonnay", "coffee"))
  return(corpus)
}

# Clean the corpus
all_clean <- clean_corpus(all_corpus)

# Create all_tdm
all_tdm <- TermDocumentMatrix(all_clean)

# Create all_m
all_m <- as.matrix(all_tdm)

# Print a commonality cloud
commonality.cloud(all_m, max.words = 100, colors = "steelblue1")

#' ### Visualize Dissimilar Words

# Clean the corpus
all_clean <- clean_corpus(all_corpus)

# Create all_tdm
all_tdm <- TermDocumentMatrix(all_clean)

# Give the columns distinct names
colnames(all_tdm) <- c("coffee", "chardonnay")

# Create all_m
all_m <- as.matrix(all_tdm)

# Create comparison cloud - runs on DataCamp, but not here
## comparison.cloud(all_m, colors = c("orange", "blue"), max.words = 0)

#' Here, DataCamp changes the all_corpus or clean_corpus function. 
#' The variables all_tdm, and hecnce all_m are not the same on DataCamp as those here.
#' This script creates all_tdm:
#'
#' `<<TermDocumentMatrix (terms: 3036, documents: 2)>>  
#'  Non-/sparse entries: 6072/0  
#' Sparsity           : 0%  
#' Maximal term length: 27  
#' Weighting          : term frequency (tf)`
#'  
#' DataCamp's version:  
#' `<<TermDocumentMatrix (terms: 5337, documents: 2)>>  
#'  Non-/sparse entries: 6016/4658  
#' Sparsity           : 44%  
#' Maximal term length: 179  
#' Weighting          : term frequency (tf)`
#'
#' ### Word Association
word_associate(coffee_tweets$text, match.string = c("barista"), 
               stopwords = c(Top200Words, "coffee", "amp"), 
               network.plot = TRUE, cloud.colors = c("gray85", "darkred"))

# Add title
title(main = "Barista Coffee Tweet Associations")

#' -------------
#'  
#' ## Session info
#+ show-sessionInfo
sessionInfo()   
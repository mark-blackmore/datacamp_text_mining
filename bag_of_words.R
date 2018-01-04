#' ---
#' title: Quick Taste of Text Mining
#' author: "Mark Blackmore"
#' date: "`r format(Sys.Date())`"
#' output: 
#'   github_document:
#'     toc: true
#'     
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

#' ### Common Cleaning Functions from `tm`

# Create the object: text
text <- "<b>She</b> woke up at       6 A.M. It\'s so early!  She was only 10% awake and began drinking coffee in front of her computer."

# All lowercase
tolower(text)

# Remove punctuation
removePunctuation(text)

# Remove numbers
removeNumbers(text)

# Remove whitespace
stripWhitespace(text)

#' ### Cleaning with `qdap`

## text is still loaded in your workspace

# Remove text within brackets
bracketX(text)

# Replace numbers with words
replace_number(text)

# Replace abbreviations
replace_abbreviation(text)

# Replace contractions
replace_contraction(text)

# Replace symbols with words
replace_symbol(text)

#' ### All About Stopwords  

# List standard English stop words
stopwords("en")

# Print text without standard stop words
removeWords(text, stopwords("en"))

# Add "coffee" and "bean" to the list: new_stops
new_stops <- c("coffee", "bean", stopwords("en"))

# Remove stop words from text
removeWords(text, new_stops) 

#' ### Intro to Word Stemming and Stem Completion  

# Create complicate
complicate <-  c("complicated", "complication", "complicatedly")

# Perform word stemming: stem_doc
stem_doc <- stemDocument(complicate)

# Create the completion dictionary: comp_dict
comp_dict <- c("complicate")

# Perform stem completion: complete_text 
complete_text <- stemCompletion(stem_doc, comp_dict)

# Print complete_text
complete_text

#' ### Word Stemming and Stem Completion on a Sentence  

text_data <- "In a complicated haste, Tom rushed to fix a new complication, too complicatedly."

# Remove punctuation: rm_punc
rm_punc <- removePunctuation(text_data)

# Create character vector: n_char_vec
n_char_vec <- unlist(strsplit(rm_punc, split = ' '))

# Perform word stemming: stem_doc
stem_doc <- stemDocument(n_char_vec)

# Print stem_doc
stem_doc

# Re-complete stemmed document: complete_doc
complete_doc <- stemCompletion(stem_doc, comp_dict)

# Print complete_doc
complete_doc

#' ### Apply Preprocessing Steps to a Corpus  
 

# Alter the function code to match the instructions
clean_corpus <- function(corpus){
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, c(stopwords("en"), "coffee", "mug"))
  corpus <- tm_map(corpus, stripWhitespace)
  return(corpus)
}

# Apply your customized function to the tweet_corp: clean_corp
clean_corp <- clean_corpus(coffee_corpus)

# Print out a cleaned up tweet
clean_corp[[227]][1]

# Print out the same tweet in original form
tweets$text[227]

#' ### Make a Document-term Matrix  

# Create the dtm from the corpus: coffee_dtm
coffee_dtm <- DocumentTermMatrix(clean_corp)

# Print out coffee_dtm data
coffee_dtm

# Convert coffee_dtm to a matrix: coffee_m
coffee_m <- as.matrix(coffee_dtm)

# Print the dimensions of coffee_m
dim(coffee_m)

# Review a portion of the matrix
coffee_m[148:150, 2587:2590]

#' ### Make a Term-document Matrix  

# Create a TDM from clean_corp: coffee_tdm
coffee_tdm <- TermDocumentMatrix(clean_corp)

# Print coffee_tdm data
coffee_tdm

# Convert coffee_tdm to a matrix: coffee_m
coffee_m <- as.matrix(coffee_tdm)

# Print the dimensions of the matrix
dim(coffee_m)

# Review a portion of the matrix
coffee_m[2587:2590, 148:150]

saveRDS(coffee_m, "coffee_m.RDS")
saveRDS(tweets$text, "tweets_text.RDS")

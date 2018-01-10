#' ---
#' title: Battle of the tech giants for talent
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
    library(dendextend)
    library(tidyverse)
    library(RWeka)
  })
)

#' ### Identifying the text sources

amzn <- read.csv("./data/500_amzn.csv", stringsAsFactors = FALSE)
goog <- read.csv("./data/500_goog.csv", stringsAsFactors = FALSE)

# Print the structure of amzn
str(amzn)

# Create amzn_pros
amzn_pros <- amzn$pros

# Create amzn_cons
amzn_cons <- amzn$cons

# Print the structure of goog
str(goog)

# Create goog_pros
goog_pros <- goog$pros

# Create goog_cons
goog_cons <- goog$cons

#' ### Text organization

qdap_clean <- function(x){
  x <- replace_abbreviation(x)
  x <- replace_contraction(x)
  x <- replace_number(x)
  x <- replace_ordinal(x)
  x <- replace_ordinal(x)
  x <- replace_symbol(x)
  x <- tolower(x)
  return(x)
}
tm_clean <- function(corpus){
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removeWords, 
                   c(stopwords("en"), "Google", "Amazon", "company"))
  return(corpus)
}

# Alter amzn_pros
amzn_pros <- qdap_clean(amzn_pros)

# Alter amzn_cons
amzn_cons <- qdap_clean(amzn_cons)

# Create az_p_corp
#' Need to add a line to address NA's
amzn_pros[which(is.na(amzn_pros))] <- "NULLVALUEENTERED"
az_p_corp <- VCorpus(VectorSource(amzn_pros))

# Create az_c_corp
#' Need to add a line to address NA's
amzn_cons[which(is.na(amzn_cons))] <- "NULLVALUEENTERED"
az_c_corp <- VCorpus(VectorSource(amzn_cons))

# Create amzn_pros_corp
amzn_pros_corp <- tm_clean(az_p_corp)

# Create amzn_cons_corp
amzn_cons_corp <- tm_clean(az_c_corp)  

#' ### Working with Google reviews

# Apply qdap_clean to goog_pros
goog_pros <- qdap_clean(goog_pros)

# Apply qdap_clean to goog_cons
goog_cons <- qdap_clean(goog_cons)

# Create goog_p_corp
#' Need to add a line to address NA's
goog_pros[which(is.na(goog_pros))] <- "NULLVALUEENTERED"
goog_p_corp <- VCorpus(VectorSource(goog_pros))

# Create goog_c_corp
#' Need to add a line to address NA's
goog_cons[which(is.na(goog_cons))] <- "NULLVALUEENTERED"
goog_c_corp <- VCorpus(VectorSource(goog_cons))

# Create goog_pros_corp
goog_pros_corp <- tm_clean(goog_p_corp)

# Create goog_cons_corp
goog_cons_corp <- tm_clean(goog_c_corp)

#' ### Feature extraction & analysis: amzn_pros

tokenizer <- function(x) 
  NGramTokenizer(x, Weka_control(min = 2, max = 2))

# Create amzn_p_tdm
amzn_p_tdm <- TermDocumentMatrix(amzn_pros_corp, control = list(tokenize = tokenizer))

# Create amzn_p_tdm_m
amzn_p_tdm_m <- as.matrix(amzn_p_tdm)

# Create amzn_p_freq
amzn_p_freq <- rowSums(amzn_p_tdm_m)

# Plot a wordcloud using amzn_p_freq values
wordcloud(names(amzn_p_freq), amzn_p_freq, max.words = 20, color = "blue")








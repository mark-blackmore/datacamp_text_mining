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
    library(plotrix)
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

#' ### Feature extraction & analysis: amzn_cons

# Create amzn_c_tdm
amzn_c_tdm <- TermDocumentMatrix(amzn_cons_corp, control = list(tokenize = tokenizer))

# Create amzn_c_tdm_m
amzn_c_tdm_m <- as.matrix(amzn_c_tdm)

# Create amzn_c_freq
amzn_c_freq <- rowSums(amzn_c_tdm_m)

# Plot a wordcloud using amzn_c_freq values
wordcloud(names(amzn_c_freq), amzn_c_freq, max.words = 20, color = "blue")

#' ### amzn_cons dendrogram

# Print amzn_c_tdm to the console
amzn_c_tdm

# Create amzn_c_tdm2 by removing sparse terms 
amzn_c_tdm2 <- removeSparseTerms(amzn_c_tdm, sparse = 0.993)
amzn_c_tdm2

# Create hc as a cluster of distance values
hc <- hclust(dist(amzn_c_tdm2, method = "euclidean"), method = "complete")

# Produce a plot of hc
plot(hc)

#' ### Word association  

# Create amzn_p_tdm
amzn_p_tdm <- TermDocumentMatrix(amzn_pros_corp, control = list(tokenize = tokenizer))

# Create amzn_p_m
amzn_p_m <- as.matrix(amzn_p_tdm)

# Create amzn_p_freq
amzn_p_freq <- rowSums(amzn_p_m)

# Create term_frequency
term_frequency <- sort(amzn_p_freq, decreasing = TRUE)

# Print the 5 most common terms
term_frequency[1:5]

# Find associations with fast paced
findAssocs(amzn_p_tdm, "fast paced", 0.2)

#' ### Quick review of Google reviews  

# Create g_pros
g_pros <- paste(goog_pros, collapse = " ")

# Create g_cons
g_cons <- paste(goog_cons, collapse = " ")

# Create all_goog
all_goog <- c(g_pros, g_cons)
all_goog_corpus <- VCorpus(VectorSource(all_goog))

# Create all_goog_corp
all_goog_corp <- tm_clean(all_goog_corpus)

# Create all_tdm
all_tdm <- TermDocumentMatrix(all_goog_corpus)

# Name the columns of all_tdm
colnames(all_tdm) <- c("Goog_Pros", "Goog_Cons")

# Create all_m
all_m <- as.matrix(all_tdm)

# Build a comparison cloud
comparison.cloud(all_m, colors = c("#F44336", "#2196f3"), max.words = 100)

#' ### Cage match! Amazon vs. Google pro reviews  

# Create a_pros
a_pros <- paste(amzn_pros, collapse = " ")

# Create all_pros
all_pros <- c(g_pros, a_pros)
all_pros_corpus <- VCorpus(VectorSource(all_pros))

# Create all_pros_corp
all_pros_corp <- tm_clean(all_pros_corpus)

# Create all_tdm
all_tdm <- TermDocumentMatrix(all_pros_corp, control = list(tokenize = tokenizer))

# Name the columns of all_tdm
colnames(all_tdm) <- c("Amazon_Pro", "Google_Pro")

all_tdm_m <- as.matrix(all_tdm)
head(all_tdm_m)

# Create common_words
common_words <- subset(all_tdm_m, all_tdm_m[, 1] > 0 & all_tdm_m[, 2] > 0)

# Create difference
difference <- abs(common_words[,1] - common_words[,2])

# Add difference to common_words
common_words <- cbind(common_words,difference)

# Order the data frame from most differences to least
common_words <- common_words[order(common_words[,3], decreasing = TRUE), ]

# Create top15_df
top15_df <- data.frame(x = common_words[1:15, 1],
                       y = common_words[1:15, 2],
                       labels = rownames(common_words[1:15, ]))

# Create the pyramid plot
pyramid.plot(top15_df$x, top15_df$y, 
             labels = top15_df$labels, gap = 15, 
             top.labels = c("Amzn", "Pro Words", "Google"), 
             main = "Words in Common", unit = NULL)


#' ### Cage match! Amazon vs. Google con reviews  

# Create a_cons
a_cons <- paste(amzn_cons, collapse = " ")

# Create all_cons
all_cons <- c(g_cons, a_cons)
all_cons_corpus <- VCorpus(VectorSource(all_cons))

# Create all_cons_corp
all_cons_corp <- tm_clean(all_cons_corpus)

# Create all_tdm
all_tdm <- TermDocumentMatrix(all_cons_corp, control = list(tokenize = tokenizer))

# Name the columns of all_tdm
colnames(all_tdm) <- c("Amazon_Con", "Google_Con")

all_tdm_m <- as.matrix(all_tdm)
head(all_tdm_m)

# Create common_words
common_words <- subset(all_tdm_m, all_tdm_m[, 1] > 0 & all_tdm_m[, 2] > 0)

# Create difference
difference <- abs(common_words[,1] - common_words[,2])

# Add difference to common_words
common_words <- cbind(common_words,difference)

# Order the data frame from most differences to least
common_words <- common_words[order(common_words[,3], decreasing = TRUE), ]

# Create top15_df
top15_df <- data.frame(x = common_words[1:15, 1],
                       y = common_words[1:15, 2],
                       labels = rownames(common_words[1:15, ]))

# Create the pyramid plot
pyramid.plot(top15_df$x, top15_df$y, 
             labels = top15_df$labels, gap = 12, 
             top.labels = c("Amzn", "Con Words", "Google"), 
             main = "Words in Common", unit = NULL)


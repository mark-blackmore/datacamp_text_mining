#' ---
#' title: Word Clouds and More Interesting Visuals
#' author: "Mark Blackmore"
#' date: "`r format(Sys.Date())`"
#' output: 
#'   github_document:
#'     toc: true
#'     
#' ---
#'
#'
#' ### Frequent Terms with `tm`  

# Read saved matrix, coerced from tdm
coffee_m  <- readRDS("coffee_m.RDS")

# Calculate the rowSums: term_frequency
term_frequency <- rowSums(coffee_m)

# Sort term_frequency in descending order
term_frequency <- sort(term_frequency, decreasing = TRUE)

# View the top 10 most common words
term_frequency[1:10]

# Plot a barchart of the 10 most common words
barplot(term_frequency[1:10], col = "tan", las = 2 )

#' ### Frequent Terms with `qdap`

# Load qdap
suppressWarnings(
  suppressPackageStartupMessages(
    library(qdap)
  )
)

# Import text data
tweets <- read.csv("./data/coffee.csv", stringsAsFactors = FALSE)

# Create frequency
frequency <- freq_terms(
  tweets$text, 
  top = 10,
  at.least = 3,
  stopwords = "Top200Words")

# Make a frequency barchart
plot(frequency)

# Create frequency2
frequency2 <- freq_terms(
  tweets$text, 
  top = 10,
  at.least = 3,
  stopwords = tm::stopwords("english"))

# Make a frequency2 barchart
plot(frequency2)

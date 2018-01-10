Adding to your tm skills
================
Mark Blackmore
2018-01-09

-   [Distance matrix and dendrogram](#distance-matrix-and-dendrogram)
-   [Make a distance matrix and dendrogram from a TDM](#make-a-distance-matrix-and-dendrogram-from-a-tdm)
-   [Put it all together: a text based dendrogram](#put-it-all-together-a-text-based-dendrogram)
-   [Dendrogram aesthetics](#dendrogram-aesthetics)

``` r
# Load Packages
suppressWarnings(
  suppressPackageStartupMessages({
    library(qdap)
    library(tm)
    library(wordcloud)
    library(dendextend)
  })
)
```

### Distance matrix and dendrogram

``` r
# Create sample data 
rain <- data.frame(city = c("Cleveland", "Portland", "Boston", "New Orleans"),
                   rainfall = c(39.14, 39.14, 43.77, 62.45))

# Create dist_rain
dist_rain <- dist(rain[,2])

# View the distance matrix
dist_rain
```

    ##       1     2     3
    ## 2  0.00            
    ## 3  4.63  4.63      
    ## 4 23.31 23.31 18.68

``` r
# Create hc
hc <- hclust(dist_rain)

# Plot hc
plot(hc, labels = rain$city)  
```

![](more_tm_skills_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-1.png)

### Make a distance matrix and dendrogram from a TDM

``` r
# Import text data
tweets <- read.csv("./data/chardonnay.csv", stringsAsFactors = FALSE)

# Isolate text from tweets: coffee_tweets
chardonnay_tweets <- tweets$text

# Make a vector source: coffee_source
chardonnay_source <- VectorSource(chardonnay_tweets)

# Make a volatile corpus: chardonnay_corpus
chardonnay_corpus <- VCorpus(chardonnay_source)

# Pre-processing function
clean_corpus <- function(corpus){
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, c(stopwords("en")))
  corpus <- tm_map(corpus, stripWhitespace)
  return(corpus)
}

# Apply your customized function to the tweet_corp: clean_corp
clean_corp <- clean_corpus(chardonnay_corpus)

# Create a TDM from clean_corp: chardonnay_tdm
chardonnay_tdm <- TermDocumentMatrix(clean_corp)

# Rename the file to match DataCamp
tweets_tdm <- chardonnay_tdm

# Create tdm1
tdm1 <- removeSparseTerms(tweets_tdm, sparse = 0.95)

# Create tdm2
tdm2 <- removeSparseTerms(tweets_tdm, sparse = 0.975)

# Print tdm1
tdm1
```

    ## <<TermDocumentMatrix (terms: 8, documents: 1000)>>
    ## Non-/sparse entries: 1360/6640
    ## Sparsity           : 83%
    ## Maximal term length: 10
    ## Weighting          : term frequency (tf)

``` r
# Print tdm2
tdm2
```

    ## <<TermDocumentMatrix (terms: 15, documents: 1000)>>
    ## Non-/sparse entries: 1600/13400
    ## Sparsity           : 89%
    ## Maximal term length: 10
    ## Weighting          : term frequency (tf)

Note: DataCamp's version of tweets\_tdm is different than the version derived here from the given source data.

### Put it all together: a text based dendrogram

``` r
# Create tweets_tdm2
tweets_tdm2 <- removeSparseTerms(tweets_tdm, sparse = 0.975)

# Create tdm_m
tdm_m <- as.matrix(tweets_tdm2)

# Create tdm_df
tdm_df <- as.data.frame(tdm_m)

# Create tweets_dist
tweets_dist <- dist(tdm_df)

# Create hc
hc <- hclust(tweets_dist)

# Plot the dendrogram
plot(hc)  
```

![](more_tm_skills_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-1.png)

### Dendrogram aesthetics

``` r
# Load dendextend
#library(dendextend)

# Create hc
hc <- hclust(tweets_dist)

# Create hcd
hcd <- as.dendrogram(hc)

# Print the labels in hcd
labels(hcd)
```

    ##  [1] "chardonnay" "wine"       "just"       "like"       "glass"     
    ##  [6] "lol"        "bottle"     "rose"       "little"     "get"       
    ## [11] "2011"       "dont"       "amp"        "gaye"       "marvin"

``` r
# Change the branch color to red for "marvin" and "gaye"
# Note color does not work here or on DataCamp
branches_attr_by_labels(hcd, c("marvin", "gaye"), color = "red")
```

    ## 'dendrogram' with 2 branches and 15 members total, at height 29.54657

``` r
# Plot hcd
plot(hcd, main = "Better Dendrogram")

# Add cluster rectangles 
rect.dendrogram(hcd, k = 2, border = "grey50")
```

![](more_tm_skills_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-5-1.png)

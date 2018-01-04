Quick Taste of Text Mining
================
Mark Blackmore
2018-01-04

-   [Quick Overview](#quick-overview)
-   [Load Some Text](#load-some-text)
-   [Make the Vector a VCrorpus Object (1)](#make-the-vector-a-vcrorpus-object-1)
-   [Make the Vector a VCrorpus Object (2)](#make-the-vector-a-vcrorpus-object-2)
-   [Common Cleaning Functions from `tm`](#common-cleaning-functions-from-tm)
-   [Cleaning with `qdap`](#cleaning-with-qdap)
-   [All About Stopwords](#all-about-stopwords)
-   [Intro to Word Stemming and Stem Completion](#intro-to-word-stemming-and-stem-completion)
-   [Word Stemming and Stem Completion on a Sentence](#word-stemming-and-stem-completion-on-a-sentence)
-   [Apply Preprocessing Steps to a Corpus](#apply-preprocessing-steps-to-a-corpus)
-   [Make a Document-term Matrix](#make-a-document-term-matrix)
-   [Make a Term-document Matrix](#make-a-term-document-matrix)

### Quick Overview

``` r
# Load qdap
suppressWarnings(
  suppressPackageStartupMessages(
    library(qdap)
  )
)

new_text <- "DataCamp is the first online learning platform that focuses on building the best learning experience specifically for Data Science. We have offices in Boston and Belgium and to date, we trained over 250,000 (aspiring) data scientists in over 150 countries. These data science enthusiasts completed more than 9 million exercises. You can take free beginner courses, or subscribe for $25/month to get access to all premium courses."

# Print new_text to the console
print(new_text)
```

    ## [1] "DataCamp is the first online learning platform that focuses on building the best learning experience specifically for Data Science. We have offices in Boston and Belgium and to date, we trained over 250,000 (aspiring) data scientists in over 150 countries. These data science enthusiasts completed more than 9 million exercises. You can take free beginner courses, or subscribe for $25/month to get access to all premium courses."

``` r
# Find the 10 most frequent terms: term_count
term_count <- freq_terms(new_text, 10)

# Plot term_count
plot(term_count)
```

![](bag_of_words_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-1-1.png)

### Load Some Text

``` r
# Import text data
tweets <- read.csv("./data/coffee.csv", stringsAsFactors = FALSE)

# View the structure of tweets
str(tweets)
```

    ## 'data.frame':    1000 obs. of  15 variables:
    ##  $ num         : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ text        : chr  "@ayyytylerb that is so true drink lots of coffee" "RT @bryzy_brib: Senior March tmw morning at 7:25 A.M. in the SENIOR lot. Get up early, make yo coffee/breakfast"| __truncated__ "If you believe in #gunsense tomorrow would be a very good day to have your coffee any place BUT @Starbucks Guns"| __truncated__ "My cute coffee mug. http://t.co/2udvMU6XIG" ...
    ##  $ favorited   : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
    ##  $ replyToSN   : chr  "ayyytylerb" NA NA NA ...
    ##  $ created     : chr  "8/9/2013 2:43" "8/9/2013 2:43" "8/9/2013 2:43" "8/9/2013 2:43" ...
    ##  $ truncated   : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
    ##  $ replyToSID  : num  3.66e+17 NA NA NA NA ...
    ##  $ id          : num  3.66e+17 3.66e+17 3.66e+17 3.66e+17 3.66e+17 ...
    ##  $ replyToUID  : int  1637123977 NA NA NA NA NA NA 1316942208 NA NA ...
    ##  $ statusSource: chr  "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>" "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>" "web" "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>" ...
    ##  $ screenName  : chr  "thejennagibson" "carolynicosia" "janeCkay" "AlexandriaOOTD" ...
    ##  $ retweetCount: int  0 1 0 0 2 0 0 0 1 2 ...
    ##  $ retweeted   : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
    ##  $ longitude   : logi  NA NA NA NA NA NA ...
    ##  $ latitude    : logi  NA NA NA NA NA NA ...

``` r
# Print out the number of rows in tweets
nrow(tweets)
```

    ## [1] 1000

``` r
# Isolate text from tweets: coffee_tweets
coffee_tweets <- tweets$text
```

### Make the Vector a VCrorpus Object (1)

``` r
# Load tm
suppressWarnings(
  suppressPackageStartupMessages(
    library(tm)
    )
)

# Make a vector source: coffee_source
coffee_source <- VectorSource(coffee_tweets)
```

### Make the Vector a VCrorpus Object (2)

``` r
# Make a volatile corpus: coffee_corpus
coffee_corpus <- VCorpus(coffee_source)

# Print out coffee_corpus
coffee_corpus
```

    ## <<VCorpus>>
    ## Metadata:  corpus specific: 0, document level (indexed): 0
    ## Content:  documents: 1000

``` r
# Print data on the 15th tweet in coffee_corpus
coffee_corpus[[15]]
```

    ## <<PlainTextDocument>>
    ## Metadata:  7
    ## Content:  chars: 111

``` r
# Print the content of the 15th tweet in coffee_corpus
coffee_corpus[[15]]$content
```

    ## [1] "@HeatherWhaley I was about 2 joke it takes 2 hands to hold hot coffee...then I read headline! #Don'tDrinkNShoot"

### Common Cleaning Functions from `tm`

``` r
# Create the object: text
text <- "<b>She</b> woke up at       6 A.M. It\'s so early!  She was only 10% awake and began drinking coffee in front of her computer."

# All lowercase
tolower(text)
```

    ## [1] "<b>she</b> woke up at       6 a.m. it's so early!  she was only 10% awake and began drinking coffee in front of her computer."

``` r
# Remove punctuation
removePunctuation(text)
```

    ## [1] "bSheb woke up at       6 AM Its so early  She was only 10 awake and began drinking coffee in front of her computer"

``` r
# Remove numbers
removeNumbers(text)
```

    ## [1] "<b>She</b> woke up at        A.M. It's so early!  She was only % awake and began drinking coffee in front of her computer."

``` r
# Remove whitespace
stripWhitespace(text)
```

    ## [1] "<b>She</b> woke up at 6 A.M. It's so early! She was only 10% awake and began drinking coffee in front of her computer."

### Cleaning with `qdap`

``` r
## text is still loaded in your workspace

# Remove text within brackets
bracketX(text)
```

    ## [1] "She woke up at 6 A.M. It's so early! She was only 10% awake and began drinking coffee in front of her computer."

``` r
# Replace numbers with words
replace_number(text)
```

    ## [1] "<b>She</b> woke up at six A.M. It's so early! She was only ten% awake and began drinking coffee in front of her computer."

``` r
# Replace abbreviations
replace_abbreviation(text)
```

    ## [1] "<b>She</b> woke up at 6 AM It's so early! She was only 10% awake and began drinking coffee in front of her computer."

``` r
# Replace contractions
replace_contraction(text)
```

    ## [1] "<b>She</b> woke up at 6 A.M. it is so early! She was only 10% awake and began drinking coffee in front of her computer."

``` r
# Replace symbols with words
replace_symbol(text)
```

    ## [1] "<b>She</b> woke up at 6 A.M. It's so early! She was only 10 percent awake and began drinking coffee in front of her computer."

### All About Stopwords

``` r
# List standard English stop words
stopwords("en")
```

    ##   [1] "i"          "me"         "my"         "myself"     "we"        
    ##   [6] "our"        "ours"       "ourselves"  "you"        "your"      
    ##  [11] "yours"      "yourself"   "yourselves" "he"         "him"       
    ##  [16] "his"        "himself"    "she"        "her"        "hers"      
    ##  [21] "herself"    "it"         "its"        "itself"     "they"      
    ##  [26] "them"       "their"      "theirs"     "themselves" "what"      
    ##  [31] "which"      "who"        "whom"       "this"       "that"      
    ##  [36] "these"      "those"      "am"         "is"         "are"       
    ##  [41] "was"        "were"       "be"         "been"       "being"     
    ##  [46] "have"       "has"        "had"        "having"     "do"        
    ##  [51] "does"       "did"        "doing"      "would"      "should"    
    ##  [56] "could"      "ought"      "i'm"        "you're"     "he's"      
    ##  [61] "she's"      "it's"       "we're"      "they're"    "i've"      
    ##  [66] "you've"     "we've"      "they've"    "i'd"        "you'd"     
    ##  [71] "he'd"       "she'd"      "we'd"       "they'd"     "i'll"      
    ##  [76] "you'll"     "he'll"      "she'll"     "we'll"      "they'll"   
    ##  [81] "isn't"      "aren't"     "wasn't"     "weren't"    "hasn't"    
    ##  [86] "haven't"    "hadn't"     "doesn't"    "don't"      "didn't"    
    ##  [91] "won't"      "wouldn't"   "shan't"     "shouldn't"  "can't"     
    ##  [96] "cannot"     "couldn't"   "mustn't"    "let's"      "that's"    
    ## [101] "who's"      "what's"     "here's"     "there's"    "when's"    
    ## [106] "where's"    "why's"      "how's"      "a"          "an"        
    ## [111] "the"        "and"        "but"        "if"         "or"        
    ## [116] "because"    "as"         "until"      "while"      "of"        
    ## [121] "at"         "by"         "for"        "with"       "about"     
    ## [126] "against"    "between"    "into"       "through"    "during"    
    ## [131] "before"     "after"      "above"      "below"      "to"        
    ## [136] "from"       "up"         "down"       "in"         "out"       
    ## [141] "on"         "off"        "over"       "under"      "again"     
    ## [146] "further"    "then"       "once"       "here"       "there"     
    ## [151] "when"       "where"      "why"        "how"        "all"       
    ## [156] "any"        "both"       "each"       "few"        "more"      
    ## [161] "most"       "other"      "some"       "such"       "no"        
    ## [166] "nor"        "not"        "only"       "own"        "same"      
    ## [171] "so"         "than"       "too"        "very"

``` r
# Print text without standard stop words
removeWords(text, stopwords("en"))
```

    ## [1] "<b>She</b> woke         6 A.M. It's  early!  She   10% awake  began drinking coffee  front   computer."

``` r
# Add "coffee" and "bean" to the list: new_stops
new_stops <- c("coffee", "bean", stopwords("en"))

# Remove stop words from text
removeWords(text, new_stops) 
```

    ## [1] "<b>She</b> woke         6 A.M. It's  early!  She   10% awake  began drinking   front   computer."

### Intro to Word Stemming and Stem Completion

``` r
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
```

    ##      complic      complic      complic 
    ## "complicate" "complicate" "complicate"

### Word Stemming and Stem Completion on a Sentence

``` r
text_data <- "In a complicated haste, Tom rushed to fix a new complication, too complicatedly."

# Remove punctuation: rm_punc
rm_punc <- removePunctuation(text_data)

# Create character vector: n_char_vec
n_char_vec <- unlist(strsplit(rm_punc, split = ' '))

# Perform word stemming: stem_doc
stem_doc <- stemDocument(n_char_vec)

# Print stem_doc
stem_doc
```

    ##  [1] "In"      "a"       "complic" "hast"    "Tom"     "rush"    "to"     
    ##  [8] "fix"     "a"       "new"     "complic" "too"     "complic"

``` r
# Re-complete stemmed document: complete_doc
complete_doc <- stemCompletion(stem_doc, comp_dict)

# Print complete_doc
complete_doc
```

    ##           In            a      complic         hast          Tom 
    ##           ""           "" "complicate"           ""           "" 
    ##         rush           to          fix            a          new 
    ##           ""           ""           ""           ""           "" 
    ##      complic          too      complic 
    ## "complicate"           "" "complicate"

### Apply Preprocessing Steps to a Corpus

``` r
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
```

    ## $content
    ## [1] "also dogs arent smart enough dip donut eat part thats dipped ladyandthetramp"

``` r
# Print out the same tweet in original form
tweets$text[227]
```

    ## [1] "Also, dogs aren't smart enough to dip the donut in the coffee and then eat the part that's been dipped. #ladyandthetramp"

### Make a Document-term Matrix

``` r
# Create the dtm from the corpus: coffee_dtm
coffee_dtm <- DocumentTermMatrix(clean_corp)

# Print out coffee_dtm data
coffee_dtm
```

    ## <<DocumentTermMatrix (documents: 1000, terms: 3075)>>
    ## Non-/sparse entries: 7384/3067616
    ## Sparsity           : 100%
    ## Maximal term length: 27
    ## Weighting          : term frequency (tf)

``` r
# Convert coffee_dtm to a matrix: coffee_m
coffee_m <- as.matrix(coffee_dtm)

# Print the dimensions of coffee_m
dim(coffee_m)
```

    ## [1] 1000 3075

``` r
# Review a portion of the matrix
coffee_m[148:150, 2587:2590]
```

    ##      Terms
    ## Docs  stampedeblue stand star starbucks
    ##   148            0     0    0         0
    ##   149            0     0    0         0
    ##   150            0     0    0         0

### Make a Term-document Matrix

``` r
# Create a TDM from clean_corp: coffee_tdm
coffee_tdm <- TermDocumentMatrix(clean_corp)

# Print coffee_tdm data
coffee_tdm
```

    ## <<TermDocumentMatrix (terms: 3075, documents: 1000)>>
    ## Non-/sparse entries: 7384/3067616
    ## Sparsity           : 100%
    ## Maximal term length: 27
    ## Weighting          : term frequency (tf)

``` r
# Convert coffee_tdm to a matrix: coffee_m
coffee_m <- as.matrix(coffee_tdm)

# Print the dimensions of the matrix
dim(coffee_m)
```

    ## [1] 3075 1000

``` r
# Review a portion of the matrix
coffee_m[2587:2590, 148:150]
```

    ##               Docs
    ## Terms          148 149 150
    ##   stampedeblue   0   0   0
    ##   stand          0   0   0
    ##   star           0   0   0
    ##   starbucks      0   0   0

``` r
saveRDS(coffee_m, "coffee_m.RDS")
saveRDS(tweets$text, "tweets_text.RDS")
```

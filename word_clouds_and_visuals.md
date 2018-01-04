Word Clouds and More Interesting Visuals
================
Mark Blackmore
2018-01-03

-   [Frequent Terms with `tm`](#frequent-terms-with-tm)
-   [Frequent Terms with `qdap`](#frequent-terms-with-qdap)

### Frequent Terms with `tm`

``` r
# Read saved matrix, coerced from tdm
coffee_m  <- readRDS("coffee_m.RDS")

# Calculate the rowSums: term_frequency
term_frequency <- rowSums(coffee_m)

# Sort term_frequency in descending order
term_frequency <- sort(term_frequency, decreasing = TRUE)

# View the top 10 most common words
term_frequency[1:10]
```

    ##     like      cup     shop     just      get  morning     want drinking 
    ##      111      103       69       66       62       57       49       47 
    ##      can    looks 
    ##       45       45

``` r
# Plot a barchart of the 10 most common words
barplot(term_frequency[1:10], col = "tan", las = 2 )
```

![](word_clouds_and_visuals_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-1-1.png)

### Frequent Terms with `qdap`

``` r
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
```

![](word_clouds_and_visuals_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-1.png)

``` r
# Create frequency2
frequency2 <- freq_terms(
  tweets$text, 
  top = 10,
  at.least = 3,
  stopwords = tm::stopwords("english"))

# Make a frequency2 barchart
plot(frequency2)
```

![](word_clouds_and_visuals_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-2.png)

Readme
================

First of all you need to have the .zip file of the dataset unzipped and placed in the working directory. Then:

1 Knit the run\_analysis.Rmd file which will produce two files:
run\_analysis.md, which has all the code and explains it
tidydata.txt, text file which contains the tidy dataset

2 Knit the codebook.Rmd file which produces the codebook.md file

The codebook contains the names of variables in the tidy dataset and their description. The details of how they were generated and the explanations of code lines are all within run\_analysis.Rmd and run\_analysis.md files.

``` r
## in 'joindata' feature values start from third column since first two are subject and activity 
##id; so 'reqfeatures' offset by 2. 'select' function from dplyr then used to select columns in 
##'joindata' reperesenting mean and standard deviation measurements by using column indices 
##values store in 'reqfeatures'
x <- c(1, 2, 3, 4, 5)
mean(x)
```

    ## [1] 3

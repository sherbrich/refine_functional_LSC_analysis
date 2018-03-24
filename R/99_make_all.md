Make All
================
stolen from K. Baggerly
2018-03-24

``` r
library(here)
```

    ## here() starts at /Users/smherbrich/Desktop/test

``` r
library(rmarkdown)
```

    ## Warning: package 'rmarkdown' was built under R version 3.4.3

``` r
if(!dir.exists(here("results"))){
  dir.create(here("results"))
}

files_in_r_to_run <- 
#  c("01_grab_data.R",
#    "02_process_data.Rmd",
#    "03_recreate_manuscript_results.Rmd",
#    "04_modified_anova_analysis.Rmd",
    ("05_compare_analyses.Rmd")

for(i1 in 1:length(files_in_r_to_run)){
  
  rmarkdown::render(here("R", files_in_r_to_run[i1]),
                    output_format = 
                      github_document(html_preview = TRUE, toc = TRUE),
                    output_dir = here("results"))
  
}
```

    ## 
    ## 
    ## processing file: 05_compare_analyses.Rmd

    ## 
      |                                                                       
      |                                                                 |   0%
      |                                                                       
      |...                                                              |   5%
    ##    inline R code fragments
    ## 
    ## 
      |                                                                       
      |......                                                           |  10%
    ## label: load_libs
    ## 
      |                                                                       
      |..........                                                       |  15%
    ##   ordinary text without R code
    ## 
    ## 
      |                                                                       
      |.............                                                    |  20%
    ## label: color_palette
    ## 
      |                                                                       
      |................                                                 |  25%
    ##   ordinary text without R code
    ## 
    ## 
      |                                                                       
      |....................                                             |  30%
    ## label: load_data
    ## 
      |                                                                       
      |.......................                                          |  35%
    ##   ordinary text without R code
    ## 
    ## 
      |                                                                       
      |..........................                                       |  40%
    ## label: plot_comparison

    ## 
      |                                                                       
      |.............................                                    |  45%
    ##   ordinary text without R code
    ## 
    ## 
      |                                                                       
      |................................                                 |  50%
    ## label: count_overlap
    ## 
      |                                                                       
      |....................................                             |  55%
    ##   ordinary text without R code
    ## 
    ## 
      |                                                                       
      |.......................................                          |  60%
    ## label: inPatientPlot
    ## 
      |                                                                       
      |..........................................                       |  65%
    ##   ordinary text without R code
    ## 
    ## 
      |                                                                       
      |..............................................                   |  70%
    ## label: sigGenes

    ## 
      |                                                                       
      |.................................................                |  75%
    ##   ordinary text without R code
    ## 
    ## 
      |                                                                       
      |....................................................             |  80%
    ## label: genes_gained

    ## 
      |                                                                       
      |.......................................................          |  85%
    ##   ordinary text without R code
    ## 
    ## 
      |                                                                       
      |..........................................................       |  90%
    ## label: genes_lost
    ## 
      |                                                                       
      |..............................................................   |  95%
    ##   ordinary text without R code
    ## 
    ## 
      |                                                                       
      |.................................................................| 100%
    ## label: plot_pvals

    ## output file: 05_compare_analyses.knit.md

    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS 05_compare_analyses.utf8.md --to markdown_github-ascii_identifiers --from markdown+autolink_bare_uris+tex_math_single_backslash --output /Users/smherbrich/Desktop/test/results/05_compare_analyses.md --standalone --table-of-contents --toc-depth 3 --template /Library/Frameworks/R.framework/Versions/3.4/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/default.md 
    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS /Users/smherbrich/Desktop/test/results/05_compare_analyses.md --to html4 --from markdown_github-ascii_identifiers --output /Users/smherbrich/Desktop/test/results/05_compare_analyses.html --standalone --self-contained --highlight-style pygments --template /Library/Frameworks/R.framework/Versions/3.4/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/preview.html --variable 'github-markdown-css:/Library/Frameworks/R.framework/Versions/3.4/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/github.css' --email-obfuscation none

    ## 
    ## Preview created: /var/folders/n4/wsndbpr93d96mtr47xbx07_mmll6nn/T//RtmpfjwOb5/preview-2b6b43018077.html

    ## 
    ## Output created: /Users/smherbrich/Desktop/test/results/05_compare_analyses.md

``` r
rmarkdown::render(here("README.Rmd"),
                  output_format = 
                    github_document(html_preview = TRUE, toc = TRUE),
                  output_dir = here())
```

    ## 
    ## 
    ## processing file: README.Rmd

    ## 
      |                                                                       
      |                                                                 |   0%
      |                                                                       
      |.................................................................| 100%
    ##    inline R code fragments

    ## output file: README.knit.md

    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS README.utf8.md --to markdown_github-ascii_identifiers --from markdown+autolink_bare_uris+tex_math_single_backslash --output /Users/smherbrich/Desktop/test/README.md --standalone --table-of-contents --toc-depth 3 --template /Library/Frameworks/R.framework/Versions/3.4/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/default.md 
    ## /Applications/RStudio.app/Contents/MacOS/pandoc/pandoc +RTS -K512m -RTS /Users/smherbrich/Desktop/test/README.md --to html4 --from markdown_github-ascii_identifiers --output /Users/smherbrich/Desktop/test/README.html --standalone --self-contained --highlight-style pygments --template /Library/Frameworks/R.framework/Versions/3.4/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/preview.html --variable 'github-markdown-css:/Library/Frameworks/R.framework/Versions/3.4/Resources/library/rmarkdown/rmarkdown/templates/github_document/resources/github.css' --email-obfuscation none

    ## 
    ## Preview created: /var/folders/n4/wsndbpr93d96mtr47xbx07_mmll6nn/T//RtmpfjwOb5/preview-2b6b179926ff.html

    ## 
    ## Output created: /Users/smherbrich/Desktop/test/README.md

README
================
Keith Baggerly
2018-03-24

-   [Overview](#overview)
-   [Brief Results](#brief-results)
-   [Running the Analysis](#running-the-analysis)
    -   [Required Libraries](#required-libraries)

Overview
========

Most of the existing acute myeloid leukemia (AML) stem cell datasets are comprised of stem cells identified using an array of immunophenotypic definitions, however, we now appreciate that the immunopheotype does not always indicate true stem cell function. At the end of 2016, Ng et al introduced the first functional AML stem cell dataset as a part of their Nature manuscript, “A 17-gene stemness score for rapid determination of risk in acute leukaemia”. While the main conclusions of the manuscript are accurate and reproducible, we believe that there is a simple approach to better understand the biology of these functional AML stem cells. Here, we present an alternative analytical approach that accounts for the variability in cell stemness within a given patient using a multivariate statistical model to significantly expand the biological findings of the original manuscript.

Brief Results
=============

-   [01\_grab\_data](results/01_grab_data.md) downloads the raw datasets used from the web.
-   [02\_process\_data](results/02_process_data.md) sets up the data matrix and corresponding annotation dataframes.
-   [03\_recreate\_manuscript\_results](results/03_recreate_manuscript_results.md) closely recapitulates the original analysis described in the manuscript.
-   [04\_modified\_anova\_analysis](results/04_modified_anova_analysis.md) presents our modified analysis in which we use an anova model to account for inter-patient variability.
-   [05\_compare\_analyses](results/05_compare_analyses.md) compares the results obtained from the original and modified analyses.

Running the Analysis
====================

Roughly, our analyses involve running the R and Rmd files in [R](R) in the order they appear.

Run [R/95\_make\_clean.R](R/95_make_clean.R) to clear out any downstream products.

Run [R/99\_make\_all.R](R/99_make_all.R) to re-run the analysis from beginning to end, including generating this README.

Raw data from the web is stored in \[data\]\[data\].

Reports and interim results are stored in \[results\]\[results\].

Required Libraries
------------------

These analyses were performed in RStudio 1.1.414 using R version 3.4.2 (2017-09-28), and use:

-   downloader 0.4
-   GEOquery 2.42.0
-   here 0.1.11
-   readr 1.1.1
-   rmarkdown 1.9
-   illuminaHumanv4.db 1.26.0
-   wesanderson 0.3.4
-   limma 3.32.10
-   ggplot2 2.2.1
-   gridExtra 2.3
-   grid 3.4.2

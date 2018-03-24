Recreate original manuscript results
================
shelley herbrich
2018-03-24

-   [Overview](#overview)
-   [Librares and Data](#librares-and-data)
    -   [Libraries](#libraries)
    -   [Color Palette](#color-palette)
    -   [Data](#data)
-   [Recreating manuscript results](#recreating-manuscript-results)

Overview
========

Librares and Data
=================

Libraries
---------

``` r
library(here)
library(RColorBrewer)
library(wesanderson) #currently requires devtools install 3/22/18
library(limma)
```

    ## 
    ## Attaching package: 'limma'

    ## The following object is masked from 'package:BiocGenerics':
    ## 
    ##     plotMA

Color Palette
-------------

``` r
rcol <- c(wes_palette("Darjeeling1"), wes_palette("Darjeeling2"))
```

Data
----

``` r
load("~/Desktop/test/results/ng_data.RData")
```

Recreating manuscript results
=============================

As per the manuscript

> Differential GE analysis was performed using the limma package. Specifically, Smyth’s moderated t-test was used with Benjamini–Hochberg multiple testing correction to compare gene expression profiles of the 138 LSC+ and 89 LSC− fractions. This resulted in a list of differentially expressed (DE) genes was obtained; 104 genes exhibited ≥ 2-fold expression level differences (adjusted P &lt; 0.01).

When we attempt to recreate these results, we obtain 145 unique genes. However, the fold-changes and p-values from our analysis track closely with those reported in Extended Data Table 1 of the paper. We also notice that the prior to the original analysis, data at the probe level was collapsed to the gene level by selecting the probe with the maximum expression across samples, a step we have not included here.

``` r
design <- matrix(1,nrow=ncol(dat),ncol=2)
rownames(design) <- colnames(dat)
colnames(design) <- c("LSC-","LSC+vsLSC-")
design[which(sample_annot$lsc_status=="LSC-"),2] <- 0

fit <- lmFit(dat, design)
fit <- eBayes(fit)
volcanoplot(fit,coef=2,main="LSC+ vs LSC-", col=rcol[1])
```

![](/Users/smherbrich/Desktop/test/results/03_recreate_manuscript_results_files/figure-markdown_github/lm_fit-1.png)

``` r
manuscriptResults <- topTable(fit, coef="LSC+vsLSC-", number=50000, adjust="BH",sort.by="logFC",lfc=0)
manuscriptResults <- manuscriptResults[order(manuscriptResults[,1],decreasing=TRUE),]
manuscriptResults <- data.frame(geneID=unlist(probe_to_gene)[rownames(manuscriptResults)],manuscriptResults)

manuscriptList <- manuscriptResults[which(manuscriptResults$adj.P.Val<0.01 & abs(manuscriptResults$logFC)>1),]
manuscriptList[which(abs(manuscriptList$logFC)>1.5),c("geneID","logFC","adj.P.Val")]
```

    ##               geneID     logFC    adj.P.Val
    ## ILMN_1732799    CD34  2.149073 3.668906e-07
    ## ILMN_1763516  SPINK2  1.986269 1.387991e-08
    ## ILMN_2341229    CD34  1.952214 1.108559e-06
    ## ILMN_2101832 LAPTM4B  1.795484 9.736556e-09
    ## ILMN_1753613   HOXA5  1.722888 1.375691e-06
    ## ILMN_1808590 GUCY1A3  1.624191 9.307095e-09
    ## ILMN_1680196 LAPTM4B  1.608698 3.880809e-08
    ## ILMN_2317581  SHANK3  1.586115 4.110810e-09
    ## ILMN_1677723  ANGPT1  1.506440 2.159722e-09
    ## ILMN_1739508    <NA> -1.605529 1.049974e-07
    ## ILMN_2091454     HBM -1.616935 5.330155e-06
    ## ILMN_1729801  S100A8 -1.632367 4.572728e-04
    ## ILMN_1790692    GNLY -1.638515 1.783449e-06
    ## ILMN_2396444    CD14 -1.736800 4.447938e-05
    ## ILMN_1652431     CA1 -1.756639 1.894271e-05
    ## ILMN_2367126   ALAS2 -1.762825 1.383446e-06
    ## ILMN_2100437     HBB -1.775411 2.826332e-05
    ## ILMN_1652199    <NA> -1.789831 1.309798e-08
    ## ILMN_1696512    AHSP -1.844394 6.336029e-07
    ## ILMN_1668063    FCN1 -1.845479 6.846155e-06
    ## ILMN_2061043    CD48 -1.849696 7.361216e-11
    ## ILMN_1667796    <NA> -1.868518 1.400943e-05
    ## ILMN_2127842    HBA2 -2.060435 1.279409e-06
    ## ILMN_3240144    <NA> -2.069238 3.609110e-06

``` r
length(unique(manuscriptList[,"geneID"]))
```

    ## [1] 134

``` r
#actualList <- read.csv(here("data", "supplementData.csv"),stringsAsFactors = FALSE)
actualList <- read.csv("~/Desktop/test/data/supplementData.csv",stringsAsFactors = FALSE)
rownames(actualList) <- paste(actualList$ILMN,as.character(actualList$illuminaID),sep="_")
plot(actualList$logFC,manuscriptResults[rownames(actualList),"logFC"],pch=21,bg="dodgerblue",xlab="reported fold changes",ylab="recreation of fold changes")
abline(a=0,b=1,col="red")
```

![](/Users/smherbrich/Desktop/test/results/03_recreate_manuscript_results_files/figure-markdown_github/lm_fit-2.png)

``` r
save(manuscriptList, manuscriptResults, actualList, file= here("results", "manuscript_results.RData"))
```

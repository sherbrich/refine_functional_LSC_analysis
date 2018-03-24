Process raw data
================
shelley herbrich
2018-03-24

-   [Overview](#overview)
-   [Libraries](#libraries)
-   [Ng et al](#ng-et-al)
    -   [Text Description](#text-description)
    -   [File Examination](#file-examination)

Overview
========

The 'raw' dataset from the original Ng et al. manuscript contains gene expression data from Illumina HumanHT-12 V4.0 expression beadchip arrays, but they also have associated metadata. For review, we briefly describe the data matrix and corresponding annotation dataframes.

Libraries
=========

``` r
library(here)
library(readr)
library(GEOquery)
library(illuminaHumanv4.db)
```

Ng et al
========

Text Description
----------------

In late 2016, [Ng et al](https://www.nature.com/articles/nature20598) produced the first publicly available gene expression dataset functionally characterizing acute myeloid leukemia (AML) stem cells (LSCs). To date, existing datasets distinguish LSCs immunophenotypically. However, we know that the functional definition of LSCs, which is the ability to engraft in sublethally irradiated mice, may be more clinically relevant. Therefore, Ng et al sorted patient samples by CD34/CD38 +/- status into 4 groups and tested engraftment in immunocompromised mice. LSC+ samples were defined as populations that engrafted in mice.

As described in the methods: &gt; RNA was extracted using Qiagen RNeasy mini kits (catalogue 74106) and was subjected to GE analysis using Illumina HumanHT-12 v4 microarrays to investigate ~ 47,000 targets corresponding to ~ 30,000 genes. The resultant fluorescence intensity profiles were subjected to variance stabilization and robust spline normalization using the lumi 2.16.0 R package31. All data was put into the log base-2 scale.

The normalized gene expression data was downloaded from the GEO SuperSeries under accession number GSE76008 (08/24/2017 version) (<https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc>= GSE76008). Sample identifier information was obtained from Stanley Ng.

File Examination
----------------

``` r
temp <- 
  read_delim(here("data", "GSE76009-GPL10558_series_matrix.txt.gz"), delim = "\t", skip = 56)
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_character()
    ## )

    ## See spec(...) for full column specifications.

``` r
#############################
# gene expression stored in
# rows not beginning with '!'
#############################
dat <- 
  temp[which(sapply(temp[,1], function(x) substr(x,1,1)) != '!'),]
sampleID <- as.character(dat[1,-1])
probeID <- (dat[-1,1])
dat <- data.matrix(dat[-1,-1])
rownames(dat) <- probeID$`!Sample_title`
colnames(dat) <- sampleID

#############################
# for annotation, let's start
# by taking all rows with '!'
#############################

sample_annot <- 
  temp[which(sapply(temp[,1], function(x) substr(x,1,1)) == '!'),]
sample_annot <- sample_annot[which(sample_annot$'!Sample_title' %in% c('!Sample_geo_accession','!Sample_characteristics_ch1','!Sample_description')),]
sample_annot <- t(sample_annot[,-1])
colnames(sample_annot) <- c("sampleID",'cell_fraction','lsc_status','batch')
sample_annot <- data.frame(sample_annot)
rownames(sample_annot) <- sample_annot$batch

###########################
# grab additional sample 
# annotation- patient ID
############################

additional_annot <- read.csv(here("data", "GSE76008_patientID.csv"), header = TRUE, row.names = 1)
sample_annot <- data.frame(sample_annot, patientID= additional_annot[rownames(sample_annot),1])
rownames(sample_annot) <- sample_annot$sampleID
sample_annot <- sample_annot[colnames(dat),]
all(rownames(sample_annot)==colnames(dat))
```

    ## [1] TRUE

``` r
## clean 
sample_annot$cell_fraction <- sapply(as.character(sample_annot$cell_fraction), function(x) strsplit(x, ': ')[[1]][2])
sample_annot$lsc_status <- sapply(as.character(sample_annot$lsc_status), function(x) strsplit(x, ': ')[[1]][2])

###########################
# probe annotation
############################

# Get the probe identifiers that are mapped to a gene symbol
mapped_probes <- mappedkeys(illuminaHumanv4SYMBOL)
# Convert to a list
probe_to_gene <- as.list(illuminaHumanv4SYMBOL[intersect(mapped_probes, rownames(dat))])

dat[1:5, 1:5]
```

    ##              GSM1972167 GSM1972168 GSM1972169 GSM1972170 GSM1972171
    ## ILMN_1343291  15.538059  15.451766  15.519726  15.503263  15.519726
    ## ILMN_1343295  12.691637  12.296734  13.378752  13.324237  12.442452
    ## ILMN_1651199   6.298350   6.369729   6.425103   6.482825   6.422127
    ## ILMN_1651209   6.727886   6.824600   6.519510   6.501324   6.802330
    ## ILMN_1651210   6.760755   6.554253   6.636405   6.620350   6.635681

``` r
sample_annot[1:5, 1:5]
```

    ##              sampleID cell_fraction lsc_status batch patientID
    ## GSM1972167 GSM1972167           +/+       LSC- H8_b1       840
    ## GSM1972168 GSM1972168           +/-       LSC+ H3_b1     80408
    ## GSM1972169 GSM1972169           -/+       LSC- A8_b1     90454
    ## GSM1972170 GSM1972170           -/-       LSC- B4_b1     80527
    ## GSM1972171 GSM1972171           +/+       LSC- D2_b1       618

``` r
## Clean up

rm(temp, sampleID, probeID, additional_annot, mapped_probes)

## Save the results

save(dat, sample_annot, probe_to_gene,
     file = here("results", "ng_data.RData"))
```

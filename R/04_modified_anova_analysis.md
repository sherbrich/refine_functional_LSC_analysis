Incorporate patient ID to ANOVA model
================
shelley herbrich
2018-03-24

Overview
========

Libraries
---------

``` r
library(here)
```

    ## here() starts at /Users/smherbrich/Desktop/test

``` r
library(RColorBrewer)
library(wesanderson) #currently requires devtools install 3/22/18
library(limma)
```

Color Palette
-------------

``` r
wes <- c(wes_palette("Darjeeling1"), wes_palette("Darjeeling2"))
```

Data
----

``` r
load(here("results", "ng_data.RData"))
```

### Modifying analysis to include patient identifiers

Gene expression profiles for AML samples vary significantly between patients. We, therefore, would like to exploit the fact that we have multiple cell extracts from the same patient and use this information to extract genes that are differentially expressed be LSC+ and LSC- cells adjusting for source.

First, we confirmed that all samples collected from the same patient were run in the same batch. This is true for all but one sample, and that sample appears to be a re-run. Thus, depending on how we handle the data, the batch effect may be orthogonal (and thus completely removable) if we adjust for patient.

``` r
#sampleMap <- read.csv("sorted_fractions.csv",stringsAsFactors = FALSE)
#rownames(sampleMap) <- sampleMap$uniqueID
#sampleMap <- sampleMap[annot$X.Sample_description,]

sample_annot$batch <- sapply(as.character(sample_annot$batch),function(x) strsplit(x,"_")[[1]][2])

## number of batches
## number of samples
table(apply(table(sample_annot$batch,sample_annot$patientID),2,function(x) sum(x!=0)))
```

    ## 
    ##  1  2 
    ## 82  1

``` r
patientsWithBoth <- names(which(sapply(split(sample_annot,factor(sample_annot$patientID)), function(x) length(unique(x[,"lsc_status"])))==2))
### total number of patients
length(unique(sample_annot$patientID))
```

    ## [1] 83

``` r
### number of patients with samples that both did and did not engraft
length(patientsWithBoth)
```

    ## [1] 48

``` r
datWB <- dat[,rownames(sample_annot)[which(sample_annot$patientID %in% patientsWithBoth)]]
mapWB <- sample_annot[rownames(sample_annot)[which(sample_annot$patientID %in% patientsWithBoth)],]
```

We use an ANOVA approach to look for genes which are significantly differentially expressed between engrafting and non-engrafting samples when we account for batch and patient source using the 48 of 83 patients that had cell fractions of both types. The summary difference in expression was determined as the average of the mean difference between LSC+ and LSC- cells from the same patient. We now identify 237 unique genes with p-values less than 0.01 (after Benjamini–Hochberg correction for multiple testing) and absolute fold-change greater than 2, as opposed to 104 genes in the original analysis . The most significantly different genes are listed below.

``` r
aovDat <- t(apply(dat,1,function(x) summary(aov(x~factor(sample_annot$patientID)+factor(sample_annot$batch)+factor(sample_annot$lsc_status)))[[1]][,5]))
aovDat <- aovDat[,-4] #subtract empty column
colnames(aovDat) <- c("patient","batch","lsc")

# or if you want cell_fraction
#aovDat <- t(apply(dat,1,function(x) summary(aov(x~factor(sample_annot$patientID)+factor(sample_annot$batch)+factor(sample_annot$lsc_status)+factor(sample_annot$cell_fraction)))[[1]][,5]))
```

``` r
diffs <- t(apply(datWB,1, function(tt){
  df <- data.frame(exp=tt,LSC=mapWB$lsc_status)
  mean(sapply(split(df,factor(mapWB$patientID)), function(t) diff(sapply(split(t[,"exp"],t[,"LSC"]),mean))))
}))
names(diffs) <- rownames(datWB)
save(aovDat,diffs,file=here("results", "aov_analysis.RData"))
```

``` r
BHpvals <- p.adjust(aovDat[,"lsc"], method = "BH")
aovDat <- data.frame(aovDat,adjustedLSC=BHpvals,diff=t(diffs))

newProbes <- rownames(aovDat)[which(aovDat[,"adjustedLSC"] <= 0.01 & abs(aovDat[,"diff"]) >=1)]
newGeneList <- data.frame(geneID=unlist(probe_to_gene)[newProbes], aovDat[newProbes,c("adjustedLSC","diff")])  
newGeneList <- newGeneList[order(newGeneList$diff,decreasing = TRUE),]
length(unique(newGeneList$geneID))
```

    ## [1] 221

``` r
head(newGeneList)
```

    ##               geneID  adjustedLSC     diff
    ## ILMN_1732799    CD34 2.233657e-12 3.401787
    ## ILMN_2341229    CD34 3.676820e-12 3.156865
    ## ILMN_1763516  SPINK2 3.340061e-13 2.008249
    ## ILMN_2317581  SHANK3 6.083909e-12 1.887882
    ## ILMN_1808590 GUCY1A3 1.516255e-13 1.819641
    ## ILMN_1786720   PROM1 5.118315e-11 1.750255

``` r
tail(newGeneList)
```

    ##              geneID  adjustedLSC      diff
    ## ILMN_2396444   CD14 4.586075e-07 -2.090555
    ## ILMN_1739508   <NA> 4.011844e-10 -2.134335
    ## ILMN_2109489   GZMB 2.767382e-08 -2.201435
    ## ILMN_1652199   <NA> 9.233810e-11 -2.378364
    ## ILMN_1668063   FCN1 5.766069e-09 -2.408386
    ## ILMN_1790692   GNLY 2.743651e-09 -2.475111

``` r
save(datWB, mapWB, aovDat, diffs, BHpvals, newGeneList, file= here("results","aov_analysis.RData"))
```

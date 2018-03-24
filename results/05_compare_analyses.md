Compare original and modified analyses
================
shelley herbrich
2018-03-24

-   [Overview](#overview)
    -   [Libraries](#libraries)
    -   [Color Palette](#color-palette)
    -   [Data](#data)
        -   [Comparing original and modified analyses](#comparing-original-and-modified-analyses)
        -   [Common genes](#common-genes)
        -   [Genes gained with modified analysis](#genes-gained-with-modified-analysis)
        -   [Genes lost with modified analysis](#genes-lost-with-modified-analysis)
    -   [Examining the sources of variability](#examining-the-sources-of-variability)

Overview
========

Libraries
---------

``` r
library(here)
library(RColorBrewer)
library(wesanderson) #currently requires devtools install 3/22/18
library(limma)
library(ggplot2)
library(gridExtra)
library(grid)
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
load(here("results", "manuscript_results.RData"))
load(here("results", "aov_analysis.RData"))
```

### Comparing original and modified analyses

We compare the all fold changes and p-values obtained between the original analysis and the modified analysis that accounts for sample pairing in the plots below. The fold change values appears more consistent between analyses than p-value.

``` r
df <- data.frame(reportedP= log(1/(manuscriptResults$adj.P.Val))*sign(manuscriptResults$logFC),patientAdjP= log(1/(aovDat[rownames(manuscriptResults),"lsc"]))*sign(diffs[rownames(manuscriptResults)]))

m <- ggplot(df, aes(x = reportedP, y = patientAdjP)) + geom_point(alpha = 1/10) 

hist_top <- ggplot(df)+geom_histogram(aes(reportedP),binwidth = 1) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title.y=element_blank())
empty <- ggplot()+geom_point(aes(1,1), colour="white")+
         theme(axis.ticks=element_blank(), 
               panel.background=element_blank(), 
               axis.text.x=element_blank(), axis.text.y=element_blank(),           
               axis.title.x=element_blank(), axis.title.y=element_blank())

scatter <- m + geom_vline(xintercept = c(-1,1)*log(1/0.5/nrow(manuscriptResults)), color="red") + geom_hline(yintercept = c(-1,1)*log(1/0.5/nrow(manuscriptResults)), color="red")
hist_right <- ggplot(df)+geom_histogram(aes(patientAdjP),binwidth = 1)+coord_flip() + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title.y=element_blank(),axis.text.y=element_blank())


grid.arrange(hist_top, empty, scatter, hist_right, ncol=2, nrow=2, widths=c(4, 1), heights=c(1, 4))
```

![](/Users/smherbrich/Desktop/test/results/05_compare_analyses_files/figure-markdown_github/plot_comparison-1.png)

``` r
####

df <- data.frame(reportedFC= manuscriptResults$logFC,patientAdjFC= diffs[rownames(manuscriptResults)])
m <- ggplot(df, aes(x = reportedFC, y = patientAdjFC)) + geom_point(alpha = 1/10) 

hist_top <- ggplot(df)+geom_histogram(aes(reportedFC),binwidth = .1) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title.y=element_blank())
empty <- ggplot()+geom_point(aes(1,1), colour="white")+
         theme(axis.ticks=element_blank(), 
               panel.background=element_blank(), 
               axis.text.x=element_blank(), axis.text.y=element_blank(),           
               axis.title.x=element_blank(), axis.title.y=element_blank())

scatter <- m + geom_vline(xintercept = c(-1,1), color="red") + geom_hline(yintercept = c(-1,1), color="red")
hist_right <- ggplot(df)+geom_histogram(aes(patientAdjFC),binwidth = .1)+coord_flip() + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.title.y=element_blank(),axis.text.y=element_blank())


grid.arrange(hist_top, empty, scatter, hist_right, ncol=2, nrow=2, widths=c(4, 1), heights=c(1, 4))
```

![](/Users/smherbrich/Desktop/test/results/05_compare_analyses_files/figure-markdown_github/plot_comparison-2.png)

### Common genes

Of the original list of significantly differentially expressed genes, approximately 86% were captured in the modified analysis. The common up- and down-regulated genes from both analyses include (with selected examples):

``` r
originalUp <- actualList$geneID[which(actualList$logFC>0)]
originalDown <- actualList$geneID[which(actualList$logFC<0)]

modifiedUp <- as.character(unique(newGeneList$geneID[which(newGeneList$diff>=1)]))
modifiedDown <- as.character(unique(newGeneList$geneID[which(newGeneList$diff<= -1)]))
length(intersect(c(originalUp,originalDown), c(modifiedUp,modifiedDown)))/length(c(originalUp,originalDown))*100
```

    ## [1] 71.15385

``` r
## Common genes higher in LSC+ samples
sort(intersect(originalUp, modifiedUp))
```

    ##  [1] "AIF1L"    "AKR1C3"   "ANGPT1"   "ARHGAP22" "ATP8B4"   "BIVM"    
    ##  [7] "CD34"     "CDK6"     "COL24A1"  "CPXM1"    "DNMT3B"   "DPYSL3"  
    ## [13] "EMP1"     "EPDR1"    "FAM30A"   "FAM69B"   "FLT3"     "FSCN1"   
    ## [19] "GPSM1"    "GUCY1A3"  "HOXA5"    "LAPTM4B"  "MAMDC2"   "MMRN1"   
    ## [25] "MYCN"     "NYNRIN"   "SHANK3"   "SOCS2"    "SPINK2"   "SPNS2"   
    ## [31] "TFPI"     "ZBTB46"

``` r
length(intersect(originalUp, modifiedUp))/length(originalUp)*100
```

    ## [1] 66.66667

``` r
## Common genes higher in LSC- samples
sort(intersect(originalDown, modifiedDown))
```

    ##  [1] "ADAM19"   "ADM"      "AHSP"     "AIM2"     "ALAS2"    "AQP9"    
    ##  [7] "BCL6"     "CD14"     "CD247"    "CD48"     "CHST15"   "CKAP4"   
    ## [13] "CTSH"     "CXCL16"   "E2F2"     "FCGR2A"   "FCN1"     "FCRLA"   
    ## [19] "FGR"      "GIMAP4"   "GNLY"     "GZMA"     "GZMB"     "GZMH"    
    ## [25] "HBA2"     "HBB"      "HBM"      "IL10RA"   "IL18RAP"  "IL2RB"   
    ## [31] "ISG20"    "ITPR3"    "JAZF1"    "KLRB1"    "LILRA5"   "MTSS1"   
    ## [37] "NPL"      "RBM38"    "SLC15A3"  "SLC25A37" "SLC4A1"   "SLC7A7"

``` r
length(intersect(originalDown, modifiedDown))/length(originalDown)*100
```

    ## [1] 75

``` r
inPatientPlot <- function(i, probeN=1){
  all_probes <- which(unlist(probe_to_gene)==i)
  pi <- names(all_probes)[probeN]
  tt <- datWB[pi,]
  df <- data.frame(exp=as.numeric(tt),LSC=mapWB$lsc_status)
  tmp <- t(sapply(split(df,factor(mapWB$patientID)), function(t) sapply(split(t[,"exp"],t[,"LSC"]),mean)))
  direction <- rep("down",nrow(tmp))
  direction[which( apply(tmp,1,diff) >0)] <- "up"
  colTmp <- data.frame(sample = rep(rownames(tmp),2), direction=rep(direction,2), type= rep(c("LSC-","LSC+"),each=nrow(tmp)), exp= c(tmp))

  p <- ggplot(colTmp, aes(x = type, y = exp)) +
    geom_boxplot(outlier.shape = NA) +
    geom_line(aes(group = sample, color = factor(direction))) +
    geom_point() + labs(y=paste0(i," (log2 expression)")) + 
    theme(axis.title.x=element_blank()) + theme(legend.position = "top")
  
  allPatients <- data.frame(expression= dat[pi,], lsc=factor(sample_annot$lsc_status))

  q <- ggplot(allPatients, aes(x=expression, fill=lsc)) + geom_density(alpha=0.3) +
    theme(legend.position = "top") + labs(x=paste0(i," (log2 expression)"))
  
    q <- ggplot(allPatients, aes(x=expression, fill=lsc)) + geom_density(alpha=0.3) +
    theme(legend.position = "top",panel.background = element_rect(fill = "white",color="black"),panel.grid.minor = element_line(color="white")) + labs(x=paste0(i," (log2 expression)"))
 
    grid.arrange(q, p, ncol=2, nrow=1, widths=c(3, 3), heights=c(3), top=textGrob(i, gp=gpar(fontsize=15,font=8)))
}
```

``` r
inPatientPlot("CD34")
```

![](/Users/smherbrich/Desktop/test/results/05_compare_analyses_files/figure-markdown_github/sigGenes-1.png)

``` r
inPatientPlot("CD200")
```

![](/Users/smherbrich/Desktop/test/results/05_compare_analyses_files/figure-markdown_github/sigGenes-2.png)

### Genes gained with modified analysis

Significant genes we gain when accounting for sample pairing include (with selected examples):

``` r
sort(modifiedUp[which(!(modifiedUp %in% originalUp))])
```

    ##  [1] "ANKRD28"  "ATP1B1"   "BAALC"    "BEX3"     "C1orf228" "C1QTNF4" 
    ##  [7] "CDCA7"    "CLEC11A"  "CMBL"     "DEPTOR"   "DNTT"     "EBPL"    
    ## [13] "FAM212A"  "FHL1"     "GNA15"    "KRT18"    "MAP7"     "MN1"     
    ## [19] "MPL"      "MSRB3"    "MYB"      "NPR3"     "NPTX2"    "NREP"    
    ## [25] "NRXN2"    "PROM1"    "PRSS57"   "RAB7B"    "SLC2A5"   "SMIM24"  
    ## [31] "SMYD3"    "STMN3"    "TM4SF1"   "TNFSF4"   "TPM2"     "TSC22D1"

``` r
sort(modifiedDown[which(!(modifiedDown %in% originalDown))])
```

    ##   [1] "ABI3"       "ADA2"       "ADAP2"      "ALOX5"      "ALOX5AP"   
    ##   [6] "ANXA5"      "ARHGAP24"   "BLK"        "BLVRB"      "C5AR1"     
    ##  [11] "CA1"        "CA2"        "CCL5"       "CD19"       "CD1D"      
    ##  [16] "CD27"       "CD36"       "CD79A"      "CD86"       "CEBPD"     
    ##  [21] "CLEC4A"     "COTL1"      "CTSL"       "CX3CR1"     "CYBB"      
    ##  [26] "EOMES"      "EPB42"      "FAM46C"     "FCER1G"     "FCGRT"     
    ##  [31] "FGD2"       "FGFBP2"     "FGL2"       "FPR1"       "GPBAR1"    
    ##  [36] "GYPB"       "GYPE"       "HBD"        "HBG1"       "HBG2"      
    ##  [41] "HBQ1"       "HES6"       "HK3"        "HLA-F"      "HMBS"      
    ##  [46] "HMOX1"      "IFI27"      "IFI30"      "IFIT1B"     "IGF2R"     
    ##  [51] "IGKV1ORY-1" "IGLL1"      "IQSEC1"     "IRF8"       "ITGB7"     
    ##  [56] "KIR2DL3"    "KLRD1"      "KLRF1"      "LBH"        "LILRA3"    
    ##  [61] "LILRB2"     "LILRB3"     "LINC00857"  "LRRC25"     "LYZ"       
    ##  [66] "MAFB"       "MARCKS"     "MCEMP1"     "MNDA"       "MS4A6A"    
    ##  [71] "MS4A7"      "MTMR11"     "MYL4"       "NAPSB"      "NCF1"      
    ##  [76] "NCF1C"      "OSBP2"      "PILRA"      "PLBD1"      "POU2AF1"   
    ##  [81] "PRF1"       "RAB31"      "RBM47"      "RHAG"       "RNASE6"    
    ##  [86] "S100A12"    "S100A8"     "S100A9"     "S1PR5"      "SCPEP1"    
    ##  [91] "SELENBP1"   "SERPINA1"   "SGK1"       "SIGLEC10"   "SLC11A1"   
    ##  [96] "SLC2A6"     "SNTB2"      "STX11"      "TAGLN"      "TGFBI"     
    ## [101] "TGFBR3"     "TLR8"       "TNFRSF13B"  "TNFRSF1B"   "TUBA4A"    
    ## [106] "TYMP"       "UPP1"       "VCAN"       "VNN2"       "ZBP1"

``` r
inPatientPlot("MN1") 
```

![](/Users/smherbrich/Desktop/test/results/05_compare_analyses_files/figure-markdown_github/genes_gained-1.png)

``` r
inPatientPlot("EGFL7") 
```

![](/Users/smherbrich/Desktop/test/results/05_compare_analyses_files/figure-markdown_github/genes_gained-2.png)

### Genes lost with modified analysis

Significant genes that fall out include (with selected examples):

``` r
sort(originalUp[which(!(originalUp %in% modifiedUp))])
```

    ##  [1] "C10orf140" "C1orf150"  "C3orf54"   "GATA2"     "GPR56"    
    ##  [6] "H2AFY2"    "HOXA6"     "HOXA9"     "KCNK17"    "KIAA0125" 
    ## [11] "LOC284422" "NGFRAP1"   "PRSSL1"    "RAGE"      "TNFRSF4"  
    ## [16] "VWF"

``` r
sort(originalDown[which(!(originalDown %in% modifiedDown))])
```

    ##  [1] "CCDC109B"  "CECR1"     "CSTL1"     "CXCR4"     "FCRL3"    
    ##  [6] "FLJ22662"  "HBA1"      "LOC642113" "LOC647450" "LOC647506"
    ## [11] "LOC652493" "LOC652694" "LOC654103" "SGK"

``` r
#inPatientPlot("TNFRSF4") 
#inPatientPlot("GPR56") 
```

Examining the sources of variability
------------------------------------

Using the results from the above ANOVA analysis, we can see which variables were most significant in explaining gene expression variability. By plotting the p-values corresponding to either ‘batch’, ‘LSC status’, and ‘sample ID’, we see that ‘sample ID’, by far, has the most extreme p-values. This confirms our hypothesis that the majority of differential gene expression is due to the sample source.

``` r
sigs <- names(which(aovDat[,"adjustedLSC"] < 0.01))
sigDat <- dat[sigs,]
dim(sigDat)
```

    ## [1]   0 227

``` r
aovDF <- data.frame(pval=(c(aovDat[,1],aovDat[,2],aovDat[,3])),source=rep(c("patient","batch","lsc"),each=nrow(aovDat)))
ggplot(aovDF, aes(source, pval,fill=source)) + geom_boxplot()  + coord_flip() +scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9")) + theme_bw()
```

![](/Users/smherbrich/Desktop/test/results/05_compare_analyses_files/figure-markdown_github/plot_pvals-1.png)

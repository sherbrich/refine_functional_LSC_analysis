#' ---
#' title: Grab Raw Data
#' author: shelley herbrich (stolen from k. baggerly)
#' output: github_document
#' ---

#' In this doc, we grab the dataset and
#' corresponding annotation dataframes
#' from various repositories on the web,
#' and drop them in data/.

library(here)
library(downloader)

#' Set up the data directory if it doesn't exist

if (!dir.exists(here("data"))) {
  cat("creating data/ directory\n")
  dir.create(here("data"))
}

#############################################
#' Locations of the soft files and/or
#' series matrix for GSE76008 from
#' the Gene Expression Omnibus (GEO)
#############################################

#gse76008_soft_url <- 
#  "ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE76nnn/GSE76008/soft/"
#gse76008_soft_file <- "GSE76008_family.soft.gz" 

gse76009_series_matrix_url <- 
  "ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE76nnn/GSE76009/matrix/"
gse76009_series_matrix_file <- 
  "GSE76009-GPL10558_series_matrix.txt.gz"

#############################################
#' If you work with a series matrix, you will
#' need to download a separate annotation
#' matrix for the specific platform
#############################################

#gpl10558_url <- 
# "https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?mode=raw&amp;is_datatable=true&amp;acc=GPL10558&amp;id=50081&amp;db=GeoDb_blob135"
#gpl10558_file <- 'GPL10558_50081.txt'

#############################################
#' Normally, you can generate the sample 
#' annotation dataframe from the header of the
#' series matrix. In this case, we have to
#' import an additional column of sample
#' annotation provided by the authors.
#############################################

#gse76009_additional_annotation_ulr <- 
  # "ftp://ftp.ncbi.nlm.nih.gov/geo/platforms/GPL10nnn/GPL10558/suppl/"
#gse76009_additional_annotation_file <- 

#############################################
#' Loop through all of the above, and acquire
#' files we don't have yet
#############################################

url_list <- 
  c(#paste0(gse76008_soft_url, gse76008_soft_file),
    paste0(gse76009_series_matrix_url, gse76009_series_matrix_file))

data_file_list <-
  c(#gse76008_soft_file, 
    gse76009_series_matrix_file)

for(i1 in 1:length(data_file_list)){
  
  if(!file.exists(here("data", data_file_list[i1]))){
    cat("downloading ", data_file_list[i1], "\n")
    
    download(url_list[i1], 
             destfile = here("data", data_file_list[i1]),
             mode = "wb")
  }
}


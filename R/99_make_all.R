#' ---
#' title: Make All
#' author: stolen from K. Baggerly
#' date: "`r Sys.Date()`"
#' output: github_document
#' ---

library(here)
library(rmarkdown)

if(!dir.exists(here("results"))){
  dir.create(here("results"))
}

files_in_r_to_run <- 
  c("01_grab_data.R",
    "02_process_data.Rmd",
    "03_recreate_manuscript_results.Rmd",
    "04_modified_anova_analysis.Rmd",
    "05_compare_analyses.Rmd")

for(i1 in 1:length(files_in_r_to_run)){
  
  rmarkdown::render(here("R", files_in_r_to_run[i1]),
                    output_format = 
                      github_document(html_preview = TRUE, toc = TRUE),
                    output_dir = here("results"))
  
}

rmarkdown::render(here("README.Rmd"),
                  output_format = 
                    github_document(html_preview = TRUE, toc = TRUE),
                  output_dir = here())
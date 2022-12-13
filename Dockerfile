FROM rocker/rstudio:4.1

RUN Rscript -e 'install.packages("RSQLite")'

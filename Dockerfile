FROM rocker/rstudio:4.1

RUN Rscript 'install.pacakges("RSQLite")'

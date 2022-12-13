FROM rocker/rstudio:4.1

RUN Rscript -e 'install.pacakges("RSQLite")'

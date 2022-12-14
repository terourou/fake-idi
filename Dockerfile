FROM rocker/rstudio:4.1

# install a bunch of packages for the IDI
RUN Rscript -e 'install.packages("RSQLite")'

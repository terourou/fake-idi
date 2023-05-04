FROM rocker/rstudio:4.1

# install a bunch of packages for the IDI
RUN apt-get install -y libodbc1
RUN Rscript -e 'install.packages("RODBC")'

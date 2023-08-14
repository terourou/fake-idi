FROM rocker/rstudio:4.1

# MS SQL Server stuff - from https://github.com/microsoft/mssql-docker/blob/master/linux/mssql-tools/Dockerfile.ubuntu2004
# apt-get and system utilities
RUN apt-get update && apt-get install -y \
	curl apt-transport-https debconf-utils gnupg2

# adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers and tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# install a bunch of packages for the IDI
RUN apt-get update && apt-get install -y unixodbc-dev libxml2-dev libcurl4-openssl-dev libssl-dev
RUN Rscript -e "install.packages(c('dbi', 'odbc', 'xml2'))"

RUN install2.r readr dotenv cli tidyverse dbplyr

ADD startup.R /usr/local/lib/R/etc/Rprofile.site

# add files as read-only
ADD demo /home/rstudio/shared/demo

# create users [tom, colin, barry, andrew, robin, alex, eileen]
RUN useradd -m -d /home/tom -s /bin/bash tom
RUN useradd -m -d /home/colin -s /bin/bash colin
RUN useradd -m -d /home/barry -s /bin/bash barry
RUN useradd -m -d /home/andrew -s /bin/bash andrew
RUN useradd -m -d /home/robin -s /bin/bash robin
RUN useradd -m -d /home/alex -s /bin/bash alex
RUN useradd -m -d /home/eileen -s /bin/bash eileen
RUN useradd -m -d /home/simon -s /bin/bash simon

# set all user passwords to 'password'
RUN echo "password\npassword" | passwd tom
RUN echo "password\npassword" | passwd colin
RUN echo "password\npassword" | passwd barry
RUN echo "password\npassword" | passwd andrew
RUN echo "password\npassword" | passwd robin
RUN echo "password\npassword" | passwd alex
RUN echo "password\npassword" | passwd eileen
RUN echo "terourouSNZ\nterourouSNZ" | passwd simon

# link /home/rstudio/shared to /home/{user}}/shared
RUN ln -s /home/rstudio/shared /home/tom/shared
RUN ln -s /home/rstudio/shared /home/colin/shared
RUN ln -s /home/rstudio/shared /home/barry/shared
RUN ln -s /home/rstudio/shared /home/andrew/shared
RUN ln -s /home/rstudio/shared /home/robin/shared
RUN ln -s /home/rstudio/shared /home/alex/shared
RUN ln -s /home/rstudio/shared /home/eileen/shared
RUN ln -s /home/rstudio/shared /home/simon/shared

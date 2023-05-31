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
RUN apt-get update && apt-get install -y unixodbc-dev
RUN Rscript -e "install.packages(c('dbi', 'odbc'))"

RUN install2.r readr dotenv cli

ADD startup.R /usr/local/lib/R/etc/Rprofile.site

# create users [tom, colin, barry, andrew, robin, alex]
RUN useradd -m -d /home/tom -s /bin/bash tom
RUN useradd -m -d /home/colin -s /bin/bash colin
RUN useradd -m -d /home/barry -s /bin/bash barry
RUN useradd -m -d /home/andrew -s /bin/bash andrew

# set all user passwords to 'password'
RUN echo "password\npassword" | passwd tom
RUN echo "password\npassword" | passwd colin
RUN echo "password\npassword" | passwd barry
RUN echo "password\npassword" | passwd andrew

FROM ubuntu:22.04

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

COPY create_schemas.sql /opt/create_schemas.sql

CMD /opt/mssql-tools18/bin/sqlcmd -S $DB_HOST,$DB_PORT -U $DB_UID -P $DB_PWD -C -i /opt/create_schemas.sql

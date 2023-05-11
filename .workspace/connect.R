library(DBI)
library(dotenv)

driver <- Sys.getenv("DB_DRIVER")
host <- Sys.getenv("DB_HOST")
database <- Sys.getenv("DB_DATABASE")
uid <- Sys.getenv("DB_UID")
pwd <- Sys.getenv("DB_PWD")
port <- Sys.getenv("DB_PORT")

con <- dbConnect(
  odbc::odbc(),
  Driver = driver,
  Server = host,
  Database = database,
  UID = uid,
  PWD = pwd,
  Port = port,
  TrustServerCertificate = "yes"
)

datasets_dir <- file.path("data", "idi-data", "Final datasets")
datasets <- list.files(datasets_dir, full.names = TRUE)

lapply(datasets, function(file) {
  data_name <- tools::file_path_sans_ext(basename(file))
  data <- readr::read_csv(file)
  dbWriteTable(con, data_name, data, overwrite = TRUE)
})

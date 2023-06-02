# basic connection and single-table queries

library(tidyverse)
library(odbc)
library(dbplyr)

con <- odbc::dbConnect(
  odbc::odbc(),
  driver = "ODBC Driver 18 for SQL Server",
  server = "mssql-125904-0.cloudclusters.net,19187",
  database = "IDI",
  uid = "terourou",
  pwd = "TeRourou2023",
  TrustServerCertificate = "yes"
)

# List schemas
schemas <- tbl(con, in_schema("sys", "schemas")) |>
  filter(principal_id == 1) |>
  select(schema_id, name) |>
  rename(schema_name = name) |>
  print()

# List tables
tables <- tbl(con, in_schema("sys", "tables")) |>
  left_join(schemas, by = "schema_id") |>
  select(schema_name, name) |>
  rename(table_name = name) |>
  print()

# View a single table
tbl(con, in_schema("data", "snz_res_pop"))

# Select columns and filter rows
d <- tbl(con, in_schema("nzta_clean", "drivers_licence_register")) |>
  # select columns
  select(nzta_dlr_birth_year_nbr, nzta_dlr_region_code, nzta_dlr_organ_donor_ind) |>
  # use rename for 'SELECT x AS y' syntax:
  rename(
    birth_year = nzta_dlr_birth_year_nbr,
    region_code = nzta_dlr_region_code,
    organ_donor = nzta_dlr_organ_donor_ind
  ) |>
  # use filter to specify 'WHERE' clause:
  filter(birth_year > 1950L) |>
  collect() |>
  # mutations
  mutate(organ_donor = ifelse(organ_donor, 'donor', 'not a donor'))

# Plots, summaries
with(d, barplot(table(organ_donor)))
with(d, barplot(
  table(organ_donor, region_code),
  beside = TRUE,
  legend = TRUE,
  main = 'Organ donation by region'
))

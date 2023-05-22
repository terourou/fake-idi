con <- odbc::dbConnect(
  odbc::odbc(),
  driver = "ODBC Driver 18 for SQL Server",
  server = "mssql-125904-0.cloudclusters.net,19187",
  database = "IDI",
  uid = "terourou",
  pwd = "TeRourou2023",
  TrustServerCertificate = "yes",
)

dl_detail <- odbc::dbGetQuery(con, paste(sep = "\n",
  "SELECT *",
  "FROM [nzta_clean].[drivers_licence_register] AS dl",
  "LEFT JOIN [data].[personal_detail] AS person",
  "  ON dl.[snz_uid] = person.[snz_uid];"
))

with(dl_detail,
  table(nzta_dlr_region_code, nzta_dlr_organ_donor_ind)
) |> plot()

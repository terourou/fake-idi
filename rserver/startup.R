# start up message
cli::cli_h1("Welcome to Te Rourou Tātaritanga's Fake IDI RStudio Server.")

cli::cli_text("This is a fake RStudio Server with a small, fake dataset mimicing the structure of the IDI.")

options("cli.code_theme" = "Solarized Light")
cli::cli_h3("To connect to the server:\n\n")
cli::cli_code(c(
    "con <- odbc::dbConnect(",
    "  odbc::odbc(),",
    "  driver = \"ODBC Driver 18 for SQL Server\",",
    "  server = \"mssql-125904-0.cloudclusters.net,19187\",",
    "  database = \"IDI\",",
    "  uid = \"terourou\",",
    "  pwd = \"TeRourou2023\",",
    "  TrustServerCertificate = \"yes\",",
    ")"
))

cli::cli_rule()

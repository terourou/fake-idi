message("Connecting to SQL Server ...\n")

library(odbc)
con <- dbConnect(
    odbc(),
    driver = "ODBC Driver 18 for SQL Server",
    server = paste(Sys.getenv("DB_HOST"), Sys.getenv("DB_PORT"), sep = ","),
    database = Sys.getenv("DB_DATABASE"),
    uid = Sys.getenv("DB_UID"),
    pwd = Sys.getenv("DB_PWD"),
    TrustServerCertificate = "yes"
)

files <- list.files("/data/idi-data/Final datasets")

schema_table <- lapply(files,
    \(x) {
        x <- strsplit(tools::file_path_sans_ext(x),
            "]_[", fixed = TRUE)[[1]]

        data.frame(
            schema = paste0(x[1], "]"),
            table = paste0("[", x[2])
        )
    }
)
schema_table <- do.call(rbind, schema_table)

schemas <- tapply(
    seq_len(nrow(schema_table)),
    schema_table$schema,
    \(i) {
        x <- schema_table[i, ]
        list(
            schema = x$schema[1],
            tables = x$table
        )
    }
) |> stats::setNames(NULL)

lapply(schemas,
    \(schema) {
        dbGetQuery(con, sprintf("DROP SCHEMA IF EXISTS %s", schema$schema))
        dbGetQuery(con,
            sprintf("CREATE SCHEMA %s", schema$schema)
        )
    }
)

dbGetQuery(con,
    paste(sep = "\n",
        sprintf("CREATE SCHEMA %s", "[data]"),
        sprintf("CREATE TABLE ")

)

# lapply(schemas,
#     \(schema) {
#         sapply(schema$tables,
#             \(table) {
#                 try(dbRemoveTable(con, paste(schema$schema, table, sep = "."),
#                     fail_if_missing = FALSE))
#             }
#         )
#     })

#         dbSendQuery(con,
#             paste0("DROP SCHEMA IF EXISTS ", schema$schema)
#         )

#         dbSendQuery(con,
#             paste0("CREATE SCHEMA ", schema$schema)
#         )

#         sapply(schema$tables,
#             \(table) {
#                 f <- paste0("/data/idi-data/Final datasets/",
#                     schema$schema, "_", table, ".csv")
#                 d <- read.csv(f)
#                 dbWriteTable(con, paste(schema$schema, table, sep = "."), d)
#                 # dbSendQuery(con,
#                 #     paste0("CREATE TABLE ", schema$schema, ".", table, " (",
#                 #         paste0(colnames(d), " VARCHAR(255)", collapse = ", "),
#                 #         collapse = ", ",
#                 #         sep = ""
#                 #     ), ")"
#                 # )
#             }
#         )
#     }
# )

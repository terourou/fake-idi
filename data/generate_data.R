cli::cli_h1("Generate Fake Data from IDI Schema")
invisible(sapply(list.files("functions", full.names = TRUE), source))

cli::cli_h3("Set-up")

cli::cli_progress_step("Reading variable list")
varlist <- readxl::read_excel("variable-lists/varlist.xlsx") |>
    # varlist <- readr::read_csv("variable-lists/varlist.csv") |>
    dplyr::select(-TABLE_CATALOG)

cli::cli_progress_step("Parsing schemas")
schemas <- read_schemas(varlist)

cli::cli_progress_step("Figuring out linking variables")
uid_matches <- get_uid_matches(schemas)

# simple fake_data
# fake_data <- lapply(schemas, \(x) lapply(x, generate_data, linking_vars = uid_matches))


# randomly generate linkable data
# uid_matrix <- generate_link_matrix(uid_matches)

cli::cli_h3("Generating data")

cli::cli_progress_step("Generating unique IDs")
raw_ids <- sample(1e7:1e8, 1e6)
unique_uids <- uid_matches[sapply(uid_matches, length) == 0] |>
    names() |>
    as.factor()
uid_values <- purrr::map_dfc(
    seq_along(levels(unique_uids)),
    \(i) {
        uid <- levels(unique_uids)[i]
        tibble::tibble(!!uid := raw_ids + i * 12)
    }
)


suppressPackageStartupMessages(library(parallel))
cli::cli_progress_step("Initializing cluster")
cl <- makeCluster(12L)
clusterExport(cl, c("generate_data", "uid_matches", "uid_values"))

cli::cli_progress_step("Generating fake data")
fake_data <- pbapply::pblapply(
    schemas,
    \(x) lapply(x, generate_data,
        linking_vars = uid_matches,
        uids = uid_values,
        n = 1000
    ),
    cl = cl
)
stopCluster(cl)

cli::cli_h3("Writing data")

# write to CSV files
cli::cli_progress_step("Create directory")
out_dir <- "random-data"
if (!dir.exists(out_dir)) dir.create(out_dir)

cli::cli_progress_step("Writing CSV files")
z <- pbapply::pblapply(
    names(fake_data),
    \(db_name) {
        db <- fake_data[[db_name]]
        lapply(
            names(db),
            \(tbl_name) {
                tbl <- db[[tbl_name]]
                fp <- sprintf("[%s]_[%s].csv", db_name, tbl_name)
                readr::write_csv(tbl, file.path(out_dir, fp), quote = "all")
                invisible()
            }
        )
    }
)

cli::cli_progress_done()

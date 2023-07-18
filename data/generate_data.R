invisible(sapply(list.files("functions", full.names = TRUE), source))

varlist <- readxl::read_excel("variable-lists/varlist.xlsx") |>
    # varlist <- readr::read_csv("variable-lists/varlist.csv") |>
    dplyr::select(-TABLE_CATALOG)

schemas <- read_schemas(varlist)

uid_matches <- get_uid_matches(schemas)

# simple fake_data
# fake_data <- lapply(schemas, \(x) lapply(x, generate_data, linking_vars = uid_matches))


# randomly generate linkable data
# uid_matrix <- generate_link_matrix(uid_matches)

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

fake_data <- pbapply::pblapply(
    schemas,
    \(x) lapply(x, generate_data,
        linking_vars = uid_matches,
        uids = uid_values,
        n = 10
    )
)

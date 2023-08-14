generate_data <- function(schema, linking_vars, uids, n = 1000L) {
    uid_rows <- sample(nrow(uids), n)
    uid_vars <- linking_vars[names(linking_vars) %in% schema$name]
    uid_values <- lapply(
        names(uid_vars),
        \(x) {
            uid <- uid_vars[[x]]
            if (length(uid)) {
                # this LINKS TO that id
                uids[uid_rows, uid] |>
                    setNames(x) |>
                    sample()
            } else {
                uids[uid_rows, x]
            }
        }
    ) |>
        dplyr::bind_cols() |>
        setNames(names(uid_vars))

    schema |>
        dplyr::rowwise() |>
        dplyr::mutate(
            data = list({
                if (name %in% names(uid_values)) {
                    uid_values[[name]]
                } else if (grepl("^CHAR", type)) {
                    stringr::str_match(type, "^CHAR\\((\\d+)\\)")[, 2] |>
                        as.numeric() |>
                        rep(n) |>
                        purrr::map_chr(~ {
                            sample(LETTERS, .x, replace = TRUE) |>
                                paste0(collapse = "")
                        })
                } else if (grepl("^VARCHAR", type)) {
                    stringr::str_match(type, "^VARCHAR\\((\\d+)\\)")[, 2] |>
                        as.numeric() |>
                        rep(n) |>
                        purrr::map_chr(~ {
                            sample(LETTERS, sample(1:.x, 1), replace = TRUE) |>
                                paste0(collapse = "")
                        })
                } else if (grepl("^DECIMAL", type) || grepl("^NUMERIC", type)) {
                    stringr::str_match(type, "\\((\\d+),\\s*(\\d+)\\)")[, 2:3] |>
                        as.numeric() |>
                        (function(x) {
                            s <- x[1]
                            p <- x[2]
                            d <- x[1] - x[2]
                            # runif(n, 1, 10^d) + runif(n, 0, 10^p) / 10^p
                            round(runif(n, 0, 10^(x[1] - x[2])), x[2])
                        })()
                } else {
                    switch(type,
                        BIGINT = sample(1:100, n, replace = TRUE) * 555555,
                        INT = sample(1:100, n, replace = TRUE) * 333,
                        SMALLINT = sample(1:100, n, replace = TRUE) * 7,
                        TINYINT = sample(1:25, n, replace = TRUE) * 10,
                        BIT = sample(c(0, 1), n, replace = TRUE),
                        DATE = sample(
                            seq(
                                as.Date("2000-01-01"),
                                as.Date("2023-01-01"),
                                by = "month"
                            ),
                            n,
                            replace = TRUE
                        ),
                        DATETIME = sample(
                            seq(
                                as.POSIXct("2000-01-01 07:44:00"),
                                as.POSIXct("2023-01-01 07:44:00"),
                                by = "day"
                            ),
                            n,
                            replace = TRUE
                        ),
                        FLOAT = runif(n, 1000, 1e6) * 3000,
                        REAL = round(runif(n, 0, 1e4) * 8, 2),
                        rep(1, n)
                    )
                }
            })
        ) |>
        dplyr::select(name, data) |>
        purrr::pmap_dfc(~ tibble::tibble(!!..1 := ..2))
}

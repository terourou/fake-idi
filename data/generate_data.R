varlist <- readxl::read_excel("variable-lists/varlist.xlsx") |>
    # varlist <- readr::read_csv("variable-lists/varlist.csv") |>
    dplyr::select(-TABLE_CATALOG)

schemas <- tapply(
    seq_len(nrow(varlist)),
    varlist$TABLE_SCHEMA,
    \(i) {
        x <- varlist[i, ] |> dplyr::select(-TABLE_SCHEMA)
    }
) |> lapply(
    function(x) {
        tapply(
            seq_len(nrow(x)),
            x$TABLE_NAME,
            \(i) {
                x[i, ] |> dplyr::select(-TABLE_NAME)
            }
        )
    }
)

# unique_id_variables <- lapply(
#     schemas,
#     \(x) lapply(
#         x,
#         \(y) y$COLUMN_NAME[grepl("uid$", y$COLUMN_NAME)]
#     ) |> unlist()
# ) |> unlist() |> as.character() |> unique()

generate_data <- function(table_schema, n = 1000L) {
    apply(
        table_schema, 1L,
        function(x) {
            switch(x[2],
                "date" = Sys.Date() - sample(1:365, n, replace = TRUE),
                "char" = sample(LETTERS, n, replace = TRUE),
                "varchar" = matrix(sample(LETTERS, n * 8, replace = TRUE),
                    nrow = n
                ) |> apply(1L, paste, collapse = ""),
                "int" = sample(1:100, n, replace = TRUE),
                "smallint" = sample(0:9, n, replace = TRUE),
                "decimal" = runif(n, 0, 100)
            )
        },
        simplify = FALSE
    ) |>
        setNames(table_schema$COLUMN_NAME) |>
        tibble::as_tibble()
}

read_schemas <- function(varlist) {
    tapply(
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
                    x[i, ] |>
                        dplyr::select(COLUMN_NAME, DATA_TYPE, ColumnLength, ColumnScale, ColumnPrecision, IS_NULLABLE) |>
                        dplyr::distinct() |>
                        stats::setNames(c("name", "type", "length", "scale", "precision", "nullable")) |>
                        dplyr::mutate(
                            type = dplyr::case_when(
                                type == "char" ~ glue::glue("CHAR({length})"),
                                type == "varchar" ~ glue::glue("VARCHAR({length})"),
                                type == "decimal" ~ glue::glue("DECIMAL({precision}, {scale})"),
                                type == "numeric" ~ glue::glue("NUMERIC({precision}, {scale})"),
                                TRUE ~ toupper(type)
                            )
                        ) |>
                        dplyr::select(-length, -scale, -precision)
                    # dplyr::mutate(
                    #     name = glue::glue("[{name}]")
                    # )
                }
            )
        }
    )
}

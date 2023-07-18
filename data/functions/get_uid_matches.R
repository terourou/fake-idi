get_uid_matches <- function(schemas) {
    unique_id_variables <- lapply(
        schemas,
        \(x) lapply(
            x,
            \(y) y$name[grepl("uid$", y$name)]
        ) |> unlist()
    ) |>
        unlist() |>
        as.character() |>
        unique()

    # figure out which UIDs link to others but checking for variables that end with [this_uid]
    uid_matches <- lapply(
        seq_along(unique_id_variables),
        \(i) {
            uid <- unique_id_variables[i]
            oids <- unique_id_variables[-i]
            oids[grepl(glue::glue("_{uid}$"), oids)]
        }
    ) |> setNames(unique_id_variables)

    # now reverse match
    reverse_matches <- lapply(unique_id_variables, \(x) character()) |>
        setNames(unique_id_variables)
    for (uid in unique_id_variables) {
        for (oid in uid_matches[[uid]]) {
            reverse_matches[[oid]] <- c(reverse_matches[[oid]], uid)
        }
    }

    lapply(
        reverse_matches,
        \(x) {
            if (length(x) <= 1) {
                return(x)
            }
            is_contained <- sapply(seq_along(x), \(i) {
                grepl(x[i], x[-i])
            })
            if (sum(is_contained) == 1) {
                return(x[is_contained])
            }
            x
        }
    )
}

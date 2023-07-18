generate_link_matrix <- function(uid_matches) {
    # calculate pairwise matches
    pmat <- lapply(
        names(uid_matches),
        \(x) if (length(uid_matches[[x]])) {
            tibble::tibble(uid1 = x, uid2 = uid_matches[[x]])
        } else {
            NULL
        }
    ) |>
        dplyr::bind_rows() |>
        dplyr::mutate(
            match = 1,
            uid1 = factor(uid1, levels = unique(uid1)),
            uid2 = factor(uid2, levels = levels(uid1)),
            i = as.integer(uid1),
            j = as.integer(uid2)
        )

    mat <- Matrix::sparseMatrix(pmat$i, pmat$j, x = pmat$match)
    dimnames(mat) <-
        list(
            uid1 = levels(pmat$uid1),
            uid2 = levels(pmat$uid2)
        )
    mat
}

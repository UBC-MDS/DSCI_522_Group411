#' Set upper triangle of matrix to NA
#'
#' @param corr_matrix A matrix
#'
#' @return Matrix with upper triangle set to NA
upper_tri_na <- function(corr_matrix) {
  corr_matrix[upper.tri(corr_matrix)] <- NA
  corr_matrix
}

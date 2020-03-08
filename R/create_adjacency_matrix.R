
#' @export
create_adjacency_matrix <- function(labels, lat, long){
  stopifnot(length(labels) == length(lat))
  stopifnot(length(lat) == length(long))

  x <- matrix(NA, nrow = length(labels), ncol = 2)
  x[,1] <- long
  x[,2] <- lat

  output <- 1e14/(geosphere::distm(x)^2)
  colnames(output) <- labels
  rownames(output) <- labels

  return(output)
}

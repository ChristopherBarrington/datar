
#' Create the datar directory
#' 
#' @param path Path to datar directory in which `R` objects will be saved
#' 
#' @importFrom magrittr %>%
#' 
#' @export
#' 
init <- function(path=datar_path()) {
  dir.create(path=path, recursive=TRUE, showWarnings=FALSE)
  ui_done('Created {ui_value(path)}')
}

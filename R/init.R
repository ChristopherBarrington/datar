
#' Create the data repository
#' 
#' @param path Path to data repository
#' 
#' @importFrom magrittr %>%
#' @importFrom usethis ui_done
#' 
#' @return
#' Invisibly returns `path`
#' 
#' @export
#' 
data_repository_init <- function(path=data_repository_path()) {
  if(!dir.exists(path)) {
    dir.create(path=path, recursive=TRUE, showWarnings=FALSE)
    ui_done('Created {ui_value(path)}')
  }
  invisible(path)
}

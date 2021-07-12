
#' Get path to the data repository of a project
#' 
#' @description
#' Checks `options()$datarepo.path` for the path, otherwise uses the project path and `options()$datarepo.subdir` which defaults to `data-repository`.
#' 
#' @return
#' Character string of path to the data repository for a project.
#' 
#' @importFrom magrittr %>% extract2
#' @importFrom stringr str_split
#' 
#' @export
#' 
data_repository_path <- function()
  getwd() %>%
    str_split(pattern=.Platform$file.sep) %>%
    extract2(1) %>%
    head(n=10) %>%
    as.list() %>%
    do.call(what=file.path) %>%
    file.path(., getOption(x='datarepo.subdir', default='data-repository')) %>%
    getOption(x='datarepo.path', default=.)

#' Get path to a saved file in a data repository
#' 
#' @description
#' If `package=='datarepository'` then the path to the data repository is appended with the specified file(s).
#' 
#' @seealso base::system.file
#' @inherit base::system.file 
#' 
#' @return
#' A path to the file(s) specified that exist, as `base::system.file()`
#' 
#' @export
#' 
system.file <- function(..., package='base', lib.loc=NULL, mustWork=FALSE) {
  if(package=='datarepository')
    file.path(data_repository_path(), ...) %>%
      {.[file.exists(.)]}
  else
    base::system.file(..., package=package, lib.loc=lib.loc, mustWork=mustWork)
}

#! system.file <- function(...) {
#!   args <- list(...)
#!   args %>%
#!     modifyList(val=list(lib.loc={data_repository_path() %>% dirname()},
#!                         package={data_repository_path() %>% basename()})) %>%
#!     when(is.element(el='package', set=names(args)) & args$package=='datarepository'~.,
#!          TRUE~args) %T>% print() %>%
#!     do.call(what=base_system.file)
#! }

#! #' Get path to the R 'data' directory of a data repository
#! #'
#! #' @description
#! #' Provides the path to the R 'data' directory in a data repository to/from which object(s) can be saved/loaded with `save_datar()`/`data()`. The 'data' is hard-coded to use with `data()`.
#! #' 
#! data_repository_rdata_path <- function()
#!   file.path(data_repository_path(), 'data')

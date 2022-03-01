#' Initialise data repository in `options()`
#' 
.onLoad <- function(libname, pkgname) {
  # set defaults
  getwd() %>%
    str_split(pattern=.Platform$file.sep) %>%
    {.[[1]]} %>%
    head(n=10) %>%
    as.list() %>%
    do.call(what=file.path) %>%
    file.path(., 'data-repository') %>%
    {list(datarepo.path=.)} %>%
    do.call(what=options)
}

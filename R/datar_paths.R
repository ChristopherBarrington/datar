#' Get path to the datar directory
#' 
#' @param root Path to the top-level directory (for a project)
#' @param subdir Path within `root` into which data can be saved
#' 
#' @importFrom purrr when
#' 
datar_path <- function(root=get_root(), subdir='data/r')
  file.path(root, subdir)

#' Get path to the root of the project
#' 
#' @description
#' From the current working directory, splits the path using the platform-specific path separator and combines the first 10 directories into a path.
#' 
#' @return
#' Character string of path to project
#' 
#' @importFrom magrittr %>% extract2
#' @importFrom stringr str_split
#' 
get_root <- function()
  getwd() %>%
    str_split(pattern=.Platform$file.sep) %>%
    extract2(1) %>%
    head(n=10) %>%
    as.list() %>%
    do.call(what=file.path)


#' Save objects to a data repository
#' 
#' @description
#' Saves an `rda` in the 'data' directory of a data repository.
#' 
#' @param ... Object(s) to save
#' @param path Path to 'data' subdirectory of a data repository in which objects will be `save`d, defaults to `datarepo:::data_repository_path()`
#' 
#' @importFrom fs path
#' @importFrom magrittr %<>%
#' @importFrom usethis ui_done ui_todo ui_value
#' 
#' @describeIn save Save to data repository
#' 
#' @return
#' Invisibly returns paths to saved object(s).
#'
save_to_data_repository <- function(..., path=data_repository_path()) {
  path %<>% file.path('data') %>% init()

  objs <- usethis:::get_objs_from_dots(usethis:::dots(...))
  paths <- path(path, objs, ext='rda')
  mapply(FUN=save, list=objs, file=paths)

  ui_done("Saving {ui_value(unlist(objs))} to {ui_value(paths)}")

  invisible(paths)
}

#' Save objects to a data repository
#' 
#' @description
#' Uses either the `base` or `datarepository` versions of `save` depending on arguments. If the `file` argument is used, it is assumed that `base::save` was intended, otherwise the `datarepository` version is used.
#' 
#' @param ... Arguments passed to `base::save` or `save_to_data_repository()` including objects to save
#' 
#' @importFrom magrittr %>% extract2
#' 
#' @describeIn save Save data using `base::save`
#' 
#' @export
#' 
save <- function(...) {
  # get names of arguments, unnamed arguments (objects to save) are ''
  match.call(expand.dots=FALSE) %>%
    extract2('...') %>%
    names() -> arg_names

  # if it looks like `base::save` was intended, pass the arguments
  # otherwise pass all arguments to `save_to_data_repository`
  if(is.element(el='file', set=arg_names))
    base::save(...)
  else
    save_to_data_repository(...)
}



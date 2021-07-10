
#' Save objects to datar
#' 
#' @param ... Objects to save
#' @param path Path to `datar` directory in which objects will be `save`d, defaults to `/path/to/project/data/r`
#' 
#' @importFrom fs path
#' @importFrom usethis ui_done ui_todo ui_value
#' 
#' @export
#' 
save_datar <- function(..., path=datar_path(), create=TRUE) {
  if(create_path)
    init(path=path)

  objs <- usethis:::get_objs_from_dots(usethis:::dots(...))
  paths <- path(path, objs, ext='rda')
  mapply(FUN=save, list=objs, file=paths)

  ui_done("Saving {ui_value(unlist(objs))} to {ui_value(paths)}")
  ui_todo("Document your data (see {ui_value('https://r-pkgs.org/data.html')})")

  invisible()
}

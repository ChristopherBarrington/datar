
#' Save objects to a data repository
#' 
#' @description
#' Saves an `rda` in the 'data' directory of a data repository.
#' 
#' @param ... Object(s) to save
#' @param path Path to 'data' subdirectory of a data repository in which objects will be `save`d, defaults to `datarepo:::data_repository_path()`
#' 
#' @importFrom digest digest
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
  path %<>% file.path('data') %>% data_repository_init()

  objs <- usethis:::get_objs_from_dots(usethis:::dots(...))
  paths <- path(path, objs, ext='rda')
  mapply(FUN=save, list=objs, file=paths)

  for(obj in objs)
    get(obj) %>%
      digest() ->> saved_object_digests[[obj]]

  ui_done('Saved {ui_value(unlist(objs))} to {ui_value(paths)}')

  invisible(paths)
}

#' Save objects to a data repository
#' 
#' @description
#' `save` uses either the `base` or `datarepository` versions of `save` depending on arguments. If the `file` argument is used, it is assumed that `base::save` was intended, otherwise the `datarepository` version is used.
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

#' Write tables to file
#' 
#' @description
#' `write` uses the `readr::write_` functions with the path to the data repository supplied when omitted. If the `ext` is `xlsx` then the `openxlsx` package is used to write an Excel file. Files are written into the `data` subdirectory of the data repository and can be read into objects using the `data` function as normal.
#' 
#' @param ... Arguments passed to `readr::write_{csv,tsv}` or `openxlsx::write.xlsx`
#' @param ext File extension - format to write - one of `csv`, `tsv` or `xlsx`
#' 
#' @seealso readr write_csv
#' @seealso readr write_tsv
#' @seealso openxlsx write.xlsx
#' 
#' @describeIn save Write a file to the data repository `data` directory
#' 
#' @importFrom fs path
#' @importFrom magrittr %>% %T>% extract2
#' @importFrom openxlsx write.xlsx
#' @importFrom readr write_csv write_tsv
#' 
#' @export
#' 
write <- function(..., ext='tsv') {
  # check that extension is ok
  if(!is.element(el=ext, set=c('csv','tsv','xlsx')))
    stop('ext must be one of: csv, tsv or xlsx')

  # get names of arguments, unnamed arguments (objects to save) are ''
  match.call(expand.dots=FALSE) %>%
    extract2('...') -> all_args

  all_args_names <- names(all_args)
  if(is.null(all_args_names))
    all_args_names <- rep('', times=length(all_args))

  # get the arguments ready to pass along
  objs <- all_args[all_args_names==''] %>% as.character()
  args <- all_args[all_args_names!='']
  data_repository_path() %>%
    file.path('data') %T>%
    data_repository_init() %>%
    path(objs, ext=ext) -> paths

  # loop through the objects and write them
  if(ext=='xlsx') {
    Map(x=objs, path=paths, f=function(x, path) {
      modifyList(list(x=get(x), file=path), args) %>%
        do.call(what=openxlsx::write.xlsx)})
  } else {
    readr_writer <- str_c('readr::write_', ext) %>% parse(text=.) %>% eval()
    Map(x=objs, path=paths, f=function(x, path) {
      modifyList(list(x=get(x), path=path), args) %>%
        do.call(what=readr_writer)})
  }

  # invisibly return paths to written files
  invisible(paths)
}

#' Access a  list of object digests
#' 
#' Objects that are saved to the repository have their checksums recorded here.
#' 
#' @param .. Character string name(s) of object(s) that have been saved to the data-repository in this session.
#' 
#' @importFrom magrittr extract
#' @importFrom purrr when
#' 
#' @export
#' 
get_saved_object_digest <- function(...) {
  list(...) %>%
    unlist() %>%
    when(length(.)==0 ~ saved_object_digests,
         TRUE ~ extract(saved_object_digests, .)) %>%
    invisible()  
}

#' The list of object digests
saved_object_digests <- list()

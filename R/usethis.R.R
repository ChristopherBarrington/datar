### #' Get a list of objects from `...`
### #' 
### #' Taken from `usethis`
### #' 
### get_objs_from_dots <- function (.dots) {
###     if (length(.dots) == 0L) {
###         ui_stop("Nothing to save.")
###     }
###     is_name <- vapply(.dots, is.symbol, logical(1))
###     if (any(!is_name)) {
###         ui_stop("Can only save existing named objects.")
###     }
###     objs <- vapply(.dots, as.character, character(1))
###     duplicated_objs <- which(stats::setNames(duplicated(objs),
###         objs))
###     if (length(duplicated_objs) > 0L) {
###         objs <- unique(objs)
###         ui_warn("Saving duplicates only once: {ui_value(names(duplicated_objs))}")
###     }
###     objs
### }
### 
### #' @importFrom glue glue glue_collapse
### ui_done <- function (x, .envir = parent.frame()) {
###     x <- glue_collapse(x, "\n")
###     x <- glue(x, .envir = .envir)
###     ui_bullet(x, crayon::green(cli::symbol$tick))
### }
### 
### #' @importFrom glue glue glue_collapse
### ui_todo <- function (x, .envir = parent.frame()) {
###     x <- glue_collapse(x, "\n")
###     x <- glue(x, .envir = .envir)
###     ui_bullet(x, crayon::red(cli::symbol$bullet))
### }
### 
### #' @importFrom glue glue_collapse
### ui_value <- function (x) {
###     if (is.character(x)) {
###         x <- encodeString(x, quote = "'")
###     }
###     x <- crayon::blue(x)
###     x <- glue_collapse(x, sep = ", ")
###     x
### }
### 
### dots <- function (...)
###     eval(substitute(alist(...)))


cat_line <- function(...) {
  cat(paste0(..., collapse = "\n"), "\n")
}

pint <- function(x, width = NULL) {
  x <- prettyNum(x, big.mark = ",")
  if (!is.null(width) && width > nchar(x)) {
    sp <- paste(rep(" ", width - nchar(x)), collapse = "")
    x <- paste0(sp, x)
  }
  x
}
pdbl <- function(x, width = NULL) {
  x <- as.numeric(x)
  x <- prettyNum(round(x, 2), big.mark = ",")
  x <- ifelse(grepl("\\.", x), x, x %P% ".00")
  if (!is.null(width) && width > nchar(x)) {
    sp <- paste(rep(" ", width - nchar(x)), collapse = "")
    x <- paste0(sp, x)
  }
  x
}
is_path <- function(x) {
  is.character(x) &&
    length(x) == 1 &&
    nchar(x) < 250 &&
    file.exists(x)
}

parse_char <- function(x) {
  if ("content" %in% names(x)) {
    x <- x[["content"]]
  }
  if (is_path(x)) {
    x <- readBin(x, "raw", file.info(x)$size)
  }
  if (is.raw(x)) {
    x <- enc2utf8(readBin(x, character()))
  }
  x
}
parse_content <- function(x, ...) {
  x <- parse_char(x)
  if (length(x) == 0 || x == "") {
    return(list())
  }
  stopifnot(
    is.character(x)
  )
  x <- tryCatch(jsonlite::fromJSON(x, ...), error = function(e) x)
  parse_cols(x)
}
coerce_int <- function(x) suppressWarnings(as.integer(x))

coerce_num <- function(x) suppressWarnings(as.numeric(x))
coerce_dt <- function(x) suppressWarnings(as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%S"))

parse_cols <- function(x) {
  UseMethod("parse_cols")
}

parse_cols.default <- function(x) {
  x
}
parse_cols.list <- function(x) {
  dapr::lap(x, parse_cols)
}

parse_cols.data.frame <- function(x) {
  dapr::dapc(x, parse_cols)
}

parse_cols.character <- function(x) {
  if (length(x) == 0) {
    return(x)
  }
  xnona <- grep("^[[:punct:]]$", trimws(x), invert = TRUE, value = TRUE)
  if (all(!is.na(coerce_num(xnona)))) {
    if (any(grepl("\\d\\.", x))) {
      return(coerce_num(x))
    } else {
      return(coerce_int(x))
    }
  }
  if (all(!is.na(coerce_dt(xnona)))) {
    return(coerce_dt(x))
  }
  x
}

brows <- function(x) {
  nms <- unique(unlist(dapr::lap(x, names)))
  for (i in seq_along(x)) {
    if (NROW(x[[i]]) == 0) {
      next
    }
    missing <- nms[!nms %in% names(x[[i]])]
    for (v in missing) {
      x[[i]][[v]] <- NA
    }
  }
  do.call("rbind", x)
}

try_null <- function(x) tryCatch(x, error = function(e) NULL)
try_tbl <- function(x) tryCatch(x, error = function(e) tbl())
try_lst <- function(x) tryCatch(x, error = function(e) list())

cleanup_names_ <- function(x) {
  x <- sub("(?<=[a-z])(?=[A-Z])", "_", x, perl = TRUE)
  x <- gsub("'|\"", "", trimws(tolower(iconv(x, to = "ASCII", sub = ""))))
  x <- gsub("%", "pct", x)
  x <- gsub("#", ".number_", x)
  x <- gsub("@|#", "", x)
  x <- gsub("[[:punct:] ]+", "_", x)
  make.names(x)
}

cleanup_names <- function(x) {
  if (is.character(x)) {
    return(cleanup_names_(x))
  }
  if (!is.null(names(x))) {
    names(x) <- cleanup_names_(names(x))
  }
  x
}

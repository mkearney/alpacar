# post_request <- function(url, h = NULL) {
#   if (is.null(h)) {
#     h <- curl::new_handle()
#   }
#   curl::handle_setopt(h, customrequest = "POST")
#   curl::curl_fetch_memory(url, h)
# }
#
# get_request <- function(url, h = NULL) {
#   if (is.null(h)) {
#     h <- curl::new_handle()
#   }
#   curl::curl_fetch_memory(url, h)
# }

alpaca_params <- function(...) {
  dots <- unlist(list(...))
  if (length(dots) == 0) {
    return("")
  }
  paste0("?", paste0(names(dots), "=", dots, collapse = "&"))
}

alpaca_url <- function(path, ...) {
  "https://paper-api.alpaca.markets" %P% path %P% alpaca_params(...)
}

alpaca_get <- function(path, params) {
  if (Sys.getenv("ALPACA_CLIENT_ID") == "" ||
      Sys.getenv("ALPACA_CLIENT_SECRET") == "") {
    stop("Please set the following env vars: ALPACA_CLIENT_ID " %P%
        "and ALPACA_CLIENT_SECRET", call. = FALSE)
  }
  h <- curl::new_handle(useragent = "alpacar /" %P% R.version.string)
  curl::handle_setheaders(h,
    .list = list(
      'APCA-API-KEY-ID' = Sys.getenv("ALPACA_CLIENT_ID"),
      'APCA-API-SECRET-KEY' = Sys.getenv("ALPACA_CLIENT_SECRET")
    )
  )
  curl::curl_fetch_memory(alpaca_url(path, params), h)
}

alpaca_delete_request <- function(path) {
  if (Sys.getenv("ALPACA_CLIENT_ID") == "" ||
      Sys.getenv("ALPACA_CLIENT_SECRET") == "") {
    stop("Please set the following env vars: ALPACA_CLIENT_ID " %P%
        "and ALPACA_CLIENT_SECRET", call. = FALSE)
  }
  h <- curl::new_handle(useragent = "alpacar /" %P% R.version.string)
  curl::handle_setheaders(h,
    .list = list(
      'APCA-API-KEY-ID' = Sys.getenv("ALPACA_CLIENT_ID"),
      'APCA-API-SECRET-KEY' = Sys.getenv("ALPACA_CLIENT_SECRET")
    )
  )
  curl::handle_setopt(h, customrequest = "DELETE")
  curl::curl_fetch_memory(alpaca_url(path), h)
}

alpaca_post <- function(path, body) {
  if (Sys.getenv("ALPACA_CLIENT_ID") == "" ||
      Sys.getenv("ALPACA_CLIENT_SECRET") == "") {
    stop("Please set the following env vars: ALPACA_CLIENT_ID " %P%
        "and ALPACA_CLIENT_SECRET", call. = FALSE)
  }
  if (is.list(body)) {
    body <- body[lengths(body) > 0]
    body <- jsonlite::toJSON(body, auto_unbox = TRUE)
  }
  if (is.character(body)) {
    body <- charToRaw(body)
  }
  stopifnot(is.raw(body))
  h <- curl::new_handle(useragent = "alpacar /" %P% R.version.string)
  curl::handle_setheaders(h,
    .list = list(
      'APCA-API-KEY-ID' = Sys.getenv("ALPACA_CLIENT_ID"),
      'APCA-API-SECRET-KEY' = Sys.getenv("ALPACA_CLIENT_SECRET")
    )
  )
  curl::handle_setopt(h, copypostfields = body)
  curl::curl_fetch_memory(alpaca_url(path), h)
}

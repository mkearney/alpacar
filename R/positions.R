#' Positions
#'
#' The positions API provides information about an account’s current open
#' positions. The response will include information such as cost basis, shares
#' traded, and market value, which will be updated live as price information is
#' updated. Once a position is closed, it will no longer be queryable through
#' this API.
#'
#' @return Information list about account positions as returned by Alpaca's API
#' @export
alpaca_positions <- function() {
  UseMethod("alpaca_positions")
}

#' Close all positions
#'
#' Closes (liquidates) all of the account’s open long and short positions. A
#' response will be provided for each order that is attempted to be cancelled.
#' If an order is no longer cancelable, the server will respond with status 500
#' and reject the request.
#'
#' @return Information list about closed positions as returned by Alpaca's API
#' @export
alpaca_close_all_positions <- function() {
  UseMethod("alpaca_close_all_positions")
}

#' @export
alpaca_close_all_positions.default <- function() {
  "/v2/positions" %>%
    alpaca_delete_request() %>%
    parse_content()
}



#' Close a position
#'
#' Closes (liquidates) the account’s open position for the given symbol. Works
#' for both long and short positions.
#'
#' @param symbol Symbol on which to close position.
#' @return Information list about closed position as returned by Alpaca's API
#' @export
alpaca_close_position <- function(symbol) {
  UseMethod("alpaca_close_position")
}

#' @export
alpaca_close_position.default <- function(symbol) {
  "/v2/positions" %P%
    symbol %>%
    alpaca_delete_request() %>%
    parse_content()
}

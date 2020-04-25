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

#' @export
alpaca_positions.default <- function() {
  "/v2/positions" %>%
    alpaca_get() %>%
    parse_content()
}

#' Request a new order
#'
#' Places a new order for the given account. An order request may be rejected if
#' the account is not authorized for trading, or if the tradable balance is
#' insufficient to fill the order.
#'
#' @param symbol symbol or asset ID to identify the asset to trade
#' @param qty number of shares to trade
#' @param side buy or sell
#' @param type market, limit, stop, or stop_limit
#' @param time_in_force stringRequired day, gtc, opg, cls, ioc, fok. Please see
#'   Understand Orders for more info.
#' @param limit_price string<number>Required required if type is limit or
#'   stop_limit
#' @param stop_price string<number>Required required if type is stop or
#'   stop_limit
#' @param extended_hours boolean (default) false. If true, order will be
#'   eligible to execute in premarket/afterhours. Only works with type limit and
#'   time_in_force day.
#' @param client_order_id string (<= 48 characters) A unique identifier for the
#'   order. Automatically generated if not sent.
#' @param order_class string simple, bracket, oco or oto. For details of
#'   non-simple order classes, please see Bracket Order Overview
#' @param take_profit object Additional parameters for take-profit leg of
#'   advanced orders limit_price string<number>Required required for bracket
#'   orders
#' @param stop_loss Additional parameters for stop-loss leg of advanced orders
#' @seealso https://alpaca.markets/docs/trading-on-alpaca/orders/
#' @return a list returned by alpaca
#' @export
alpaca_new_order <- function(symbol,
                             qty = 1,
                             side = "buy",
                             type = "market",
                             time_in_force = "day",
                             limit_price = NULL,
                             stop_price = NULL,
                             extended_hours = FALSE,
                             client_order_id = NULL,
                             order_class = NULL,
                             take_profit = NULL,
                             stop_loss = NULL) {
  UseMethod("alpaca_new_order")
}

#' @export
alpaca_new_order.default <- function(symbol,
                                     qty = 1,
                                     side = "buy",
                                     type = "market",
                                     time_in_force = "day",
                                     limit_price = NULL,
                                     stop_price = NULL,
                                     extended_hours = FALSE,
                                     client_order_id = NULL,
                                     order_class = NULL,
                                     take_profit = NULL,
                                     stop_loss = NULL) {
  params <- list(
    symbol = symbol,
    qty = qty,
    side = side,
    type = type,
    time_in_force = time_in_force,
    limit_price = limit_price,
    stop_price = stop_price,
    extended_hours = extended_hours,
    client_order_id = client_order_id,
    order_class = order_class,
    take_profit = take_profit,
    stop_loss = stop_loss
  )
  "/v2/orders" %>%
    alpaca_post(params) %>%
    parse_content()
}

#' Get a list of orders
#'
#' Retrieves a list of orders for the account, filtered by the supplied query
#' parameters.
#'
#' @param status string Order status to be queried. open, closed or all. Defaults to open.
#' @param limit int The maximum number of orders in response. Defaults to 50 and max is 500.
#' @param after timestamp The response will include only ones submitted after this timestamp (exclusive.)
#' @param until timestamp The response will include only ones submitted until this timestamp (exclusive.)
#' @param direction string The chronological order of response based on the submission time. asc or desc. Defaults to desc.
#' @param nested boolean If true, the result will roll up multi-leg orders under the legs field of primary order.
#' @seealso https://alpaca.markets/docs/trading-on-alpaca/orders/
#' @return a list returned by alpaca
#' @export
alpaca_list_orders <- function(status = "open",
                               limit = 50,
                               after = NULL,
                               until = NULL,
                               direction = "desc",
                               nested = TRUE) {
  UseMethod("alpaca_list_orders")
}

#' @export
alpaca_list_orders.default <- function(status = "open",
                                       limit = 50,
                                       after = NULL,
                                       until = NULL,
                                       direction = "desc",
                                       nested = TRUE) {
  params <- list(
    status = status,
    limit = limit,
    after = after,
    until = until,
    direction = direction,
    nested = nested
  )
  "/v2/orders" %>%
    alpaca_get(params) %>%
    parse_content()
}





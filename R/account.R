#' Account
#'
#' The account API serves important information related to an account, including
#' account status, funds available for trade, funds available for withdrawal,
#' and various flags relevant to an account’s ability to trade. An account maybe
#' be blocked for just for trades (trades_blocked flag) or for both trades and
#' transfers (account_blocked flag) if Alpaca identifies the account to engaging
#' in any suspicious activity. Also, in accordance with FINRA’s pattern day
#' trading rule, an account may be flagged for pattern day trading
#' (pattern_day_trader flag), which would inhibit an account from placing any
#' further day-trades.
#'
#' @return Information list about account as returned by Alpaca's API
#' @export
alpaca_account <- function() {
  UseMethod("alpaca_account")
}

#' @export
alpaca_account.default <- function() {
  "/v2/account" %>%
    alpaca_get() %>%
    parse_content() %>%
    structure(class = c("alpaca_account", "list"))
}

# pgray <- function(x) {
#   "\033[90m" %P% x %P% "\033[39m"
# }
pgray <- function(x) {
  "\033[38;5;247m" %P% x %P% "\033[39m"
}
# pgold <- function(x) {
#   "\033[38;5;221m" %P% x %P% "\033[39m"
# }

pgold <- function(x) {
  "\033[38;5;136m" %P% x %P% "\033[39m"
}

#' @export
print.alpaca_account <- function(x, ...) {
  cat_line(pgray("<alpaca_account>"))
  w <- nchar(x$account_number)
  cat_line("  Account Number    : ", pgold(x$account_number))
  cat_line("  Buying Power      : ", pgold(pdbl(x$buying_power, w)))
  cat_line("  Regt Buying Power : ", pgold(pdbl(x$regt_buying_power, w)))
  cat_line("  Cash              : ", pgold(pdbl(x$cash, w)))
  cat_line("  Portfolio Value   : ", pgold(pdbl(x$portfolio_value, w)))
  cat_line("  Multiplier        : ", pgold(pint(x$multiplier, w)))
  cat_line("  Equity            : ", pgold(pdbl(x$equity, w)))
  cat_line("  Last Equity       : ", pgold(pdbl(x$last_equity, w)))
  cat_line("  Long Market Value : ", pgold(pdbl(x$long_market_value, w)))
  cat_line("  Short Market Value: ", pgold(pdbl(x$short_market_value, w)))
  cat_line("  Initial Margin    : ", pgold(pint(x$initial_margin, w)))
  cat_line("  Daytrade Count    : ", pgold(pint(x$daytrade_count, w)))
  cat_line(pgray("</alpaca_account>"))
  invisible(x)
}

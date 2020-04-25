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

pgray <- function(x) {
  "\033[90m" %P% x %P% "\033[39m"
}

#' @export
print.alpaca_account <- function(x) {
  cat_line(pgray("<alpaca_account>"))
  w <- nchar(x$account_number)
  cat_line("  Account Number    : ", x$account_number)
  cat_line("  Buying Power      : ", pint(x$buying_power, w))
  cat_line("  Cash              : ", pint(x$cash, w))
  cat_line("  Portfolio_value   : ", pint(x$portfolio_value, w))
  cat_line("  Equity            : ", pint(x$equity, w))
  cat_line("  Long Market Value : ", pint(x$long_market_value, w))
  cat_line("  Short Market Value: ", pint(x$short_market_value, w))
  cat_line("  Daytrade Count    : ", pint(x$daytrade_count, w))
  cat_line(pgray("</alpaca_account>"))
  invisible(x)
}

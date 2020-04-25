
# alpacar

<!-- badges: start -->
<!-- badges: end -->

Algorithmic stock trading with [Alpaca](https://alpaca.market)'s Stock Trading API.

## Note

Alpaca offers both paper and live market APIs. **At the current time, {alpacar} 
is designed for use with Alpaca's *paper* (simulated) trading API**.

## Installation

You can install the released version of **`{alpacar}`** from Github with:

``` r
remotes::install_github("mkearney/alpacar")
```

## Authorization

To get this to work, you'll need to create an app on Alpaca, activate your
credentials for the **paper trading API**, and store as environment variables
`ALPACA_CLIENT_ID` and `ALPACA_CLIENT_SECRET`. You can set these variables in
your ~/.Renviron file by replacing the string values and running the following 
code:

``` r
## this isn't a real client id–replace with yours
tfse::set_renv(ALPACA_CLIENT_ID = "as879f62asf8sdy7fysad")

## this isn't a real client secret–replace with yours
tfse::set_renv(ALPACA_CLIENT_SECRET = "as879f62asf8sdy7fysada9sfd87sdaf9a87sd")
```

## Endpoints

### Account

Get information about your account–e.g., buying power, cash, equity, long/short market value, daytrade count, etc.

``` r
alpacar::alpaca_account()
```

### Positions

Get information about your current positions–e.g., symbol, quantity, side (long vs. short), profit/loss, etc.

``` r
alpacar::alpaca_positions()
```

### Orders

Place new orders–e.g., create short or long position–and specify various options–e.g., market or limit buys, stop loss, etc.

``` r
## purchase long position on TWTR stock
alpacar::alpaca_orders(
  symbol = "TWTR",
  qty = 10,
  side = "buy",
  type = "market"
)

## purchase short position on FB stock
alpacar::alpaca_orders(
  symbol = "FB",
  qty = 10,
  side = "buy",
  type = "market"
)
```

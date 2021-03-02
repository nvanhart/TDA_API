function [quote] = GetQuotesTDA(symbol)
%% Gets Current Quote for Symbol
%  v1.1 01/11/21: Updated to class tdapi
%  v1.0 05/01/20: Initial release. Removed support for specific field.
%                 Returns full result instead
%
%  Fetches current quote data; returns structure data. Supports multiple
%  quotes separated by commas. Returned fields:
%  cusip, bidPrice, bidSize, askPrice, askSize, lastPrice, lastSize,
%  openPrice (daily open), highPrice, lowPrice, closePrice, totalVolume,
%  mark, volatility, x52WkHigh, x52WkLow, other basic stats
%
%  Note: Open is current day open, close is previous day close
%  
%  Ex: threeQuotes = GetQuotesTDA('AAPL,SPY,TSLA');
%  Ex: spyCall = GetQuotesTDA('SPY_121721C375');
%% Format Input, Call Class TDAPI
if class(symbol) == "cell" %handles cell format input
symbol = symbol{1};
end
symbol = urlencode(upper(char(symbol)));

responseGQ = GetQuotesTDA(tdapi,symbol);

%% Format Output
quote = responseGQ.(upper(symbol));
end

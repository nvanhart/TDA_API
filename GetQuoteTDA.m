function quote = GetQuoteTDA(symbol,field)
%% Gets most recent quote from TDA
%  1.11.20 Works fine. No issues.
%  Fetches current quote data. Supported fields:
%
%  current, bid, ask, open, close, high, low, volume, volatility, 52wkHigh,
%  52wkLow, P/E, divAmount, divDate
%  
%  Ex: aapl = GetQuoteTDA('AAPL','52wkHigh');
%% Fetch quote
if class(symbol) == "cell" %checks for cell format
symbol = symbol{1};
end

apikey = 'XXXXXXXXXXXXXXXXXXXX';
uri = 'https://api.tdameritrade.com/v1/marketdata/quotes?apikey=%s&symbol=%s';
uri = sprintf(uri,apikey,urlencode(symbol));
accessToken = GetAccessToken();
options = weboptions('Timeout',10);
options.HeaderFields = {'Authorization' ['Bearer ' accessToken]};
raw = webread(uri,options);
switch lower(field)
    case 'current' 
        if symbol(1) == '/'
            field = 'lastPrice';
        else
            field = 'regularMarketLastPrice';
        end
    case 'bid'; field = 'bidPrice';
    case 'ask'; field = 'askPrice';
    case 'open'; field = 'openPrice';
    case 'close'; field = 'closePrice';
    case 'high'; field = 'highPrice';
    case 'low'; field = 'lowPrice';
    case 'volume'; field = 'totalVolume';
    case 'volatility'; field = 'volatility';
    case '52wkHigh'; field = 'x52WkHigh';
    case '52wkLow'; field = 'x52WkLow';
    case 'P/E'; field = 'peRatio';
    case 'divAmount'; field = 'divAmount'; %cash amount NOT percent yield
    case 'divDate'; field = 'divDate';
    case 'bidSize'; field = 'bidSize';
    case 'askSize'; field = 'askSize';
end
%% Format symbol
symbol = strrep(symbol,'.','_') %formats option & fractional dollar contracts
raw.(upper(symbol)) %dispenses check

if symbol(1) == '/'
    symbol = ['x_' symbol(2:end)]; %removes '/' from futures contracts
    field = [field 'InDouble']; %corrects fields for futures
    quote = raw.(symbol).(field);   
else
    quote = raw.(upper(symbol)).(field);
end



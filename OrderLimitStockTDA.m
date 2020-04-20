function confirmation = OrderLimitStockTDA(symbol,shares,buy_sell,price)
%% Submit Limit Stock Order. Dispenses 'Reported' time.
%  Does NOT report order conf nums
%
%  Syntax: 'ALL_CAPS_SYMBOL'; 'Buy' or 'Sell','string_limit_price'
%
%  Ex: Reported = PlaceTradeTDA('X',100,'Buy','12.55') 

%% Section 1: Format Request
symbol = upper(symbol);
buy_sell = [upper(buy_sell(1)) lower(buy_sell(2:end))]; %formats buy/sell 
price = char(price); %formats price to character vector
inst = struct('symbol',upper(symbol),'assetType','EQUITY');
olc = struct('instruction',(buy_sell),'quantity',shares,'instrument',inst);
body = struct('orderType','LIMIT','session','NORMAL','price',price,'duration',...
              'DAY','orderStrategyType','SINGLE','orderLegCollection',olc);
body = jsonencode(body);
body = strrep(body,'"orderLegCollection":{"instruction"','"orderLegCollection":[{"instruction"');
body = strrep(body,'"assetType":"EQUITY"}}}','"assetType":"EQUITY"}}]}');
options = weboptions('MediaType','application/json','RequestMethod','post');
options.HeaderFields = {'Authorization' ['Bearer ' GetAccessToken()]};
uri = 'https://api.tdameritrade.com/v1/accounts/XXXXXXXXX/orders';
raw = webwrite(uri,body,options)
%raw.GetFields('Location')
if isempty(raw) == 1
    confirmation = cellstr(datetime('now','TimeZone','America/New_York'));
else
    confirmation = 'Error';
end
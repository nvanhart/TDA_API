function confirmation = OrderMarketStockTDA(symbol,shares,buy_sell)
%% Submit Market Stock Order. Dispenses 'Reported' time.
%  Does NOT work for Paper Money accounts!
%
%  Syntax: 'ALL_CAPS_SYMBOL'; 'Buy' or 'Sell'
%
%  Ex: Reported = OrderMarketStockTDA('X',100,'Buy'); 
%% Section 1: Format Request

inst = struct('symbol',upper(symbol),'assetType','EQUITY');
olc = struct('instruction',(buy_sell),'quantity',shares,'instrument',inst);
body = struct('orderType','MARKET','session','NORMAL','duration','DAY',...
              'orderStrategyType','SINGLE','orderLegCollection',olc);
options = weboptions('MediaType','application/json','RequestMethod','post');
options.HeaderFields = {'Authorization' ['Bearer ' GetAccessToken()]};
uri = 'https://api.tdameritrade.com/v1/accounts/XXXXXXXXXX/orders';
body = jsonencode(body);
body = strrep(body,'"orderLegCollection":{"instruction"','"orderLegCollection":[{"instruction"');
body = strrep(body,'"assetType":"EQUITY"}}}','"assetType":"EQUITY"}}]}');
raw = webwrite(uri,body,options);
if isempty(raw) == 1
    confirmation = cellstr(datetime('now','TimeZone','America/New_York'));
else
    confirmation = 'Error';
end

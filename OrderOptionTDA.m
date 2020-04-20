function confirmation = OrderOptionTDA(symbol,shares,buy_sell,price)
%% Submit Limit Option Order. Dispenses 'Reported' time.
%  
%  Syntax: 'ALL_CAPS_SYMBOL'; 'Buy' or 'Sell','string_limit_price'
%  
%  Ex: Reported = OrderOptionTDA('X_013120C11.5',100,'Buy','12.55'); 
%% Section 1: Format Request
symbol(symbol == '.') = '_'; %formats correctly
switch buy_sell
    case 'Buy'; buy_sell = 'BUY_TO_OPEN';
    case 'Sell'; buy_sell = 'SELL_TO_OPEN';
end

instrument = struct('symbol',upper(symbol),'assetType','OPTION');
orderLeg = struct('instruction',(buy_sell),'quantity',shares,'instrument',instrument);
body = struct('complexOrderStrategyType','NONE','orderType','LIMIT','session',...
              'NORMAL','price',price,'duration','DAY','orderStrategyType','SINGLE',...
              'orderLegCollection',orderLeg);
options = weboptions('MediaType','application/json','RequestMethod','post');
options.HeaderFields = {'Authorization' ['Bearer ' GetAccessToken()]};
uri = 'https://api.tdameritrade.com/v1/accounts/XXXXXXXXX/orders';
body = jsonencode(body);
body = strrep(body,'"orderLegCollection":{"instruction"','"orderLegCollection":[{"instruction"');
body = strrep(body,'"assetType":"OPTION"}}}','"assetType":"OPTION"}}]}');
raw = webwrite(uri,body,options);
if isempty(raw) == 1
    confirmation = cellstr(datetime('now','TimeZone','America/New_York'));
else
    confirmation = 'Error';
end
end
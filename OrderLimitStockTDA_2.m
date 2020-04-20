function confNum = OrderLimitStockTDA_2(symbol,shares,direction,price)
%% TDA limit order v2. Updated to return confirmation number as output
%  2.6.20: Functional to submit orders and receive confirmation numbers.
%  
%  Ex: confNum = OrderLimitStockTDA('ACB', 1, 'buy', 2.5) 
%% Section 1: Prepare order block
%symbol = 'ACB';
%shares = 1;
%direction = 'buy';
%price = 1.00;
instrument = struct('symbol', upper(symbol), 'assetType', 'EQUITY'); %instrument block
orderLegCollection = struct('instruction', lower(direction), 'quantity', shares, 'instrument', instrument); %order leg block
main = struct('orderType', 'LIMIT', 'session', 'NORMAL', 'price',sprintf('%.2f',price),'duration',...
    'DAY', 'orderStrategyType', 'SINGLE', 'orderLegCollection', orderLegCollection);
main.orderLegCollection = {main.orderLegCollection}; %receives syntax BadRequest error without this!

%% Section 2: Prepare http.RequestMessage
order = matlab.net.http.RequestMessage;
order.Method = 'Post';
order.Header = matlab.net.http.field.GenericField('Authorization',['Bearer ' GetAccessToken]);
order.Body(1).Data = main;
URI = 'https://api.tdameritrade.com/v1/accounts/XXXXXXXXX/orders';
response = order.send(URI)

raw = parse(response.Header); %extracts header values into cell array
rawConf = char(raw{5}); %url containing order num
confNum = rawConf(end-9:end);

end
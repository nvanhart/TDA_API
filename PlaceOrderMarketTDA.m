function confirmation = PlaceOrderMarketTDA(symbol,buySell,shares)
%% Submits Basic Market Buy or Sell Order 
%  v1.1 01/11/21: Class TDAPI support
%  v1.0 04/16/20: Initial release
%
%  PlaceOrderTDA sends basic order. Returns timeStamp.
%
%  Ex: USS_buy = PlaceOrderMarketTDA('x','Buy',1);
% 
%  TO DO: 1) Add processing capabilities to find order conf number via
%            additional api fcns
%         2) Replace market w buy(ask)
%% Format Input Vars, Call Class TDAPI
switch lower(char(buySell))
    case 'buy'; buySell = 'Buy';
    case 'sell'; buySell = 'Sell';
end
symbol = upper(char(symbol));
responsePOM = PlaceOrderMarketTDA(tdapi,symbol,buySell,shares);

%% Format Raw Response
if isempty(responsePOM) == 1
    confirmation = cellstr(datetime('now','TimeZone','America/New_York'));
    disp('-place market order success-')
else
    confirmation = 'Error';
end

end


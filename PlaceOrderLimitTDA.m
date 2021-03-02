function [confNum,details] = PlaceOrderLimitTDA(symbol,buySell,shares,limit)
%% Submits Limit Buy or Sell Order
%  v1.0 01/13/21: Initial Release. Class TDAPI support
%
%  PlaceOrderTDA sends basic order. Returns confId (orderId) and optional 
%  order details structure (details). Supports equities & options. Note 
%  eseential option contract formatting: (SYM)_(mmDDyy)(C/P)(strike)
%
%  Ex: spyCallOrder = PlaceOrderLimitTDA('SPY_011321C371','Buy',1,'0.10');
%      Sends order to buy 1 SPY Call expiring on Jan 13, 2021 w strike(371)
%      for a maximum price of $0.10. Good for day by default.
% 
%  TO DO: 1) 
%
%% Format Input Variables 
symbol = upper(char(symbol));
if contains(symbol,'_') %checks asset type to define instruction
    assetType = 'OPTION';
    if lower(char(buySell)) == "buy"
        buySell = 'BUY_TO_OPEN';
    else
        buySell = 'SELL_TO_CLOSE';
    end
else
    assetType = 'EQUITY';
    if lower(char(buySell)) == "buy"
        buySell = 'Buy';
    else
        buySell = 'Sell';
    end
end
%shares = char(string(shares)); %shares should be type int NOT str
limit = char(string(limit)); %converts num to char

%% Call Class TDAPI
responsePOL = PlaceOrderLimitTDA(tdapi,symbol,assetType,buySell,shares,limit);

%% Format Raw Response
if isempty(responsePOL) == 1
    disp('-place limit order success-')
    raw = GetOrderLastTDA();
    confNum = char(string(raw.orderId));
    details = raw;
else
    confNum = 'Error';
    details = [];
end

end


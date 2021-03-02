function data = GetOptionChainTDA(symbol,conType,daysToExp)
%% Fetches Specified Option Chain
%  v1.1 01/11/21: Updated to class tdapi.
%  v1.0 01/13/20: Initial release. Backbone code only. Many variations.
%
%  GetOptionChain outputs full option chains given inputs of call/put/all
%  and number of days to expiration 
%
%  Input Var Syntax 
%  symbol: ticker (type = string)
%  conType: call, put, all (type = string)
%  daysToExp: max number of days into future  (type = int)
%  
%  Ex: spyCons = GetOptionChainTDA('SPY','call',28)
%      %all available strikes for SPY calls expiring in next 28 days
%
%  TO DO: 1) 
%% Format Input Vars, Call Class TDAPI
symbol = upper(char(symbol));
conType = upper(char(conType));
daysToExp = char(string(daysToExp));
responseGOC = GetOptionChainTDA(tdapi,symbol,conType,daysToExp);

data = responseGOC; %leaves data raw as post-processing often highly specific
end
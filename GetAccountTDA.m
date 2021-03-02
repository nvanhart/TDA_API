function info = GetAccountTDA(field)
%% Retrieves Specified Account Details
%  v1.2 01/10/21: Update to TDAPI class, renamed, added fields support.
%  v1.0 12/31/19: Initial release.
%
%  Fetches information for account. 
%  Supported fields:
%      type, isDayTrader, cashBalance, liquidationValue, availableFunds,
%      buyingPower, equity, equityPercentage
%
%  Ex: buyingPower = GetAccountTDA('buyingPower');
%
%% Call TDAPI
responseGA = GetAccountTDA(tdapi,field); %calls class

%% Process Raw Response
raw1 = responseGA.securitiesAccount;
if field == "type" || field == "isDaytrader"
    raw2 = raw1.(field);
else
    raw2 = raw1.currentBalances.(field);
end
info = raw2;
end

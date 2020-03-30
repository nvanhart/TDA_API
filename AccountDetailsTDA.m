function output = AccountDetailsTDA(info)
%% Outputs the buying power available for account
%  Fetches information for account. Current options included:
%  pendingDeposits, availableFunds, buyingPower, equity, equityPercentage
%
%  12.31.19 Works. No issues.
%
%  Ex: buyingPower = AccountDetailsTDA('buyingPower');
%% Section 1: Fetch raw data
inputs.fields = 'positions';
uri = 'https://api.tdameritrade.com/v1/accounts/XXXXXXXXX'; %account num
options = weboptions('Timeout',10);
accessToken = GetAccessToken();
options.HeaderFields = {'Authorization' ['Bearer ' accessToken]};
raw = webread(uri,'fields',inputs.fields,options);
raw = raw.securitiesAccount.currentBalances;

switch info
    case 'pendingDeposits'; output = raw.pendingDeposits;
    case 'availableFunds'; output = raw.availableFunds;
    case 'buyingPower'; output = raw.buyingPower;
    case 'equity'; output = raw.equity;
    case 'equityPercentage'; output = raw.equityPercentage;
end
end

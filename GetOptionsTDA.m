function data = GetOptionsTDA(ticker,contractType,strikeCount,expMonth)
%% Fetches option chains data from TDA.
%  1.13.20 Backbone code only. Customized to individual strategies. 
%  Too many variations to build useful general function.
%
%  Syntax, valid values, descriptions:
%
%  contractType (CALL, PUT, ALL); strikeCount (1-10: number of contracts
%  above and below at-the-money price; expMonth (JAN-DEC: month contract
%  expires in)
%  
%  Ex: US_Steel = GetOptionsTDA('X','CALL',5,'FEB')
%      Options chain for 5 Feb-expiring call contracts above & below ATM price
%% Fetch chain
apikey = 'XXXXXXXXXXXXXXXX';
uri = ['https://api.tdameritrade.com/v1/marketdata/chains?apikey=%s&symbol=%s'...
      '&contractType=ALL&strikeCount=%d&includeQuotes=FALSE&strategy=SINGLE'...
      '&expMonth=%s&optionType=ALL'];
uri = sprintf(uri,apikey,ticker,strikeCount,expMonth); %change this to strike
accessToken = GetAccessToken();
options = weboptions('Timeout',10);
options.HeaderFields = {'Authorization' ['Bearer ' accessToken]};
raw = webread(uri,options)

%% Format raw data
switch contractType
    case 'CALL'; ct = 'callExpDateMap';
    case 'PUT'; ct = 'putExpDataMap';
end
series = raw.(ct)
seriesNames = fieldnames(series) %expiration-dates/field names for contracts
for i = 1:length(seriesNames)
    sn = seriesNames{i} %extracts field name
    contracts = series.(sn)
    contractNames = fieldnames(contracts); 
end

data = p;
end
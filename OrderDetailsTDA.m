function details = OrderDetailsTDA(confNum)
%% Gets most recent quote from TDA
%  2.21.20 Works fine. No issues.
%  Fetches fill price for given order
%  
%  Ex: acb_fill = OrderDetailsTDA(2528404336);
%% 
uri = 'https://api.tdameritrade.com/v1/accounts/XXXXXXXXXX/orders/%s';
uri = sprintf(uri,char(string(confNum)));
options = weboptions('Timeout',10);
options.HeaderFields = {'Authorization' ['Bearer ' GetAccessToken()]};
raw = webread(uri,options);
details = raw.orderActivityCollection.executionLegs.price; 


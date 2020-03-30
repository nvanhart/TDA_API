function status = GetHoursTDA()
%% Checks if market is open
%  1.22.20 Works fine. No issues.
%  Returns boolean 1 for market open or 0 for closed
%  
%  Ex: status = GetHoursTDA();
%% Check Hours
apikey = 'XXXXXXXXXXXXXXXXXXX';
date = string(datetime('now','Format','yyyy-MM-dd'));
uri = 'https://api.tdameritrade.com/v1/marketdata/EQUITY/hours?apikey=%s&date=%s';
uri = sprintf(uri,apikey,date);
accessToken = GetAccessToken();
options = weboptions('Timeout',10);
options.HeaderFields = {'Authorization' ['Bearer ' accessToken]};
raw = webread(uri,options)
status = raw.equity.EQ.isOpen;
end
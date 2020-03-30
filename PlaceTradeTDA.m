function status = PlaceTradeTDA(ticker,shares)
%% Submits trades for practice and live accounts
%
%  12.31.19: 400 error. Something incorrect in request.
%
%  Ex: x_status = PlaceTradeTDA('x',100);
%% Section 1: Format Request

uri = 'https://api.tdameritrade.com/v1/accounts/XXXXXXXXXXX/orders';

inst = struct('symbol',upper(ticker),'assetType','EQUITY');
olc = struct('instruction','Buy','quantity',shares,'instrument',inst);
body = struct('orderType','MARKET','session','NORMAL','duration','DAY',...
              'orderStrategyType','SINGLE','orderLegCollection',olc);
options = weboptions;
%options.ContentType = 'text';
options.MediaType = 'application/json';
options.RequestMethod = 'post';
options.HeaderFields = {'Authorization' ['Bearer ' GetAccessToken()]};
status = webwrite(uri,body,options)
end


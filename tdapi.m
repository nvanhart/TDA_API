classdef tdapi
%% Class TDAPI for TD Ameritrade Developer API
%  v2.0 01/08/2021: Initial release reformatted as class.
% 
%  TO DO: 1) 
%
    properties (Constant)
        accountID = 'XXXXXXXXX'; % Trading
        %investingID = 'XXXXXXXX'; % RothIra
        clientID = 'XXXXXXXXXXXXXXXXXXX'; 
        server = 'https://api.tdameritrade.com/v1/';
    end

    methods
        %% GetAccessToken: Refreshes Access Token                        %%
        function responseGAT = GetAccessTokenTDA(tdapi) 
            tokenList = readtable('Trading/APIs/TDAPI/tl.xlsx','ReadVariableNames',true); %make sure only one copy of tl.xlsx
            if tokenList.refreshTokenExpir(end) < datetime('now')
                responseGAT = 'refresh'; %refresh token needs to be updated
            elseif tokenList.accTokenExpir(end) > datetime('now')
                responseGAT = 'valid'; %token not expired yet
            else %request new access token
                uri = [tdapi.server,'oauth2/token'];
                options = weboptions('RequestMethod','post','HeaderFields',... 
                    {'Content-Type' 'application/x-www-form-urlencoded'});
                responseGAT = webwrite(uri,options,'grant_type','refresh_token',...
                    'refresh_token',tokenList.refreshToken{end},'client_id',...
                    tdapi.clientID);
            end
        end
         
        %% GetAccount: Returns Account Field Info                        %%
        function responseGA = GetAccountTDA(tdapi,~) 
            uri = [tdapi.server,'accounts/',tdapi.accountID];
            options = weboptions('RequestMethod','get','HeaderFields',...      
                {'Authorization' ['Bearer ' GetAccessTokenTDA()]});
            responseGA = webread(uri,options);  
        end
        
        %% GetHours: Returns Market Status & Next Open Day               %%
        function responseGH = GetHoursTDA(tdapi,market)
            uri = [tdapi.server,'marketdata/hours?',tdapi.accountID,...
                '&markets=',market,'&date=',datestr(datetime('now'),'YYYY-mm-dd')];
            options = weboptions('RequestMethod','get','HeaderFields',...      
                {'Authorization' ['Bearer ' GetAccessTokenTDA()]});
            responseGH = webread(uri,options); 
        end
        
        %% GetMovers: Returns 10 Most Volatile Equities                  %%
        function responseGM = GetMoversTDA(tdapi,index,direction,changeType)
            uri = [tdapi.server,'marketdata/$',index,'/movers?apikey=',...
                tdapi.clientID,'&direction=',direction,'&change=',changeType];
            options = weboptions('RequestMethod','get','HeaderFields',... 
                {'Authorization' ['Bearer ' GetAccessTokenTDA()]});
            responseGM = webread(uri,options);
        end
        
        %% GetOptionChain: Returns Option Chain                          %%
        function responseGOC = GetOptionChainTDA(tdapi,symbol,conType,daysToExp)
            toDate = char(datetime('now','Format','yyyy-MM-dd') + str2double(daysToExp));
            uri = [tdapi.server,'marketdata/chains?apikey=',tdapi.clientID,...
                '&symbol=',symbol,'&contractType=',conType,'&includeQuotes=TRUE'...
                '&strategy=SINGLE&toDate=',toDate];
            options = weboptions('RequestMethod','get','HeaderFields',... 
                {'Authorization' ['Bearer ' GetAccessTokenTDA()]});
            responseGOC = webread(uri,options);
        end
        
        %% GetOrder: Returns Specified Order Details                     %%
        function responseGO = GetOrderTDA(tdapi,confNum)
            uri = [tdapi.server,'accounts/',tdapi.accountID,'/orders/',confNum];
            options = weboptions('RequestMethod','get','HeaderFields',... 
                {'Authorization' ['Bearer ' GetAccessTokenTDA()]});
            responseGO = webread(uri,options);
        end
        
        %% GetOrderLast: Returns Last Filled Order Details               %%
        function responseGOL = GetOrderLastTDA(tdapi)
            uri = [tdapi.server,'/orders?accountId=',tdapi.accountID,'&maxResults=100'];
            options = weboptions('RequestMethod','get','HeaderFields',... 
                {'Authorization' ['Bearer ' GetAccessTokenTDA()]});
            responseGOL = webread(uri,options);
        end
        
        %% GetPriceHistory: Returns Historical Price Series for Symbol   %%
        function responseGPH = GetPriceHistoryTDA(tdapi,symbol,periodType,period,freqType,freq,extHrs)
            uri = [tdapi.server,'marketdata/',symbol,'/pricehistory?apikey='...
                tdapi.clientID,'&periodType=',periodType,'&period=',period,...
                '&frequencyType=',freqType,'&frequency=',freq,...
                '&needExtendedHoursData=',extHrs];
            options = weboptions('RequestMethod','get','HeaderFields',... 
                {'Authorization' ['Bearer ' GetAccessTokenTDA()]});
            responseGPH = webread(uri,options);
        end
        
        %% GetQuotes: Returns Current Quote for Symbol(s)                %%
        function responseGQ = GetQuotesTDA(tdapi,symbol)
            uri = [tdapi.server, 'marketdata/quotes?symbol=',symbol];
            options = weboptions('RequestMethod','get','HeaderFields',... 
                {'Authorization' ['Bearer ' GetAccessTokenTDA()]});
            responseGQ = webread(uri,options);
        end
        
        %% GetStreamingKey: Returns Key for Streaming Services           %%
        function responseGSK = GetStreamingKeyTDA(tdapi)
            uri = [tdapi.server,'userprincipals/streamersubscriptionkeys?'...
                'accountIds=',tdapi.accountID];
            options = weboptions('RequestMethod','get','HeaderFields',... 
                {'Authorization' ['Bearer ' GetAccessTokenTDA()]});
            responseGSK = webread(uri,options);
        end
        
        %% PlaceOrderMarket: Sends Market Order                          %%
        function responsePOM = PlaceOrderMarketTDA(tdapi,symbol,buySell,shares)
            uri = [tdapi.server,'accounts/',tdapi.accountID,'/orders'];

            inst = struct('symbol',symbol,'assetType','EQUITY');
            olc = struct('instruction',buySell,'quantity',shares,'instrument',inst);
            body = struct('orderType','MARKET','session','NORMAL','duration',...
                'DAY','orderStrategyType','SINGLE','orderLegCollection',olc);
          
            body.orderLegCollection = {body.orderLegCollection}; %added 4.16.20
            options = weboptions;
            options.MediaType = 'application/json';
            options.RequestMethod = 'post';
            options.HeaderFields = {'Authorization' ['Bearer ' GetAccessTokenTDA()]};
            responsePOM = webwrite(uri,body,options);
            
            %options = weboptions('RequestMethod','post','HeaderFields',... 
            %        {'MediaType' 'application/json'});
        end
        
        %% PlaceOrderLimit: Sends Limit Order                            %%
        function responsePOL = PlaceOrderLimitTDA(tdapi,symbol,assetType,buySell,shares,limit)
            uri = [tdapi.server,'accounts/',tdapi.accountID,'/orders'];

            inst = struct('symbol',symbol,'assetType',assetType);
            olc = struct('instruction',buySell,'quantity',shares,'instrument',inst);
            body = struct('complexOrderStrategyType','NONE','orderType','LIMIT',...
                'session','NORMAL','price',limit,'duration','DAY',...
                'orderStrategyType','SINGLE','orderLegCollection',olc);
          
            body.orderLegCollection = {body.orderLegCollection}; %added 4.16.20
            options = weboptions;
            options.MediaType = 'application/json';
            options.RequestMethod = 'post';
            options.HeaderFields = {'Authorization' ['Bearer ' GetAccessTokenTDA()]};
            responsePOL = webwrite(uri,body,options);
        end
        
    end
end

function [status, closingTime] = GetHoursTDA(market)
%% Checks if Requested Market is Closed Due to Holiday or Weekend
%  v1.1 01/11/21: Updated to class tdapi 
%  v1.0 01/22/20: Initial release.
%  
%  Returns status of 1 if equity market is open. Also returns closing time.
%  Default return is equity market. Additional supported markets: Option,
%  Index Option, Bond, Forex.
%  
%  Ex: status = GetHoursTDA('index option');
%      [status, bondHrs] = GetHoursTDA('bond')
%  
%  TO DO: 1) Add futures support for each futures product market
%% Call Classs TDAPI
market = upper(char(market));
if market == "INDEX OPTION" || market == "OPTIONS"
    market = 'OPTION';
end
responseGH = GetHoursTDA(tdapi,market); %calls class

%% Process Raw Response
fn1 = fieldnames(responseGH); %determine market/fieldname
switch market
    case 'OPTION', fn2 = 'option';
    case 'INDEX OPTION'; fn2 = 'IND';
    case 'BOND', fn2 = 'BON';  
    case 'FOREX', fn2 = 'forex';
    case 'EQUITY', fn2 = 'EQ';
end
status = responseGH.(fn1{1}).(fn2).isOpen;
if status == 1
    closingTime = responseGH.(fn1{1}).(fn2).sessionHours.regularMarket.end;
else
    closingTime = 'Market Closed.';
end
end
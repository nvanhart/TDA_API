function data = GetMoversTDA(index,direction,changeType)
%% Fetches top 10 movers for the day
%  v1.1 01/11/21: Updated to class tdapi
%  v1.0 10/28/20: Initial release.
%
%  Top movers function to retrieve top 10 daily most volatile equities.
%
%  Input Variable Key (type=string):
%  Index: COMPX, DJI, SPX.X
%  Direction: up, down
%  ChangeType: percent, value
%  
%  Ex: todaysMovers = GetMoversTDA('SPX.X','up','value')
%  
%  TO DO: 1)
%% Format Vars, Call Class TDAPI
index = urlencode(upper(char(index)));
direction = lower(char(direction));
changeType = lower(char(changeType));
responseGM = GetMoversTDA(tdapi,index,direction,changeType);

%% Format Raw Data
if isempty(responseGM)
    data = [];
    disp('Movers unavailable.')
    return
end
%% Format Raw Data

s = {responseGM.symbol};
symbol = strings(size(s))';
for i = 1:length(symbol)
    symbol(i) = char(s{i});
end
last = vertcat(responseGM.last);
change = vertcat(responseGM.change);

movers =  table(symbol,last,change);
data = sortrows(movers,3); %sorts by change

end
function details = GetOrderTDA(confNum)
%% Fetches Order Details
%  v1.1 01/13/21: Updated to class tdapi
%  v1.0 02/21/20: Initial release
%
%  Input a valid order confirmation number and returns structure object
%  with fill quantity, price, time, etc.
%  
%  Ex: acb_fill = GetOrderTDA(1328405006);
%      
%% Call Class TDAPI
confNum = char(string(confNum));
responseGO = GetOrderTDA(tdapi,confNum);

%% Format Raw Response
details = responseGO; %.orderActivityCollection.executionLegs.price; 


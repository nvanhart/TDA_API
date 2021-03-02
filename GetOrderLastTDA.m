function details = GetOrderLastTDA()
%% Returns Last Submitted Order Info 
%  v1.0 01/13/21: Initial Release. Class TDAPI support.
%
%  GetOrderLast fetches last submitted order & returns structure w fields.
%
%  Ex: lastOrder = GetOrderLastTDA()
%      confNum = lastOrder.orderId
% 
%  TO DO: 1) update entered time to dispense proper datetime.. not sure why
%            it is in cell format
%
%% Call Class TDAPI
%refDate = char(string(datetime('now','Format','yyyy-MM-dd')));
responseGOL = GetOrderLastTDA(tdapi);

%% Format Raw Response
raw = responseGOL;
orderId = string([raw.orderId]'); %converts to Nx1 array
orderType = {raw.orderType}';
quantity = [raw.quantity]';
filledQuantity = [raw.filledQuantity]';
remainingQuantity = [raw.remainingQuantity]';
price = [raw.price]';
status = {raw.status}';
rawT = {raw.enteredTime}

enteredTime = zeros(length(rawT),1);
for i = 1:length(rawT)
    t = char(string(rawT(i,1)));
    t = datestr(strrep(t(1:end-8),'T',' '))
    enteredTime(i) = datetime(t)
end

details = table(orderId,orderType,quantity,filledQuantity,remainingQuantity,...
    price,status,enteredTime);
details = rawT
end

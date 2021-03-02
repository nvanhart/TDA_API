function data = GetPriceHistoryTDA(symbol,periodType,period,freqType,freq,extHrs)
%% Get Price Series History
%  v1.1 01/10/21: Renamed, added to tdapi class
%  v1.0 01/11/20: Initial release. Note all caps on ticker
%  
%  GetPriceHistory returns the following outputs in table format:
%  timeStamp,open, high, low, close, volume
%  
%  Supported Fields Table
%
%  periodType |      period      |      freqType        |     freq
%  -----------------------------------------------------------------------
%  day        | 1,2,3,4,5,10     | minute               | 1,5,10,15,30
%  month      | 1,2,3,6          | daily,weekly         | 1
%  year       | 1,2,3,5,10,15,20 | daily,weekly,monthly | 1
%  ytd        | 1                | daily,weekly         | 1
%  
%  Ex: SPY = GetPriceHistoryTDA('SPY','day',1,'minute',1,0)
%      One day period of one minute frequency, non-extended hours SPY
%      price series data
%% Format Input Vars, Call Class TDAPI
symbol = upper(char(symbol));
periodType = lower(char(periodType));
period = char(string(period));
freqType = lower(char(freqType));
freq = char(string(freq));
if extHrs > 0
    extHrs = 'true';
else
    extHrs = 'false';
end
responseGPH = GetPriceHistoryTDA(tdapi,symbol,periodType,period,freqType,freq,extHrs);

%% Format Raw Response Data
raw = responseGPH.candles;
open = zeros(size(raw));
high = zeros(size(raw));
low = zeros(size(raw));
close = zeros(size(raw));
volume = zeros(size(raw));
date = zeros(size(raw));

for i = 1:length(raw)
    open(i) = raw(i).open;
    high(i) = raw(i).high;
    low(i) = raw(i).low;
    close(i) = raw(i).close;
    volume(i) = raw(i).volume;
    date(i) = raw(i).datetime/1000; %not sure why TDA adds extra zeros
end
date = datetime(date,'ConvertFrom','PosixTime','Format','MM-dd-yyyy HH:mm',...
    'TimeZone','America/New_York');
data = table(date,open,high,low,close,volume);
end
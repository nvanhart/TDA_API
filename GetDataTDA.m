function data = GetDataTDA(ticker,periodType,period,freqType,freq,extHours)
%% Fetches historic data from TDA.
%  1.11.20 Works fine. No issues. Note all caps on ticker.
%  Supported periods/frequencies:
%
%  Periods:
%  day (1,2,3,4,5,10); month (1,2,3,6), year (1,2,3,5,10,15,20), ytd
%
%  Supported Frequencies:
%  day (minute 1,5,10,15,30), month (daily,weekly 1), 
%  year (daily,weekly,monthly 1), ytd (daily,weekly 1)
%  
%  Ex: US_Steel = GetDataTDA('X','month',6,'daily',1,'true')
%      Historic data for US Steel over the past six months, where each
%      candle represents one day and includes extended hours data.
%% Fetch quote
apikey = 'XXXXXXXXXXXXXXXXXXXXXX';
uri = ['https://api.tdameritrade.com/v1/marketdata/%s/pricehistory?apikey=%s'...
      '&periodType=%s&period=%d&frequencyType=%s&frequency=%d&needExtendedHoursData=%s'];
uri = sprintf(uri,ticker,apikey,periodType,period,freqType,freq,extHours);
accessToken = GetAccessToken();
options = weboptions('Timeout',10);
options.HeaderFields = {'Authorization' ['Bearer ' accessToken]};
raw = webread(uri,options)
raw = raw.candles

%% Format Raw Data
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
date = datetime(date,'ConvertFrom','PosixTime','Format','dd-MMM-yyyy');

data = table(date,open,high,low,close,volume);
end
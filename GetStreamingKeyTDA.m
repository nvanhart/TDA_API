function key = GetStreamingKeyTDA()
%% Fetches streamer key to stream real time & level 2 data
%  v1.1 01/11/21: Updated to class tdapi
%  v1.0 10/28/20: Initial release
%  
%  Gets streaming key for streaming services. Need to develop functions
%  from this api. Please share if you have developed these already. Thanks!
%
%  https://developer.tdameritrade.com/content/streaming-data#_Toc504640578 
%  https://tda-api.readthedocs.io/en/stable/streaming.html
%  
%  Ex: key = GetStreamingKeyTDA()
%% Call Class TDAPI
responseGSK = GetStreamingKeyTDA(tdapi);

%% Format Raw Response
if isempty(responseGSK)
    key = [];
    disp('Key unavailable.')
else
    key = responseGSK.keys.key;
end
end
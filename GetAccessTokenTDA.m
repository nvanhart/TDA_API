function AccessToken = GetAccessTokenTDA()
%% Writes a single new token; dispenses access token as output
%  v3.4 02/07/21: Defined correct filepath for token list
%  v3.3 01/10/21: Updated to incorporate tdapi class
%  v3.2 01/08/21: Functional. Manual update after 3 months
%  v3.1 04/01/20: Refresh token expire, date check update to <= to exp date
%  
%  Uses valid refresh token to retrieve new access token. Access tokens are
%  valid for 30 minutes (1800s). If refresh token is >80 days old, a new 
%  refresh token must be retrieved. 
% 
%  TO DO: 1) Create refresh token call
%  
%  Ex: token = GetAccessTokenTDA()
%% Call TDAPI
responseGAT = GetAccessTokenTDA(tdapi); %calls class

%% Process Raw Response
if isstruct(responseGAT)
    tokenList = readtable('Trading/APIs/TDAPI/tl.xlsx','ReadVariableNames',true); %use your own file path
    refreshTokenExpir = tokenList.refreshTokenExpir(end);
    accTokenNum = tokenList.accTokenNum(end) + 1; %updates total access tokens requested
    accTokenExpir = datetime('now') + seconds(1800); %defines access token expiration
    refreshToken = tokenList.refreshToken(end);
    accessToken = cellstr(responseGAT.access_token); 
    scope = cellstr(responseGAT.scope);
    newLine = table(refreshTokenExpir,accTokenNum,accTokenExpir,...
              refreshToken,accessToken,scope);        
    tokenList = [tokenList;newLine];
    writetable(tokenList,'Trading/APIs/TDAPI/tl.xlsx','FileType','spreadsheet'); 
    AccessToken = char(accessToken);
    
elseif char(responseGAT) == "valid"
    tokenList = readtable('Trading/APIs/TDAPI/tl.xlsx','ReadVariableNames',true);
    AccessToken = tokenList.accessToken{end};
    
end
%% Get New Refresh Token Scenario
authID = 'XXXXXXXXXXXXXXXXX@AMER.OAUTHAP'; %specific for refresh token - use your own
redirectURI = 'https://127.0.0.1'; %for refresh token - use your own

%if <5 days can refresh via cmd line?
%       manually get authCode for now - below may need to be urlencoded
%       body = struct('grant_type','authorization_code','access_type','offline',...
%                     'code',authCode,'client_id',authID,'redirect_uri',redirectURI);
%    command = 'curl -X POST --header "Content-Type: application/x-www-form-urlencoded" -d "grant_type=refresh_token&refresh_token=%s&access_type=offline&code=&client_id=XXXXXXXXXXXXXXXXXXX%40AMER.OAUTHAP&redirect_uri=" "https://api.tdameritrade.com/v1/oauth2/token"'; %specific url - use your own authID again
%    command = sprintf(command,urlencode(refreshToken)) %url encoded here
%    rawRT = char(regexp(cmdout,'refresh_token" : ".*scope','match'));
%    refreshToken = string(rawRT(19:end-11));
%    rawAT = char(regexp(cmdout,'access_token" : ".*refresh_token"','match'));
%    rawAccessToken = string(rawAT(18:end-20)); %removes extra characters
%else
end

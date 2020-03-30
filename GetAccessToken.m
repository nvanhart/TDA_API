function token = GetAccessToken()
%% Writes a single new token; dispenses access token as output
%  Version 3.0: 12.31.19
%  
%  Uses valid refresh token to retrieve new access token. If refresh token
%  is greater than 85 days old, a new refresh token is retrieved. Access
%  tokens are valid for 30 minutes. 
%  
%  Ex: token = GetToken()
%% Universality Check
if computer == "MACI64"
    tokenPath = '/Users/github_rep/TDA_API/tl.xlsx';
else
    tokenPath = "C:\\Users\\gitbhub_rep\\TDA_API\\tl.xlsx";
end
%% Check refresh token
tokenList = readtable(tokenPath,'ReadVariableNames',true);

if day(tokenList.refreshDate(end)) == day(datetime('now'))
    command = 'curl -X POST --header "Content-Type: application/x-www-form-urlencoded" -d "grant_type=refresh_token&refresh_token=%s&access_type=offline&code=&client_id=XXXXXXXXXXXXXXXXXXX%%40AMER.OAUTHAP&redirect_uri=" "https://api.tdameritrade.com/v1/oauth2/token"';
    command = sprintf(command,urlencode(oldToken)) %url encoded here
    [~,cmdout] = system(command) %command line prompt

    tokenNumber = tokenList.tokenNumber(end) + 1;
    refreshDate = tokenList.refreshDate(end) + 85;
    rawRT = char(regexp(cmdout,'refresh_token" : ".*scope','match'));
    refreshToken = string(rawRT(19:end-11));
    rawAT = char(regexp(cmdout,'access_token" : ".*refresh_token"','match'));
    accessToken = string(rawAT(18:end-20)); %removes extra characters
    newTokens = table(tokenNumber,refreshDate,refreshToken,accessToken);
    tokenList = [tokenList; newTokens];
    writetable(tokenList,tokenPath,'FileType','spreadsheet'); %writes new tokens
else
    refreshToken = char(tokenList.refreshToken(end));
    options = weboptions;
    options.ContentType = 'text';
    options.MediaType = 'application/x-www-form-urlencoded';
    options.RequestMethod = 'post';
    clientID = 'XXXXXXXXXXXXXXXXXX';
    response = webwrite('https://api.tdameritrade.com/v1/oauth2/token',... 
                        'grant_type','refresh_token','refresh_token',...
                        refreshToken,'client_id',clientID);
    tokenNumber = tokenList.tokenNumber(end);
    refreshDate = tokenList.refreshDate(end);
    refreshToken = cellstr(tokenList.refreshToken(end));
    accessToken = cellstr(response.access_token);
    newToken = table(tokenNumber,refreshDate,refreshToken,accessToken);
    tokenList = [tokenList; newToken];
    writetable(tokenList,tokenPath,'FileType','spreadsheet'); %writes new token
end
token = char(accessToken);
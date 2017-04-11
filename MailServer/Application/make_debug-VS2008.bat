path %path%;C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE

                                                                                 
devenv.com ..\ServerAPI\API\ServerAPI.csproj /rebuild "Debug"
devenv.com ..\ServerAPI\API_XML\xml_API.csproj /rebuild "Debug"
rem devenv.com ..\ServerAPI\API_MSSQL\mssql_API.csproj /rebuild "Debug"
rem devenv.com ..\ServerAPI\API_PGSQL\pgsql_API.csproj /rebuild "Debug"
devenv.com ..\MailServer\lsMailServer.csproj /rebuild "Debug"
devenv.com ..\MailServerService\MailServerService.csproj /rebuild "Debug"

devenv.com ..\MailServerConfiguration\MailServerConfiguration.csproj /rebuild "Debug"
devenv.com ..\ServerAPI\UserAPI\UserAPI\UserAPI.csproj /rebuild "Debug"

devenv.com ..\MailServerManager\MailServerManager.csproj /rebuild "Debug"

devenv.com ..\Filters\lsDNSBL\lsDNSBL_Filter.csproj /rebuild "Debug"
devenv.com ..\Filters\lsVirusFilter\lsVirusFilter.csproj /rebuild "Debug"

copy ..\version.txt Debug\version.txt
 



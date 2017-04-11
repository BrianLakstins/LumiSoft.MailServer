path %path%;C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE

                                                                                 
devenv.com ..\ServerAPI\API\ServerAPI.csproj /rebuild "release"
devenv.com ..\ServerAPI\API_XML\xml_API.csproj /rebuild "release"
rem devenv.com ..\ServerAPI\API_MSSQL\mssql_API.csproj /rebuild "release"
rem devenv.com ..\ServerAPI\API_PGSQL\pgsql_API.csproj /rebuild "release"
devenv.com ..\MailServer\lsMailServer.csproj /rebuild "release"
devenv.com ..\MailServerService\MailServerService.csproj /rebuild "release"

devenv.com ..\MailServerConfiguration\MailServerConfiguration.csproj /rebuild "release"
devenv.com ..\ServerAPI\UserAPI\UserAPI\UserAPI.csproj /rebuild "release"

devenv.com ..\MailServerManager\MailServerManager.csproj /rebuild "release"

devenv.com ..\Filters\lsDNSBL\lsDNSBL_Filter.csproj /rebuild "Release"
devenv.com ..\Filters\lsVirusFilter\lsVirusFilter.csproj /rebuild "Release"

copy ..\version.txt Release\version.txt
 



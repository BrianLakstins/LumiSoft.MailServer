path %path%;C:\Program Files\Microsoft Visual Studio 9.0\Common7\IDE\

                                                                                 
VCSExpress.exe ..\ServerAPI\API\ServerAPI.csproj /rebuild "Debug"
VCSExpress.exe ..\ServerAPI\API_XML\xml_API.csproj /rebuild "Debug"
rem VCSExpress.exe ..\ServerAPI\API_MSSQL\mssql_API.csproj /rebuild "Debug"
rem VCSExpress.exe ..\ServerAPI\API_PGSQL\pgsql_API.csproj /rebuild "Debug"
VCSExpress.exe ..\MailServer\lsMailServer.csproj /rebuild "Debug"
VCSExpress.exe ..\MailServerService\MailServerService.csproj /rebuild "Debug"

VCSExpress.exe ..\MailServerConfiguration\MailServerConfiguration.csproj /rebuild "Debug"
VCSExpress.exe ..\ServerAPI\UserAPI\UserAPI\UserAPI.csproj /rebuild "Debug"

VCSExpress.exe ..\MailServerManager\MailServerManager.csproj /rebuild "Debug"

devenv.exe ..\Filters\lsDNSBL\lsDNSBL_Filter.csproj /rebuild "Debug"
devenv.exe ..\Filters\lsVirusFilter\lsVirusFilter.csproj /rebuild "Debug"

copy ..\version.txt Debug\version.txt
 



path %path%;C:\Program Files\Microsoft Visual Studio 9.0\Common7\IDE\

                                                            
VCSExpress.exe ..\ServerAPI\API\ServerAPI.csproj /rebuild "Release" 
VCSExpress.exe ..\ServerAPI\API_XML\xml_API.csproj /rebuild "Release"
rem VCSExpress.exe ..\ServerAPI\API_MSSQL\mssql_API.csproj /rebuild "Release"
rem VCSExpress.exe ..\ServerAPI\API_PGSQL\pgsql_API.csproj /rebuild "Release"
VCSExpress.exe ..\MailServer\lsMailServer.csproj /rebuild "Release"
VCSExpress.exe ..\MailServerService\MailServerService.csproj /rebuild "Release"

VCSExpress.exe ..\MailServerConfiguration\MailServerConfiguration.csproj /rebuild "Release"
VCSExpress.exe ..\ServerAPI\UserAPI\UserAPI\UserAPI.csproj /rebuild "Release"

VCSExpress.exe ..\MailServerManager\MailServerManager.csproj /rebuild "Release"

devenv.exe ..\Filters\lsDNSBL\lsDNSBL_Filter.csproj /rebuild "Release"
devenv.exe ..\Filters\lsVirusFilter\lsVirusFilter.csproj /rebuild "Release"

copy ..\version.txt Release\version.txt
del Release\*.pdb


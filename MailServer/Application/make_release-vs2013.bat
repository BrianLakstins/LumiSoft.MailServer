path %path%;C:\Program Files\Microsoft Visual Studio 12.0\Common7\IDE\
path %path%;C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\

                                                            
devenv.exe ..\ServerAPI\API\ServerAPI.csproj /rebuild "Release" 
devenv.exe ..\ServerAPI\API_XML\xml_API.csproj /rebuild "Release"
rem devenv.exe ..\ServerAPI\API_MSSQL\mssql_API.csproj /rebuild "Release"
rem devenv.exe ..\ServerAPI\API_PGSQL\pgsql_API.csproj /rebuild "Release"
devenv.exe ..\MailServer\lsMailServer.csproj /rebuild "Release"
devenv.exe ..\MailServerService\MailServerService.csproj /rebuild "Release"

devenv.exe ..\MailServerConfiguration\MailServerConfiguration.csproj /rebuild "Release"
devenv.exe ..\ServerAPI\UserAPI\UserAPI\UserAPI.csproj /rebuild "Release"

devenv.exe ..\MailServerManager\MailServerManager.csproj /rebuild "Release"

devenv.exe ..\Filters\lsDNSBL\lsDNSBL_Filter.csproj /rebuild "Release"
devenv.exe ..\Filters\lsVirusFilter\lsVirusFilter.csproj /rebuild "Release"

copy ..\version.txt Release\version.txt
del Release\*.pdb

pause


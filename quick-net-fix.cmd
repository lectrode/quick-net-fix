::Quick Net Fix 5.0.356 (DEV)

::Documentation and updated versions can be found at
::https://code.google.com/p/quick-net-fix/

::------------------------
::-       SETTINGS       -
::------------------------

::-Manual Router-
::Examples: 192.168.0.1 or www.google.com or NONE (optional)
::Do NOT include the "HTTP://" portion of the web address
@set manualRouter=

::-Manual Adapter-
::Examples: Wireless Network Connection or ALL (optional)
::Names with special characters (% & ! ^) must be as follows (notice the quotes):
::@set "manualAdapter=N&me with specia! c%aracters"
::NOTE: Names with ^ before another special character cannot be parsed
@set manualAdapter=

::-Filters- (Separate filter keywords with space. Matches are filtered OUT)
@set filterRouters=
@set filterAdapters=Tunnel VirtualBox VMnet VMware Loopback Pseudo Bluetooth Internal

::-GUI-
@set pretty=1
@set theme=subtle			none,subtle,vibrant,fullsubtle,fullvibrant,fullcolor,neon
@set viewmode=normal		mini,normal

::-Updates-
::This script can check for updates only; it does not download or install them
::Setting options: '0' is OFF; '1' is ON
@set check4update=1

::-User Interaction-
::Setting fullAuto to 1 will omit all user input and best guess is made for each decision;
::if 'requestDisableIPv6' is set to '1', changes that to '0' (auto-reject)
@set fullAuto=0

::Setting requestAdmin to 1 will request admin rights if it doesn't already have them.
::Admin rights are needed to enable/disable the Network Connection
@set requestAdmin=1

::-Advanced-
@set INT_StabilityHistory=25	Default: 25 [number of last tests to determine stblty]
@set INT_flukechecks=7			Default: 7  [test x times to verify result]
@set INT_checkdelay=5			Default: 5  [wait x seconds between connectivity tests]
@set INT_fixdelay=10			Default: 10 [wait x seconds after resetting connection]
@set INT_flukecheckdelay=1		Default: 1  [wait x seconds between fluke checks]
@set INT_timeoutsecs=3			Default: 3  [wait x seconds for timeout]
@set INT_checkrouterdelay=10	Default: 10 [wait x number of connects before verifying router and adapter]

:: --------------------------------------
:: -      DO NOT EDIT BELOW HERE!       -
:: --------------------------------------
@PROMPT=^>&setlocal enabledelayedexpansion enableextensions
%noclose%@set noclose=::&start "" "cmd" /k "%~dpnx0"&exit
@call :init&call :chkRA

:loop
%debgn%call :SETMODECON
set /a c4u+=1&set /a cleanTMPPnum+=1&call :check&call :sleep %INT_checkdelay%&goto :loop

:getNETINFO
setlocal disabledelayedexpansion&set /a net_arrLen+=0
if not %net_arrLen% equ 0 for /l %%n in (1,1,%net_arrLen%) do set net_%%n_cn=&set net_%%n_gw=
set net_arrLen=0&set GNI_NdADR=1
for /f "tokens=*" %%r in ('ipconfig') do set "line=%%r"&call :getNETINFO_parse
for /f "tokens=1* delims==" %%a in ('set net_') do endlocal&set "%%a=%%b"
goto :eof

:getNETINFO_parse
echo "%line%" |FINDSTR /C:"adapter">nul && goto :getNETINFO_parseAdapter
if %GNI_NdADR%==1 goto :eof
echo "%line%" |FINDSTR /C:"disconnected">nul && (set /a net_arrLen-=1&set GNI_NdADR=1&goto :eof)
echo "%line%" |FINDSTR /C:"Default Gateway">nul && goto :getNETINFO_parseRouter
goto :eof

:getNETINFO_parseAdapter
if not "%filterAdapters%"=="" echo "%line%" |FINDSTR /I /L "%filterAdapters%">nul && (set GNI_NdADR=1&goto :eof)
set "line=%line:!=^!%"
setlocal enabledelayedexpansion
set "line=!line:%%=%%%!"
endlocal&set "line=%line%"
set GNI_NdADR=0&set /a net_arrLen+=1&set "line=%line:adapter =:%"
(for /f "tokens=2 delims=:" %%a in ("%line%") do set "net_%net_arrLen%_cn=%%a")&goto :eof

:getNETINFO_parseRouter
if not "%filterRouters%"=="" echo "%line%"|FINDSTR /I /L "%filterRouters%">nul && (set /a net_arrLen-=1&set GNI_NdADR=1&goto :eof)
for /f "tokens=1 delims=%%" %%r in ("%line%") do set "line=%%r"
set line=%line: .=%
set line=%line:Default Gateway :=%
if "%line%"=="" (set /a net_arrLen-=1&set GNI_NdADR=1&goto :eof)
set net_%net_arrLen%_gw=%line: =%&goto :eof

:header
call :stblty_set %ss_STR%&set h_ss_STR=%plainbar%%ss_STR%&set h_ss_STR=!h_ss_STR:0=-!
set h_ss_STR=%h_ss_STR:1==%&set h_ss_STR=!h_ss_STR:2=*!
set h_ss_STR=!h_ss_STR: =%-%!&goto :header_%viewmode%

:header_mini
set /a l_dbl=dbl-1&set h_dbl=&if not !l_dbl! leq 0 set h_dbl=!h_dbl!/%INT_flukechecks%
COLOR %curcolor%&cls&echo  %h_top:~-35%&echo  ^|%ThisTitle:Limited: =%^|
echo  ^| http://electrodexs.net/scripts  ^|&echo. !h_ss_STR:~-%colnum%!
echo. !%h_curADR%!&echo. %curRTR%&echo. Up: %uptime% ^| Fixes: %numfixes%
echo. Last result: %result% %h_dbl%&echo. %status%&goto :eof

:header_normal
COLOR %curcolor%&cls&echo  %h_top:~-50%
echo  ^|     -%ThisTitle:Limited: =%-        ^|
echo  ^|       http://electrodexs.net/scripts           ^|
echo. !h_ss_STR:~-%colnum%!
echo.
if defined h_curADR	echo  Connection: !%h_curADR%!
if defined curRTR	echo  Router:     %curRTR%
if defined uptime	echo  Uptime:     %uptime% [started %GRT_RT% ago]
if defined stblty	echo  Stability:  %stblty%
echo.
if %numfixes% geq 1	echo  Fixes:      %numfixes%
if defined result	echo  Last Test:  %result% %showdbl%
if defined status	echo  Status:     %status%&goto :eof

:stblty_set
if not "%1"=="" set /a ss_tests+=1&set /a ss_val+=%1&shift&goto :stblty_set
set /a ss_over=ss_tests-INT_StabilityHistory&set /a ss_over2=!ss_over!*2
:stblty_loop
if %ss_over% geq 1 set /a ss_tests-=1&set /a ss_over-=1&(for /f "tokens=1" %%n in ("%ss_STR%") do set /a ss_val-=%%n)&&set ss_STR=!ss_STR:~2!&goto :stblty_loop
set /a stblty=100-((ss_val*100)/ss_tests)&set /a ss_valneg=ss_tests-ss_val&set /a stblty+=0&set /a ss_tests+=0&if !stblty! leq 0 set stblty=0
set "stblty=!stblty!%% [!ss_valneg!/%ss_tests%]"
set ss_tests=&set ss_sub=&set ss_val=&goto :eof

:precisiontimer
set id=%1&set var=%2
if /i "%var%"=="start" set %id%_ptsmils=%time:~9,2%&set %id%_ptssecs=%time:~6,2%&set %id%_ptsmins=%time:~3,2%&goto :eof
if /i "%var%"=="halt" set %id%_ptssecs=invalid&goto :eof
if "!%id%_ptssecs!"=="invalid" set %var%=0&goto :eof
set %id%_ptemils=%time:~9,2%&set %id%_ptesecs=%time:~6,2%&set %id%_ptemins=%time:~3,2%
for /f "tokens=1 delims==" %%p in ('set %id%_pt') do if "!%%p:~0,1!"=="0" set %%p=!%%p:~1,1!
if !%id%_ptemils! lss !%id%_ptsmils! set /a %id%_ptemils+=100&set /a %id%_ptesecs-=1
if !%id%_ptesecs! lss !%id%_ptssecs! set /a %id%_ptesecs+=60&set /a %id%_ptemins-=1
if !%id%_ptemins! lss !%id%_ptsmins! set /a %id%_ptemins+=60
set /a %var%=(%id%_ptemils-%id%_ptsmils)+((%id%_ptesecs-%id%_ptssecs)*100)+(((%id%_ptemins-%id%_ptsmins)*60)*100)
goto :eof

:chkRA
set checkconnects=0&if defined manualRouter if defined manualAdapter goto :eof
set status=Verify Router/Adapter...&%debgn%call :header
call :getNETINFO
set curRTR=&set curADR=&set h_curADR=
if defined manualAdapter call :getRouter
if defined manualRouter call :getAdapter
if "%curRTR%%curADR%"=="" call :getRouterAdapter
goto :eof

:getRouterAdapter
if %net_arrLen%==0 goto :eof
if %net_arrLen%==1 set curRTR=%net_1_gw%&set "curADR=net_1_cn"&set "h_curADR=net_1_cn"&goto :eof
call :ask4NET&goto :eof

:getRouter
set "curADR=manualAdapter"&set "h_curADR=manualAdapter"
if /i "%manualAdapter%"=="all" set curADR=&set h_curADR=allAdapters
if %net_arrLen%==0 goto :eof
if %net_arrLen%==1 set curRTR=%net_1_gw%&goto :eof
for /l %%n in (1,1,%net_arrLen%) do if "%manualAdapter%"=="!net_%%n_cn!" set curRTR=!net_%%n_gw!
if "%curRTR%"=="" call :Ask4NET router
goto :eof

:getAdapter
set curRTR=%manualRouter%
if /i "%manualRouter%"=="none" set curRTR=
if %net_arrLen%==0 goto :eof
if %net_arrLen%==1 set curADR=net_1_cn&goto :eof
for /l %%n in (1,1,%net_arrLen%) do if "%manualRouter%"=="!net_%%n_gw!" set "curADR=net_%%n_cn"&set "h_curADR=net_%%n_cn"
if "%curADR%"=="" call :Ask4NET adapter
if /i "%manualAdapter%"=="all" set curADR=&set h_curADR=allAdapter
goto :eof

:check
@set status=Testing connectivity...
%debgn%call :header
set ping_test=&set result=&set testrouter=%testSite%
if not "%curRTR%"=="" if %dbl% equ 0 set "testrouter=%curRTR%"
if not "%manualRouter%"=="" set "testrouter=%curRTR%"

for /f "tokens=* delims=" %%p in ('ping -w %timeoutmilsecs% -n 1 "%testrouter%"') do set "ping_test=!ping_test! %%p"
echo "%ping_test%" |FINDSTR /C:"bytes=32" >nul && (set result=Connected&set chkresup=&set chkresdn=::)
echo "%ping_test%" |FINDSTR /C:"request could not find" /C:"Unknown host" /C:"unreachable" /C:"General failure" >nul
if %errorlevel% equ 0 set result=NotConnected&set chkresup=::&set chkresdn=
if "%result%"=="" set result=TimeOut&set chkresup=::&set chkresdn=

if not "%lastresult%"=="%result%" set /a timepassed/=2&if !timepassed! leq 0 set timepassed=1
%chkresup%set /a checkconnects+=1&set /a up+=timepassed&set curcolor=%norm%&set ss_STR=%ss_STR% 0
%chkresup%set lastresult=up&if "%resetted%"=="1" set /a numfixes+=1&set resetted=0
%chkresdn%set /a down+=timepassed&set curcolor=%warn%&set ss_STR=%ss_STR% 1&if not %dbl%==0 call :testSite_set
%chkresdn%set lastresult=dn&if "%result%"=="TimeOut" set /a down+=INT_timeoutsecs

set timepassed=0&if %dbl% gtr 0 set showdbl=(fluke check %dbl%/%INT_flukechecks%)
set /a dbl+=1&call :set_uptime
if "%result%"=="NotConnected" call :c_enabled
if %lastresult%==dn if not %dbl% gtr %INT_flukechecks% call :sleep %INT_flukecheckdelay%&goto :check
if %lastresult%==dn if %dbl% gtr %INT_flukechecks% call :resetConnection
set dbl=0&set showdbl=&goto :eof

:c_enabled
if "%isAdmin%"=="0" goto :eof
if "%curADR%"=="" goto :eof
ipconfig |FINDSTR /C:"adapter !%curADR%!:">nul && goto :eof
@set status=Enabling adapter...&set curcolor=%pend%&%debgn%call :header
%no_netsh%call :rset_netsh enable %curADR% && goto :c_e_success
%no_wmic%call :rset_wmic enable %curADR% && goto :c_e_success
%no_temp%%no_cscript%call :rset_vbs enable %curADR%&goto :c_e_success
goto :eof
:c_e_success
set resetted=1&set ss_STR=%ss_STR% 2&call :sleep %INT_fixdelay%&goto :eof

:testSite_set
%sSR_init%set sSR_addr=www.google.com;www.ask.com;www.yahoo.com;www.bing.com&set sSR_init=::
for /f "tokens=%sSR_num% delims=;" %%r in ("%sSR_addr%") do set testSite=%%r
if "%testSite%"=="" set sSR_num=1&goto :testSite_set
set /a sSR_num+=1&goto :eof

:sleep
call :precisiontimer SLP start&if "%1"=="" set pn=3
if not "%1"=="" set pn=%1&if !pn! equ 0 goto :eof
%no_temp%if not "%checkconnects%"=="force" if %cleanTMPPnum% geq 20000 (call :cleanTMPP&set cleanTMPPnum=0)
if not "%checkconnects%"=="force" if %c4u% geq %c4u_max% call :check4update&set /a pn-=tot
if "%checkconnects%"=="force" call :chkRA&set /a pn-=tot
if "%result%"=="Connected" if %checkconnects% geq %INT_checkrouterdelay% call :chkRA&set /a pn-=tot
@set status=Wait %pn% seconds...&%debgn%call :header
set /a pn+=1&ping -n !pn! -w 1000 127.0.0.1>nul
call :precisiontimer SLP timepassed&set /a timepassed/=100&goto :eof

:SETMODECON
if /i "%viewmode%"=="mini" set cols=37&set lines=10
if /i "%viewmode%"=="normal" set cols=52&set lines=14
if /i "%viewmode%"=="details" set cols=80&set lines=28
if not "%1"=="" set cols=%1&set lines=%2
if not "%pretty%"=="1" set cols=80&set lines=900
MODE CON COLS=%cols% LINES=%lines%&goto :eof

:set_uptime
if %up% geq 100000 set /a up=up/10&set /a down=down/10
set /a uptime=((up*10000)/(up+down))>nul 2>&1
set /a uptime+=0&set uptime=!uptime:~0,-2!.!uptime:~-2!%%
call :getruntime&goto :eof

:getruntime
%toolong%
if "%GRT_s_year%"=="" goto :getruntime_init
set GRT_c_year=%DATE:~10,4%&set GRT_c_month=%DATE:~4,2%&set GRT_c_day=%DATE:~7,2%
set GRT_c_hour=%TIME:~0,2%&set GRT_c_min=%TIME:~3,2%&set GRT_c_sec=%TIME:~6,2%
for /f "tokens=1 delims==" %%a in ('set GRT_c_') do if "!%%a:~0,1!"=="0" set /a %%a=!%%a:~1,1!+0
set GRT_MO_2=28&set /a GRT_leapyear=GRT_c_year*10/4
if %GRT_leapyear:~-1% equ 0 set GRT_MO_2=29
set /a GRT_lastmonth=GRT_c_month-1
if %GRT_c_month% lss %GRT_s_month% set /a GRT_c_month+=12&set /a GRT_c_year-=1
if %GRT_c_day% lss %GRT_s_day% set /a GRT_c_day+=GRT_MO_%GRT_lastmonth%&set /a GRT_c_month-=1
if %GRT_c_hour% lss %GRT_s_hour% set /a GRT_c_hour+=24&set /a GRT_c_day-=1
if %GRT_c_min% lss %GRT_s_min% set /a GRT_c_min+=60&set /a GRT_c_hour-=1
if %GRT_c_sec% lss %GRT_s_sec% set /a GRT_c_sec+=60&set /a GRT_c_min-=1
set /a GRT_c_year=GRT_c_year-GRT_s_year
set /a GRT_c_month=GRT_c_month-GRT_s_month
set /a GRT_c_day=GRT_c_day-GRT_s_day
set /a GRT_c_hour=GRT_c_hour-GRT_s_hour
set /a GRT_c_min=GRT_c_min-GRT_s_min
set /a GRT_c_sec=GRT_c_sec-GRT_s_sec
for /f "tokens=1 delims==" %%a in ('set GRT_c_') do if !%%a! leq 0 set /a %%a=0
if %GRT_c_min% leq 9 set GRT_c_min=0%GRT_c_min%
if %GRT_c_sec% leq 9 set GRT_c_sec=0%GRT_c_sec%
if %GRT_c_year% geq 10000 set GRT_RT=Over 10,000 years&set toolong=goto :eof&goto :eof
set GRT_RT=%GRT_c_hour%:%GRT_c_min%:%GRT_c_sec%
if %GRT_c_year% neq 0 set GRT_RT=%GRT_c_year%y %GRT_c_month%m %GRT_c_day%d %GRT_RT%&goto :eof
if %GRT_c_month% neq 0 set GRT_RT=%GRT_c_month%m %GRT_c_day%d %GRT_RT%&goto :eof
if %GRT_c_day% neq 0 set GRT_RT=%GRT_c_day%d %GRT_RT%
goto :eof
:getruntime_init
set GRT_s_year=%DATE:~10,4%&set GRT_s_month=%DATE:~4,2%&set GRT_s_day=%DATE:~7,2%
set GRT_s_hour=%TIME:~0,2%&set GRT_s_min=%TIME:~3,2%&set GRT_s_sec=%TIME:~6,2%
for /f "tokens=1 delims==" %%a in ('set GRT_s_') do if "!%%a:~0,1!"=="0" set /a %%a=!%%a:~1,1!+0
set GRT_MO_1=31&set GRT_MO_3=31&set GRT_MO_4=30&set GRT_MO_5=31
set GRT_MO_6=30&set GRT_MO_7=31&set GRT_MO_8=31&set GRT_MO_9=30
set GRT_MO_10=31&set GRT_MO_11=30&set GRT_MO_12=31&goto :eof

:EnumerateAdapters
setlocal disabledelayedexpansion&set adapters_arrLen=0
%no_wmic%call :antihang 20 wmicnetadapt wmic.exe nic get NetConnectionID || goto :EA_alt
%no_wmic%%no_temp%for /f "usebackq tokens=* delims=" %%n in ("%TMPP%\wmicnetadapt%CID%") do set "line=%%n"&call :EA_parse wmic
%no_wmic%if "%no_temp%"=="::" for /f "tokens=1* delims==" %%n in ('set wmicnetadapt') do set "line=%%o"&call :EA_parse wmic
%no_wmic%goto :EA_cleanup
:EA_alt
%no_netsh%for /f "tokens=*" %%n in ('netsh int show int') do set "line=%%n"&call :EA_parse netsh
%no_netsh%for /f "tokens=*" %%n in ('netsh mbn show int') do set "line=%%n"&call :EA_parse mbn
:EA_cleanup
%no_wmic%%no_temp%DEL /F /Q "%TMPP%"\wmicnetadapt%CID% >nul 2>&1
for /f "tokens=1* delims==" %%n in ('set adapters_') do endlocal&set "%%n=%%o"
goto :eof

:EA_parse
if "%line%"=="" goto :eof
if not "%filterAdapters%"=="" echo "%line%"|FINDSTR /I /L "%filterAdapters%">nul && goto :eof
::set "line=%line:^=^^%"
set "line=%line:!=^!%"
setlocal enabledelayedexpansion
set "line=!line:%%=%%%!"
endlocal&set "line=%line%"
goto :EA_parse_%1
:EA_parse_wmic
if "%line%"=="NetConnectionID" goto :eof
set /a adapters_arrLen+=1
set "adapters_%adapters_arrLen%_name=%line%"&goto :eof
:EA_parse_netsh
if "%line:~0,11%"=="Admin State" goto :eof
if "%line:~0,4%"=="----" goto :eof
set /a adapters_arrLen+=1
set EA_tokens=3&(for /f "tokens=2* delims= " %%c in ("%line%") do echo "%%c"|FINDSTR /I /C:"connected" /C:"Unreachable">nul || set EA_tokens=2)
for /f "tokens=%EA_tokens%* delims= " %%c in ("%line%") do set "adapters_%adapters_arrLen%_name=%%d"
goto :eof
:EA_parse_mbn
echo "%line%"|FINDSTR /C:"Name">nul || goto :eof
set /a adapters_arrLen+=1
set "adapters_%adapters_arrLen%_name=%line:*: =%"&goto :eof

:resetConnection
set curcolor=%alrt%&set status=Attempting to fix connection...&set ss_STR=%ss_STR% 2
%debgn%call :header
set resetted=1&if "%curADR%"=="" call :resetConnection_all
if not "%curADR%"=="" call :resetConnection_one
set curcolor=%pend%&call :sleep %INT_fixdelay%&set checkconnects=force&goto :eof

:resetConnection_all
ipconfig /release>nul 2>&1&ipconfig /flushdns>nul 2>&1
%use_admin%call :EnumerateAdapters
%use_admin%%no_netsh%set use_netsh=::&call :rset_netsh disable adapters_1_name && (set use_netsh=&set use_wmic=::&set use_vbs=::)
%use_admin%%no_netsh%%use_netsh%for /l %%n in (1,1,%adapters_arrLen%) do call :rset_netsh disable adapters_%%n_name&call :rset_netsh enable adapters_%%n_name
%use_admin%%no_wmic%%use_wmic%set use_wmic=::&(call :rset_wmic disable adapters_1_name && (set use_wmic=&set use_vbs=::))
%use_admin%%no_wmic%%use_wmic%for /l %%n in (1,1,%adapters_arrLen%) do call :rset_wmic disable adapters_%%n_name&call :rset_wmic enable adapters_%%n_name
%use_admin%%use_vbs%%no_temp%%no_cscript%for /l %%n in (1,1,%adapters_arrLen%) do call :rset_vbs disable adapters_%%n_name&call :rset_vbs enable adapters_%%n_name
ipconfig /renew>nul 2>&1&goto :eof

:resetConnection_one
ipconfig /release "%curADR%">nul 2>&1
ipconfig /flushdns "%curADR%">nul 2>&1
%use_admin%%no_netsh%set use_netsh=::&(call :rset_netsh disable curADR && (set use_netsh=&set use_wmic=::&set use_vbs=::))
%use_admin%%no_netsh%%use_netsh%call :rset_netsh enable curADR || set use_wmic=
%use_admin%%no_wmic%call :rset_wmic disable curADR && (call :rset_wmic enable curADR&set use_wmic=&set use_vbs=::)
%use_admin%%use_vbs%%no_temp%%no_cscript%call :rset_vbs disable curADR&call :rset_vbs enable curADR
ipconfig /renew "%curADR%">nul 2>&1&goto :eof

:rset_netsh
netsh int set int "!%2!" admin=%1>nul 2>&1&exit /b !errorlevel!
:rset_wmic
call :antihang 11 null wmic.exe path win32_networkadapter where "NetConnectionID='!%2!'" call %1>nul 2>&1&exit /b !errorlevel!
:rset_vbs
set rs_tf=true&if /I "%1"=="enable" set rs_tf=false
set rs_file=%TMPP%\%1adapter%CID%.vbs
@echo on
@echo Const ssfCONTROLS = 3 '>"%rs_file%"
@echo sEnableVerb = "En&able" '>>"%rs_file%"
@echo sDisableVerb = "Disa&ble" '>>"%rs_file%"
@echo set shellApp = createobject("shell.application") '>>"%rs_file%"
@echo set oControlPanel = shellApp.Namespace(ssfCONTROLS) '>>"%rs_file%"
@echo set oNetConnections = nothing '>>"%rs_file%"
@echo for each folderitem in oControlPanel.items '>>"%rs_file%"
@echo   if folderitem.name = "Network Connections" then '>>"%rs_file%"
@echo         set oNetConnections = folderitem.getfolder: exit for '>>"%rs_file%"
@echo   elseif folderitem.name = "Network and Dial-up Connections" then '>>"%rs_file%"
@echo         set oNetConnections = folderitem.getfolder: exit for '>>"%rs_file%"
@echo end if '>>"%rs_file%"&echo next '>>"%rs_file%"
@echo if oNetConnections is nothing then '>>"%rs_file%"
@echo wscript.quit '>>"%rs_file%"&echo end if '>>"%rs_file%"
@echo set oLanConnection = nothing '>>"%rs_file%"
@echo for each folderitem in oNetConnections.items '>>"%rs_file%"
@echo if lcase(folderitem.name) = lcase("!%2!") then '>>"%rs_file%"
@echo set oLanConnection = folderitem: exit for '>>"%rs_file%"
@echo end if '>>"%rs_file%"&echo next '>>"%rs_file%"
@echo Dim objFSO '>>"%rs_file%"&echo if oLanConnection is nothing then '>>"%rs_file%"
@echo wscript.quit '>>"%rs_file%"&echo end if '>>"%rs_file%"
@echo bEnabled = true '>>"%rs_file%"&echo set oEnableVerb = nothing '>>"%rs_file%"
@echo set oDisableVerb = nothing '>>"%rs_file%"
@echo s = "Verbs: " ^& vbcrlf '>>"%rs_file%"
@echo for each verb in oLanConnection.verbs '>>"%rs_file%"
@echo s = s ^& vbcrlf ^& verb.name '>>"%rs_file%"
@echo if verb.name = sEnableVerb then '>>"%rs_file%"
@echo set oEnableVerb = verb '>>"%rs_file%"&echo bEnabled = false '>>"%rs_file%"
@echo end if '>>"%rs_file%"&echo if verb.name = sDisableVerb then '>>"%rs_file%"
@echo set oDisableVerb = verb '>>"%rs_file%"&echo end if '>>"%rs_file%"
@echo next '>>"%rs_file%"&echo if bEnabled = %rs_tf% then '>>"%rs_file%"
@echo o%1Verb.DoIt '>>"%rs_file%"&echo end if '>>"%rs_file%"
@echo wscript.sleep 2000 '>>"%rs_file%"
%debgn%@echo off
call :antihang 25 null cscript.exe //E:VBScript //T:25 //NoLogo "%rs_file%"
DEL /F /Q "%rs_file%">nul 2>&1&exit /b 0

:antihang
set proc=%*&set proc=!proc:%1 %2 =!&set procsuccess=1&set /a ah_maxwait=(%1*10)/4
%no_temp%set temperrfile=%TMPP%\procerrlvl%CID%%RANDOM%&set tempoutfile=%TMPP%\tempoutput%CID%%RANDOM%
%no_temp%set tempoutput= 1^^^>"%tempoutfile%.tmp" 2^^^>^^^>"%temperrfile%.tmp"
%no_temp%set geterrlvl= ^^^& (echo .^^^>^^^>"%temperrfile%.tmp")
%no_temp%start /b "" cmd /c %proc%%tempoutput%%geterrlvl%&set startedproc=::
%startedproc%if "%2"=="null" start /b "" cmd /c %proc%>nul 2>&1&set startedproc=::
%startedproc%for /f "tokens=*" %%n in ('%proc%') do (set "%2!ah_num!=%%n"&set /a ah_num+=1)
%startedproc%set procsuccess=0&goto :antihang_reset
:antihang_wait
set /a waitproc+=1
%procfinished%%no_proclist%call :findprocess %3 && (if %waitproc% leq %ah_maxwait% goto :antihang_wait)
%procfinished%%no_proclist%set procfinished=::&if "%no_temp%"=="::" set procsuccess=0
%no_temp%if not exist "%temperrfile%.tmp" if %waitproc% leq %ah_maxwait% goto :antihang_wait
%no_temp%2>nul TYPE "%temperrfile%.tmp" > "%temperrfile%" || if %waitproc% leq %ah_maxwait% goto :antihang_wait
%no_temp%for /f "usebackq tokens=* delims=" %%t in ("%temperrfile%") do if not "%%t"=="" set "procerr=!procerr!%%t"
%no_temp%if "%procerr%"=="" if %waitproc% leq %ah_maxwait% goto :antihang_wait
%no_temp%if "%procerr%"=="." set procsuccess=0
if "%no_temp%%no_proclist%"=="::::" ping -n %1 127.0.0.1>nul
%no_prockill%if "%no_temp%%no_proclist%"=="::::" (%prockill% %3)>nul 2>&1 || set procsuccess=0
:antihang_reset
%no_prockill%(%prockill% %3)>nul 2>&1
%no_temp%2>nul TYPE "%tempoutfile%.tmp">"%TMPP%\%2%CID%" || if %waitproc% leq %ah_maxwait% goto :antihang_reset
:antihang_cleanup
set /a waitkill+=1&%no_prockill%(%prockill% %3)>nul 2>&1
%no_temp%DEL /F /Q "%TMPP%\procerrlvl%CID%*">nul 2>&1
%no_temp%DEL /F /Q "%TMPP%\null%CID%*">nul 2>&1
%no_temp%DEL /F /Q "%TMPP%\tempoutput%CID%*">nul 2>&1
%no_temp%DIR /B "%TMPP%" 2>nul|FINDSTR /C:"null%CID%" /C:"procerrlvl%CID%" /C:"tempoutput%CID%" >nul 2>&1 && if %waitkill% lss 25 goto :antihang_cleanup
for /f "tokens=1 delims==" %%n in ('set null 2^>nul') do set %%n=
set waitproc=&set waitkill=&set procfinished=&set procerr=&set proc=&set startedproc=&set ah_num=0&exit /b %procsuccess%

:findprocess
%no_tasklist%tasklist /fo:csv|FINDSTR /I /C:"%*">nul && exit /b 0
%no_tasklist%exit /b 1
%no_pslist%set proc=%*&set proc=!proc:~0,-4!
%no_pslist%(pslist -e %proc%)>nul 2>&1 & exit /b !errorlevel!& REM name max 15 char
%no_temp%%no_cscript%@echo on&set foundproc=1&set tempfile=%TMPP%\findproc%CID%
%no_temp%%no_cscript%@echo strComputer=".">"%tempfile%.vbs"
%no_temp%%no_cscript%@echo Set objFSO = CreateObject("Scripting.FileSystemObject")>>"%tempfile%.vbs"
%no_temp%%no_cscript%@echo Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" ^& strComputer ^& "\root\cimv2")>>"%tempfile%.vbs"
%no_temp%%no_cscript%@echo Set colProcessList = objWMIService.ExecQuery("Select * from Win32_Process")>>"%tempfile%.vbs"
%no_temp%%no_cscript%@echo For Each objProcess in colProcessList>>"%tempfile%.vbs"
%no_temp%%no_cscript%@echo If InStr( objProcess.Name , "%*"  ) > 0 Then>>"%tempfile%.vbs"
%no_temp%%no_cscript%@echo Set objFile = objFSO.CreateTextFile("%tempfile%", True)>>"%tempfile%.vbs"
%no_temp%%no_cscript%@echo End If >>"%tempfile%.vbs"
%no_temp%%no_cscript%@echo Next>>"%tempfile%.vbs"
%debgn%%no_temp%%no_cscript%@echo off
%no_temp%%no_cscript%cscript.exe //E:VBScript //B //NoLogo "%tempfile%.vbs"
%no_temp%%no_cscript%if exist "%tempfile%" set foundproc=1
%no_temp%%no_cscript%del /f /q "%tempfile%*">nul 2>&1
%no_temp%%no_cscript%exit /b %foundproc%
%no_tlist%tlist|FINDSTR /I /C:"%*">nul & exit /b !errorlevel!& REM name max 15 char
set no_proclist=::&exit /b 2

:check4update
set c4u=%c4u_max%&set tot=0&if not "%result%"=="Connected" goto :eof
echo "%ss_STR:~-50%"|FINDSTR /C:"2">nul && goto :eof
set c4u=0&if "%h_top:~0,4%"=="____" goto :eof
set status=Checking for updates...&%debgn%call :header
set use_ps=&set use_bits=::&set use_vbs=::
set vurl=http://electrodexs.net/scripts/qNET/cur&set c4u_local=%version:.=%
%no_ps%set pscmd=powershell -c "echo (New-Object System.Text.ASCIIEncoding).GetString((New-Object Net.WebClient).DownloadData('%vurl%'));"
%no_ps%for /f "usebackq tokens=2 delims==" %%v in (`%pscmd%^|FINDSTR "SET %channel%="`) do set "c4u_remote=%%v"&title %ThisTitle%
set /a c4u_remote+=0&if !c4u_remote!==0 set use_bits=&set c4u_file=%TMPP%\c4u%CID%
%no_bits%%no_temp%%use_bits%call :antihang 25 null bitsadmin /transfer "qNET_updatecheck" "%vurl%" "%c4u_file%" && (call :c4u_parse %c4u_file%&set c4u_remote=!%channel%!&del /f /q "%c4u_file%">nul 2>&1)
set /a c4u_remote+=0&if !c4u_remote!==0 set use_vbs=&set c4u_vbs=%TMPP%\c4u%CID%.vbs
%no_cscript%%no_temp%%use_vbs%echo Set mX = CreateObject("Microsoft.XmlHTTP")>"%c4u_vbs%"
%no_cscript%%no_temp%%use_vbs%echo mX.Open "GET", "%vurl%", False>>"%c4u_vbs%"&echo mX.Send "">>"%c4u_vbs%"
%no_cscript%%no_temp%%use_vbs%echo Set objFile = CreateObject("Scripting.FileSystemObject").CreateTextFile("%c4u_file%", True)>>"%c4u_vbs%"
%no_cscript%%no_temp%%use_vbs%echo objFile.Write mX.responseText>>"%c4u_vbs%"
%no_cscript%%no_temp%%use_vbs%call :antihang 25 null cscript.exe //E:VBScript //T:25 //NoLogo "%c4u_vbs%"
%no_cscript%%no_temp%%use_vbs%call :c4u_parse %c4u_file%&del /f /q "%c4u_file%*">nul 2>&1&set "c4u_remote=!%channel%!"
set /a c4u_remote+=0&if !c4u_remote! gtr %c4u_local% set h_top=___________________________________________________________/UPDATE AVAILABLE\ 
goto :eof
:c4u_parse
if exist "%*" for /f "usebackq tokens=2 delims==" %%v in (`FINDSTR /C:"SET %channel%=" "%*"^>nul 2^>^&1`) do set "%channel%=%%v"
goto :eof

:detectIsAdmin
call :iecho Detect Admin Rights...
%no_temp%DEL /F /Q "%TMPP%\getadmin*.vbs">nul 2>&1
for /f "tokens=* delims=" %%s in ('sfc 2^>^&1^|MORE') do @set "output=!output!%%s"
set isAdmin=0&echo "%output%"|findstr /I /C:"/scannow">nul 2>&1 && set isAdmin=1
:dIA_kill
%no_prockill%%no_tasklist%for /f "tokens=2 delims=," %%p in ('tasklist /V /FO:CSV ^|FINDSTR /C:"Limited: %ThisTitle%" 2^>nul') do (%killPID% %%p>nul 2>&1 && goto :dIA_kill)
%no_prockill%%no_tlist%for /f %%p in ('tlist ^|FINDSTR /C:"Limited: %ThisTitle%" 2^>nul') do (%killPID% %%p>nul 2>&1 && goto :dIA_kill)
if %isAdmin%==1 goto :eof
set ThisTitle=Limited: %ThisTitle%&title !ThisTitle!
if not "%requestAdmin%"=="1" goto :eof
%no_winfind%%no_prockill%%no_temp%%no_cscript%echo Set StartAdmin = CreateObject^("Shell.Application"^) > "%TMPP%\getadmin%CID%.vbs"
%no_winfind%%no_prockill%%no_temp%%no_cscript%echo StartAdmin.ShellExecute "%~s0", "", "", "runas", 1 >> "%TMPP%\getadmin%CID%.vbs"
%no_winfind%%no_prockill%%no_temp%%no_cscript%set "ie_last=Requesting Admin Rights...&echo (This will close upon successful request)"&call :iecho
%no_winfind%%no_prockill%%no_temp%%no_cscript%start /b "" cscript //E:VBScript //B //T:1 "%TMPP%\getadmin%CID%.vbs" //nologo
%no_winfind%%no_prockill%%no_temp%%no_cscript%ping -n 11 127.0.0.1>nul&DEL /F /Q "%TMPP%\getadmin%CID%.vbs">nul 2>&1
goto :eof

:Ask4NET
if not "%1"=="adapter" if "%fullAuto%"=="1" set manualRouter=%testSite%&set curRTR=%testSite%
if "%1"=="router" if "%fullAuto%"=="1" goto :eof
if not "%1"=="router" if "%fullAuto%"=="1" set manualAdapter=all&set curADR=&set h_curADR=allAdapter&goto :eof
if "%1"=="adapter" call :EnumerateAdapters
%debgn%set /a lines=%net_arrLen%+11
%debgn%call :SETMODECON 70 %lines%
echo.&echo Which one would you like to monitor?&echo.&echo Choose by the selection number below.
if not "%1"=="router" echo You may also enter x to cancel.
if "%1"=="router" echo You may also type in a router address to use, or x to cancel.
echo.&if not "%1"=="adapter" echo  #     Router Adress                  Associated Connection
if not "%1"=="adapter" echo  ----- ------------------------------ -----------------------------
if not "%1"=="adapter" for /l %%n in (1,1,%net_arrLen%) do set showroutr%%n=[%%n]%statspacer%
if not "%1"=="adapter" for /l %%n in (1,1,%net_arrLen%) do set "showroutr%%n=!showroutr%%n:~0,5! !net_%%n_gw!%statspacer%"
if not "%1"=="adapter" for /l %%n in (1,1,%net_arrLen%) do set "showroutr%%n=!showroutr%%n:~0,36! !net_%%n_cn!%statspacer%"
if not "%1"=="adapter" for /l %%n in (1,1,%net_arrLen%) do echo -!showroutr%%n:~0,68!
if "%1"=="adapter" echo  #     Connection
if "%1"=="adapter" echo  ----- -------------------------------------------
if "%1"=="adapter" for /l %%n in (1,1,%adapters_arrLen%) do set showconn%%n=[%%n]%statspacer%
if "%1"=="adapter" for /l %%n in (1,1,%adapters_arrLen%) do set "showconn%%n=!showconn%%n:~0,5! !adapters_%%n_name!%statspacer%"
if "%1"=="adapter" for /l %%n in (1,1,%adapters_arrLen%) do echo -!showconn%%n:~0,50!
echo.&set usrinput=&set usrinput2=
set /p usrinput=[] 
if "%usrinput%"=="" set usrinput=1
if not "%1"=="adapter" for /l %%n in (1,1,%net_arrLen%) do if "%usrinput%"=="%%n" set curRTR=!net_%%n_gw!
if not "%1"=="adapter" if "%manualAdapter%"=="" for /l %%n in (1,1,%net_arrLen%) do if "%usrinput%"=="%%n" set "curADR=!net_%%n_cn!"
if "%1"=="adapter" for /l %%n in (1,1,%adapters_arrLen%) do if "%usrinput%"=="%%n" set "curADR=!adapters_%%n_name!"
if "%usrinput%"=="x" if not "%1"=="adapter" set curRTR=%testSite%
if "%usrinput%"=="x" if not "%1"=="router" set manualAdapter=all&set curADR=&set h_curADR=allAdapter&goto :eof
if "%1"=="router" if "%curRTR%"=="" cls&echo.&echo.&echo Use "%usrinput%" as router address?
if "%1"=="router" if "%curRTR%"=="" set /p usrinput2=[y/n] 
if "%1"=="router" if "%curRTR%"=="" if "%usrinput2%"=="" set curRTR=%usrinput%
if "%1"=="router" if "%curRTR%"=="" if /i "%usrinput2%"=="y" set curRTR=%usrinput%
if "%1"=="router" if "%curRTR%"=="" goto :Ask4NET
if "%1"=="adapter" if "%curADR%"=="" goto :Ask4NET
if not "%1"=="adapter" set manualRouter=%curRTR%
if not "%1"=="router" set "manualAdapter=%curADR%"&set "h_curADR=%curADR%"
cls&call :SETMODECON&goto :eof

:testValidPATHS
set thisdir=%~dp0&call :iecho Verify Environment Variables...
set tVPS=call :testValidPATHS_SYSTEMROOT &set tVPT=call :testValidPATHS_TEMP 
set PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;%PATHEXT%
%tVPS%%SYSTEMROOT%
%hassys32%%tVPS%%SYSTEMDRIVE%\Windows
%hassys32%%tVPS%%SYSTEMDRIVE%\WINNT
%hassys32%%tVPS%%WINDIR%
%hassys32%%tVPS%%~dp0
%hassys32%echo Required commands not found.&echo Press any key to exit...&pause>nul&exit
attrib /?>nul 2>&1 || set no_attrib=::
%tVPT%%TEMP%
%hastemp%%tVPT%%LOCALAPPDATA%\Temp
%hastemp%%tVPT%%USERPROFILE%\Local Settings\Temp
%hastemp%%tVPT%%APPDATA%
%hastemp%%tVPT%%SYSTEMDRIVE%\Windows\Temp
%hastemp%%tVPT%%SYSTEMDRIVE%\WINNT\Temp
%hastemp%%tVPT%%WINDIR%\Temp
%hastemp%%tVPT%%thisdir:~0,-1%
%hastemp%set no_temp=::
goto :eof
:testValidPATHS_SYSTEMROOT
if "%*"=="" goto :eof
set origPATH=%PATH%
if exist "%*\system32\wbem" set PATH=%*\system32\wbem;%PATH%
if exist "%*\system32" set PATH=%*\system32;%PATH%
if exist "%*\wbem" set PATH=%*\wbem;%PATH%
if exist "%*" set PATH=%*;%PATH%
findstr /?>nul 2>&1 || (set "PATH=%origPATH%"&goto :eof)
set SYSTEMROOT=%*&set WINDIR=%*
set hassys32=::&set origPATH=&goto :eof
:testValidPATHS_TEMP
if "%*"=="" goto :eof
set TMPP=%*\EXSqNET
if not exist "%TMPP%" md "%TMPP%">nul 2>&1
if exist "%TMPP%" type nul>"%TMPP%\RWA%CID%.txt"
DEL /F /Q "%TMPP%\RWA%CID%.txt">nul 2>&1 || goto :eof
%no_attrib%ATTRIB +S +H "%TMPP%"
set hastemp=::&goto :eof

:testCompatibility
call :iecho Test Basic Commands...
ping /?>nul 2>&1 || (echo.&echo Critical error: PING error.&echo Press any key to exit...&pause>nul&exit)
ipconfig >nul 2>&1 || (echo.&echo Critical error: IPCONFIG error.&echo Press any key to exit...&pause>nul&exit)
for %%c in (framedyn.dll) do if "%%~$PATH:c"=="" set no_taskkill=::
set no_kill=::&(kill /?>nul 2>&1 && (set prockill=kill /f&set no_kill=&set killPID=kill))
set no_pskill=::&pskill /?>nul 2>&1& if !errorlevel! equ -1 set prockill=pskill /f&set no_pskill=&set killPID=pskill
set no_tskill=::&(tskill /?>nul 2>&1 && (set no_tskill=&set prockill=tskill&set killPID=tskill))
%no_taskkill%set no_taskkill=::&(taskkill /?>nul 2>&1 && (set no_taskkill=&set prockill=taskkill /f /im&set killPID=taskkill /pid))
if "%prockill%"=="" set no_prockill=::
tlist /?>nul 2>&1 || set no_tlist=::
tasklist /?>nul 2>&1 || set no_tasklist=::
pslist >nul 2>&1 || set no_pslist=::
if "%no_tlist%%no_tasklist%"=="::::" set no_winfind=::
if "%no_tlist%%no_tasklist%%no_pslist%"=="::::::" set no_proclist=::
set no_reg=::&set reg1=::&set reg2=::&(reg /?>nul 2>&1 && set no_reg=&set reg1=)&if !errorlevel!==5005 set no_reg=&set reg2=
cscript /?>nul 2>&1 || set no_cscript=::
goto :eof
:testCompatibility2
bitsadmin /?>nul 2>&1 || set no_bits=::
netsh help >nul 2>&1 || set no_netsh=::
call :iecho Test POWERSHELL...&powershell -?>nul 2>&1 || set no_ps=:: & title %ThisTitle%
call :iecho Test WMIC...&call :antihang 11 null wmic.exe os get status || set no_wmic=::
if "%no_netsh%%no_wmic%"=="::::" (echo.&echo Critical error: This script requires either NETSH or WMIC.&echo Press any key to exit...&pause>nul&exit)
goto :eof

:disableQuickEdit
set qkey=HKEY_CURRENT_USER\Console&set qpro=QuickEdit&call :iecho Check Console Properties...
%no_reg%%reg1%if not "%qedit_val%"=="" ((echo y|reg add "%qkey%" /v "%qpro%" /t REG_DWORD /d %qedit_val%)>nul&goto :eof)
%no_reg%%reg1%for /f "tokens=3*" %%i in ('reg query "%qkey%" /v "%qpro%" ^| FINDSTR /I "%qpro%"') DO (set qedit_val=%%i)&if "!qedit_val!"=="0x0" goto :eof
%no_reg%%reg1%(echo y|reg add "%qkey%" /v "%qpro%" /t REG_DWORD /d 0)>nul&start "" "cmd" /k set CID=%CID%^&set qedit_val=%qedit_val% ^& call "%~dpnx0"&exit
%no_reg%%reg2%if not "%qedit_val%"=="" ((reg update "%qkey%\%qpro%"=%qedit_val%)>nul&goto :eof)
%no_reg%%reg2%for /f "tokens=3*" %%i in ('reg query "%qkey%\%qpro%"') DO (set qedit_val=%%i)&if "!qedit_val!"=="0" pause&goto :eof
%no_reg%%reg2%if "%qedit_val%"=="" (reg add "%qkey%\%qpro%"=0 REG_DWORD>nul&start "" "cmd" /k set CID=%CID%^&set qedit_val=%qedit_val% ^&call "%~dpnx0"&exit)
%no_reg%%reg2%if "%qedit_val%"=="1" ((reg update "%qkey%\%qpro%"=0)>nul&start "" "cmd" /k set CID=%CID%^& call "%~dpnx0"&exit)
%no_regedit%%no_temp%echo REGEDIT4>"%TMPP%\quickedit3%CID%.reg"&(regedit /S "%TMPP%\quickedit3%CID%.reg" || set no_regedit=::)
%no_regedit%%no_temp%DEL /F /Q "%TMPP%\quickedit3%CID%.reg">nul 2>&1
%no_regedit%%no_temp%if exist "%TMPP%\quickedit%CID%.reg" regedit /S "%TMPP%\quickedit%CID%.reg"&DEL /F /Q "%TMPP%\quickedit%CID%.reg"&goto :eof
%no_regedit%%no_temp%regedit /S /e "%TMPP%\quickedit%CID%.reg" "%qkey%"
%no_regedit%%no_temp%echo REGEDIT4>"%TMPP%\quickedit2%CID%.reg"&echo [%qkey%]>>"%TMPP%\quickedit2%CID%.reg"
%no_regedit%%no_temp%(echo "%qpro%"=dword:00000000)>>"%TMPP%\quickedit2%CID%.reg"
%no_regedit%%no_temp%regedit /S "%TMPP%\quickedit2%CID%.reg"&DEL /F /Q "%TMPP%\quickedit2%CID%.reg"&start "" "cmd" /k set CID=%CID%^& call "%~dpnx0"&exit
goto :eof

:crashAlert
@start /b /wait "" "cmd" /c set CID=%CID%^&call "%~dpnx0"
@echo.&echo Script crashed. Please contact ElectrodeXSnet@gmail.com with the information above.&@pause>nul&exit

:init
@call :setn_defaults&call :init_settnBOOL !settingsBOOL!
@if "%pretty%"=="0" set debgn=::
%debgn%@echo off&call :init_colors %theme%
call :init_settnSTR viewmode %viewmode%&set version=5.0.356&set channel=d
echo ";%viewmode%;"|FINDSTR /L ";mini; ;normal;">nul || set viewmode=%D_viewmode%
call :SETMODECON&call :iecho Verify Settings...&%debgn%COLOR %curcolor%
set ThisTitle=Lectrode's Quick Net Fix %channel%%version%&call :init_settnINT %settingsINT%
TITLE %ThisTitle%&if "%CID%"=="" call :init_CID
%alertoncrash%call :testValidPATHS&call :testCompatibility&call :detectIsAdmin&call :disableQuickEdit
%alertoncrash%@set alertoncrash=::&goto :crashAlert
if "%isAdmin%"=="0" set use_admin=::&set thistitle=Limited: %thistitle%&title !thistitle!
call :getruntime&call :testCompatibility2&%no_temp%call :iecho Clean Temp Files...&call :cleanTMPP
call :iecho Initialize Variables...
set statspacer=                                                               .
set plainbar=------------------------------------------------------------------------------
echo ,%requestDisableIPv6%,|FINDSTR /L ",0, ,1, ,2,">nul || set reqeustDisableIPv6=%D_requestDisableIPv6%
set numfixes=0&set up=0&set down=0&set lastResult=up&set /a c4u_max=24*60*60/(INT_checkdelay+1)
set /a c4u=c4u_max-(INT_StabilityHistory+(6*60-INT_StabilityHistory)/(INT_checkdelay+1))
set timepassed=0&set dbl=0&set numAdapters=0&set checkconnects=0
set /a timeoutmilsecs=1000*INT_timeoutsecs&set allAdapter=[Reset All Connections on Error]&set h_top=%plainbar%
set sSR_num=1&call :testSite_set&call :init_manualRouter %manualRouter%
for /f "tokens=1 DELIMS=:" %%a in ("%manualAdapter%") do call :init_manualAdapter %%a
call :init_bar
goto :eof

:iecho
%debgn%@if not "%*"=="" set "ie_last=%*"
%debgn%@cls&echo.&echo Please wait while qNET starts...&echo.&echo.%ie_last%
@goto :eof

:init_CID
%init_CID%setlocal&set charSTR=000000000abcdefghijklmnopqrstuvwxyz1234567890&set CIDchars=0&set init_CID=::
set cidchar=%random:~0,2%&if !cidchar! gtr 45 goto :init_CID
set /a CIDchars+=1&set CID=%CID%!charSTR:~%cidchar%,1!%random:~1,1%
if %CIDchars% lss 3 goto :init_CID
endlocal&set CID=%CID:~0,5%&goto :eof

:cleanTMPP
set day=%DATE:/=-%&cd "%TMPP%"
for /f "tokens=*" %%a IN ('xcopy *.* /d:%day:~4% /L /I null') do @if exist "%%~nxa" set "excludefiles=!excludefiles!;;%%~nxa"
for /f "tokens=*" %%a IN ('dir /b 2^>nul') do @(@echo ";;%excludefiles%;;"|FINDSTR /C:";;%%a;;">nul || if exist "%TMPP%\%%a" DEL /F /Q "%TMPP%\%%a">nul 2>&1)
cd "%~dp0"&goto :eof

:init_settnINT
if "%1"=="" goto :eof
if "!%1!"=="" set %1=D_%1
set /a %1=%1&shift&goto :init_settnINT
:init_settnBOOL
@if "%1"=="" goto :eof
@echo ",!%1!,"|FINDSTR /L ",0, ,1,">nul || set /a %1=D_%1
@shift&goto :init_settnBOOL
:init_settnSTR
if "%2"=="" set %1=!D_%1!&goto :eof
set %1=%2&goto :eof

:init_manualRouter
if not defined manualRouter goto :eof
set curRTR=%manualRouter%
if /I "%manualRouter%"=="none" set curRTR=%testSite%
goto :eof

:init_manualAdapter
if not defined manualAdapter goto :eof
set curADR=manualAdapter&set h_curADR=manualAdapter
if /I "%manualAdapter%"=="all" set curADR=&set h_curADR=allAdapter
goto :eof

:init_bar
set /a colnum=cols-2&set -=
if %colnum% leq %INT_StabilityHistory% goto :eof
set /a numhyp=(colnum/INT_StabilityHistory)-1
:init_bar_loop
if not %numhyp% leq 0 set -=%-%-&set /a numhyp-=1
if %numhyp% gtr 0 goto :init_bar_loop
goto :eof

:init_colors
set theme=%1&echo ",%1,"|FINDSTR /I /L ",mini, ,none, ,subtle, ,vibrant, ,fullsubtle, ,fullvibrant, ,fullcolor, ,neon,">nul || set theme=%D_theme%
set THM_subtle=07 06 04 03
set THM_vibrant=0a 0e 0c 0b
set THM_fullsubtle=20 60 40 30
set THM_fullvibrant=a0 e0 c0 b0
set THM_fullcolor=2a 6e 4c 1b
set THM_neon=5a 9e 1c 5b
if not "%theme%"=="none" for /f "tokens=1-4" %%c in ("!THM_%theme%!") do set norm=%%c&set warn=%%d&set alrt=%%e&set pend=%%f
set curcolor=%norm%&goto :eof

:setn_defaults
@set settingsINT=INT_StabilityHistory INT_flukechecks INT_checkdelay INT_fixdelay INT_flukecheckdelay INT_timeoutsecs INT_checkrouterdelay
@set settingsBOOL=pretty fullAuto requestAdmin check4update
@set D_pretty=1&set D_theme=subtle&set D_viewmode=normal&set D_fullAuto=0
@set D_requestAdmin=1&set D_INT_StabilityHistory=25
@set D_INT_flukechecks=7&set D_INT_flukemaxtime=25&set D_INT_checkdelay=5
@set D_INT_fixdelay=10&set D_INT_flukecheckdelay=1&set D_INT_timeoutsecs=3
@set D_INT_checkrouterdelay=10&set D_check4update=1&goto :eof
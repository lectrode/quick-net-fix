::Quick detect&fix
@set version=4.1.323

:: Documentation and updated versions can be found at
:: https://code.google.com/p/quick-net-fix/

::-Settings-
set manualRouter=			Examples: 192.168.0.1 or www.google.com or NONE (optional)
set manualAdapter=			Examples: Wireless Network Connection or ALL (optional)

set INT_StabilityHistory=25	Default: 25 (number of last tests to determine stability)
set INT_flukechecks=7		Default: 7 (test x times to verify result)
set INT_checkdelay=5		Default: 5 seconds
set INT_fixdelay=10			Default: 10 seconds
set INT_flukecheckdelay=1	Default: 1 seconds
set INT_timeoutsecs=0		Default: 0 (auto) seconds
set INT_checkrouterdelay=0	Default: 0 (auto) (wait x number of connects before verifying router and adapter)

::-Filters- (Separate filter keywords with space. Matches are filtered OUT)
set filterRouters=
set filterAdapters=Tunnel VirtualBox VMnet VMware Loopback Pseudo Bluetooth Internal

::-GUI-
set pretty=1
set theme=subtle			none,subtle,vibrant,fullsubtle,fullvibrant,crazy
set viewmode=normal			mini,normal,details

::-Advanced-
::Setting fullAuto to 1 will omit all user input and best guess is made for each decision.
::If 'requestDisableIPv6' is set to '1', changes that to '0' (auto-reject)
set fullAuto=0

::Setting requestAdmin to 1 will request admin rights if it doesn't already have them.
::Admin rights are needed to enable/disable the Network Connection
set requestAdmin=1

::This script can disable IPv6 if the computer has an excessive number of Tunnel adapters.
::Setting options: 0:auto-reject, 1:ask, 2:auto-accept
set requestDisableIPv6=1



:: -DO NOT EDIT BELOW THIS LINE!-
setlocal enabledelayedexpansion
setlocal enableextensions
set thisdir=%~dp0
call :testValidPATHS
%startpretty%if "%pretty%"=="0" set startpretty=::&start /b "" "cmd" /k "%~dpnx0"&exit /b
call :init
call :checkRouterAdapter

:loop
%debgn%call :SETMODECON
call :check
call :sleep %INT_checkdelay%
goto :loop


:getNETINFO
set /a gNI_arrLen+=0
if not %gNI_arrLen% equ 0 for /l %%n in (1,1,%gNI_arrLen%) do set net_%%n_cn=&set net_%%n_gw=
set gNI_arrLen=0&set gNI_needAdapter=1
for /f "tokens=1 delims=%%" %%r in ('ipconfig') do call :getNETINFO_parse %%r
goto :eof

:getNETINFO_parse
echo %* |FINDSTR /C:"adapter">NUL
if %errorlevel%==0 set line=%*&goto :getNETINFO_parseAdapter
if %gNI_needAdapter%==1 goto :eof
echo %* |FINDSTR /C:"disconnected">NUL
if %errorlevel%==0 set net_%gNI_arrLen%_cn=&set net_%gNI_arrLen%_gw=&set /a gNI_arrLen-=1&set gNI_needAdapter=1&goto :eof
echo %* |FINDSTR /C:"Default Gateway">NUL
if %errorlevel%==0 set line=%*&goto :getNETINFO_parseRouter
goto :eof

:getNETINFO_parseAdapter
if not "%filterAdapters%"=="" echo %line%|FINDSTR /I /L "%filterAdapters%">NUL
if not "%filterAdapters%"=="" if %errorlevel%==0 set gNI_needAdapter=1&goto :eof
set gNI_needAdapter=0&set /a gNI_arrLen+=1&set line=%line:adapter =:%
for /f "tokens=2 delims=:" %%a in ("%line%") do set net_%gNI_arrLen%_cn=%%a
goto :eof

:getNETINFO_parseRouter
if not "%filterRouters%"=="" echo %line%|FINDSTR /I /L "%filterRouters%">NUL
if not "%filterRouters%"=="" if %errorlevel%==0 set net_%gNI_arrLen%_cn=&set net_%gNI_arrLen%_gw=&set /a gNI_arrLen-=1&set gNI_needAdapter=1&goto :eof
set line=%line: .=%
set line=%line:Default Gateway :=%
if "%line%"=="" set net_%gNI_arrLen%_cn=&set net_%gNI_arrLen%_gw=&set /a gNI_arrLen-=1&set gNI_needAdapter=1&goto :eof
set net_%gNI_arrLen%_gw=%line: =%&goto :eof


:header
set show_stbtlySTR=%stbltySTR:0=-%
set show_stbtlySTR=%show_stbtlySTR:1==%
set show_stbtlySTR=%show_stbtlySTR:2=*%
set show_stbtlySTR=%aft-%!show_stbtlySTR: =%-%!
if "%stbltySTR%"=="" set show_stbtlySTR=                                                   -
goto :header_%viewmode%

:header_mini
set /a h_dbl=dbl-1
set dsp_dbl=&if not %h_dbl% leq 0 set dsp_dbl=%h_dbl%/%INT_flukechecks%
cls
COLOR %curcolor%
echo  -----------------------------------
echo  ^|%ThisTitle%^|
echo  ^| http://electrodexs.net/scripts  ^|
echo. !show_stbtlySTR:~-%colnum%!
echo. %show_cur_ADAPTER%
echo. %cur_ROUTER%
echo. Up: %uptime% ^| Fixes: %numfixes%
echo. Last result: %lastresult% %dsp_dbl%
echo. %curstatus%
goto :eof

:header_normal
cls
COLOR %curcolor%
echo  --------------------------------------------------
echo  ^|     -%ThisTitle%-        ^|
echo  ^|       http://electrodexs.net/scripts           ^|
if "!show_stbtlySTR:~-%colnum%!"=="" echo  --------------------------------------------------
if not "!show_stbtlySTR:~-%colnum%!"=="" echo. !show_stbtlySTR:~-%colnum%!
echo.
if not "%show_cur_ADAPTER%"=="" echo  Connection: %show_cur_ADAPTER%
if not "%cur_ROUTER%"=="" 		echo  Router:     %cur_ROUTER%
if not "%uptime%"=="" 			echo  Uptime:     %uptime% (started %GRT_TimeRan% ago)
if not "%stability%"==""		echo  Stability:  %stability%
echo.
if not %numfixes%==0 			echo  Fixes:      %numfixes%
if not "%lastresult%"=="" 		echo  Last Test:  %lastresult% %showdbl%
if not "%curstatus%"=="" 		echo  Status:     %curstatus%
goto :eof

:header_details
set ismanualA=&if "%manualAdapter%"=="" set ismanualA= (AUTO)
set ismanualR=&if "%manualRouter%"=="" set ismanualR= (AUTO)
set dsp_cur_ROUTER=%cur_Router%%ismanualR%%statspacer%
set dsp_secondaryRouter=%secondaryRouter%%statspacer%
if "%cur_ROUTER%"=="" set dsp_cur_ROUTER=%secondaryRouter%%ismanualR%%statspacer%
set dsp_uptime=%uptime%%statspacer%
set dsp_GRT_TimeRan=%GRT_TimeRan%%statspacer%
set dsp_adapters=%con_num%
if "%con_num%"=="" set dsp_adapters=%numAdapters%
set dsp_stability=%stability% (%stblty_result%%%)%statspacer%
set dspAdmin=True&if %isAdmin%==0 set dspAdmin=False
set dspUsrInput=True&if %fullAuto%==0 set dspUsrInput=False
set dspReqAdmin=True&if %requestAdmin%==0 set dspReqAdmin=False
set dspCRD=[%INT_checkrouterdelay%]%STR_ca_percent%%statspacer%
set dspAvgTOS=[%timeoutmilsecs%]%STR_timeout%%statspacer%
set dsp_fixes=%numfixes%%statspacer%
set H_filterRouters=%filterRouters%%statspacer%
set H_filterAdapters=%filterAdapters%%statspacer%
set dsp_rfilt1=%H_filterRouters:~0,30%%statspacer%
set dsp_rfilt2=%H_filterRouters:~30,60%%statspacer%
set dsp_afilt1=%H_filterAdapters:~0,30%%statspacer%
set dsp_afilt2=%H_filterAdapters:~30,60%%statspacer%
cls
COLOR %curcolor%
echo  ------------------------------------------------------------------------------
echo  ^|                                                                            ^|
echo  ^|                   -%ThisTitle%-                      ^|
echo  ^|                     http://electrodexs.net/scripts                         ^|
echo  ^|                                                                            ^|
if not "!show_stbtlySTR:~-%colnum%!"=="" echo. !show_stbtlySTR:~-%colnum%!
echo.
echo  Connection: %show_cur_ADAPTER%%ismanualA%
echo  Router:     %dsp_cur_ROUTER:~0,40%NIC Adapters:      %totalAdapters%
echo  Router 2:   %dsp_secondaryRouter:~0,40%No User Input:     %dspUsrInput%
echo  Uptime:     %dsp_uptime:~0,40%Stability Hist:    %INT_StabilityHistory%
echo  Runtime:    %dsp_GRT_TimeRan:~0,40%Request Admin:     %dspReqAdmin%
echo  Stability:  %dsp_stability:~0,40%Is Admin:          %dspAdmin%
echo  Fixes:      %dsp_fixes:~0,40%Theme:             %theme%
echo                                                      Fluke Checks:      %INT_flukechecks%
echo                                                      Check Delay:       %INT_checkdelay%
echo  Verify Router Delay: %dspCRD:~0,31%Test Timeout Secs: %INT_timeoutsecs%
echo  Test Timeout Mils: %dspAvgTOS:~0,33%Fix Delay:         %INT_fixdelay%
echo                                                      Fluke Check Delay: %INT_flukecheckdelay%
echo. Router Filters:  %dsp_rfilt1:~0,30%
echo.                  %dsp_rfilt2:~0,30%
echo. Adapter Filters: %dsp_afilt1:~0,30%
echo.                  %dsp_afilt2:~0,30%
echo.
echo  Last Test:  %lastresult% %showdbl%
echo  Status:     %curstatus%
goto :eof


:set_stability
set /a stblty_tests+=1
set /a stblty_val+=%1
if "%stblty_firstval%"=="" set stblty_firstval=%1
shift
if not "%1"=="" goto :set_stability
set stblty_over=0
if %stblty_tests% geq %INT_StabilityHistory% set /a stblty_over=stblty_tests-INT_StabilityHistory&set /a stblty_val-=stblty_firstval
if %stblty_over% geq 1 set /a stblty_over*=2
if %stblty_over% geq 1 set stbltySTR=!stbltySTR:~%stblty_over%!
set /a stblty_result=100-((stblty_val*100)/stblty_tests)
set stability=Very Poor [7]
if %stblty_result% gtr 40 set stability=Poor [6]
if %stblty_result% gtr 55 set stability=Lower [5]
if %stblty_result% gtr 70 set stability=Low [4]
if %stblty_result% gtr 85 set stability=Fair [3]
if %stblty_result% gtr 94 set stability=Normal [2]
if %stblty_result% equ 100 set stability=High [1]
if %stblty_tests% leq %INT_StabilityHistory% set stability=Calculating...(%stblty_tests%/%INT_StabilityHistory%)
if %stblty_tests% gtr %INT_StabilityHistory% set INT_checkdelay=%orig_checkdelay%
set stblty_tests=0
set stblty_val=0
set stblty_firstval=
goto :eof

:countAdapters
set totalAdapters=0
for /f %%n in ('ipconfig ^|FINDSTR /C:"adapter"') do set /a totalAdapters+=1
set /a est_secs=(totalAdapters*ca_percent)/100
goto :eof

:Update_avgca
set /a last_ca_percent+=0
set /a last_checkca+=0
set /a checkca=(%1*100)/ca_percent
if %checkca% geq 300 if not %last_checkca% geq 300 goto :eof
set num=0
set avg_ca_percent=0
set STR_ca_percent=
if %checkca% geq 300 set STR_ca_percent=%last_ca_percent%&set num=1
set last_checkca=%checkca%&set last_ca_percent=%1
:Update_avgca_loop
if not "%1"=="" if %num% lss %MX_avgca% set /a avg_ca_percent+=%1&set STR_ca_percent=%STR_ca_percent% %1
if not "%1"=="" if %num% lss %MX_avgca% set /a num+=1&shift&goto :Update_avgca_loop
set /a ca_percent=(avg_ca_percent/num)
if "%AUTO_checkrouterdelay%"=="" goto :eof
set /a est_secs=(totalAdapters*ca_percent)/100
set /a INT_checkrouterdelay=est_secs+1
if %INT_checkrouterdelay% lss %MN_crd% set INT_checkrouterdelay=%MN_crd%
if %INT_checkrouterdelay% gtr %MX_crd% set INT_checkrouterdelay=%MX_crd%
goto :eof

:Update_avgtimeout
if "%AUTO_timeoutsecs%"=="" goto :eof
set num=0
set avg_timeout=0
set STR_timeout=
:Update_avgtimeout_loop
if not "%1"=="" if %num% lss %MX_avgtimeout% set /a avg_timeout+=%1&set STR_timeout=%STR_timeout% %1
if not "%1"=="" if %num% lss %MX_avgtimeout% set /a num+=1&shift&goto :Update_avgtimeout_loop
set /a timeoutmilsecs=(avg_timeout/num)+((avg_timeout/num)/2)
if %timeoutmilsecs% lss %MN_timeout% set timeoutmilsecs=%MN_timeout%
if %timeoutmilsecs% gtr %MX_timeout% set timeoutmilsecs=%MX_timeout%
goto :eof

:precisiontimer
set id=%1
set var=%2
if /i "%var%"=="start" set startmils%id%=%time:~9,2%&set startsecs%id%=%time:~6,2%&set startmins%id%=%time:~3,2%&goto :eof
if /i "%var%"=="halt" set startsecs%id%=invalid&goto :eof
if "!startsecs%id%!"=="invalid" set %var%=0&goto :eof
set endmils%id%=%time:~9,2%&set endsecs%id%=%time:~6,2%&set endmins%id%=%time:~3,2%
if "!startmils%id%:~0,1!"=="0" set startmils%id%=!startmils%id%:~1,1!
if "!startsecs%id%:~0,1!"=="0" set startsecs%id%=!startsecs%id%:~1,1!
if "!startmins%id%:~0,1!"=="0" set startmins%id%=!startmins%id%:~1,1!
if "!endmils%id%:~0,1!"=="0" set endmils%id%=!endmils%id%:~1,1!
if "!endsecs%id%:~0,1!"=="0" set endsecs%id%=!endsecs%id%:~1,1!
if "!endmins%id%:~0,1!"=="0" set endmins%id%=!endmins%id%:~1,1!
if !endmils%id%! lss !startmils%id%! set /a endmils%id%+=100&set /a endsecs%id%-=1
if !endsecs%id%! lss !startsecs%id%! set /a endsecs%id%+=60&set /a endmins%id%-=1
if !endmins%id%! lss !startmins%id%! set /a endmins%id%+=60
set /a %var%=(endmils%id%-startmils%id%)+((endsecs%id%-startsecs%id%)*100)+(((endmins%id%-startmins%id%)*60)*100)
goto :eof


:checkRouterAdapter
set checkconnects=0
if not "%manualRouter%"=="" if not "%manualAdapter%"=="" goto :eof
call :precisiontimer cRA start
call :countAdapters
set curstatus=Verify Router/Adapter [%est_secs%s]&call :header
call :getNETINFO
set cur_ROUTER=&set cur_ADAPTER=&set show_cur_ADAPTER=
if not "%manualAdapter%"=="" call :getRouter
if not "%manualRouter%"=="" call :getAdapter
if "%cur_ROUTER%"=="" if "%cur_ADAPTER%"=="" call :getRouterAdapter
if "%cur_ROUTER%"=="" if "%cur_ADAPTER%"=="" call :EnumerateAdapters

:checkRouterAdapter_end
call :precisiontimer cRA tot
set /a tot/=100
set /a timepassed+=tot
if not %tot%==0 set /a new_ca_percent=(tot*100)/totalAdapters
if not %tot%==0 call :Update_avgca %new_ca_percent% %STR_ca_percent%
goto :eof

:getRouterAdapter
if %gNI_arrLen%==0 goto :eof
if %gNI_arrLen%==1 set cur_ROUTER=%net_1_gw%&set cur_ADAPTER=%net_1_cn%&set show_cur_ADAPTER=%net_1_cn%&goto :eof
call :ask4NET&goto :eof

:getRouter
set cur_ADAPTER=%manualAdapter%&set show_cur_ADAPTER=%manualAdapter%
if /i "%manualAdapter%"=="all" set cur_ADAPTER=&set show_cur_ADAPTER=[Reset All Connections on Error]
if %gNI_arrLen%==0 goto :eof
if %gNI_arrLen%==1 set cur_ROUTER=%net_1_gw%&goto :eof
for /l %%n in (1,1,%gNI_arrLen%) do if "%manualAdapter%"=="!net_%%n_cn!" set cur_ROUTER=!net_%%n_gw!
if "%cur_ROUTER%"=="" call :Ask4Router
goto :eof

:getAdapter
set cur_ROUTER=%manualRouter%
if /i "%manualRouter%"=="none" set cur_ROUTER=
if %gNI_arrLen%==0 goto :eof
if %gNI_arrLen%==1 set cur_ADAPTER=%net_1_cn%&goto :eof
for /l %%n in (1,1,%gNI_arrLen%) do if "%manualRouter%"=="!net_%%n_gw!" set cur_ADAPTER=!net_%%n_cn!
if "%cur_ADAPTER%"=="" call :Ask4Adapter
set show_cur_ADAPTER=%cur_Adapter%
if /i "%manualAdapter%"=="all" set cur_ADAPTER=&set show_cur_ADAPTER=[Reset All Connections on Error]
goto :eof


:check
@set curstatus=Testing connectivity...
%debgn%call :header
set ping_test=&set result=&set resultUpDown=&set testrouter=%secondaryRouter%
if not "%cur_ROUTER%"=="" if %dbl% equ 0 set testrouter=%cur_ROUTER%
if not "%manualRouter%"=="" set testrouter=%cur_ROUTER%
if "%lastResult%"=="" set lastResult=Connected
if "%timeoutmilsecs_add%"=="1" set /a timeoutmilsecs+=1000&set timeoutmilsecs_add=0

call :precisiontimer PING start
for /f "tokens=* delims=" %%p in ('ping -w %timeoutmilsecs% -n 1 %testrouter%') do set ping_test=!ping_test! %%p
call :precisiontimer PING pingtime
echo "%ping_test%" |FINDSTR /C:"Reply from " >NUL
if %errorlevel% equ 0 set result=Connected&set resultUpDown=Up
echo "%ping_test%" |FINDSTR /C:"request could not find" /C:"Unknown host" /C:"unreachable" /C:"General failure" >NUL
if %errorlevel% equ 0 set result=NotConnected&set resultUpDown=Down
if "%result%"=="" set result=TimeOut&set resultUpDown=Down&set /a timeoutmilsecs_add=1

if "%resultUpDown%"=="Up" (
set /a checkconnects+=1
if not "%lastresult%"=="Connected" set /a timepassed/=2
if not "%lastresult%"=="Connected" if not "%resetted%"=="1" set checkconnects=force
if not "%lastresult%"=="Connected" if "%resetted%"=="1" if "%cur_Adapter%"==""  set checkconnects=force
if %timepassed% leq 0 set timepassed=1
set /a up+=timepassed&set curcolor=%norm%&set stbltySTR=%stbltySTR% 0
)

if "%resultUpDown%"=="Down" (
if "%lastresult%"=="Connected" set /a timepassed/=2
if not "%lastresult%"=="" if %timepassed% leq 0 set timepassed=1
set /a down+=timepassed
if "%result%"=="TimeOut" set /a down+=INT_timeoutsecs
set curcolor=%warn%&set stbltySTR=%stbltySTR% 1
if not %dbl%==0 call :setSecondaryRouter
)

set timepassed=0
if %dbl% gtr 0 set showdbl=(fluke check %dbl%/%INT_flukechecks%)
set /a dbl+=1
set /a pingtime*=10
call :update_avgtimeout %pingtime% %STR_timeout%
call :set_uptime
call :set_stability %stbltySTR%


if "%result%"=="Connected" if not "%lastresult%"=="Connected" if "%resetted%"=="1" set /a numfixes+=1
set lastresult=%result%
if "%result%"=="Connected" set resetted=0
if "%result%"=="NotConnected" call :check_adapterenabled
if not "%result%"=="Connected" if not %dbl% gtr %INT_flukechecks% call :sleep %INT_flukecheckdelay%&goto :check
if not "%result%"=="Connected" if %dbl% gtr %INT_flukechecks% call :resetConnection
set dbl=0
set showdbl=
goto :eof

:check_adapterenabled
if "%isAdmin%"=="0" goto :eof
if "%cur_ADAPTER%"=="" goto :eof
ipconfig |FINDSTR /C:"adapter %cur_ADAPTER%:">NUL
if %errorlevel% equ 0 goto :eof
@set curstatus=Enabling adapter...&set curcolor=%pend%
%debgn%call :header
set resetted=1
netsh interface set interface "%cur_ADAPTER%" admin=enable>NUL 2>&1
if %errorlevel%==0 set stbltySTR=%stbltySTR% 2&call :sleep %INT_fixdelay%&goto :eof
%no_wmic%wmic path win32_networkadapter where "NetConnectionID='%cur_ADAPTER%'" call enable>NUL 2>&1
%no_wmic%if %errorlevel%==0 set stbltySTR=%stbltySTR% 2&call :sleep %INT_fixdelay%&goto :eof
call :resetAdapter_oldOS enable %cur_ADAPTER%&set stbltySTR=%stbltySTR% 2&goto :eof

:setSecondaryRouter
if %secondaryRouternum%==0 set secondaryRouter=www.google.com
if %secondaryRouternum%==1 set secondaryRouter=www.ask.com
if %secondaryRouternum%==2 set secondaryRouter=www.yahoo.com
if %secondaryRouternum%==3 set secondaryRouter=www.bing.com
set /a secondaryRouternum+=1
if %secondaryRouternum% geq 4 set secondaryRouternum=0
goto :eof

:sleep
if "%1"=="" set pn=3
if not "%1"=="" set pn=%1
if %pn% equ 0 goto :eof
if "%checkconnects%"=="force" call :checkRouterAdapter&set /a pn-=tot
if not "%stability:~0,4%"=="Calc" if "%lastResult%"=="Connected" if %checkconnects% geq %INT_checkrouterdelay% call :checkRouterAdapter&set /a pn-=tot
if %pn% leq 0 goto :eof
@set curstatus=Wait %pn% seconds...
%debgn%call :header
set /a timepassed+=pn
set /a pn+=1
ping -n %pn% -w 1000 127.0.0.1>nul&goto :eof

:SETMODECON
if /i "%viewmode%"=="mini" set cols=37&set lines=10
if /i "%viewmode%"=="normal" set cols=52&set lines=14
if /i "%viewmode%"=="details" set cols=80&set lines=28
if not "%1"=="" set cols=%1&set lines=%2
if not "%pretty%"=="1" set cols=80&set lines=900
MODE CON COLS=%cols% LINES=%lines%
goto :eof

:crazy
@echo off
set /a cr_num=%random:~-1%
set /a cr_num+=%random:~-1%
if %cr_num% gtr 15 goto :crazy
:crazy2
set /a cr_num2=%random:~-1%-1
set /a cr_num2+=%random:~-1%-1
if %cr_num2% gtr 15 goto :crazy2
if "%cr_num%"=="%cr_num2%" goto :crazy
COLOR !crazystr:~%cr_num%,1!!crazystr:~%cr_num2%,1!
goto :eof


:set_uptime
if %up% geq 100000 set /a up=up/10&set /a down=down/10
set /a uptime=((up*10000)/(up+down))>NUL 2>&1
set /a uptime+=0
set uptime=%uptime:~0,-2%.%uptime:~-2%%%
call :getruntime
goto :eof


:getruntime
%toolong%
if "%GRT_TIME_start_year%"=="" goto :getruntime_init

set GRT_TIME_curr_year=%DATE:~10,4%
set GRT_TIME_curr_month=%DATE:~4,2%
set GRT_TIME_curr_day=%DATE:~7,2%
set GRT_TIME_curr_hour=%TIME:~0,2%
set GRT_TIME_curr_min=%TIME:~3,2%
set GRT_TIME_curr_sec=%TIME:~6,2%
::set GRT_TIME_curr_mili=%TIME:~9,2%

for /f "tokens=1 delims==" %%a in ('set GRT_TIME_curr_') do if "!%%a:~0,1!"=="0" set /a %%a=!%%a:~1,1!+0

set GRT_MO_3=28&set /a GRT_leapyear=GRT_TIME_curr_year*10/4
if %GRT_leapyear:~-1% equ 0 set GRT_MO_3=29

set /a GRT_lastmonth=GRT_TIME_curr_month-1

if %GRT_TIME_curr_month% lss %GRT_TIME_start_month% set /a GRT_TIME_curr_month+=12&set GRT_TIME_curr_year-=1
if %GRT_TIME_curr_day% lss %GRT_TIME_start_day% set /a GRT_TIME_curr_day+=GRT_MO_%GRT_lastmonth%&set GRT_TIME_curr_month-=1
if %GRT_TIME_curr_hour% lss %GRT_TIME_start_hour% set /a GRT_TIME_curr_hour+=24&set /a GRT_TIME_curr_day-=1
if %GRT_TIME_curr_min% lss %GRT_TIME_start_min% set /a GRT_TIME_curr_min+=60&set /a GRT_TIME_curr_hour-=1
if %GRT_TIME_curr_sec% lss %GRT_TIME_start_sec% set /a GRT_TIME_curr_sec+=60&set /a GRT_TIME_curr_min-=1
::if %GRT_TIME_curr_mili% lss %GRT_TIME_start_mili% set /a GRT_TIME_curr_mili+=100&set GRT_TIME_curr_sec-=1

set /a GRT_TIME_curr_year=GRT_TIME_curr_year-GRT_TIME_start_year
set /a GRT_TIME_curr_month=GRT_TIME_curr_month-GRT_TIME_start_month
set /a GRT_TIME_curr_day=GRT_TIME_curr_day-GRT_TIME_start_day
set /a GRT_TIME_curr_hour=GRT_TIME_curr_hour-GRT_TIME_start_hour
set /a GRT_TIME_curr_min=GRT_TIME_curr_min-GRT_TIME_start_min
set /a GRT_TIME_curr_sec=GRT_TIME_curr_sec-GRT_TIME_start_sec
::set /a GRT_TIME_curr_mili=GRT_TIME_curr_mili-GRT_TIME_start_mili

for /f "tokens=1 delims==" %%a in ('set GRT_TIME_curr_') do if !%%a! leq 0 set /a %%a=0

if %GRT_TIME_curr_min% leq 9 set GRT_TIME_curr_min=0%GRT_TIME_curr_min%
if %GRT_TIME_curr_sec% leq 9 set GRT_TIME_curr_sec=0%GRT_TIME_curr_sec%

if %GRT_TIME_curr_year% geq 10000 set GRT_TimeRan=Over 10,000 years&set toolong=goto :eof&goto :eof
set GRT_TimeRan=%GRT_TIME_curr_hour%:%GRT_TIME_curr_min%:%GRT_TIME_curr_sec%
if %GRT_TIME_curr_year% neq 0 set GRT_TimeRan=%GRT_TIME_curr_year%y %GRT_TIME_curr_month%m %GRT_TIME_curr_day%d %GRT_TimeRan%&goto :eof
if %GRT_TIME_curr_month% neq 0 set GRT_TimeRan=m:%GRT_TIME_curr_month%m %GRT_TIME_curr_day%d %GRT_TimeRan%&goto :eof
if %GRT_TIME_curr_day% neq 0 set GRT_TimeRan=%GRT_TIME_curr_day%d %GRT_TimeRan%
goto :eof

:getruntime_init
set GRT_TIME_start_year=%DATE:~10,4%
set GRT_TIME_start_month=%DATE:~4,2%
set GRT_TIME_start_day=%DATE:~7,2%
set GRT_TIME_start_hour=%TIME:~0,2%
set GRT_TIME_start_min=%TIME:~3,2%
set GRT_TIME_start_sec=%TIME:~6,2%
set GRT_TIME_start_mili=%TIME:~9,2%

for /f "tokens=1 delims==" %%a in ('set GRT_TIME_start_') do if "!%%a:~0,1!"=="0" set /a %%a=!%%a:~1,1!+0

set GRT_MO_1=31
REM February set seperately
set GRT_MO_3=31
set GRT_MO_4=30
set GRT_MO_5=31
set GRT_MO_6=30
set GRT_MO_7=31
set GRT_MO_8=31
set GRT_MO_9=30
set GRT_MO_10=31
set GRT_MO_11=30
set GRT_MO_12=31
goto :eof

:EnumerateAdapters
set adapters_arrLen=0
%no_wmic%for /f "tokens=* delims=" %%n in ('wmic nic get NetConnectionID') do call :EnumerateAdapters_parse %%n
%no_wmic%goto :eof
for /f "tokens=* delims=" %%n in ('netsh int show int') do call :EnumerateAdapters_parse %%n
for /f "tokens=* delims=" %%n in ('netsh mbn show int') do call :EnumerateAdapters_parseMBN %%n
goto :eof

:EnumerateAdapters_parse
if "%*"=="" goto :eof
if "%*"=="NetConnectionID" goto :eof
if "%1 %2"=="Admin State" goto :eof
set line=%*
if "%line:~0,4%"=="----" goto :eof
if not "%filterAdapters%"=="" echo %line%|FINDSTR /I /L "%filterAdapters%">NUL
if not "%filterAdapters%"=="" if %errorlevel% equ 0 goto :eof
set /a adapters_arrLen+=1
%no_wmic%set adapters_%adapters_arrLen%_name=%line%&goto :eof
for /f "tokens=2* delims= " %%c in ("%line%") do set adapters_%adapters_arrLen%_name=%%d
goto :eof

:EnumerateAdapters_parseMBN
echo x %*|FINDSTR /C:"Name">NUL
if not %errorlevel%==0 goto :eof
set line=%*
if not "%filterAdapters%"=="" echo %line%|FINDSTR /I /L "%filterAdapters%">NUL
if not "%filterAdapters%"=="" if %errorlevel%==0 goto :eof
set /a adapters_arrLen+=1
set adapters_%adapters_arrLen%_name=%line:*: =%&goto :eof


:resetConnection
set curcolor=%alrt%
@set curstatus=Attempting to fix connection...
set stbltySTR=%stbltySTR% 2
%debgn%call :header
set resetted=1
if "%cur_ADAPTER%"=="" call :resetConnection_all
if not "%cur_ADAPTER%"=="" call :resetConnection_one
set curcolor=%pend%&call :sleep %INT_fixdelay%
set checkconnects=force
goto :eof

:resetConnection_all
ipconfig /release>NUL 2>&1
ipconfig /flushdns>NUL 2>&1
%use_admin%set use_netsh=::
%use_admin%netsh interface set interface "%adapters_1_name%" admin=disable>NUL 2>&1
%use_admin%if %errorlevel%==0 set use_netsh=&set use_wmic=::&set use_vbs=::
%use_admin%%use_netsh%for /l %%n in (1,1,%adapters_arrLen%) do netsh interface set interface "!adapters_%%n_name!" admin=disable>NUL 2>&1
%use_admin%%use_netsh%for /l %%n in (1,1,%adapters_arrLen%) do netsh interface set interface "!adapters_%%n_name!" admin=enable>NUL 2>&1
%use_admin%%no_wmic%%use_wmic%wmic path win32_networkadapter where "NetConnectionID='%adapters_1_name%'" call disable>NUL 2>&1
%use_admin%%no_wmic%%use_wmic%if %errorlevel%==0 set use_wmic=&set use_vbs=::
%use_admin%%no_wmic%%use_wmic%for /l %%n in (1,1,%adapters_arrLen%) do wmic path win32_networkadapter where "NetConnectionID='!adapters_%%n_name!'" call disable>NUL 2>&1
%use_admin%%no_wmic%%use_wmic%for /l %%n in (1,1,%adapters_arrLen%) do wmic path win32_networkadapter where "NetConnectionID='!adapters_%%n_name!'" call enable>NUL 2>&1
%use_admin%%use_vbs%for /l %%n in (1,1,%adapters_arrLen%) do call :resetAdapter_oldOS disable !adapters_%%n_name!
%use_admin%%use_vbs%for /l %%n in (1,1,%adapters_arrLen%) do call :resetAdapter_oldOS enable !adapters_%%n_name!
ipconfig /renew>NUL 2>&1
goto :eof

:resetConnection_one
ipconfig /release "%cur_ADAPTER%">NUL 2>&1
ipconfig /flushdns "%cur_ADAPTER%">NUL 2>&1
set use_netsh=::
%use_admin%netsh interface set interface "%cur_Adapter%" admin=disable>NUL 2>&1
%use_admin%if %errorlevel%==0 set use_netsh=&set use_wmic=::&set use_vbs=::
%use_admin%%use_netsh%netsh interface set interface "%cur_ADAPTER%" admin=enable>NUL 2>&1
%use_admin%%no_wmic%wmic path win32_networkadapter where "NetConnectionID='%cur_ADAPTER%'" call disable>NUL 2>&1
%use_admin%%no_wmic%if %errorlevel%==0 set use_wmic=&set use_vbs=::
%use_admin%%no_wmic%%use_wmic%wmic path win32_networkadapter where "NetConnectionID='%cur_ADAPTER%'" call enable>NUL 2>&1
%use_admin%%use_vbs%call :resetAdapter_oldOS disable %cur_ADAPTER%
%use_admin%%use_vbs%call :resetAdapter_oldOS enable %cur_ADAPTER%
ipconfig /renew "%cur_ADAPTER%">NUL 2>&1
goto :eof

:resetAdapter_oldOS
if /I "%1"=="enable" set disoren=Enable&set trufalse=false
if /I "%1"=="disable" set disoren=Disable&set trufalse=true
set reset_adaptername=%*
set reset_adaptername=!reset_adaptername:%1 =!
set resetfile=%temp%\NetworkResetNWCR.vbs
@echo on
@echo Const ssfCONTROLS = 3 '>"%resetfile%"
@echo sEnableVerb = "En&able" '>>"%resetfile%"
@echo sDisableVerb = "Disa&ble" '>>"%resetfile%"
@echo set shellApp = createobject("shell.application") '>>"%resetfile%"
@echo set oControlPanel = shellApp.Namespace(ssfCONTROLS) '>>"%resetfile%"
@echo set oNetConnections = nothing '>>"%resetfile%"
@echo for each folderitem in oControlPanel.items '>>"%resetfile%"
@echo   if folderitem.name = "Network Connections" then '>>"%resetfile%"
@echo         set oNetConnections = folderitem.getfolder: exit for '>>"%resetfile%"
@echo   elseif folderitem.name = "Network and Dial-up Connections" then '>>"%resetfile%"
@echo         set oNetConnections = folderitem.getfolder: exit for '>>"%resetfile%"
@echo end if '>>"%resetfile%"
@echo next '>>"%resetfile%"
@echo if oNetConnections is nothing then '>>"%resetfile%"
@echo wscript.quit '>>"%resetfile%"
@echo end if '>>"%resetfile%"
@echo set oLanConnection = nothing '>>"%resetfile%"
@echo for each folderitem in oNetConnections.items '>>"%resetfile%"
@echo if lcase(folderitem.name) = lcase("%reset_adaptername%") then '>>"%resetfile%"
@echo set oLanConnection = folderitem: exit for '>>"%resetfile%"
@echo end if '>>"%resetfile%"
@echo next '>>"%resetfile%"
@echo Dim objFSO '>>"%resetfile%"
@echo if oLanConnection is nothing then '>>"%resetfile%"
@echo wscript.quit '>>"%resetfile%"
@echo end if '>>"%resetfile%"
@echo bEnabled = true '>>"%resetfile%"
@echo set oEnableVerb = nothing '>>"%resetfile%"
@echo set oDisableVerb = nothing '>>"%resetfile%"
@echo s = "Verbs: " ^& vbcrlf '>>"%resetfile%"
@echo for each verb in oLanConnection.verbs '>>"%resetfile%"
@echo s = s ^& vbcrlf ^& verb.name '>>"%resetfile%"
@echo if verb.name = sEnableVerb then '>>"%resetfile%"
@echo set oEnableVerb = verb '>>"%resetfile%"
@echo bEnabled = false '>>"%resetfile%"
@echo end if '>>"%resetfile%"
@echo if verb.name = sDisableVerb then '>>"%resetfile%"
@echo set oDisableVerb = verb '>>"%resetfile%"
@echo end if '>>"%resetfile%"
@echo next '>>"%resetfile%"
@echo if bEnabled = %trufalse% then '>>"%resetfile%"
@echo o%disOrEn%Verb.DoIt '>>"%resetfile%"
@echo end if '>>"%resetfile%"
@echo wscript.sleep 2000 '>>"%resetfile%"
%debgn%@echo off
start /B /WAIT cmd /C cscript //B //NoLogo "%resetfile%"
DEL /F /Q "%resetfile%">NUL 2>&1
goto :eof

:detectIsAdmin
DEL /F /Q "%temp%\getadminNWCR.vbs">NUL 2>&1
set isAdmin=0
net session >nul 2>&1
if %errorLevel%==0 set isAdmin=1&set useregadd=::&set usetypenul=::
%no_reg%%useregadd%set usetypenul=::
%no_reg%%useregadd%REG ADD HKLM /F>nul 2>&1
%no_reg%%useregadd%if %errorLevel%==0 set isAdmin=1&set usetypenul=::
%no_windir%%usetypenul%type nul>"%WINDIR%\testisadmin.txt"
%no_windir%%usetypenul%del /f /q "%WINDIR%\testisadmin.txt">NUL 2>&1
%no_windir%%usetypenul%if %errorLevel%==0 set isAdmin=1
%no_taskkill%for /f "usebackq tokens=*" %%a in (`taskkill /F /FI "WINDOWTITLE eq Limited: %ThisTitle%" ^|FINDSTR /C:SUCCESS`) do set killresult=%%a
%no_taskkill%if not "%killresult%"=="" goto :eof
if %isAdmin%==1 goto :eof
title Limited: %ThisTitle%
if not "%requestAdmin%"=="1" goto :eof
%no_taskkill%echo Set StartAdmin = CreateObject^("Shell.Application"^) > "%temp%\getadminNWCR.vbs"
%no_taskkill%echo StartAdmin.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadminNWCR.vbs"
%no_taskkill%echo Requesting admin rights...&echo (This will close upon successful request)
%no_taskkill%cscript //E:VBScript //B //T:1 "%temp%\getadminNWCR.vbs" //nologo>NUL 2>&1
%no_taskkill%ping 127.0.0.1>NUL&ping 127.0.0.1>NUL&DEL /F /Q "%temp%\getadminNWCR.vbs">NUL 2>&1
goto :eof

:Ask4NET
if "%fullAuto%"=="1" set manualRouter=%secondaryRouter%&set cur_ROUTER=%secondaryRouter%
if "%fullAuto%"=="1" set manualAdapter=all&set cur_ADAPTER=&set show_cur_ADAPTER=[Reset All Connections on Error]&goto :eof
call :precisiontimer cRA halt
%debgn%set /a lines=%gNI_arrLen%+11
%debgn%call :SETMODECON 70 %lines%
echo.
echo Which one would you like to monitor?
echo.
echo Choose by the selection number below.
echo You may also enter x to cancel.
echo.
echo  #     Router Adress                  Associated Connection
echo  ----- ------------------------------ -----------------------------
for /l %%n in (1,1,%gNI_arrLen%) do set showroutr%%n=[%%n]%statspacer%
for /l %%n in (1,1,%gNI_arrLen%) do set showroutr%%n=!showroutr%%n:~0,5! !net_%%n_gw!%statspacer%
for /l %%n in (1,1,%gNI_arrLen%) do set showroutr%%n=!showroutr%%n:~0,36! !net_%%n_cn!%statspacer%
for /l %%n in (1,1,%gNI_arrLen%) do echo -!showroutr%%n:~0,68!
echo.
set usrinput=
set /p usrinput=[] 
if "%usrinput%"=="" set usrinput=1
for /l %%n in (1,1,%gNI_arrLen%) do if "%usrinput%"=="%%n" set cur_ROUTER=!net_%%n_gw!&set cur_ADAPTER=!net_%%n_cn!
if "%usrinput%"=="x" set manualRouter=%secondaryRouter%&set cur_ROUTER=%secondaryRouter%
if "%usrinput%"=="x" set manualAdapter=all&set cur_Adapter=&set show_cur_ADAPTER=[Reset All Connections on Error]&goto :eof
if "%cur_ROUTER%"=="" goto :Ask4Router
set manualRouter=%cur_ROUTER%
set manualAdapter=%cur_ADAPTER%&set show_cur_ADAPTER=%cur_ADAPTER%
cls&call :SETMODECON
goto :eof



:Ask4Router
if "%fullAuto%"=="1" set manualRouter=%secondaryRouter%&set cur_ROUTER=%secondaryRouter%&goto :eof
call :precisiontimer cRA halt
%debgn%set /a lines=%gNI_arrLen%+11
%debgn%call :SETMODECON 70 %lines%
echo.
echo Which Router would you like to monitor?
echo.
echo Choose a router by the selection number below.
echo You may also type in a router address to use, or x to cancel.
echo.
echo  #     Router Adress                  Associated Connection
echo  ----- ------------------------------ -----------------------------
for /l %%n in (1,1,%gNI_arrLen%) do set showroutr%%n=[%%n]%statspacer%
for /l %%n in (1,1,%gNI_arrLen%) do set showroutr%%n=!showroutr%%n:~0,5! !net_%%n_gw!%statspacer%
for /l %%n in (1,1,%gNI_arrLen%) do set showroutr%%n=!showroutr%%n:~0,36! !net_%%n_cn!%statspacer%
for /l %%n in (1,1,%gNI_arrLen%) do echo -!showroutr%%n:~0,68!
echo.
set usrinput=
set usrinput2=
set /p usrinput=[] 
if "%usrinput%"=="" set usrinput=1
for /l %%n in (1,1,%gNI_arrLen%) do if "%usrinput%"=="%%n" set cur_ROUTER=!net_%%n_gw!
if "%usrinput%"=="x" set manualRouter=%secondaryRouter%&set cur_ROUTER=%secondaryRouter%&goto :eof
if "%cur_ROUTER%"=="" cls&echo.&echo.&echo Use "%usrinput%" as router address?
if "%cur_ROUTER%"=="" set /p usrinput2=[y/n] 
if "%usrinput2%"=="" set cur_ROUTER=%usrinput%
if /i "%usrinput2%"=="y" set cur_ROUTER=%usrinput%
if "%cur_ROUTER%"=="" goto :Ask4Router
set manualrouter=%cur_ROUTER%
cls&call :SETMODECON
goto :eof

:Ask4Adapter
if "%fullAuto%"=="1" set manualAdapter=All&set show_cur_ADAPTER=[Reset All Connections on Error]&goto :eof
call :precisiontimer cRA halt
call :EnumerateAdapters
set /a lines=%adapters_arrLen%+10
%debgn%call :SETMODECON 52 %lines%
echo.
set cur_ADAPTER=
echo Which connection would you like to monitor?
echo.
echo Choose a connection by the selection number below.
echo You may also type x to cancel.
echo.
echo  #     Connection
echo  ----- -------------------------------------------
for /l %%n in (1,1,%adapters_arrLen%) do set showconn%%n=[%%n]%statspacer%
for /l %%n in (1,1,%adapters_arrLen%) do set showconn%%n=!showconn%%n:~0,5! !adapters_%%n_name!%statspacer%
for /l %%n in (1,1,%adapters_arrLen%) do echo -!showconn%%n:~0,50!
echo.
set usrinput=
set /p usrinput=[] 
if "%usrinput%"=="" set usrinput=1
if "%usrinput%"=="x" set manualAdapter=All&set show_cur_ADAPTER=[Reset All Connections on Error]&goto :eof
for /l %%n in (1,1,%adapters_arrLen%) do if "%usrinput%"=="%%n" set cur_ADAPTER=!adapters_%%n_name!
if "%cur_ADAPTER%"=="" goto :ask4connection
set manualadapter=%cur_ADAPTER%&set show_cur_ADAPTER=%cur_ADAPTER%
echo.
goto :eof

:countTunnelAdapters
set totalTunnelAdapters=0
for /f %%n in ('ipconfig ^|FINDSTR /C:"Tunnel"') do set /a totalTunnelAdapters+=1
goto :eof

:alert_2manyconnections
call :SETMODECON 60 20
if %requestDisableIPv6%==1 if %fullAuto%==1 set requestDisableIPv6=0
set /a est_min=est_secs/60
set /a est_sec=est_secs-(est_min*60)
set rkey=hklm\system\currentcontrolset\services\tcpip6\parameters
set rval=DisabledComponents
for /f "tokens=3*" %%i in ('reg query "%rkey%" /v "%rval%" ^| FINDSTR /I "%rval%"') DO set ipv6_dsbld=%%i
:alert_2manyconnections_ask
cls&set usrInput=&echo.
echo    -- Warning: Excessive number of Network Connections --
echo.
echo  Network Connections: %totalAdapters%
echo  Tunnel Adapters: %totalTunnelAdapters%
echo  Est. configure time: %est_min% min, %est_sec% sec
echo.
echo  Excessive network connections can cause performance and 
echo  stability issues, including long delays in connecting to 
echo  a network and/or the internet.
echo.&echo.
if "%isAdmin%"=="0" ping 127.0.0.1>NUL&ping 127.0.0.1>NUL&goto :eof
if "%requestDisableIPv6%"=="0" ping 127.0.0.1>NUL&ping 127.0.0.1>NUL&goto :eof
if "%ipv6_dsbld%"=="0xffffffff" ping 127.0.0.1>NUL&ping 127.0.0.1>NUL&goto :eof
if "%requestDisableIPv6%"=="2" goto :disable_IPv6
echo Do you wish to disable IPv6 to remove some of these
set /p usrInput=network connections?[y/n] 
if /i "%usrInput%"=="y" goto :disable_IPv6
if /i "%usrInput%"=="n" goto :alert_2manyconnections_ask_no
goto :alert_2manyconnections_ask

:alert_2manyconnections_ask_no
cls&echo.&echo.
echo  This option can be disabled by editing this script's 
echo  settings. Settings can be accessed by opening this
echo  script with notepad.
echo.&pause&goto :eof

:disable_IPv6
set oldnumtotal=%totalAdapters%&cls&echo.
echo Disable IPv6:&set disableipv6_err=0
echo. |set /p dummy=-add 'DisableComponents' to registry...
:: the number '4294967295' is not random; it creates the hex value '0xffffffff'
echo y|reg add "%rkey%" /v "%rval%" /t REG_DWORD /d 4294967295>NUL 2>&1
if not %errorlevel% equ 0 echo Fail %errorlevel%&set disableipv6_err=1
echo.&echo. |set /p dummy=-set netsh interface teredo state disable...
netsh interface teredo set state disable>NUL 2>&1
if not %errorlevel% equ 0 echo. |set /p dummy=Fail %errorlevel%&set /a disableipv6_err+=1
echo.&echo. |set /p dummy=-set netsh interface 6to4 state disable...
netsh interface 6to4 set state disabled>NUL 2>&1
if not %errorlevel% equ 0 echo. |set /p dummy=Fail %errorlevel%&set /a disableipv6_err+=1
echo.&echo. |set /p dummy=-set netsh interface isatap state disable...
netsh interface isatap set state disabled>NUL 2>&1
if not %errorlevel% equ 0 echo. |set /p dummy=Fail %errorlevel%&set /a disableipv6_err+=1
echo.&if %disableipv6_err% geq 1 echo.&echo %disableipv6_err% commands did not complete successfully.
if %disableipv6_err% leq 0 echo.&echo Commands completed successfully.
call :countAdapters
set /a removedadapters=oldnumtotal-totaladapters
echo Removed %removedadapters% adapters
echo.
echo You may have to reboot your computer for some changes to 
echo take effect.
ping 127.0.0.1>NUL&ping 127.0.0.1>NUL&goto :eof

:testValidPATHS
@set PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;%PATHEXT%
@if exist "%WINDIR%" set haswindir=::&set PATH=%WINDIR%\system32;%PATH%
%haswindir%@if exist "%SYSTEMDRIVE%\Windows" set WINDIR="%SYSTEMDRIVE%\Windows"&set haswindir=::&set PATH=%WINDIR%\system32;%PATH%
%haswindir%@if exist "%SYSTEMDRIVE%\WINNT" set WINDIR="%SYSTEMDRIVE%\WINNT"&set haswindir=::&set PATH=%WINDIR%\system32;%PATH%
%haswindir%set use_windir=::
@findstr /?>NUL 2>&1
@if %errorlevel%==0 set hassys32=::
%hassys32%@if exist "%comspec%" for /f "delims=" %%a in ("%comspec%") do set "PATH=%%~dpa;%PATH%"
%hassys32%@if exist "%SYSTEMDRIVE%\Windows\system32" set "PATH=%SYSTEMDRIVE%\Windows\system32;%PATH%"
%hassys32%@if exist "%SYSTEMDRIVE%\WINNT\system32" set "PATH=%SYSTEMDRIVE%\WINNT\system32;%PATH%"
%hassys32%@findstr /?>NUL 2>&1
%hassys32%@if not %errorlevel%==0 echo Could not find System32!&exit /b

if exist "%TEMP%" set hastemp=::
%hastemp%@if exist "%APPDATA%\TEMP" set TEMP=%APPDATA%\TEMP&set hastemp=::
%hastemp%@if exist "%SYSTEMDRIVE%\Windows\Temp" set TEMP=%SYSTEMDRIVE%\Windows\Temp&set hastemp=::
%hastemp%@if exist "%SYSTEMDRIVE%\WINNT\Temp" set TEMP=%SYSTEMDRIVE%\WINNT\Temp&set hastemp=::
%hastemp%@if exist "%WINDIR%\Temp" set TEMP="%WINDIR%\Temp"&set hastemp=::
%hastemp%@set TEMP=%thisdir%qNET_Temp&md %thisdir%qNET_Temp
%hastemp%@if not exist "%thisdir%qNET_Temp" set TEMP=%thisdir:~0,-1%
goto :eof

:testCompatibility
taskkill /?>NUL 2>&1
if not %errorlevel%==0 set no_taskkill=::
wmic /?>NUL 2>&1
if not %errorlevel%==0 set no_wmic=::
sc create /?>NUL
if not %errorlevel%==0 set no_sc=::&cls
reg /?>NUL 2>&1
if not %errorlevel%==0 set no_reg=::
goto :eof

:disableQuickEdit
set qkey=HKEY_CURRENT_USER\Console
set qval=QuickEdit
%no_reg%if not "%qedit_dsbld%"=="" echo y|reg add "%qkey%" /v "%qval%" /t REG_DWORD /d %qedit_dsbld%&cls
%no_reg%if not "%qedit_dsbld%"=="" goto :eof
%no_reg%for /f "tokens=3*" %%i in ('reg query "%qkey%" /v "%qval%" ^| FINDSTR /I "%qval%"') DO set qedit_dsbld=%%i
%no_reg%if "%qedit_dsbld%"=="0x0" goto :eof
%no_reg%echo y|reg add "%qkey%" /v "%qval%" /t REG_DWORD /d 0&cls&start "" "cmd" /k "%~dpnx0"&exit
if exist "%TEMP%\qNET_quickedit.reg" regedit /S "%TEMP%\qNET_quickedit.reg"&DEL /F /Q "%TEMP%\qNET_quickedit.reg"&goto :eof
regedit /S /e "%TEMP%\qNET_quickedit.reg" "%qkey%"
echo REGEDIT4>"%TEMP%\qNET_quickedit2.reg"&echo [%qkey%]>>"%TEMP%\qNET_quickedit2.reg"
(echo "%qval%"=dword:00000000)>>"%TEMP%\qNET_quickedit2.reg"
regedit /S "%TEMP%\qNET_quickedit2.reg"&DEL /F /Q "%TEMP%\qNET_quickedit2.reg"&start "" "cmd" /k "%~dpnx0"&exit

:init
@if not "%pretty%"=="1" set debgn=::
@call :init_settnSTR viewmode %viewmode%
@call :SETMODECON
%debgn%@echo off
%debgn%cls
@PROMPT=^>
@echo.
@echo .|set /p dummy=initializing...
@set ThisTitle=Lectrode's Quick Net Fix v%version%
@TITLE %ThisTitle%
@call :testCompatibility
@call :detectIsAdmin
@if "%isAdmin%"=="0" set use_admin=::
%debgn%@call :disableQuickEdit
@call :init_colors %theme%
%debgn%COLOR %norm%
@call :getruntime
@set numfixes=0
@set up=0
@set down=0
@set timepassed=0
@set dbl=0
@set numAdapters=0
@set checkconnects=0
@set stbltySTR=
@set ca_percent=5
@set MN_crd=5
@set MX_crd=120
@set MX_avgca=5
@set MX_avgtimeout=5
@set MN_timeout=100
@set MX_timeout=5000
@set statspacer=                                                               .
@for /f "tokens=1,* DELIMS==" %%s in ('set INT_') do call :init_settn %%s %%t
@set orig_checkdelay=%INT_checkdelay%
@set INT_checkdelay=1
@if %INT_checkrouterdelay%==0 set AUTO_checkrouterdelay=1
@if %INT_timeoutsecs%==0 set AUTO_timeoutsecs=1&call :update_avgtimeout 3000
@if "%AUTO_timeoutsecs%"=="" set /a timeoutmilsecs=1000*INT_timeoutsecs
@set secondaryRouternum=0&call :setSecondaryRouter
@call :init_manualRouter %manualRouter%
@for /f "tokens=1 DELIMS=:" %%a in ("%manualAdapter%") do call :init_manualAdapter %%a
@call :init_bar
@call :countAdapters
@call :countTunnelAdapters
@if %totalAdapters% geq 20 call :alert_2manyconnections
@call :SETMODECON
@call :update_avgca %ca_percent%
@echo .|set /p dummy=..
goto :eof

:init_settn
set /a %1=%2
goto :eof

:init_settnSTR
set %1=%2
goto :eof

:init_manualRouter
set manualRouter=%1
set manualRouter=%manualRouter:http:=%
set manualRouter=%manualRouter:https:=%
set manualRouter=%manualRouter:/=%
if "%manualRouter%"=="Examples:" set manualRouter=
if not "%manualRouter%"=="" set cur_ROUTER=%manualRouter%
if /I "%manualRouter%"=="none" set cur_ROUTER=%secondaryRouter%
goto :eof

:init_manualAdapter
set manualAdapter=%*
set manualAdapter=%manualAdapter:Examples=%
if "%manualAdapter%"=="" goto :eof
set manualAdapter=%manualAdapter:	=%
if not "%manualAdapter%"=="" set cur_ADAPTER=%manualAdapter%
if /I "%manualAdapter%"=="all" set cur_ADAPTER=
goto :eof

:init_bar
set /a colnum=cols-2
set -=
set aft-=
if %colnum% leq %INT_StabilityHistory% goto :eof
set /a numhyp=(colnum/INT_StabilityHistory)
set /a hypleft=(colnum-(numhyp*INT_StabilityHistory))
set /a numhyp-=1
:init_bar_loop
if not %numhyp% leq 0 set -=%-%-&set /a numhyp-=1
if not %hypleft% leq 0 set aft-=%aft-%-&set /a hypleft-=1
set /a bar_loop_tot=numhyp+hypleft
if %bar_loop_tot% gtr 0 goto :init_bar_loop
goto :eof

:init_colors
set theme=%1&call :init_colors_%theme%&goto :eof

:init_colors_none
set norm=&set warn=&set alrt=&goto :eof

:init_colors_subtle
set norm=07&set warn=06&set alrt=04&set pend=03&goto :eof

:init_colors_vibrant
set norm=0a&set warn=0e&set alrt=0c&set pend=0b&goto :eof

:init_colors_fullsubtle
set norm=20&set warn=60&set alrt=40&set pend=30&goto :eof

:init_colors_fullvibrant
set norm=a0&set warn=e0&set alrt=c0&set pend=b0&goto :eof

:init_colors_crazy
set norm=^&call :crazy&set warn=^&call :crazy&set alrt=^&call :crazy&set crazystr=0123456789ABCDEF&goto :eof
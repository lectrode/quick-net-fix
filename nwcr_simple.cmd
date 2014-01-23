::Quick detect&fix v4.2.342

::Documentation and updated versions can be found at
::https://code.google.com/p/quick-net-fix/

::------------------------
::-       SETTINGS       -
::------------------------
::-Manual-
@set manualRouter=			Examples: 192.168.0.1 or www.google.com or NONE (optional)
@set manualAdapter=			Examples: Wireless Network Connection or ALL (optional)

::-Filters- (Separate filter keywords with space. Matches are filtered OUT)
@set filterRouters=
@set filterAdapters=Tunnel VirtualBox VMnet VMware Loopback Pseudo Bluetooth Internal

::-GUI-
@set pretty=1
@set theme=subtle			none,subtle,vibrant,fullsubtle,fullvibrant,fullcolor,neon,crazy
@set viewmode=normal		mini,normal,details

::-User Interaction-
::Setting fullAuto to 1 will omit all user input and best guess is made for each decision;
::if 'requestDisableIPv6' is set to '1', changes that to '0' (auto-reject)
@set fullAuto=0

::Setting requestAdmin to 1 will request admin rights if it doesn't already have them.
::Admin rights are needed to enable/disable the Network Connection
@set requestAdmin=1

::This script can disable IPv6 if the computer has an excessive number of Tunnel adapters.
::Setting options: 0:auto-reject, 1:ask, 2:auto-accept
@set requestDisableIPv6=1

::-Advanced-
@set INT_StabilityHistory=25	Default: 25 [number of last tests to determine stability]
@set INT_flukechecks=0			Default: 0  (auto) [test x times to verify result]
@set INT_flukemaxtime=25		Default: 25 [test for maximum of x seconds to verify result (requires INT_flukechecks=0)]
@set INT_checkdelay=5			Default: 5  [wait x seconds between connectivity tests]
@set INT_fixdelay=10			Default: 10 [wait x seconds after resetting connection]
@set INT_flukecheckdelay=1		Default: 1  [wait x seconds between fluke checks]
@set INT_timeoutsecs=0			Default: 0  (auto) [wait x seconds for timeout]
@set INT_checkrouterdelay=0		Default: 0  (auto) [wait x number of connects before verifying router and adapter]

:: --------------------------------------
:: -      DO NOT EDIT BELOW HERE!       -
:: --------------------------------------
@PROMPT=^>&setlocal enabledelayedexpansion&setlocal enableextensions
%noclose%@set noclose=::&start "" "cmd" /k set CID=%CID%^&call "%~dpnx0"&exit
@call :init&call :checkRouterAdapter

:loop
%debgn%call :SETMODECON
%no_temp%set /a cleanTMPPnum+=1&(if !cleanTMPPnum! geq 200 (call :cleanTMPP&set cleanTMPPnum=0))
call :check&call :sleep %INT_checkdelay%&goto :loop

:getNETINFO
set /a gNI_arrLen+=0
if not %gNI_arrLen% equ 0 for /l %%n in (1,1,%gNI_arrLen%) do set net_%%n_cn=&set net_%%n_gw=
set gNI_arrLen=0&set gNI_needAdapter=1&set gNI_RESET=set net_^^!gNI_arrLen^^!_cn=^&set net_^^!gNI_arrLen^^!_gw=^&set /a gNI_arrLen-=1^&set gNI_needAdapter=1^&goto :eof
for /f "tokens=1 delims=%%" %%r in ('ipconfig') do echo "%%r" |FINDSTR /L "^& ^^ ^^! %%">nul || call :getNETINFO_parse %%r
goto :eof

:getNETINFO_parse
echo "%*" |FINDSTR /C:"adapter">nul && (set "line=%*"&goto :getNETINFO_parseAdapter)
if %gNI_needAdapter%==1 goto :eof
echo "%*" |FINDSTR /C:"disconnected">nul && (%gNI_RESET%)
echo "%*" |FINDSTR /C:"Default Gateway">nul && (set "line=%*"&goto :getNETINFO_parseRouter)
goto :eof

:getNETINFO_parseAdapter
if not "%filterAdapters%"=="" echo "%line%" |FINDSTR /I /L "%filterAdapters%">nul && (set gNI_needAdapter=1&goto :eof)
set gNI_needAdapter=0&set /a gNI_arrLen+=1&set line=%line:adapter =:%
for /f "tokens=2 delims=:" %%a in ("%line%") do set net_%gNI_arrLen%_cn=%%a
goto :eof

:getNETINFO_parseRouter
if not "%filterRouters%"=="" echo %line%|FINDSTR /I /L "%filterRouters%">nul && (%gNI_RESET%)
set line=%line: .=%&set line=!line:Default Gateway :=!
if "%line%"=="" (%gNI_RESET%)
set net_%gNI_arrLen%_gw=%line: =%&goto :eof

:header
set show_stbtlySTR=%stbltySTR:0=-%
set show_stbtlySTR=%show_stbtlySTR:1==%
set show_stbtlySTR=%show_stbtlySTR:2=*%
set show_stbtlySTR=%aft-%!show_stbtlySTR: =%-%!
if "%stbltySTR%"=="" set show_stbtlySTR=------------------------------------------------------------------------------
goto :header_%viewmode%

:header_mini
set /a h_dbl=dbl-1
set dsp_dbl=&if not %h_dbl% leq 0 set dsp_dbl=%h_dbl%/%INT_flukechecks%
cls&COLOR %curcolor%
echo  -----------------------------------
echo  ^|%ThisTitle%^|
echo  ^| http://electrodexs.net/scripts  ^|
echo. !show_stbtlySTR:~-%colnum%!
echo. %show_cur_ADAPTER%
echo. %cur_ROUTER%
echo. Up: %uptime% ^| Fixes: %numfixes%
echo. Last result: %result% %dsp_dbl%
echo. %curstatus%
goto :eof

:header_normal
cls&COLOR %curcolor%
echo  --------------------------------------------------
echo  ^|     -%ThisTitle%-        ^|
echo  ^|       http://electrodexs.net/scripts           ^|
if not "!show_stbtlySTR:~-%colnum%!"=="" echo. !show_stbtlySTR:~-%colnum%!
echo.
if not "%show_cur_ADAPTER%"=="" echo  Connection: %show_cur_ADAPTER%
if not "%cur_ROUTER%"=="" 		echo  Router:     %cur_ROUTER%
if not "%uptime%"=="" 			echo  Uptime:     %uptime% (started %GRT_TimeRan% ago)
if not "%stability%"==""		echo  Stability:  %stability%
echo.
if not %numfixes%==0 			echo  Fixes:      %numfixes%
if not "%result%"=="" 		echo  Last Test:  %result% %showdbl%
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
cls&COLOR %curcolor%
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
echo  Last Test:  %result% %showdbl%
echo  Status:     %curstatus%
goto :eof

:set_stability
if "%stblty_firstval%"=="" set stblty_firstval=%1
set /a stblty_tests+=1&set /a stblty_val+=%1&shift
if not "%1"=="" goto :set_stability
set /a stblty_over=stblty_tests-INT_StabilityHistory
if %stblty_over% geq 1 set /a stblty_over*=2&set /a stblty_val-=stblty_firstval&set stbltySTR=!stbltySTR:~%stblty_over%!
set /a stblty_result=100-((stblty_val*100)/stblty_tests)
set stability=Very Poor [7]&if %stblty_result% gtr 40 set stability=Poor [6]
if %stblty_result% gtr 55 set stability=Lower [5]&if %stblty_result% gtr 70 set stability=Low [4]
if %stblty_result% gtr 85 set stability=Fair [3]&if %stblty_result% gtr 94 set stability=Normal [2]
if %stblty_result% equ 100 set stability=High [1]
if %stblty_tests% leq %INT_StabilityHistory% set stability=Calculating...(%stblty_tests%/%INT_StabilityHistory%)
if %stblty_tests% gtr %INT_StabilityHistory% set INT_checkdelay=%orig_checkdelay%
set stblty_firstval=&set stblty_tests=&set stblty_val=&goto :eof

:countAdapters
set totalAdapters=0&set tA_plus=0
for /f "tokens=*" %%n in ('ipconfig ^|FINDSTR /C:"adapter"') do set /a totalAdapters+=1&(echo "%%n"|FINDSTR /L "& ^ %%">nul && set /a badnm+=1)
setlocal disabledelayedexpansion
for /f "tokens=*" %%n in ('ipconfig ^|FINDSTR /C:"adapter"') do @echo "%%n"|FINDSTR /L "!">nul && set /a badnm+=1
if not "%badnm%"=="0" if not "%badnm%"=="%oldbadnm%" (cls&echo.&echo Error: %badnm% or more adapter names have invalid symbols.&echo This script may not parse them correctly.&ping -n 11 127.0.0.1>nul)
endlocal&set badnm=0&set oldbadnm=%badnm%
if "%totalAdapters%"=="0" set tA_plus=1
set /a est_secs=((totalAdapters+%tA_plus%)*ca_percent)/100&goto :eof

:Update_avgca
set /a last_ca_percent+=0&set /a last_checkca+=0
set /a checkca=(%1*100)/ca_percent
if %checkca% geq 300 if not %last_checkca% geq 300 goto :eof
set num=0&set avg_ca_percent=0&set STR_ca_percent=
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
if not "%1"=="" if %num% lss %MX_avgtimeout% set /a avg_timeout+=%1&set STR_timeout=%STR_timeout% %1&set /a num+=1&shift&goto :Update_avgtimeout_loop
set /a timeoutmilsecs=(avg_timeout/num)+((avg_timeout/num)/2)
if %timeoutmilsecs% lss %MN_timeout% set timeoutmilsecs=%MN_timeout%
if %timeoutmilsecs% gtr %MX_timeout% set timeoutmilsecs=%MX_timeout%
goto :eof

:Update_avgdowntest
if "%AUTO_flukechecks%"=="" goto :eof
set num=0&set avg_downtest=0&set STR_downtest%result%=
:Update_avgdowntest_loop
if not "%1"=="" set /a avg_downtest+=%1&set STR_downtest%result%=!STR_downtest%result%! %1
if not "%1"=="" set /a num+=1&shift&goto :Update_avgdowntest_loop
set /a INT_flukechecks=(INT_flukemaxtime*1000)/((avg_downtest/num)+(INT_flukecheckdelay*1000))
if %INT_flukechecks% lss %MN_flukechecks% set INT_flukechecks=%MN_flukechecks%
if %INT_flukechecks% gtr %MX_flukechecks% set INT_flukechecks=%MX_flukechecks%
goto :eof

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

:checkRouterAdapter
set checkconnects=0&if not "%manualRouter%"=="" if not "%manualAdapter%"=="" goto :eof
call :precisiontimer cRA start
call :countAdapters&set curstatus=Verify Router/Adapter [%est_secs%s]
%debgn%call :header
call :getNETINFO
set cur_ROUTER=&set cur_ADAPTER=&set show_cur_ADAPTER=
if not "%manualAdapter%"=="" call :getRouter
if not "%manualRouter%"=="" call :getAdapter
if "%cur_ROUTER%%cur_ADAPTER%"=="" call :getRouterAdapter
if "%cur_ROUTER%%cur_ADAPTER%"=="" call :EnumerateAdapters

:checkRouterAdapter_end
call :precisiontimer cRA tot
set /a tot/=100&set /a timepassed+=!tot!
if not %tot%==0 set /a new_ca_percent=(tot*100)/(totalAdapters+%tA_plus%)
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
if "%cur_ROUTER%"=="" call :Ask4NET router
goto :eof

:getAdapter
set cur_ROUTER=%manualRouter%
if /i "%manualRouter%"=="none" set cur_ROUTER=
if %gNI_arrLen%==0 goto :eof
if %gNI_arrLen%==1 set cur_ADAPTER=%net_1_cn%&goto :eof
for /l %%n in (1,1,%gNI_arrLen%) do if "%manualRouter%"=="!net_%%n_gw!" set cur_ADAPTER=!net_%%n_cn!
if "%cur_ADAPTER%"=="" call :Ask4NET adapter
set show_cur_ADAPTER=%cur_Adapter%
if /i "%manualAdapter%"=="all" set cur_ADAPTER=&set show_cur_ADAPTER=[Reset All Connections on Error]
goto :eof

:check
@set curstatus=Testing connectivity...
%debgn%call :header
set ping_test=&set result=&set testrouter=%secondaryRouter%
if not "%cur_ROUTER%"=="" if %dbl% equ 0 set testrouter=%cur_ROUTER%
if not "%manualRouter%"=="" set testrouter=%cur_ROUTER%
if "%timeoutmilsecs_add%"=="1" set /a timeoutmilsecs+=1000&set timeoutmilsecs_add=0

call :precisiontimer PING start
for /f "tokens=* delims=" %%p in ('ping -w %timeoutmilsecs% -n 1 %testrouter%') do set ping_test=!ping_test! %%p
call :precisiontimer PING pingtime
set /a pingtime*=10
echo "%ping_test%" |FINDSTR /C:"Reply from " >nul && (set result=Connected&set chkresup=&set chkresdn=::)
echo "%ping_test%" |FINDSTR /C:"request could not find" /C:"Unknown host" /C:"unreachable" /C:"General failure" >nul
if %errorlevel% equ 0 set result=NotConnected&set chkresup=::&set chkresdn=
if "%result%"=="" set result=TimeOut&set chkresup=::&set chkresdn=&set /a timeoutmilsecs_add=1

%chkresup%set /a checkconnects+=1
%chkresup%if %lastresult%==dn set /a timepassed/=2&if not "%resetted%"=="1" set checkconnects=force
%chkresup%if %lastresult%==dn if "%resetted%"=="1" if "%cur_Adapter%"==""  set checkconnects=force
%chkresup%if %timepassed% leq 0 set timepassed=1
%chkresup%set /a up+=timepassed&set curcolor=%norm%&set stbltySTR=%stbltySTR% 0
%chkresdn%if %lastresult%==up set /a timepassed/=2
%chkresdn%if %timepassed% leq 0 set timepassed=1
%chkresdn%set /a down+=timepassed&if "%result%"=="TimeOut" set /a down+=INT_timeoutsecs
%chkresdn%set curcolor=%warn%&set stbltySTR=%stbltySTR% 1&if not %dbl%==0 call :setSecondaryRouter
%chkresdn%call :Update_avgdowntest !STR_downtest%result%! %pingtime%

set timepassed=0&if %dbl% gtr 0 set showdbl=(fluke check %dbl%/%INT_flukechecks%)
set /a dbl+=1&call :update_avgtimeout %pingtime% %STR_timeout%
call :set_uptime&call :set_stability %stbltySTR%
if "%result%"=="Connected" if not %lastresult%==up if "%resetted%"=="1" set /a numfixes+=1
set lastresult=dn&if "%result%"=="Connected" (set resetted=0&set lastresult=up)
if "%result%"=="NotConnected" call :check_adapterenabled
if not "%result%"=="Connected" if not %dbl% gtr %INT_flukechecks% call :sleep %INT_flukecheckdelay%&goto :check
if not "%result%"=="Connected" if %dbl% gtr %INT_flukechecks% call :resetConnection
set dbl=0&set showdbl=&set STR_downtestNotConnected=&set STR_downtestTimeOut=&goto :eof

:check_adapterenabled
if "%isAdmin%"=="0" goto :eof
if "%cur_ADAPTER%"=="" goto :eof
ipconfig |FINDSTR /C:"adapter %cur_ADAPTER%:">nul && goto :eof
@set curstatus=Enabling adapter...&set curcolor=%pend%&set resetted=1
%debgn%call :header
%no_netsh%%rsetnetsh%"%cur_ADAPTER%" admin=enable>nul 2>&1
%no_netsh%if %errorlevel%==0 set stbltySTR=%stbltySTR% 2&call :sleep %INT_fixdelay%&goto :eof
%no_wmic%%rsetwmic%%cur_ADAPTER%'" call enable
%no_wmic%if %errorlevel%==0 set stbltySTR=%stbltySTR% 2&call :sleep %INT_fixdelay%&goto :eof
%no_temp%%no_cscript%call :resetAdapter_oldOS enable %cur_ADAPTER%&set stbltySTR=%stbltySTR% 2
goto :eof

:setSecondaryRouter
%sSR_init%set sSR_addr=www.google.com;www.ask.com;www.yahoo.com;www.bing.com&set sSR_init=::
for /f "tokens=%sSR_num% delims=;" %%r in ("%sSR_addr%") do set secondaryRouter=%%r
if "%secondaryRouter%"=="" set sSR_num=1&goto :setSecondaryRouter
set /a sSR_num+=1&goto :eof

:sleep
if "%1"=="" set pn=3
if not "%1"=="" set pn=%1&if !pn! equ 0 goto :eof
if "%checkconnects%"=="force" call :checkRouterAdapter&set /a pn-=tot
if not "%stability:~0,4%"=="Calc" if "%lastResult%"=="Connected" if %checkconnects% geq %INT_checkrouterdelay% call :checkRouterAdapter&set /a pn-=tot
if %pn% leq 0 goto :eof
@set curstatus=Wait %pn% seconds...
%debgn%call :header
set /a timepassed+=pn&set /a pn=!pn!+1
ping -n %pn% -w 1000 127.0.0.1>nul&goto :eof

:SETMODECON
if /i "%viewmode%"=="mini" set cols=37&set lines=10
if /i "%viewmode%"=="normal" set cols=52&set lines=14
if /i "%viewmode%"=="details" set cols=80&set lines=28
if not "%1"=="" set cols=%1&set lines=%2
if not "%pretty%"=="1" set cols=80&set lines=900
MODE CON COLS=%cols% LINES=%lines%&goto :eof

:crazy
set /a cr_num=%random:~-1%&set /a cr_num=!cr_num!+!random:~-1!
if %cr_num% gtr 15 goto :crazy
:crazy2
set /a cr_num2=%random:~-1%-1
set /a cr_num2+=%random:~-1%-1
if %cr_num2% gtr 15 goto :crazy2
if "%cr_num%"=="%cr_num2%" goto :crazy
COLOR !crazystr:~%cr_num%,1!!crazystr:~%cr_num2%,1!&goto :eof

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
if %GRT_c_month% lss %GRT_s_month% set /a GRT_c_month+=12&set GRT_c_year-=1
if %GRT_c_day% lss %GRT_s_day% set /a GRT_c_day+=GRT_MO_%GRT_lastmonth%&set GRT_c_month-=1
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
if %GRT_c_year% geq 10000 set GRT_TimeRan=Over 10,000 years&set toolong=goto :eof&goto :eof
set GRT_TimeRan=%GRT_c_hour%:%GRT_c_min%:%GRT_c_sec%
if %GRT_c_year% neq 0 set GRT_TimeRan=%GRT_c_year%y %GRT_c_month%m %GRT_c_day%d %GRT_TimeRan%&goto :eof
if %GRT_c_month% neq 0 set GRT_TimeRan=m:%GRT_c_month%m %GRT_c_day%d %GRT_TimeRan%&goto :eof
if %GRT_c_day% neq 0 set GRT_TimeRan=%GRT_c_day%d %GRT_TimeRan%
goto :eof
:getruntime_init
set GRT_s_year=%DATE:~10,4%&set GRT_s_month=%DATE:~4,2%&set GRT_s_day=%DATE:~7,2%
set GRT_s_hour=%TIME:~0,2%&set GRT_s_min=%TIME:~3,2%&set GRT_s_sec=%TIME:~6,2%
for /f "tokens=1 delims==" %%a in ('set GRT_s_') do if "!%%a:~0,1!"=="0" set /a %%a=!%%a:~1,1!+0
set GRT_MO_1=31&set GRT_MO_3=31&set GRT_MO_4=30&set GRT_MO_5=31
set GRT_MO_6=30&set GRT_MO_7=31&set GRT_MO_8=31&set GRT_MO_9=30
set GRT_MO_10=31&set GRT_MO_11=30&set GRT_MO_12=31&goto :eof

:findprocess
%no_tasklist%tasklist /fo:csv|FINDSTR /I /C:"%*">nul && exit /b 0
%no_tasklist%exit /b 1
%no_pslist%set proc=%*&set proc=!proc:~0,-4!
%no_pslist%(pslist -e %proc%)>nul 2>&1 && exit /b 0
%no_pslist%exit /b 1& REM Proc name max 15 char
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
%no_tlist%tlist|FINDSTR /I /C:"%*">nul && exit /b 0
%no_tlist%exit /b 1
set no_proclist=::&exit /b 2

:EnumerateAdapters
set adapters_arrLen=0&set EAwmic=
%no_wmic%call :antihang 20 wmicnetadapt wmic.exe nic get NetConnectionID || (set EAwmic=::&goto :EnumerateAdapters_alt)
%no_wmic%%no_temp%for /f "usebackq tokens=* delims=" %%n in ("%TMPP%\wmicnetadapt%CID%") do echo "%%n" |FINDSTR /L "^& ^^! %% ^^">nul || call :EnumerateAdapters_parse %%n
%no_wmic%if "%no_temp%"=="::" for /f "tokens=1* delims==" %%n in ('set wmicnetadapt') do (set "%%n="&echo "%%o" |FINDSTR /L "^& ^^! %% ^^">nul || call :EnumerateAdapters_parse %%o)
%no_wmic%DEL /F /Q "%TMPP%"\wmicnetadapt%CID% >nul 2>&1&goto :eof
:EnumerateAdapters_alt
%no_wmic%%no_temp%DEL /F /Q "%TMPP%"\wmicnetadapt%CID% >nul 2>&1
%no_netsh%for /f "tokens=* delims=" %%n in ('netsh int show int') do echo "%%n" |FINDSTR /L "^& ^^! %% ^^">nul || call :EnumerateAdapters_parse %%n
%no_netsh%for /f "tokens=* delims=" %%n in ('netsh mbn show int') do echo "%%n" |FINDSTR /L "^& ^^! %% ^^">nul || call :EnumerateAdapters_parseMBN %%n
goto :eof

:EnumerateAdapters_parse
if "%*"=="" goto :eof
set line=%*&if "!line!"=="NetConnectionID" goto :eof
if "%line:~0,11%"=="Admin State" goto :eof
if "%line:~0,4%"=="----" goto :eof
if not "%filterAdapters%"=="" echo %line%|FINDSTR /I /L "%filterAdapters%">nul && goto :eof
set /a adapters_arrLen+=1
%no_wmic%%EAwmic%set adapters_%adapters_arrLen%_name=%line%&goto :eof
set EA_tokens=3&(echo "%2"|FINDSTR /I /C:"connected" /C:"Unreachable">nul || set EA_tokens=2)
for /f "tokens=%EA_tokens%* delims= " %%c in ("%line%") do set adapters_%adapters_arrLen%_name=%%d
goto :eof

:EnumerateAdapters_parseMBN
echo "%*"|FINDSTR /C:"Name">nul || goto :eof
set line=%*&if not "%filterAdapters%"=="" echo !line!|FINDSTR /I /L "%filterAdapters%">nul && goto :eof
set /a adapters_arrLen+=1&set adapters_!adapters_arrLen!_name=%line:*: =%&goto :eof

:resetConnection
set curcolor=%alrt%&set curstatus=Attempting to fix connection...&set stbltySTR=%stbltySTR% 2
%debgn%call :header
set resetted=1&if "%cur_ADAPTER%"=="" call :resetConnection_all
if not "%cur_ADAPTER%"=="" call :resetConnection_one
set curcolor=%pend%&call :sleep %INT_fixdelay%&set checkconnects=force&goto :eof

:resetConnection_all
ipconfig /release>nul 2>&1&ipconfig /flushdns>nul 2>&1
%use_admin%set use_netsh=::
%use_admin%%no_netsh%%rsetnetsh%"%adapters_1_name%" admin=disable>nul 2>&1 && (set use_netsh=&set use_wmic=::&set use_vbs=::)
%use_admin%%use_netsh%for /l %%n in (1,1,%adapters_arrLen%) do %rsetnetsh%"!adapters_%%n_name!" admin=disable>nul 2>&1&%rsetnetsh%"!adapters_%%n_name!" admin=enable>nul 2>&1
%use_admin%%no_wmic%%use_wmic%set use_wmic=::&(%rsetwmic%%adapters_1_name%'" call disable && (set use_wmic=&set use_vbs=::))
%use_admin%%no_wmic%%use_wmic%for /l %%n in (1,1,%adapters_arrLen%) do %rsetwmic%!adapters_%%n_name!'" call disable&%rsetwmic%!adapters_%%n_name!'" call enable
%use_admin%%use_vbs%%no_temp%%no_cscript%for /l %%n in (1,1,%adapters_arrLen%) do call :resetAdapter_oldOS disable !adapters_%%n_name!&call :resetAdapter_oldOS enable !adapters_%%n_name!
ipconfig /renew>nul 2>&1&goto :eof

:resetConnection_one
ipconfig /release "%cur_ADAPTER%">nul 2>&1
ipconfig /flushdns "%cur_ADAPTER%">nul 2>&1
%use_admin%%no_netsh%set use_netsh=::&(%rsetnetsh%"%cur_Adapter%" admin=disable>nul 2>&1 && (set use_netsh=&set use_wmic=::&set use_vbs=::))
%use_admin%%no_netsh%%use_netsh%%rsetnetsh%"%cur_ADAPTER%" admin=enable>nul 2>&1
%use_admin%%no_wmic%%rsetwmic%%cur_ADAPTER%'" call disable && (%rsetwmic%%cur_ADAPTER%'" call enable&set use_wmic=&set use_vbs=::)
%use_admin%%use_vbs%%no_temp%%no_cscript%call :resetAdapter_oldOS disable "%cur_ADAPTER%"&call :resetAdapter_oldOS enable "%cur_ADAPTER%"
ipconfig /renew "%cur_ADAPTER%">nul 2>&1&goto :eof

:antihang
set proc=%*&set proc=!proc:%1 %2 =!&set procsuccess=1
%no_temp%set temperrfile=%TMPP%\procerrlvl%CID%
%no_temp%set tempoutput= 1^^^>"%TMPP%\%2%CID%.tmp" 2^^^>^^^>"%temperrfile%.tmp"
%no_temp%set geterrlvl= ^^^& (echo .^^^>^^^>"%temperrfile%.tmp")
%no_temp%start /b "" cmd /c %proc%%tempoutput%%geterrlvl%&set startedproc=::
%startedproc%if "%2"=="null" start /b "" cmd /c %proc%>nul 2>&1&set startedproc=::
%startedproc%for /f "tokens=*" %%n in ('%proc%') do (set "%2!ah_num!=%%n"&set /a ah_num+=1)
%startedproc%set procsuccess=0&goto :antihang_reset
:antihang_wait
set /a waitproc+=1
%procfinished%%no_proclist%call :findprocess %3 && (if %waitproc% leq %1 (ping -n 2 127.0.0.1>nul&goto :antihang_wait))
%procfinished%%no_proclist%set procfinished=::&if "%no_temp%"=="::" set procsuccess=0
%no_temp%if not exist "%temperrfile%.tmp" if %waitproc% leq %1 (ping -n 2 127.0.0.1>nul&goto :antihang_wait)
%no_temp%TYPE "%temperrfile%.tmp" > "%temperrfile%"
%no_temp%for /f "usebackq tokens=* delims=" %%t in ("%temperrfile%") do if not "%%t"=="" set "procerr=!procerr!%%t"
%no_temp%if "%procerr%"=="" if %waitproc% leq %1 (ping -n 2 127.0.0.1>nul&goto :antihang_wait)
%no_temp%if "%procerr%"=="." set procsuccess=0
if "%no_temp%%no_proclist%"=="::::" ping -n %1 127.0.0.1>nul
%no_prockill%if "%no_temp%%no_proclist%"=="::::" (%prockill% %3)>nul 2>&1 || set procsuccess=0
:antihang_reset
%no_prockill%(%prockill% %3)>nul 2>&1
%no_temp%DEL /F /Q "%temperrfile%*">nul 2>&1
%no_temp%TYPE "%TMPP%\%2%CID%.tmp">"%TMPP%\%2%CID%"&DEL /F /Q "%TMPP%\%2%CID%.tmp">nul 2>&1
%no_temp%DEL /F /Q "%TMPP%\null%CID%">nul 2>&1
for /f "tokens=1 delims==" %%n in ('set null 2^>nul') do set %%n=
set waitproc=0&set procfinished=&set procerr=&set proc=&set startedproc=&set ah_num=0&exit /b %procsuccess%

:resetAdapter_oldOS
if /I "%1"=="enable" set disoren=Enable&set trufalse=false
if /I "%1"=="disable" set disoren=Disable&set trufalse=true
set reset_adaptername=%*&set reset_adaptername=!reset_adaptername:%1 =!
set resetfile=%TMPP%\resetadapter%CID%.vbs
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
@echo end if '>>"%resetfile%"&echo next '>>"%resetfile%"
@echo if oNetConnections is nothing then '>>"%resetfile%"
@echo wscript.quit '>>"%resetfile%"&echo end if '>>"%resetfile%"
@echo set oLanConnection = nothing '>>"%resetfile%"
@echo for each folderitem in oNetConnections.items '>>"%resetfile%"
@echo if lcase(folderitem.name) = lcase("%reset_adaptername%") then '>>"%resetfile%"
@echo set oLanConnection = folderitem: exit for '>>"%resetfile%"
@echo end if '>>"%resetfile%"&echo next '>>"%resetfile%"
@echo Dim objFSO '>>"%resetfile%"&echo if oLanConnection is nothing then '>>"%resetfile%"
@echo wscript.quit '>>"%resetfile%"&echo end if '>>"%resetfile%"
@echo bEnabled = true '>>"%resetfile%"&echo set oEnableVerb = nothing '>>"%resetfile%"
@echo set oDisableVerb = nothing '>>"%resetfile%"
@echo s = "Verbs: " ^& vbcrlf '>>"%resetfile%"
@echo for each verb in oLanConnection.verbs '>>"%resetfile%"
@echo s = s ^& vbcrlf ^& verb.name '>>"%resetfile%"
@echo if verb.name = sEnableVerb then '>>"%resetfile%"
@echo set oEnableVerb = verb '>>"%resetfile%"&echo bEnabled = false '>>"%resetfile%"
@echo end if '>>"%resetfile%"&echo if verb.name = sDisableVerb then '>>"%resetfile%"
@echo set oDisableVerb = verb '>>"%resetfile%"&echo end if '>>"%resetfile%"
@echo next '>>"%resetfile%"&echo if bEnabled = %trufalse% then '>>"%resetfile%"
@echo o%disOrEn%Verb.DoIt '>>"%resetfile%"&echo end if '>>"%resetfile%"
@echo wscript.sleep 2000 '>>"%resetfile%"
%debgn%@echo off
call :antihang 25 null cscript.exe //E:VBScript //T:25 //NoLogo "%resetfile%"
DEL /F /Q "%resetfile%">nul 2>&1&goto :eof

:detectIsAdmin
%no_temp%DEL /F /Q "%TMPP%\getadmin*.vbs">nul 2>&1
%no_sfc%for /f "tokens=* delims=" %%s in ('sfc 2^>^&1^|MORE') do @set "output=!output!%%s"
set isAdmin=0&echo "%output%"|findstr /I /C:"/scannow">nul 2>&1 && set isAdmin=1
:dIA_kill
%no_prockill%%no_tasklist%for /f "tokens=2 delims=," %%p in ('tasklist /V /FO:CSV ^|FINDSTR /C:"Limited: %ThisTitle%" 2^>nul') do (%killPID% %%p>nul 2>&1 && goto :dIA_kill)
%no_prockill%%no_tlist%for /f %%p in ('tlist ^|FINDSTR /C:"Limited: %ThisTitle%" 2^>nul') do (%killPID% %%p>nul 2>&1 && goto :dIA_kill)
if %isAdmin%==1 goto :eof
title Limited: %ThisTitle%
if not "%requestAdmin%"=="1" goto :eof
%no_winfind%%no_prockill%%no_temp%%no_cscript%echo Set StartAdmin = CreateObject^("Shell.Application"^) > "%TMPP%\getadmin%CID%.vbs"
%no_winfind%%no_prockill%%no_temp%%no_cscript%echo StartAdmin.ShellExecute "%~s0", "", "", "runas", 1 >> "%TMPP%\getadmin%CID%.vbs"
%no_winfind%%no_prockill%%no_temp%%no_cscript%cls&echo.&echo Requesting admin rights...&echo (This will close upon successful request)
%no_winfind%%no_prockill%%no_temp%%no_cscript%start /b "" cscript //E:VBScript //B //T:1 "%TMPP%\getadmin%CID%.vbs" //nologo
%no_winfind%%no_prockill%%no_temp%%no_cscript%ping -n 11 127.0.0.1>nul&DEL /F /Q "%TMPP%\getadmin%CID%.vbs">nul 2>&1
goto :eof

:Ask4NET
if not "%1"=="adapter" if "%fullAuto%"=="1" set manualRouter=%secondaryRouter%&set cur_ROUTER=%secondaryRouter%
if "%1"=="router" if "%fullAuto%"=="1" goto :eof
if not "%1"=="router" if "%fullAuto%"=="1" set manualAdapter=all&set cur_ADAPTER=&set show_cur_ADAPTER=[Reset All Connections on Error]&goto :eof
call :precisiontimer cRA halt
if "%1"=="adapter" call :EnumerateAdapters
%debgn%set /a lines=%gNI_arrLen%+11
%debgn%call :SETMODECON 70 %lines%
echo.&echo Which one would you like to monitor?&echo.&echo Choose by the selection number below.
if not "%1"=="router" echo You may also enter x to cancel.
if "%1"=="router" echo You may also type in a router address to use, or x to cancel.
echo.&if not "%1"=="adapter" echo  #     Router Adress                  Associated Connection
if not "%1"=="adapter" echo  ----- ------------------------------ -----------------------------
if not "%1"=="adapter" for /l %%n in (1,1,%gNI_arrLen%) do set showroutr%%n=[%%n]%statspacer%
if not "%1"=="adapter" for /l %%n in (1,1,%gNI_arrLen%) do set showroutr%%n=!showroutr%%n:~0,5! !net_%%n_gw!%statspacer%
if not "%1"=="adapter" for /l %%n in (1,1,%gNI_arrLen%) do set showroutr%%n=!showroutr%%n:~0,36! !net_%%n_cn!%statspacer%
if not "%1"=="adapter" for /l %%n in (1,1,%gNI_arrLen%) do echo -!showroutr%%n:~0,68!
if "%1"=="adapter" echo  #     Connection
if "%1"=="adapter" echo  ----- -------------------------------------------
if "%1"=="adapter" for /l %%n in (1,1,%adapters_arrLen%) do set showconn%%n=[%%n]%statspacer%
if "%1"=="adapter" for /l %%n in (1,1,%adapters_arrLen%) do set showconn%%n=!showconn%%n:~0,5! !adapters_%%n_name!%statspacer%
if "%1"=="adapter" for /l %%n in (1,1,%adapters_arrLen%) do echo -!showconn%%n:~0,50!
echo.&set usrinput=&set usrinput2=
set /p usrinput=[] 
if "%usrinput%"=="" set usrinput=1
if not "%1"=="adapter" for /l %%n in (1,1,%gNI_arrLen%) do if "%usrinput%"=="%%n" set cur_ROUTER=!net_%%n_gw!
if not "%1"=="adapter" if "%manualAdapter%"=="" for /l %%n in (1,1,%gNI_arrLen%) do if "%usrinput%"=="%%n" set cur_ADAPTER=!net_%%n_cn!
if "%1"=="adapter" for /l %%n in (1,1,%adapters_arrLen%) do if "%usrinput%"=="%%n" set cur_ADAPTER=!adapters_%%n_name!
if "%usrinput%"=="x" if not "%1"=="adapter" set cur_ROUTER=%secondaryRouter%
if "%usrinput%"=="x" if not "%1"=="router" set manualAdapter=all&set cur_Adapter=&set show_cur_ADAPTER=[Reset All Connections on Error]&goto :eof
if "%1"=="router" if "%cur_ROUTER%"=="" cls&echo.&echo.&echo Use "%usrinput%" as router address?
if "%1"=="router" if "%cur_ROUTER%"=="" set /p usrinput2=[y/n] 
if "%1"=="router" if "%cur_ROUTER%"=="" if "%usrinput2%"=="" set cur_ROUTER=%usrinput%
if "%1"=="router" if "%cur_ROUTER%"=="" if /i "%usrinput2%"=="y" set cur_ROUTER=%usrinput%
if "%1"=="router" if "%cur_ROUTER%"=="" goto :Ask4NET
if "%1"=="adapter" if "%cur_ADAPTER%"=="" goto :Ask4NET
if not "%1"=="adapter" set manualRouter=%cur_ROUTER%
if not "%1"=="router" set manualAdapter=%cur_ADAPTER%&set show_cur_ADAPTER=%cur_ADAPTER%
cls&call :SETMODECON&goto :eof

:countTunnelAdapters
set totalTunnelAdapters=0&for /f %%n in ('ipconfig ^|FINDSTR /C:"Tunnel"') do set /a totalTunnelAdapters+=1
goto :eof

:alert_2manyconnections
call :SETMODECON 60 20&if %requestDisableIPv6%==1 if %fullAuto%==1 set requestDisableIPv6=0
set /a est_min=est_secs/60
set /a est_sec=est_secs-(est_min*60)
set rkey=hklm\system\currentcontrolset\services\tcpip6\parameters
set rval=DisabledComponents
for /f "tokens=3*" %%i in ('reg query "%rkey%" /v "%rval%" ^| FINDSTR /I "%rval%"') DO set ipv6_dsbld=%%i
:alert_2manyconnections_ask
cls&set usrInput=&echo.&echo    -- Warning: Excessive number of Network Connections --
echo.&echo  Network Connections: %totalAdapters%
echo  Tunnel Adapters: %totalTunnelAdapters%
echo  Est. configure time: %est_min% min, %est_sec% sec
echo.&echo  Excessive network connections can cause performance and 
echo  stability issues, including long delays in connecting to 
echo  a network and/or the internet.&echo.&echo.
if "%isAdmin%"=="0" ping 127.0.0.1>nul&ping 127.0.0.1>nul&goto :eof
if "%requestDisableIPv6%"=="0" ping 127.0.0.1>nul&ping 127.0.0.1>nul&goto :eof
if "%ipv6_dsbld%"=="0xffffffff" ping 127.0.0.1>nul&ping 127.0.0.1>nul&goto :eof
if "%requestDisableIPv6%"=="2" goto :disable_IPv6
echo Do you wish to disable IPv6 to remove some of these
set /p usrInput=network connections?[y/n] 
if /i "%usrInput%"=="y" goto :disable_IPv6
if /i "%usrInput%"=="n" goto :alert_2manyconnections_ask_no
goto :alert_2manyconnections_ask

:alert_2manyconnections_ask_no
cls&echo.&echo.&echo  This option can be disabled by editing this script's 
echo  settings. Settings can be accessed by opening this
echo  script with notepad.&echo.&echo Press any key to continue...&pause&goto :eof

:disable_IPv6
set oldnumtotal=%totalAdapters%&cls&echo.&echo Disable IPv6:&set disableipv6_err=0
echo. |set /p dummy=-add 'DisableComponents' to registry...
echo y|reg add "%rkey%" /v "%rval%" /t REG_DWORD /d 4294967295>nul 2>&1 || (echo Fail %errorlevel%&set disableipv6_err=1)
%no_netsh%echo.&echo. |set /p dummy=-set netsh interface teredo state disable...
%no_netsh%netsh interface teredo set state disable>nul 2>&1 || (echo. |set /p dummy=Fail %errorlevel%&set /a disableipv6_err+=1)
%no_netsh%echo.&echo. |set /p dummy=-set netsh interface 6to4 state disable...
%no_netsh%netsh interface 6to4 set state disabled>nul 2>&1 || (echo. |set /p dummy=Fail %errorlevel%&set /a disableipv6_err+=1)
%no_netsh%echo.&echo. |set /p dummy=-set netsh interface isatap state disable...
%no_netsh%netsh interface isatap set state disabled>nul 2>&1 || (echo. |set /p dummy=Fail %errorlevel%&set /a disableipv6_err+=1)
echo.&if %disableipv6_err% geq 1 echo.&echo %disableipv6_err% commands did not complete successfully.
if %disableipv6_err% leq 0 echo.&echo Commands completed successfully.
%no_netsh%call :countAdapters&set /a removedadapters=oldnumtotal-totaladapters&echo Removed !removedadapters! adapters&echo.
echo You may have to reboot your computer for some changes to&echo take effect.
ping 127.0.0.1>nul&ping 127.0.0.1>nul&goto :eof

:testValidPATHS
set thisdir=%~dp0
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
ping /?>nul 2>&1 || (echo Critical error: PING error.&echo Press any key to exit...&pause>nul&exit)
ipconfig >nul 2>&1 || (echo Critical error: IPCONFIG error.&echo Press any key to exit...&pause>nul&exit)
for %%c in (framedyn.dll) do if "%%~$PATH:c"=="" set no_taskkill=::
for %%c in (sfc.exe) do if "%%~$PATH:c"=="" set no_sfc=::
set no_kill=::&(kill /?>nul 2>&1 && (set prockill=kill&set no_kill=&set killPID=kill /f))
set no_pskill=::&pskill /?>nul 2>&1& if !errorlevel! leq 0 set prockill=pskill&set no_pskill=&set killPID=pskill& REM Normal returns -1
set no_tskill=::&(tskill /?>nul 2>&1 && (set no_tskill=&set prockill=tskill&set killPID=tskill))
%no_taskkill%set no_taskkill=::&(taskkill /?>nul 2>&1 && (set no_taskkill=&set prockill=taskkill /im&set killPID=taskkill /f /pid))
if "%prockill%"=="" set no_prockill=::
tlist /?>nul 2>&1 || set no_tlist=::
tasklist /?>nul 2>&1 || set no_tasklist=::
pslist >nul 2>&1 || set no_pslist=::
if "%no_tlist%%no_tasklist%"=="::::" set no_winfind=::
if "%no_tlist%%no_tasklist%%no_pslist%"=="::::::" set no_proclist=::
set no_reg=::&set reg1=::&set reg2=::&(reg /?>nul 2>&1 && set no_reg=&set reg1=)&if !errorlevel!==5005 set no_reg=&set reg2=
cscript /?>nul 2>&1 || set no_cscript=::
netsh help >nul 2>&1 || set no_netsh=::
call :antihang 11 null wmic.exe os get status || set no_wmic=::
if "%no_netsh%%no_wmic%"=="::::" (echo Critical error: This script requires either NETSH or WMIC.&echo Press any key to exit...&pause>nul&exit)
goto :eof

:disableQuickEdit
set qkey=HKEY_CURRENT_USER\Console&set qval=QuickEdit
%no_reg%%reg1%if not "%qedit_dsbld%"=="" (echo y|reg add "%qkey%" /v "%qval%" /t REG_DWORD /d %qedit_dsbld%&cls&%initializing%&goto :eof)
%no_reg%%reg1%for /f "tokens=3*" %%i in ('reg query "%qkey%" /v "%qval%" ^| FINDSTR /I "%qval%"') DO (set qedit_dsbld=%%i)&if "!qedit_dsbld!"=="0x0" goto :eof
%no_reg%%reg1%echo y|reg add "%qkey%" /v "%qval%" /t REG_DWORD /d 0&cls&start "" "cmd" /k set CID=%CID%^&set qedit_dsbld=%qedit_dsbld% ^& call "%~dpnx0"&exit
%no_reg%%reg2%if not "%qedit_dsbld%"=="" (reg update "%qkey%\%qval%"=%qedit_dsbld%&cls&%initializing%&goto :eof)
%no_reg%%reg2%for /f "tokens=3*" %%i in ('reg query "%qkey%\%qval%"') DO (set qedit_dsbld=%%i)&if "!qedit_dsbld!"=="0" goto :eof
%no_reg%%reg2%if "%qedit_dsbld%"=="" (reg add "%qkey%\%qval%"=0 REG_DWORD&start "" "cmd" /k set CID=%CID%^&set qedit_dsbld=%qedit_dsbld% ^&call "%~dpnx0"&exit)
%no_reg%%reg2%if "%qedit_dsbld%"=="1" (reg update "%qkey%\%qval%"=0&start "" "cmd" /k set CID=%CID%^& call "%~dpnx0"&exit)
%no_regedit%%no_temp%echo REGEDIT4>"%TMPP%\quickedit3%CID%.reg"&(regedit /S "%TMPP%\quickedit3%CID%.reg" || set no_regedit=::)
%no_regedit%%no_temp%DEL /F /Q "%TMPP%\quickedit3%CID%.reg"&cls&%initializing%
%no_regedit%%no_temp%if exist "%TMPP%\quickedit%CID%.reg" regedit /S "%TMPP%\quickedit%CID%.reg"&DEL /F /Q "%TMPP%\quickedit%CID%.reg"&goto :eof
%no_regedit%%no_temp%regedit /S /e "%TMPP%\quickedit%CID%.reg" "%qkey%"
%no_regedit%%no_temp%echo REGEDIT4>"%TMPP%\quickedit2%CID%.reg"&echo [%qkey%]>>"%TMPP%\quickedit2%CID%.reg"
%no_regedit%%no_temp%(echo "%qval%"=dword:00000000)>>"%TMPP%\quickedit2%CID%.reg"
%no_regedit%%no_temp%regedit /S "%TMPP%\quickedit2%CID%.reg"&DEL /F /Q "%TMPP%\quickedit2%CID%.reg"&start "" "cmd" /k set CID=%CID%^& call "%~dpnx0"&exit
goto :eof

:crashAlert
@start /b /wait "" "cmd" /c set CID=%CID%^&call "%~dpnx0"
@echo.&echo Script crashed. Please contact ElectrodeXSnet@gmail.com with the above error.&@pause>nul&exit

:init
@call :setn_defaults
@call :init_settnBOOL %settingsBOOL%
@if "%pretty%"=="0" set debgn=::
%debgn%@echo off
call :init_settnSTR viewmode %viewmode%&set initializing=echo.^&echo Please wait while qNET starts...
echo " %viewmode% "|FINDSTR /C:" mini " /C:" normal " /C:" details ">nul || set viewmode=%D_viewmode%
call :SETMODECON&%initializing%&set version=4.2.342
set ThisTitle=Lectrode's Quick Net Fix v%version%&call :init_settnINT %settingsINT%
%alertoncrash%TITLE %ThisTitle%
if "%CID%"=="" call :init_CID
%alertoncrash%call :testValidPATHS&call :testCompatibility&call :detectIsAdmin&call :disableQuickEdit
%alertoncrash%@set alertoncrash=::&goto :crashAlert
if "%isAdmin%"=="0" set use_admin=::&title Limited: %thistitle%
%no_temp%call :cleanTMPP
%debgn%@call :init_colors %theme%
set statspacer=                                                               .
call :getruntime
echo ,%requestDisableIPv6%,|FINDSTR /L ",0, ,1, ,2,">nul || set reqeustDisableIPv6=%D_requestDisableIPv6%
set numfixes=0&set up=0&set down=0&set lastResult=up
set timepassed=0&set dbl=0&set numAdapters=0&set checkconnects=0
set ca_percent=5&set MN_crd=5&set MX_crd=120&set MX_avgca=5
set MX_avgtimeout=5&set MN_timeout=100&set MX_timeout=5000
set MN_flukechecks=3&set MX_flukechecks=7&set INT_flukemaxtime*=1000
set orig_checkdelay=%INT_checkdelay%&set INT_checkdelay=1
if %INT_checkrouterdelay%==0 set AUTO_checkrouterdelay=1
if %INT_timeoutsecs%==0 set AUTO_timeoutsecs=1&call :update_avgtimeout 3000
if "%AUTO_timeoutsecs%"=="" set /a timeoutmilsecs=1000*INT_timeoutsecs
if %INT_flukechecks%==0 set AUTO_flukechecks=1&set INT_flukechecks=7
set sSR_num=1&call :setSecondaryRouter
call :init_manualRouter %manualRouter%
for /f "tokens=1 DELIMS=:" %%a in ("%manualAdapter%") do call :init_manualAdapter %%a
call :init_bar&call :countAdapters&call :countTunnelAdapters
if %totalAdapters% geq 20 (call :alert_2manyconnections&call :SETMODECON)
set rsetwmic=call :antihang 11 null wmic.exe path win32_networkadapter where "NetConnectionID='
set rsetnetsh=netsh interface set interface 
call :update_avgca %ca_percent%&goto :eof

:init_CID
%init_CID%setlocal&set charSTR=000000000abcdefghijklmnopqrstuvwxyz1234567890&set CIDchars=0&set init_CID=::
set cidchar=%random:~0,2%
if %cidchar% gtr 45 goto :init_CID
set /a CIDchars+=1&set CID=%CID%!charSTR:~%cidchar%,1!%random:~1,1%
if %CIDchars% lss 3 goto :init_CID
endlocal&set CID=%CID:~0,5%&goto :eof

:cleanTMPP
set day=%DATE:/=-%
for /f "tokens=*" %%a IN ('xcopy "%TMPP%"\*.* /d:%day:~4% /L /I null') do @if exist "%%~nxa" set "excludefiles=!excludefiles!;;%%~nxa"
for /f "tokens=*" %%a IN ('dir "%TMPP%" /b 2^>nul') do @(@echo ";;%excludefiles%;;"|FINDSTR /C:";;%%a;;">nul || if exist "%TMPP%\%%a" DEL /F /Q "%TMPP%\%%a">nul 2>&1)
goto :eof

:init_settnINT
if "%1"=="" goto :eof
if "!%1!"=="" set %1=D_%1
set /a %1=%1&shift&goto :init_settnINT
:init_settnBOOL
@if "%1"=="" goto :eof
@echo ,!%1!,|FINDSTR /L ",0, ,1,">nul || set /a %1=D_%1
@shift&goto :init_settnBOOL
:init_settnSTR
if "%2"=="" set %1=!D_%1!&goto :eof
set %1=%2&goto :eof

:init_manualRouter
if "%1"=="" set manualRouter=&goto :eof
if "%1"=="Examples:" set manualRouter=&goto :eof
set manualRouter=%1
set manualRouter=%manualRouter:https:=%
set manualRouter=%manualRouter:http:=%
set manualRouter=%manualRouter:/=%
set cur_ROUTER=%manualRouter%
if /I "%manualRouter%"=="none" set cur_ROUTER=%secondaryRouter%
goto :eof

:init_manualAdapter
if "%1"=="" set manualAdapter=&goto :eof
set manualAdapter=%*
set manualAdapter=%manualAdapter:Examples=%
if "%manualAdapter%"=="" goto :eof
set manualAdapter=%manualAdapter:	=%
set cur_ADAPTER=%manualAdapter%&set show_cur_ADAPTER=%manualAdapter%
if /I "%manualAdapter%"=="all" set cur_ADAPTER=&set show_cur_ADAPTER=[Reset All Connections on Error]
goto :eof

:init_bar
set /a colnum=cols-2
set -=&set aft-=
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
set theme=%1&echo ",%1,"|FINDSTR /I /L ",mini, ,none, ,subtle, ,vibrant, ,fullsubtle, ,fullvibrant, ,fullcolor, ,neon, ,crazy,">nul || set theme=%D_theme%
call :init_colors_%theme%
set curcolor=%norm%&goto :eof
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
:init_colors_fullcolor
set norm=2A&set warn=6E&set alrt=4C&set pend=1B&goto :eof
:init_colors_neon
set norm=5A&set warn=9E&set alrt=1C&set pend=5B&goto :eof
:init_colors_crazy
set "norm=>nul ^&call :crazy"&set "warn=^&call :crazy"&set "alrt=^&call :crazy"&set "pend=^&call :crazy"&set crazystr=0123456789ABCDEF&goto :eof

:setn_defaults
@set settingsINT=INT_StabilityHistory INT_flukechecks INT_flukemaxtime INT_checkdelay INT_fixdelay INT_flukecheckdelay INT_timeoutsecs INT_checkrouterdelay
@set settingsBOOL=pretty fullAuto requestAdmin
@set D_pretty=1&set D_theme=subtle&set D_viewmode=normal&set D_fullAuto=0
@set D_requestAdmin=1&set D_requestDisableIPv6=1&set D_INT_StabilityHistory=25
@set D_INT_flukechecks=0&set D_INT_flukemaxtime=25&set D_INT_checkdelay=5
@set D_INT_fixdelay=10&set D_INT_flukecheckdelay=1&set D_INT_timeoutsecs=0
@set D_INT_checkrouterdelay=0&goto :eof
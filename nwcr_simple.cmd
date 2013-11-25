::Quick detect&fix
@set version=3.4.309

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
set INT_timeoutsecs=1		Default: 1 seconds
set INT_checkrouterdelay=0	Default: 0 (auto) (wait x number of connects before verifying router and adapter)

::-Filters- (Separate filter keywords with space. Matches are filtered OUT)
set filterRouters=
set filterAdapters=Tunnel VirtualBox VMnet VMware Loopback Pseudo Bluetooth

::-GUI-
set pretty=1
set theme=subtle			none,subtle,vibrant,fullsubtle,fullvibrant,crazy
set viewmode=normal			mini,normal,details

::-Advanced-
::Setting fullAuto to 1 will omit all user input and best guess is made for each decision.
set fullAuto=0

::Setting requestAdmin to 1 will request admin rights if it doesn't already have them.
::Admin rights are needed to enable/disable the Network Connection
set requestAdmin=1



:: -DO NOT EDIT BELOW THIS LINE!-

%startpretty%if "%pretty%"=="0" set startpretty=::&start "" "cmd" /k "%~dpnx0" "%params%"&exit
setlocal enabledelayedexpansion
call :init
call :checkRouterAdapter

:loop
%debgn%call :SETMODECON
call :check
call :sleep %INT_checkdelay%
goto :loop



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
echo  -%ThisTitle%-
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
echo  -      %ThisTitle%         -
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
echo  ^|                    %ThisTitle%                       ^|
echo  ^|                                                                            ^|
if not "!show_stbtlySTR:~-%colnum%!"=="" echo. !show_stbtlySTR:~-%colnum%!
echo.
echo  Connection: %show_cur_ADAPTER%%ismanualA%
echo  Router:     %dsp_cur_ROUTER:~0,40%NIC Adapters:      %totalAdapters%
echo  Uptime:     %dsp_uptime:~0,40%No User Input:     %dspUsrInput%
echo  Runtime:    %dsp_GRT_TimeRan:~0,40%Stability Hist:    %INT_StabilityHistory%
echo  Stability:  %dsp_stability:~0,40%Request Admin:     %dspReqAdmin%
echo  Fixes:      %dsp_fixes:~0,40%Is Admin:          %dspAdmin%
echo                                                      Theme:             %theme%
echo                                                      Check Delay:       %INT_checkdelay%
echo  Verify Router Delay: %dspCRD:~0,31%Fluke Checks:      %INT_flukechecks%
echo                                                      Fix Delay:         %INT_fixdelay%
echo                                                      Test Timeout:      %INT_timeoutsecs%
echo                                                      Fluke Check Delay: %INT_checkdelay%
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
for /f %%n in ('ipconfig ^|FINDSTR /I /C:"adapter"') do set /a totalAdapters+=1
set /a est_secs=(totalAdapters*ca_percent)/100
set progressDelay=1
if %totalAdapters% gtr %cols% set /a progressDelay=(totalAdapters/cols)+1
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
if "%manualVerifyDelay%"=="" goto :eof
set /a est_secs=(totalAdapters*ca_percent)/100
set /a INT_checkrouterdelay=est_secs+1
if %INT_checkrouterdelay% lss %MN_crd% set INT_checkrouterdelay=%MN_crd%
if %INT_checkrouterdelay% gtr %MX_crd% set INT_checkrouterdelay=%MX_crd%
goto :eof


:precisiontimer
set id=%1
set var=%2
if /i "%var%"=="start" set startsecs%id%=%time:~6,2%&set startmins%id%=%time:~3,2%&goto :eof
if /i "%var%"=="halt" set startsecs%id%=invalid&goto :eof
if "!startsecs%id%!"=="invalid" set %var%=0&goto :eof
set endsecs%id%=%time:~6,2%
set endmins%id%=%time:~3,2%
if "!startsecs%id%:~0,1!"=="0" set startsecs%id%=!startsecs%id%:~1,1!
if "!startmins%id%:~0,1!"=="0" set startmins%id%=!startmins%id%:~1,1!
if "!endsecs%id%:~0,1!"=="0" set endsecs%id%=!endsecs%id%:~1,1!
if "!endmins%id%:~0,1!"=="0" set endmins%id%=!endmins%id%:~1,1!
if !endsecs%id%! lss !startsecs%id%! set /a endsecs%id%+=60&set /a endmins%id%-=1
if !endmins%id%! lss !startmins%id%! set /a endmins%id%+=60
set /a %var%=endsecs%id%-startsecs%id%+((endmins%id%-startmins%id%)*60)
goto :eof


:checkRouterAdapter
set checkconnects=0
if not "%manualRouter%"=="" if not "%manualAdapter%"=="" goto :eof
call :precisiontimer cRA start
call :countAdapters
set curstatus=Verify Router/Adapter [%est_secs%s]&call :header
call :getNETINFO
set isConnected=0
if not "%cur_ADAPTER%"=="" set checkadapternum=0&call :checkadapterstatus
if "%isConnected%"=="1" if not "%cur_ROUTER%"=="" goto :checkRouterAdapter_end
if not "%cur_ROUTER%"=="" if "%manualRouter%"=="" set cur_ROUTER=
if not "%cur_ADAPTER%"=="" if "%manualAdapter%"=="" set cur_ADAPTER=
if "%manualrouter%"=="" call :getAutoRouter
@echo .|set /p dummy=%L$%
if "%cur_ADAPTER%"=="" if not "%manualRouter%"=="" call :getAutoAdapter
if "%cur_ADAPTER%"=="" if "%lastresult%"=="Connected" call :Ask4Adapter
if "%cur_ADAPTER%"=="" call :EnumerateAdapters %filterAdapters%

:checkRouterAdapter_end
%debgn%call :SETMODECON
set show_cur_ADAPTER=
if not "%cur_ADAPTER%"=="" set show_cur_ADAPTER=%cur_ADAPTER%
if /I "%manualAdapter%"=="all" set show_cur_ADAPTER=[Reset All Connections on Error]
call :precisiontimer cRA tot
set /a timepassed+=tot
if not %tot%==0 set /a new_ca_percent=(tot*100)/totalAdapters
if not %tot%==0 call :Update_avgca %new_ca_percent% %STR_ca_percent%
goto :eof

:getNETINFO
if not %numAdapters% equ 0 for /l %%n in (1,1,%numAdapters%) do set conn_%%n_cn=&set conn_%%n_gw=&set conn_%%n_ms=
set numAdapters=0
set filtered=1
for /f "tokens=1 delims=%%" %%r in ('ipconfig') do call :getNETINFO_parse %%r
goto :eof

:getNETINFO_parse
set line=^%*
echo %line% |findstr "adapter">NUL
if %errorlevel% equ 0 call :getNETINFO_parseAdapter %filterAdapters%&goto :eof
if "%filtered%"=="1" goto :eof
echo %line% |findstr "Media State">NUL
if %errorlevel% equ 0 call :getNETINFO_parseMediaState %filterAdapters%&goto :eof
echo %line% |findstr /C:"Default Gateway">NUL
if %errorlevel% equ 0 call :getNETINFO_parseGateway %filterRouters%&goto :eof
goto :eof

:getNETINFO_parseAdapter
set /a delayed+=1
if %delayed% geq %progressDelay% @echo .|set /p dummy=%L$%&set delayed=0
set line=%line:adapter =:%
set filtered=0
:getNETINFO_parseAdapter_loop
if not "%1"=="" echo %line%|FINDSTR /I "%1">NUL
if not "%1"=="" if %errorlevel% equ 0 set filtered=1&goto :eof
if not "%1"=="" shift&goto :getNETINFO_parseAdapter_loop
if %numAdapters% geq 1 if "!conn_%numAdapters%_gw!"=="" set conn_%numAdapters%_cn=&set conn_%numAdapters%_ms=&set conn_%numAdapters%_gw=&set /a numAdapters-=1
set /a numAdapters+=1
for /f "tokens=2 delims=:" %%a in ("%line%") do set conn_%numAdapters%_cn=%%a
goto :eof

:getNETINFO_parseMediaState
set conn_%numAdapters%_ms=disconnected&goto :eof
goto :eof

:getNETINFO_parseGateway
if not "%1"=="" echo %line%|FINDSTR /I "%1">NUL
if not "%1"=="" if %errorlevel% equ 0 set filtered=1&set conn_%numAdapters%_cn=&set conn_%numAdapters%_ms=&set /a numAdapters-=1&goto :eof
if not "%1"=="" shift&goto :getNETINFO_parseGateway
set line=%line: .=%
set line=%line:Default Gateway :=%
if "%line%"=="" set filtered=1&set conn_%numAdapters%_cn=&set conn_%numAdapters%_ms=&set /a numAdapters-=1&goto :eof
set conn_%numAdapters%_gw=%line: =%
goto :eof

:getAutoRouter
set numrouters=0
set actvrouters=0
:getAutoRouter_loop
set /a numrouters+=1
if not "!conn_%numrouters%_gw!"=="" set /a actvrouters+=1&set lastrouter=!conn_%numrouters%_gw!&set lastadapter=!conn_%numrouters%_cn!
if %numrouters% lss %numAdapters% goto :getAutoRouter_loop
if %actvrouters% equ 0 goto :eof
if %actvrouters% equ 1 set cur_ROUTER=%lastrouter%
if %actvrouters% equ 1 if "%manualAdapter%"=="" set cur_ADAPTER=%lastadapter%
if %actvrouters% geq 2 call :Ask4Router
goto :eof


:checkadapterstatus
if %checkadapternum% geq %numAdapters% goto :eof
set /a checkadapternum+=1
if not "!conn_%checkadapternum%_cn!"=="%cur_ADAPTER%" goto :checkadapterstatus
if not "!conn_%checkadapternum%_ms!"=="" goto :eof
if "%manualRouter%"=="" set cur_ROUTER=!conn_%checkadapternum%_gw!&set isConnected=1
goto :eof


:getAutoAdapter
if %numAdapters% equ 0 goto :eof
if %numAdapters% equ 1 set cur_ADAPTER=%conn_1_cn%
goto :eof



:check
@set curstatus=Testing connectivity...
%debgn%call :header
set result=
set resultUpDown=
set testrouter=%secondaryRouter%
if not "%cur_ROUTER%"=="" if %dbl% equ 0 set testrouter=%cur_ROUTER%
if not "%manualRouter%"=="" set testrouter=%cur_ROUTER%
if "%lastResult%"=="" set lastResult=Connected

for /f "tokens=* delims=" %%p in ('ping -w %timeoutmilsecs% -n 1 %testrouter%') do set ping_test=%%p
echo %ping_test% |findstr "request could not find" >NUL
if %errorlevel% equ 0 set result=NotConnected&set resultUpDown=Down
echo %ping_test% |findstr "Unreachable" >NUL
if %errorlevel% equ 0 set result=Unreachable&set resultUpDown=Down
echo %ping_test% |findstr "General Failure" >NUL
if %errorlevel% equ 0 set result=Connecting...&set /a down+=timepassed&set curcolor=%pend%
echo %ping_test% |findstr "Minimum " >NUL
if %errorlevel% equ 0 set result=Connected&set resultUpDown=Up
if "%result%"=="" set result=TimeOut&set resultUpDown=Down

if "%resultUpDown%"=="Up" (
set /a checkconnects+=1
if not "%lastresult%"=="Connected" set /a timepassed/=2
if not "%lastresult%"=="Connected" if not "%resetted%"=="1" set checkconnects=force
if not "%lastresult%"=="Connected" if "%resetted%"=="1" if "%cur_Adapter%"==""  set checkconnects=force
if %timepassed% leq 0 set timepassed=1
set /a up+=timepassed
set curcolor=%norm%
set stbltySTR=%stbltySTR% 0
)

if "%resultUpDown%"=="Down" (
if "%lastresult%"=="Connected" set /a timepassed/=2
if not "%lastresult%"=="" if %timepassed% leq 0 set timepassed=1
set /a down+=timepassed
if "%result%"=="TimeOut" set /a down+=INT_timeoutsecs
set curcolor=%warn%
set stbltySTR=%stbltySTR% 1
set result=%result%
)

set timepassed=0
if %dbl% gtr 0 set showdbl=(fluke check %dbl%/%INT_flukechecks%)
set /a dbl+=1
call :set_uptime
call :set_stability %stbltySTR%

if "%result%"=="Connected" if not "%lastresult%"=="Connected" if "%resetted%"=="1" set /a numfixes+=1
set lastresult=%result%
if "%result%"=="Connected" set resetted=0
if "%result%"=="NotConnected" call :check_adapterenabled
if not "%result%"=="Connected" if not %dbl% gtr %INT_flukechecks% call :sleep %INT_flukecheckdelay%&goto :check
if not "%result%"=="Connected" if %dbl% gtr %INT_flukechecks% call :resetAdapter
set dbl=0
set showdbl=
goto :eof

:check_adapterenabled
if "%isAdmin%"=="0" goto :eof
if "%cur_ADAPTER%"=="" goto :eof
netsh interface show interface "%cur_ADAPTER%" |FINDSTR "Disabled">NUL
if %errorlevel% neq 0 goto :eof
@set curstatus=Enabling adapter...
%debgn%call :header
netsh interface set interface "%cur_ADAPTER%" admin=enable>NUL 2>&1
ping -n 3 127.0.0.1>NUL
set resetted=1
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
ping -n %pn% -w 1000 127.0.0.1>nul
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
set /a uptime=((up*10000)/(up+down))
set /a uptime+=0
set uptime=%uptime:~0,-2%.%uptime:~-2%%%
call :getruntime
goto :eof



:Ask4Router
if "%fullAuto%"=="1" set manualRouter=%secondaryRouter%&set cur_ROUTER=%secondaryRouter%&goto :eof
call :precisiontimer cRA halt
%debgn%set /a lines=%numrouters%+11
%debgn%call :SETMODECON 70 %lines%
set cur_ROUTER=
echo.
echo Which Router would you like to monitor?
echo.
echo Choose a router by the selection number below.
echo You may also type in a router address to use, or x to cancel.
echo.
echo  #     Router Adress                  Associated Connection
echo  ----- ------------------------------ -----------------------------
for /l %%n in (1,1,%numrouters%) do set showroutr%%n=[%%n]%statspacer%
for /l %%n in (1,1,%numrouters%) do set showroutr%%n=!showroutr%%n:~0,5! !conn_%%n_gw!%statspacer%
for /l %%n in (1,1,%numrouters%) do set showroutr%%n=!showroutr%%n:~0,36! !conn_%%n_cn!%statspacer%
for /l %%n in (1,1,%numrouters%) do echo -!showroutr%%n:~0,68!
echo.
set usrinput=
set usrinput2=
set /p usrinput=[] 
if "%usrinput%"=="" set usrinput=1
for /l %%n in (1,1,%numrouters%) do if "%usrinput%"=="%%n" set cur_ROUTER=!conn_%%n_gw!
if not "%cur_ROUTER%"=="" if "%manualAdapter%"=="" set cur_ADAPTER=!conn_%usrinput%_cn!&set manualAdapter=!conn_%usrinput%_cn!
if "%usrinput%"=="x" set manualRouter=%secondaryRouter%&set cur_ROUTER=%secondaryRouter%&goto :eof
if "%cur_ROUTER%"=="" cls&echo.&echo.&echo Use "%usrinput%" as router address?
if "%cur_ROUTER%"=="" set /p usrinput2=[y/n] 
if "%usrinput%"=="" set cur_ROUTER=%usrinput%
if /i "%usrinput%"=="y" set cur_ROUTER=%usrinput%
if "%cur_ROUTER%"=="" goto :Ask4Router
set manualrouter=%cur_ROUTER%
echo.
goto :eof


:EnumerateAdapters
set con_num=0
set EA_filters=%*
for /f "tokens=* delims=" %%n in ('wmic nic get NetConnectionID') do call :get_network_connections_parse %%n
goto :eof

:get_network_connections_parse
set line=%*
if "%line%"=="" goto :eof
if "%line%"=="NetConnectionID" goto :eof
set filtered=0
call :get_network_connections_filter %EA_filters%
goto :eof

:get_network_connections_filter
if not "%1"=="" echo %line%|FINDSTR /I "%1">NUL
if not "%1"=="" if %errorlevel% equ 0 set filtered=1
if not "%1"=="" shift&goto :get_network_connections_filter
if %filtered% equ 1 goto :eof
set /a con_num+=1
set connection%con_num%_name=%line%
goto :eof

:Ask4Adapter
if "%fullAuto%"=="1" set manualAdapter=All&goto :eof
call :precisiontimer cRA halt
call :EnumerateAdapters
set /a lines=%con_num%+10
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
for /l %%n in (1,1,%con_num%) do set showconn%%n=[%%n]%statspacer%
for /l %%n in (1,1,%con_num%) do set showconn%%n=!showroutr%%n:~0,5! !connection%%n_name!%statspacer%
for /l %%n in (1,1,%numrouters%) do echo -!showconn%%n:~0,50!
echo.
set usrinput=
set /p usrinput=[] 
if "%usrinput%"=="" set usrinput=1
if "%usrinput%"=="x" set manualAdapter=All&goto :eof
for /l %%n in (1,1,%con_num%) do if "%usrinput%"=="%%n" set cur_ADAPTER=!connection%%n_name!
if "%cur_ADAPTER%"=="" goto :ask4connection
set manualadapter=%cur_ADAPTER%
echo.
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


:resetAdapter
set curcolor=%alrt%
@set curstatus=Attempting to fix connection...
set stbltySTR=%stbltySTR% 2
%debgn%call :header
set resetted=1
if "%cur_Adapter%"=="" (
ipconfig /release>NUL 2>&1
ipconfig /flushdns>NUL 2>&1
	if "%isAdmin%"=="1" (
	for /l %%n in (1,1,%con_num%) do netsh interface set interface "!connection%%n_name!" admin=disable>NUL 2>&1
	for /l %%n in (1,1,%con_num%) do netsh interface set interface "!connection%%n_name!" admin=enable>NUL 2>&1
	)
ipconfig /renew>NUL 2>&1
)
if not "%cur_ADAPTER%"=="" (
ipconfig /release "%cur_ADAPTER%">NUL 2>&1
ipconfig /flushdns "%cur_ADAPTER%">NUL 2>&1
	if "%isAdmin%"=="1" (
	netsh interface set interface "%cur_ADAPTER%" admin=disable>NUL 2>&1
	netsh interface set interface "%cur_ADAPTER%" admin=enable>NUL 2>&1
	)
ipconfig /renew "%cur_ADAPTER%">NUL 2>&1
)
call :sleep %INT_fixdelay%
set checkconnects=force
goto :eof


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
@call :detectIsAdmin
@call :init_colors %theme%
%debgn%COLOR %norm%
@call :getruntime
@set L$=.
@set numfixes=0
@set up=0
@set down=0
@set timepassed=0
@set dbl=0
@set numAdapters=0
@set checkconnects=0
@set stbltySTR=
@set secondaryRouter=www.google.com
@set ca_percent=40
@set MN_crd=5
@set MX_crd=120
@set MX_avgca=5
@set statspacer=                                                               .
@for /f "tokens=1,* DELIMS==" %%s in ('set INT_') do call :init_settn %%s %%t
@set orig_checkdelay=%INT_checkdelay%
@set INT_checkdelay=1
@if %INT_checkrouterdelay%==0 set manualVerifyDelay=AUTO
@set /a timeoutmilsecs=1000*INT_timeoutsecs
@call :init_manualRouter %manualRouter%
@for /f "tokens=1 DELIMS=:" %%a in ("%manualAdapter%") do call :init_manualAdapter %%a
@call :init_bar
@call :countAdapters
@call :update_avgca %ca_percent%
@if %totalAdapters% gtr 20 call :alert_2manyconnections
@echo .|set /p dummy=..
goto :eof

:SETMODECON
if /i "%viewmode%"=="mini" set cols=37&set lines=9
if /i "%viewmode%"=="normal" set cols=52&set lines=13
if /i "%viewmode%"=="details" set cols=80&set lines=27
if not "%1"=="" set cols=%1&set lines=%2
if not "%pretty%"=="1" set cols=80&set lines=900
MODE CON COLS=%cols% LINES=%lines%
goto :eof

:detectIsAdmin
DEL /F /Q "%temp%\getadminNWCR.vbs">NUL 2>&1
set isAdmin=0
set usenetsession=&set useregadd=::
sc query lanmanserver |FINDSTR /I /C:running>NUL 2>&1
if not %errorlevel%==0 set useregadd=&set usenetsession=::
%useregadd%REG ADD HKLM /F>nul 2>&1
%usenetsession%net session >nul 2>&1
if %errorLevel%==0 set isAdmin=1

for /f "usebackq tokens=*" %%a in (`taskkill /F /FI "USERNAME eq %USERNAME%" /FI "WINDOWTITLE eq Limited:  %ThisTitle%" ^| find /i "success"`) do set killresult=%%a
if not "%killresult%"=="" goto :eof
if %isAdmin%==1 goto :eof
title Limited:  %ThisTitle%
if not "%requestAdmin%"=="1" goto :eof
echo Set StartAdmin = CreateObject^("Shell.Application"^) > "%temp%\getadminNWCR.vbs"
echo StartAdmin.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadminNWCR.vbs"
start /b "" cscript "%temp%\getadminNWCR.vbs" /nologo>NUL 2>&1
ping 127.0.0.1>NUL
ping 127.0.0.1>NUL
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

:alert_2manyconnections
call :header
set /a est_min=est_secs/60
set /a est_sec=est_secs-(est_min*60)
echo Alert: Excessive number of Network Connections
echo.
echo Network Connections: %totalAdapters%
echo Est. configure time: %est_min% min, %est_sec% sec
echo.
if "%manualVerifyDelay%"=="AUTO" echo Changed Check Router Delay to %INT_checkrouterdelay%
ping 127.0.0.1>NUL
ping 127.0.0.1>NUL
goto :eof
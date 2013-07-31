::Quick detect&fix
@SET version=2.1.205

::-Settings-
set checkdelay=5
set fixdelay=20
set debgn=







%debgn%@echo off
setlocal enabledelayedexpansion
call :init

call :getrouter
call :getadapter

:loop
MODE CON COLS=52 LINES=12
call :check
call :sleep %checkdelay%
goto :loop




:header
cls
echo  --------------------------------------------------
echo  -      %ThisTitle%         -
echo  --------------------------------------------------
echo.
if not "%NETWORK%"=="" 		echo  Connection: %NETWORK%
if not "%router%"=="" 		echo  Router:     %router%
if not "%uptime%"=="" 		echo  Uptime:     %uptime%        U:%dispUP% D:%dispDN%
echo.
if not %numfixes%==0 		echo  Fixes:      %numfixes%
if not "%lastresult%"=="" 	echo  Last Test:  %lastresult%
if not "%curstatus%"=="" 	echo  Status:     %curstatus%
goto :eof





:sleep
if "%1"=="" set pn=3
if not "%1"=="" set pn=%1
@set curstatus=Wait %pn% seconds...
%debgn%call :header
ping -n 2 -w 1000 127.0.0.1>nul
ping -n %pn% -w 1000 127.0.0.1>nul
goto :eof


:doublecheck
set dbl=1
:check
@set curstatus=Testing connection...
%debgn%call :header
set result=
set testrouter=www.google.com
if not "%router%"=="" set testrouter=%router%
set /a pts=checkdelay
if "%dbl%"=="1" set pts=1
for /f "tokens=* delims=" %%p in ('ping -n 1 %testrouter%') do set ping_test=%%p
echo %ping_test% |findstr "request could not find" >NUL
if %errorlevel% equ 0 set result=NotConnected&set /a down+=pts
echo %ping_test% |findstr "Unreachable" >NUL
if %errorlevel% equ 0 set result=Unreachable&set /a down+=pts
echo %ping_test% |findstr "Minimum " >NUL
if %errorlevel% equ 0 set result=Connected&set /a up+=pts
if "%result%"=="" set result=TimeOut&set /a down+=pts

if %up% geq 10000 set /a up=up/10&set /a down=down/10
set /a uptime=((up*10000)/(up+down))
set /a uptime+=0
set uptime=%uptime:~0,-2%.%uptime:~-2%%%
set /a dispUP=up/checkdelay
set /a dispDN=down/checkdelay

if "%result%"=="Connected" if not "%lastresult%"=="Connected" if "%resetted%"=="1" set /a numfixes+=1
set lastresult=%result%
if "%result%"=="Connected" set resetted=0
if not "%result%"=="Connected" if not "%dbl%"=="1" call :sleep 1&goto :doublecheck
if not "%result%"=="Connected" if "%dbl%"=="1" call :resetAdapter
set dbl=0
goto :eof


:resetAdapter
@set curstatus=Resetting connection...
%debgn%call :header
set resetted=1
netsh interface set interface "%NETWORK%" admin=disable>NUL 2>&1
netsh interface set interface "%NETWORK%" admin=enable>NUL 2>&1
call :sleep 15
set /a down+=(fixdelay/checkdelay)+1
call :getrouter
call :getadapter
goto :eof



:getrouter
set numrouters=0
for /f "tokens=2 delims=:" %%r in ('ipconfig ^|findstr "Gateway"') do call :setrouter%%r
set router=%router1%
if %numrouters% geq 2 call :chooserouter
set lastrouter=%router%
goto :eof

:setrouter
if "%1"=="" goto :eof
set testrtr=1
:checkrtrs
if "!router%testrtr%!"=="%1" goto :eof
if %testrtr% leq %numrouters% set /a testrtr+=1&goto :checkrtrs
set /a numrouters+=1
set router%numrouters%=%1
goto :eof


:chooserouter
set hasrouter=0
FOR /L %%n IN (1,1,%numrouters%) DO if "!router%%n!"=="%lastrouter%" set hasrouter=1
if %hasrouter%==1 goto :eof
set /a lines=%numrouters%+5
%debgn%MODE CON COLS=52 LINES=%lines%
%debgn%CALL :HEADER
SET router=
ECHO Which Router would you like to use?
ECHO.
FOR /L %%n IN (1,1,%numrouters%) DO SET SHOWROUTR%%n=!router%%n!%STATSpacer%
FOR /L %%n IN (1,1,%numrouters%) DO ECHO -!SHOWROUTR%%n:~0,20! [%%n]
ECHO.
SET usrInput=
SET /P usrInput=[] 
IF "%usrInput%"=="" SET usrInput=0
FOR /L %%n IN (1,1,%numrouters%) DO IF "%usrInput%"=="%%n" SET router=!router%%n!
IF "%router%"=="" GOTO :chooserouter
ECHO.
goto :eof



:getAdapter
if not "%router%"=="" goto :autoAdapter
SET CON_NUM=0
FOR /F "tokens=* DELIMS=" %%n IN ('wmic nic get NetConnectionID') DO CALL :GET_NETWORK_CONNECTIONS_PARSE %%n
call :Ask4Connection
GOTO :EOF

:GET_NETWORK_CONNECTIONS_PARSE
SET LINE=%*
if "%LINE%"=="" goto :eof
if "%LINE%"=="NetConnectionID" goto :eof
SET /A CON_NUM+=1
set CONNECTION%CON_NUM%_NAME=%LINE%
GOTO :EOF



:Ask4Connection
set /a lines=%CON_NUM%+5
%debgn%MODE CON COLS=52 LINES=%lines%
%debgn%CALL :HEADER
SET NETWORK=
ECHO Which Connection would you like to reset?
ECHO.
FOR /L %%n IN (1,1,%CON_NUM%) DO SET SHOWCONN%%n=!CONNECTION%%n_NAME!%STATSpacer%
FOR /L %%n IN (1,1,%CON_NUM%) DO ECHO -!SHOWCONN%%n:~0,40! [%%n]
ECHO.
SET usrInput=
SET /P usrInput=[] 
IF "%usrInput%"=="" SET usrInput=1
FOR /L %%n IN (1,1,%CON_NUM%) DO IF "%usrInput%"=="%%n" SET NETWORK=!CONNECTION%%n_NAME!
IF "%NETWORK%"=="" GOTO :Ask4Connection
ECHO.
goto :eof


:autoAdapter
set curadapter=
set curgateway=
for /f "tokens=* delims=" %%r in ('ipconfig') do call :autoAdapter_parse %%r
goto :eof

:autoAdapter_parse
set line=%*
echo %line% |findstr "adapter">NUL
if %errorlevel% equ 0 goto :autoAdapter_parseAdapter

echo %line% |findstr "Gateway">NUL
if %errorlevel% equ 0 goto :autoAdapter_parseGateway
goto :eof

:autoAdapter_parseAdapter
set line=%line:adapter =:%
for /f "tokens=2 delims=:" %%a in ("%line%") do set curadapter=%%a
goto :eof

:autoAdapter_parseGateway
for /f "tokens=2 delims=:" %%a in ("%line%") do set curGateway=%%a
set curGateway=%curGateway:~1%
if %curGateway%==%router% set NETWORK=%curadapter%
goto :eof







:init
%debgn%cls
@PROMPT=^>
%debgn%MODE CON COLS=52 LINES=20
@echo initializing...
@SET ThisTitle=Lectrode's Quick Net Fix v%version%
@TITLE %ThisTitle%
@set numfixes=0
@set up=0
@set down=0
goto :eof



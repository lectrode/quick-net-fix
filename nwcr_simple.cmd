::Quick detect&fix

::-Settings-
set router=192.168.0.1
set checkdelay=2
set debgn=







%debgn%@echo off
setlocal enabledelayedexpansion
call :init

call :getadapters
call :Ask4Connection

:loop
call :check
call :sleep %checkdelay%
goto :loop




:header
cls
echo  --------------------------------------------------
echo  -     Lectrode's Quick Net Fix v%version%         -
echo  --------------------------------------------------
echo.
if not "%NETWORK%"=="" 		echo  Connection: %NETWORK%
if not "%uptime%"=="" 		echo  Uptime:     %uptime%
echo.
if not %numfixes%==0 		echo  Fixes:      %numfixes%
if not "%lastresult%"=="" 	echo  Last Test:  %lastresult%
if not "%curstatus%"=="" 	echo  Status:     %curstatus%
echo. 
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
for /f "tokens=* delims=" %%p in ('ping -n 1 %router%') do set ping_test=%%p
echo %ping_test% |findstr "request could not find" >NUL
if %errorlevel% equ 0 set result=NotConnected&set /a down+=1
echo %ping_test% |findstr "Unreachable" >NUL
if %errorlevel% equ 0 set result=Unreachable&set /a down+=1
echo %ping_test% |findstr "Minimum " >NUL
if %errorlevel% equ 0 set result=Connected&set /a up+=1
if "%result%"=="" set result=TimeOut

if %up% geq 10000 set /a up=up/10&set /a down=down/10
set /a uptime=(up*100)/(up+down)
set uptime=%uptime%%%
set lastresult=%result%
if "%result%"=="TimeOut" if not "%dbl%"=="1" call :sleep 1&goto :doublecheck
if "%result%"=="TimeOut" if "%dbl%"=="1" set dbl=0&set /a down+=5&call :resetAdapter
goto :eof


:resetAdapter
@set curstatus=Resetting connection...
%debgn%call :header
set /a numfixes+=1
netsh interface set interface "%NETWORK%" admin=disable
netsh interface set interface "%NETWORK%" admin=enable
call :sleep 15
goto :eof



:getAdapters
SET CON_NUM=0
FOR /F "tokens=* DELIMS=" %%n IN ('wmic nic get NetConnectionID') DO CALL :GET_NETWORK_CONNECTIONS_PARSE %%n
GOTO :EOF

:GET_NETWORK_CONNECTIONS_PARSE
SET LINE=%*
if "%LINE%"=="" goto :eof
if "%LINE%"=="NetConnectionID" goto :eof
SET /A CON_NUM+=1
set CONNECTION%CON_NUM%_NAME=%LINE%
GOTO :EOF



:Ask4Connection
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

:init
cls
@PROMPT=^>
%debgn%MODE CON COLS=52 LINES=20
@echo initializing...
@SET version=1.1.051
@SET ThisTitle=Lectrode's Quick Net Fix v%version%
@TITLE %ThisTitle%
@set numfixes=0
@set up=0
@set down=0
goto :eof



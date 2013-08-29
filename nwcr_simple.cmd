::Quick detect&fix
@SET version=2.6.235

::-Settings-
set manualRouter=			Examples: 192.168.0.1 or www.google.com
set manualAdapter=			Examples: Local Area Connection or Wireless Network Connection

set INT_StabilityHistory=25	Default: 25 (number of last tests to determine stability)
set INT_flukechecks=7		Default: 7 (test x times to verify result)
set INT_checkdelay=5		Default: 5 seconds
set INT_fixdelay=2			Default: 2 seconds
set INT_flukecheckdelay=1	Default: 1 seconds
set INT_timeoutsecs=1		Default: 1 seconds

::-GUI-
set pretty=1
set theme=subtle			none,subtle,vibrant,fullsubtle,fullvibrant,crazy



:: -DO NOT EDIT BELOW THIS LINE!-




setlocal enabledelayedexpansion
call :init

call :getrouter
call :getadapter

:loop
%debgn%MODE CON COLS=%cols% LINES=13
call :check
call :sleep %INT_checkdelay%
goto :loop




:header
set show_stbtlySTR=%stbltySTR:0=-%
set show_stbtlySTR=%show_stbtlySTR:1==%
set show_stbtlySTR=%show_stbtlySTR:2=*%
set show_stbtlySTR=%aft-%!show_stbtlySTR: =%-%!
if "%stbltySTR%"=="" set show_stbtlySTR=                                                   -
cls
COLOR %curcolor%
echo  --------------------------------------------------
echo  -      %ThisTitle%         -
echo. !show_stbtlySTR:~-%colnum%!
echo.
if not "%NETWORK%"=="" 		echo  Connection: %NETWORK%
if not "%router%"=="" 		echo  Router:     %router%
if not "%uptime%"=="" 		echo  Uptime:     %uptime%
if not "%stability%"==""	echo  Stability:  %stability%
echo.
if not %numfixes%==0 		echo  Fixes:      %numfixes%
if not "%lastresult%"=="" 	echo  Last Test:  %lastresult%
if not "%curstatus%"=="" 	echo  Status:     %curstatus%
goto :eof





:sleep
if "%1"=="" set pn=3
if not "%1"=="" set pn=%1
if %pn% equ 0 goto :eof
@set curstatus=Wait %pn% seconds...
set /a timepassed+=pn
set /a pn+=1
%debgn%call :header
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




:check
@set curstatus=Testing connectivity...
%debgn%call :header
set result=
set resultUpDown=
set testrouter=www.google.com
if not "%router%"=="" set testrouter=%router%

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

if "%lastresult%"=="" set lastresult=%result%

if "%resultUpDown%"=="Up" (
if not "%lastresult%"=="Connected" set /a timepassed/=2
if %timepassed% leq 0 set timepassed=1
set /a up+=timepassed
set curcolor=%norm%
set stbltySTR=%stbltySTR% 0
)

if "%resultUpDown%"=="Down" (
if "%lastresult%"=="Connected" set /a timepassed/=2
if %timepassed% leq 0 set timepassed=1
set /a down+=timepassed
if "%result%"=="TimeOut" set /a down+=INT_timeoutsecs
set curcolor=%warn%
set stbltySTR=%stbltySTR% 1
set result=%result% %showdbl%
)


set timepassed=0
set /a dbl+=1
set showdbl=(fluke check %dbl%/%INT_flukechecks%)

call :set_uptime
call :set_stability %stbltySTR%

if "%result%"=="Connected" if not "%lastresult%"=="Connected" if "%resetted%"=="1" set /a numfixes+=1
set lastresult=%result%
if "%result%"=="Connected" set resetted=0
if not "%result%"=="Connected" if not %dbl% gtr %INT_flukechecks% call :sleep %INT_flukecheckdelay%&goto :check
if not "%result%"=="Connected" if %dbl% gtr %INT_flukechecks% call :resetAdapter
set dbl=0
set showdbl=
goto :eof


:set_uptime
if %up% geq 100000 set /a up=up/10&set /a down=down/10
set /a dispUP=up/INT_checkdelay
set /a dispDN=down/INT_checkdelay
set /a uptime=((up*10000)/(up+down))
set /a uptime+=0
set uptime=%uptime:~0,-2%.%uptime:~-2%%%        U:%dispUP% D:%dispDN%
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


:resetAdapter
set curcolor=%alrt%
@set curstatus=Resetting connection...
%debgn%call :header
set resetted=1
set stbltySTR=%stbltySTR% 2
netsh interface set interface "%NETWORK%" admin=disable>NUL 2>&1
netsh interface set interface "%NETWORK%" admin=enable>NUL 2>&1
call :sleep %INT_fixdelay%
set /a down+=INT_fixdelay
call :getrouter
call :getadapter
goto :eof



:getrouter
if not "%manualRouter%"=="" set router=%manualRouter%&goto :eof
set numrouters=0
for /f "tokens=2 delims=:" %%r in ('ipconfig ^|findstr "Default Gateway"') do call :setrouter%%r
set router=%router1%
if %numrouters% geq 2 call :chooserouter
set lastrouter=%router%
goto :eof

:setrouter
if "%1"=="" goto :eof
call :testvalidrouter valid %1
if "%valid%"=="invalid" goto :eof
set testrtr=1
:checkrtrs
if "!router%testrtr%!"=="%1" goto :eof
if %testrtr% leq %numrouters% set /a testrtr+=1&goto :checkrtrs
set /a numrouters+=1
set router%numrouters%=%1
goto :eof

:testvalidrouter
set isValid=%1
set %isValid%=valid
set line=%2
set testrtrSTR=%line:.=$!$%
echo %testrtrSTR% |FIND "$!$">NUL
if %errorlevel% geq 1 set %isValid%=invalid&goto :eof
for /f "tokens=1,2,3,4 delims=." %%r in ("%line%") do call :testvalidrouter_4numbers %%r %%s %%t %%u
goto :eof

:testvalidrouter_4numbers
set ipplace=0
:testvalidrouter_4numbers_shift
set /a ipplace+=1
set "ip%ipplace%=%1"
if "!ip%ipplace%!"=="0" goto :testvalidrouter_4numbers_shift_next
set /a ip%ipplace%=!ip%ipplace%!
if "!ip%ipplace%!"=="0" set %isValid%=invalid&goto :eof
:testvalidrouter_4numbers_shift_next
shift
if not "%1"=="" goto :testvalidrouter_4numbers_shift
if %ipplace% gtr 4 set %isValid%=invalid
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
set manualRouter=%router%
ECHO.
goto :eof



:getAdapter
if not "%manualAdapter%"=="" set NETWORK=%manualAdapter%&goto :eof
if not "%router%"=="" call :autoAdapter
if not "%NETWORK%"=="" goto :eof
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
set manualAdapter=%NETWORK%
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

echo %line% |findstr "Media State">NUL
if %errorlevel% equ 0 goto :autoAdapter_parseMediaState
if "%curMediaState%"=="Media disconnected" goto :eof

echo %line% |findstr "Gateway">NUL
if %errorlevel% equ 0 goto :autoAdapter_parseGateway
goto :eof

:autoAdapter_parseAdapter
set line=%line:adapter =:%
set curMediaState=
for /f "tokens=2 delims=:" %%a in ("%line%") do set curadapter=%%a
goto :eof

:autoAdapter_parseMediaState
for /f "tokens=2 delims=:" %%a in ("%line%") do set curMediaState=%%a
set curMediaState=%curGateway:~1%
goto :eof

:autoAdapter_parseGateway
for /f "tokens=2 delims=:" %%a in ("%line%") do set curGateway=%%a
set curGateway=%curGateway:~1%
if %curGateway%==%router% set NETWORK=%curadapter%
goto :eof







:init
if not "%pretty%"=="1" set debgn=::
%debgn%@echo off
%debgn%cls
@PROMPT=^>
@set cols=52
%debgn%MODE CON COLS=%cols% LINES=20
@echo initializing...
@call :init_colors %theme%
%debgn%COLOR %norm%
@SET ThisTitle=Lectrode's Quick Net Fix v%version%
@TITLE %ThisTitle%
@set numfixes=0
@set up=0
@set down=0
@set timepassed=1
@set dbl=0
@set stbltySTR=
@for /f "tokens=1,* DELIMS==" %%s in ('set INT_') do call :init_settn %%s %%t
@set orig_checkdelay=%INT_checkdelay%
@set INT_checkdelay=1
@set /a timeoutmilsecs=1000*INT_timeoutsecs
@call :init_manualRouter %manualRouter%
@for /f "tokens=1 DELIMS=:" %%a in ("%manualAdapter%") do call :init_manualAdapter %%a
@call :init_bar
goto :eof

:init_settn
set /a %1=%2
goto :eof

:init_manualRouter
set manualRouter=%1
set manualRouter=%manualRouter:http:=%
set manualRouter=%manualRouter:https:=%
set manualRouter=%manualRouter:/=%
if "%manualRouter%"=="Examples:" set manualRouter=
goto :eof

:init_manualAdapter
set manualAdapter=%*
set manualAdapter=%manualAdapter:Examples=%
if "%manualAdapter%"=="" goto :eof
set manualAdapter=%manualAdapter:	=%
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
set theme=%1
call :init_colors_%theme%
goto :eof

:init_colors_none
set norm=
set warn=
set alrt=
goto :eof

:init_colors_subtle
set norm=07
set warn=06
set alrt=04
set pend=03
goto :eof

:init_colors_vibrant
set norm=0a
set warn=0e
set alrt=0c
set pend=0b
goto :eof

:init_colors_fullsubtle
set norm=20
set warn=60
set alrt=40
set pend=30
goto :eof

:init_colors_fullvibrant
set norm=a0
set warn=e0
set alrt=c0
set pend=b0
goto :eof

:init_colors_crazy
set norm=^&call :crazy
set warn=^&call :crazy
set alrt=^&call :crazy
set crazystr=0123456789ABCDEF
goto :eof
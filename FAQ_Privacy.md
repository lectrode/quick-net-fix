[<- Back to \*Frequently Asked Questions / Definitions\*](FAQ.md)

# FAQ: What kind of information does [qNET](FAQ_qNET.md) retrieve, and how is it used? #

  * **None of the information that [qNET](FAQ_qNET.md) retrieves is personally identifiable.**
  * **None of the information obtained is recorded in any way.**
  * **The information below applies to Releases only. Beta and Dev builds will vary.**

Information that qNET retrieves from the current computer system is as follows (in order of when it is usually obtained):
  * The current value of environment variables:
    * **`COMSPEC`**, **`SYSTEMDRIVE`**, **`TEMP`**, **`APPDATA`**
  * Whether or not qNET has administrative privileges
  * Whether or not the current system can use the following:
    * **`FINDSTR`**, **`PING`**, **`IPCONFIG`**, **`TASKKILL`**, **`WMIC`**, **`REG`**, **`SFC`**
    * **`KILL`**, **`TSKILL`**, **`PSKILL`**, **`TASKKILL`**, **`TLIST`**, **`PSLIST`**, **`TASKLIST`**
    * **`CSCRIPT`**, **`BITSADMIN`**, **`POWERSHELL`**, **`WMIC`**
  * Current system date and time
  * The number of [Network Connections](FAQ_NetworkConnection.md) currently enabled on the system
  * The number of [Network Connections](FAQ_NetworkConnection.md) that are Tunnel adapters
  * The current value of registry key: `"hklm\system\currentcontrolset\services\tcpip6\parameters\DisabledComponents"` (if it exists)
  * All [Network Connections](FAQ_NetworkConnection.md) that have a gateway and their associated gateways
  * All [Network Connection](FAQ_NetworkConnection.md) names
  * Last [25](StabilityHistory.md) Connectivity test results (Connected, Not Connected, Timeout)

## How those are used ##
  * Environment variables are retrieved to make sure that **`TEMP`**, **`PATH`**, and **`PATHEXT`** have necessary and correct values
  * All functions that use commands that are unavailable are disabled (alternatives are used where possible)
  * The current system date and time are used to time how long certain functions take in order to improve efficiency of the script. It is also used to display how long ago the script was started.
  * The number of enabled adapters is used to estimate how long it will take to determine the active Router and [Network Connection](FAQ_NetworkConnection.md)
  * The registry key value is used to determine if IPv6 has been disabled
  * The current Network Connection name is used to reset the connection when a connectivity issue is detected.
  * The current Router address is used to quickly test the connectivity between the computer and the Router. This also prevents spamming PING requests to a 3rd party website and allows tests to be done more frequently to quickly detect a connectivity problem.
  * The last [25](StabilityHistory.md) Connectivity test results are used to determine and show how "stable" the connection is.


## Temporary files created by qNET ##
  * Legend:
    * %temp% is an environment variable that holds the address of a location on the local computer reserved for temporary files
    * %CID% is a randomly generated ID unique to the running instance
    * %random% is a random number


  * **`"%temp%\EXSqNET\findproc%CID%.vbs"`**
    * used to find a running process if **`TLIST`**,**`PSLIST`**, and **`TASKLIST`** are unavailable

  * **`"%temp%\EXSqNET\wmicnetadapt%CID%"`**
    * used to retrieve output of commands run with **`WMIC`** indirectly

  * **`"%temp%\EXSqNET\procerrlvl%CID%%random%"`**
    * used to retrieve errors output by commands run with the `ANTIHANG` function

  * **`"%temp%\EXSqNET\tempoutput%CID%%random%"`**
    * used to retrieve output of commands run with `ANTIHANG` indirectly

  * **`"%temp%\EXSqNET\enableadapter%CID%.vbs"`**
    * used to enable a Network Connection if **`NETSH`** and **`WMIC`** fail

  * **`"%temp%\EXSqNET\disableadapter%CID%.vbs"`**
    * used to disable a Network Connection if **`NETSH`** and **`WMIC`** fail

  * **`"%temp%\EXSqNET\c4u%CID%.vbs"`**
    * used to download a text file to check for updates if **`POWERSHELL`** and **`BITSADMIN`** fail

  * **`"%temp%\EXSqNET\c4u%CID%"`**
    * holds the data downloaded by **`BITSADMIN`** or **`c4u%CID%.vbs`** if **`POWERSHELL`** fails

  * **`"%temp%\EXSqNET\getadmin%CID%.vbs""`**
    * used to request administrative rights if it doesn't have them

  * **`"%temp%\EXSqNET\RWA%CID%.txt"`**
    * used to check if the script has Write access

  * **`"%temp%\EXSqNET\quickedit#%CID%.reg"`**
    * used to disable `QuickEdit` for the current Console if **`REG`** is not available
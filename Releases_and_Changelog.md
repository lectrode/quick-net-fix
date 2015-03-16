# [v5.0.377 (Release Candidate 2)](http://adf.ly/1489522/http://www.mediafire.com/?673ddauah5r5752) (2014-06-06) #
  * (Please note that this may have undiscovered bugs or compatibility regressions. Please see the [Compatibility chart](Compatibility.md) for up to date information)
  * Priorities for this version: speed and efficiency ([More Info...](https://code.google.com/p/quick-net-fix/source/detail?r=4809dd15fe7266bfac3396a22d9dd0ef79869c18))
  * Renamed script to 'quick-net-fix.cmd'
  * **Removed functions:** Dynamic Settings, Theme: crazy, Viewmode: details
  * **Removed settings:** requestdisableIPv6, flukemaxtime
  * Added settings: [channel](channel.md), [noStop](noStop.md), [errorLog](errorLog.md), [c4uwait](c4uwait.md)
    * When noStop is enabled, script will restart itself if it crashes ("crashing" is not likely, but this way the script is sure to stay running)
    * When errorLog is enabled, a crash/error log will be generated
  * **COMPATABILITY**: Confirms script `EOL` format is `CRLF` (Windows) before allowing script to continue ([More info...](http://code.google.com/p/quick-net-fix/source/detail?r=a58e393e3ec079ef36fcd97d59c53a3f6621419c))
  * **Smarter and quicker adaptation to changing network configuration**
    * Full support for networks without internet access ([More Info...](https://code.google.com/p/quick-net-fix/source/detail?r=2a61d0296e13e81866f56081033295eb10c83c9b))
    * Use DHCP or DNS address if Gateway address is not available
  * Unsupported `PING` responses will cause an error report to be generated and the script will continue
  * **Many more `PING` results supported** ([More Info...](https://code.google.com/p/quick-net-fix/source/detail?r=a0e9f9bc509aec3ceaa3b7c8150d21a66e468173))
  * If the script encounters an error, an **`x`** will appear in the lower-right corner of the Title box
  * Verify availability of **`SETLOCAL`**, Delayed Expansion, Basic Math, and supported script location during initialization
  * **Full support for [Network Connection](FAQ_NetworkConnection.md) names containing previously unsupported symbols** (**`! & %`**)
  * No more "Calculating..." when script starts
  * Renamed settings:
    * `StabilityHistory` to [fluxHist](StabilityHistory.md)
    * `checkrouterdelay` to [chknetwait](checkrouterdelay.md)
    * `checkdelay` to [checkwait](checkdelay.md)
    * `flukecheckdelay` to [flukechkwait](flukecheckdelay.md)
    * `fixdelay` to [fixwait](fixdelay.md)
  * Replace setting: `timeoutsecs` with [timeoutmil](timeoutsecs.md)
  * [fullAuto](fullAuto.md) mode has changed and is now enabled by default
  * [fluxHist](StabilityHistory.md) is now '50' by default
  * Update check bugfix (updated latest release 2014-02-13)
  * More information can be found in the revision messages between [v5.0.354](https://code.google.com/p/quick-net-fix/source/detail?r=4809dd15fe7266bfac3396a22d9dd0ef79869c18) and [v5.0.377](http://code.google.com/p/quick-net-fix/source/detail?r=c5e6b9ea396e7fb0f9b742b15f02e7aa7a779bb7)

# [v4.3.353 (Latest Release)](http://adf.ly/1489522/http://www.mediafire.com/view/d8fx339j5na5gbl/) #
  * Added 1 setting: [check4update](check4update.md)
  * **Script now automatically checks for script updates** ([More Info...](https://code.google.com/p/quick-net-fix/source/detail?r=f4c70f4a5a0a387389650126c2bd51933baa6e42))
  * Script can check for updates on 3 channels: Stable, Beta, and Dev
  * **Commands that risk causing the script to hang indefinitely are called indirectly with a time limit so the script can continue if they take too long** (Write access required)
  * Use **`SFC`** to check for admin privileges instead of 3 separate commands for different systems
  * **Timeout duration calculated based on highest response time instead of average**
  * Last 20 test response times are used in calculation instead of last 5
  * **`PING`** waits longer every sequencial test that results in a timeout
  * Verify availability of all basic commands
  * **More alternative commands supported: `PSKILL`, `PSLIST`, `TLIST`, `KILL`**
  * Functions that require the creation of temporary files are individually disabled if script does not have write access
  * Ensure `NETSH` output is parsed correctly if output is unusual
  * Check for and remove old temporary files at script start and infrequently during continued use (once every 15-20 min)
  * Displays alert if adapter names have unsupported symbols (**`! & ^ %`**)
  * GUI: More descriptive initialization
  * In the unlikely event that the script crashes, a message saying so will appear with information about the error and what to do about it
  * Various bug fixes
  * More information can be found in the revision messages between [4.1.330](https://code.google.com/p/quick-net-fix/source/detail?r=af1f02daf0b71ceb51270668c0e2126e8ac5aa5e) and [v4.3.353](https://code.google.com/p/quick-net-fix/source/detail?r=e311bbd9f949ba2a79e18b9ea2b73b9b50af266d)

# [v4.1.329](http://adf.ly/1489522/http://www.mediafire.com/view/v0awnzw7kftu7a6/) #
  * Added 1 setting: [flukemaxtime](flukemaxtime.md)
  * **[Setting:flukechecks](flukechecks.md) now determined automatically/dynamically by default**
  * Ensure Console Extensions are enabled
  * **Add support for Windows 2000**
  * More checks to ensure commands are available and work correctly
  * Use alternate methods if certain commands are not available
  * 2 new themes: fullcolor,neon
  * **Thoroughly check all settings when script is initialized**
  * More thorough Environment Variable checks
  * More cases for connectivity test results
  * Bug fixes
  * **`PEND`** color is used after attempting to fix connection
  * Disable `QuickEdit` mode for current Console Window
  * More information can be found in the revision messages between [4.1.322](https://code.google.com/p/quick-net-fix/source/detail?r=1b09b890c802ab12843ebde46b5d48b592f6669c) and [v4.1.329](https://code.google.com/p/quick-net-fix/source/detail?r=7b074d0296afc0cd779340c195ba5727e49d2b54)

# [v4.0.321](http://adf.ly/1489522/http://www.mediafire.com/view/baisu0fld6boom9/nwcr_simple_v4.0.321.cmd) #
  * Added 3 settings: [viewmode](viewmode.md), [requestDisableIPv6](requestDisableIPv6.md), [requestAdmin](requestAdmin.md)
  * **Major Compatibility changes. This script has been tested and confirmed to work on nearly every edition of every version of Windows from XP and Server 2003 to 8.1 and Server 2012.** ([detailed Compatibility](Compatibility.md))
  * **Router/Adapter configuration detection completely re-written. It is now over 90% faster than the previous release**
  * **[Setting:checkrouterdelay](checkrouterdelay.md) is now determined automatically/dynamically by default**
  * **[Setting:timeoutsecs](timeoutsecs.md) is now determined automatically/dynamically by default**
  * Script displays estimated time to detect [Router](FAQ_RouterAddress.md)/[Adapter](FAQ_NetworkConnection.md) configuration
  * Certain tasks are timed down to the millisecond to improve overall efficiency
  * A lot of code tweaks and rewrites for the specific purpose of making the script more efficient
  * Added [adapter filters](filterAdapters.md): Bluetooth, Internal
  * More accurate and descriptive setting descriptions at beginning of script
  * **Alternate privilege detection method is used if the first one fails**
  * **Script now has 3 methods of resetting a [network adapter](FAQ_NetworkConnection.md) if some fail**
  * Script attempts to automatically (temporarily) resolve issues with environment variables if faulty: PATH,PATHEXT,TEMP
  * More information can be found in the revision messages between [3.4.297](https://code.google.com/p/quick-net-fix/source/detail?r=66dd341d14543192b3c20fa9a0467fe4ae8db8df) and [v4.0.321](https://code.google.com/p/quick-net-fix/source/detail?r=946af79ff40d20fb8cf76c4d9bffd6ba3ada5c7e)

# [v3.3.295)](http://adf.ly/1489522/http://www.mediafire.com/view/tlyb5cyzxva9vly/nwcr_simple_v3.3.295.cmd) #
  * New Setting: [fullAuto](fullAuto.md)
  * **Detect if run with Administrative privileges**
  * **Add alternate solution to attempt to fix [network connections](FAQ_NetworkConnection.md) on Limited Users**
  * A few bug fixes
  * **Displays the total time the script has been running ("started y m d hh:mm:ss ago")**
  * You can now set [manualAdapter](manualAdapter.md) to "all" (uses all [non-filtered](filterAdapters.md) network connections)
  * You can now set [manualRouter](manualRouter.md) to "none" (uses predefined website to test connectivity)
  * GUI dialog fixes
  * Faster initial loading
  * **Network configuration information is now retrieved using IPCONFIG ([more info...](https://code.google.com/p/quick-net-fix/source/detail?r=57d68da26e6a7d86fd8877472695736d79e11f39))**
  * More accurate "uptime" percentage
  * More information can be found in the revision messages between [v3.3.265](https://code.google.com/p/quick-net-fix/source/detail?r=8d6c9221fde6fb5f383aaa519558505abef5efaf) and [v3.3.295](https://code.google.com/p/quick-net-fix/source/detail?r=e7d8dbcd3046a8406aec5fe54fdbf57cdaa0fb3e)

# [v3.2.263](http://adf.ly/1489522/http://www.mediafire.com/view/6fmmfzc9992fb3z/nwcr_simple_v3.2.263.cmd) #
  * **Critical bug fix: Some IPv6 addresses were not retrieved correctly. All IPv6 addresses are now retrieved correctly**
  * **Network Configuration Information is now retrieved from NETSH instead of IPCONFIG**
  * Added [Adapter filters](filterAdapters.md): VMware, VMnet, Loopback, Pseudo
  * More information can be found in the revision messages between [v3.1.261](https://code.google.com/p/quick-net-fix/source/detail?r=62c4a7bfb02fc84918e9b9f68806995a7907ca4e) and [v3.2.263](https://code.google.com/p/quick-net-fix/source/detail?r=e97ee962de6fcbb08b0a39dee59cb477e8afff6d)

# [v3.1.260](http://adf.ly/1489522/http://www.mediafire.com/view/xdi6zv48kg3g7l6/nwcr_simple_v3.1.260.cmd) #
  * Added 3 settings: [timeoutsecs](timeoutsecs.md), [checkrouterdelay](checkrouterdelay.md), [filterRouters](filterRouters.md), [filterAdapters](filterAdapters.md)
  * Removed 1 setting: [timeoutmilsecs](timeoutsecs.md) (replaced with [timeoutsecs](timeoutsecs.md))
  * **Added IPv6 Support**
  * re-wrote [Router](FAQ_RouterAddress.md) and [Adapter](FAQ_NetworkConnection.md) detection code (smarter, tries more possibilities before giving up)
  * Updates Adapter and Router values every [checkrouterdelay](checkrouterdelay.md) (5 by default) successful connects
  * **Detects changes in network configuration** and changes accordingly
  * Updates Adapter and Router values after a successful connect following a connection error
  * More accurate Uptime percentage calculation and tracking
  * Test with pre-defined website if error connecting to router
  * Almost immediate detection of change in Router/Adapter, without the need to reset your adapters first
  * More readable Stability level
  * More information can be found in the revision message of [v2.6.232](https://code.google.com/p/quick-net-fix/source/detail?r=d6405580f707f47757153bb2c6c2a9a5bc03a819) and [v3.1.260](https://code.google.com/p/quick-net-fix/source/detail?r=5d93d5b1ae3f532171117219065bc96f39310272)

# [v2.6.230](http://adf.ly/1489522/http://www.mediafire.com/view/i2fm5v9ax3sg2vm/nwcr_simple_v2.6.230.cmd) #
  * Added 8 settings: [manualRouter](manualRouter.md), [manualAdapter](manualAdapter.md), [StabilityHistory](StabilityHistory.md), [flukechecks](flukechecks.md), [checkdelay](checkdelay.md), [fixdelay](fixdelay.md), [flukecheckdelay](flukecheckdelay.md), [timeoutmilsecs](timeoutsecs.md), [pretty](pretty.md), [theme](theme.md)
  * Removed 1 setting: [debgn](pretty.md) (replaced with [pretty](pretty.md))
  * **Visually Depict last [StabilityHistory](StabilityHistory.md) (default 25) connection tests in the bottom titlebar**
  * **Display connection Stability rating**
  * Console colors change depending on what the current network status is (unless you have [theme](theme.md) set to "crazy" in which case everything changes randomly, or set to "none" where it doesn't change at all)
  * **Detects PING result "General Failure" as adapter in process of connecting**
  * More accurate Uptime percentage calculation
  * Show uptime and downtime divided by [checkdelay](checkdelay.md)
  * Filter out unsupported IPv6 gateways
  * Add short setting descriptions by each one
  * More information can be found in the revision messages between [v2.1.205](https://code.google.com/p/quick-net-fix/source/detail?r=eb19726da786d0cef60948d7057777d37ce04192) and [v2.6.230](https://code.google.com/p/quick-net-fix/source/detail?r=3b9cf7e426c5f477a75a716d47f1497c4a819969)

# [v2.1.199](http://adf.ly/1489522/http://www.mediafire.com/view/5xakatk8gkja5p1/nwcr_simple_v2.1.199.cmd) #
  * Added 1 setting: [fixdelay](fixdelay.md)
  * Removed 1 setting: [router](manualRouter.md) (now **automatically determined**)
  * Show router address when retrieved
  * Console size adjusts to fit the content displayed
  * Default to predefined website address as router if none detected
  * Silence netsh and other routines
  * More information can be found in the revision message of [v2.1.199](https://code.google.com/p/quick-net-fix/source/detail?r=bf70658358fae0fb64f402a4466be5ff8f69f3d4)

# [v1.1.051 (Initial Release)](http://adf.ly/1489522/http://www.mediafire.com/view/0cip585879hi3ko/nwcr_simple_v1.1.051.cmd) #
  * 3 settings: [router](manualRouter.md), [checkdelay](checkdelay.md), and [debgn](pretty.md)
  * Router is set manually
  * Asks for Adapter you want to monitor/fix. Uses WMIC to retrieve all available adapters
  * Shows the adapter you chose
  * **Shows the Uptime percentage**
  * Shows the number of times the connection has been fixed
  * Shows the result of the last connection test
  * Shows what the script is currently doing
  * when testing, double checks to make sure result is accurate
  * **Pings router to determine connectivity**
  * **Fix is simple network adapter reset**
  * [Revision f13d707fcec6d6 v1.1.051](https://code.google.com/p/quick-net-fix/source/detail?r=f13d707fcec6d610eb5ef8b04f5ad1884175cf3c)
# Setting: check4update #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v4.2.343](https://code.google.com/p/quick-net-fix/source/detail?r=f4c70f4a5a0a387389650126c2bd51933baa6e42) | Current | check4update |

Current Prefix: N/A


## Description ##
This setting controls whether or not this <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> checks for the availability of newer versions. If a newer version is found, the script displays "UPDATE AVAILABLE" as part of the title box. It is completely up to the user when or if to update the script.

  * An update check is performed only if all of the following are true:
    * Setting: check4update is set to 1
    * Last connectivity test result was "Connected"
    * Script is not due to verify router/adapter
    * There was not a connection reset within the last [25](StabilityHistory.md) (BETA: 50) checks
    * It has been at least 5 minutes (BETA: 10 minutes) since the script started and/or about 1 day (BETA: [configurable](c4uwait.md) since the last update check

**This is a BOOLEAN setting, meaning that the value must be 0 or 1**. In this case: 0 is OFF, and 1 is ON.



## History ##
  * Added in [v4.2.343](https://code.google.com/p/quick-net-fix/source/detail?r=f4c70f4a5a0a387389650126c2bd51933baa6e42)


[List of Settings](Settings.md)
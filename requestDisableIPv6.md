# Setting: requestDisableIPv6 #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v3.4.310](https://code.google.com/p/quick-net-fix/source/detail?r=b50e7680f1363aed66ec6fd8a056f2bd10e17b09) | Current | fullAuto |

Current Prefix: N/A


## Description ##
When this  <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> is run, it will (by default) scan all currently enabled Network Adapters to determine your current Router/Adapter configuration. If you have an excessive number of Tunnel adapters, the script can offer to disable IPv6. Having the protocol IPv6 enabled is generally not a bad thing, but there are cases where it is not implemented properly. This results in an excessive number of Tunnel adapters which can cause long delays in connecting to the internet and overall system instability.

If **requestDisableIPv6** is set to 0, the script will ignore the excessive number of Network Adapters.

If **requestDisableIPv6** is set to 1, the script will ask the user if they would like to disable IPv6.

If **requestDisableIPv6** is set to 2, the script will automatically disable IPv6 when this issue is detected.

**The value for this setting must be 0, 1, or 2**


**NOTE: This setting is removed in [v5.0.355](https://code.google.com/p/quick-net-fix/source/detail?r=75be907e1999fd70ee02fc2e1b56b5fd1fcc73d7) and later**


## History ##
  * Added in [v3.4.310](https://code.google.com/p/quick-net-fix/source/detail?r=b50e7680f1363aed66ec6fd8a056f2bd10e17b09)
  * Removed in [v5.0.355](https://code.google.com/p/quick-net-fix/source/detail?r=75be907e1999fd70ee02fc2e1b56b5fd1fcc73d7)


[List of Settings](Settings.md)
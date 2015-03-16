# Setting: fullAuto #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v3.3.284](https://code.google.com/p/quick-net-fix/source/detail?r=ee5c44e4c9c22fbd28f88158f1b1181d848f5453) | Current | fullAuto |

Current Prefix: N/A


## Description ##
When this  <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> is run, it will attempt to automatically determine what your Router and Adapter are. Occasionally, there may be multiple Routers or multiple Adapters that are in use. When this is the case, the script will not know which ones to use, and a dialog asking the user which ones to use will appear. Setting **fullAuto** to '1' will disable these dialogs and force the script to set [manualRouter](manualRouter.md) to 'none' and [manualAdapter](manualAdapter.md) to 'all'


**The value for this setting must be 1 or 0**


**NOTE: The functionality that this setting enables/disables is changed in [v5.0.361](https://code.google.com/p/quick-net-fix/source/detail?r=9a9067be32a3b87b80dc583bc1e553f36a9fcb28) and later**

In the latest BETA with fullAuto mode enabled, it will no longer set the manualAdapter and manualRouter settings. Instead, the script will be forced to continue with empty values for the current router and adapter. The values for the current router and adapter will be revisited instead of permanently set to the 'fallback' values. This means that the script will better adapt to changing network configurations.


## History ##
  * Added in [v3.3.284](https://code.google.com/p/quick-net-fix/source/detail?r=ee5c44e4c9c22fbd28f88158f1b1181d848f5453)
  * Default value changed from '0' to '1' in [5.0.361](https://code.google.com/p/quick-net-fix/source/detail?r=9a9067be32a3b87b80dc583bc1e553f36a9fcb28)


[List of Settings](Settings.md)
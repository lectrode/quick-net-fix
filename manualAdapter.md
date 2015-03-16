# Setting: manualAdapter #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| v2.3.218 | Current | manualAdapter |


## Description ##
When a network problem is detected, the Adapter is reset. The **manualAdapter** setting allows the user to force the <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> to use a certain Adapter. By default this is blank, as the script attempts to automatically determine a suitable value. **If set to "all" it will reset all [non-filtered](filterAdapters.md) [network adapters](FAQ_NetworkConnection.md) if a connectivity problem is detected.**

Setting value examples:
  * Local Area Connection
  * Wireless Network Connection
  * all
  * (blank)

## BETA ([5.0.355](https://code.google.com/p/quick-net-fix/source/detail?r=75be907e1999fd70ee02fc2e1b56b5fd1fcc73d7) and later) ##

If the network connection name has any or multiple of the symbols: **`& % ! ^`**, the script now supports them.

Names with special characters (**`& % ! ^`**) must be as follows (notice the quotes):

`@set "manualAdapter=N&me with specia! c%%aracters"`

NOTE: Names with **`^`** before another special character cannot be parsed

NOTE: If the name has **`%`** (ie "`A%apter Name`") it must be written "`%%`" (ie "`A%%apter Name`")



## History ##
  * Added in v2.3.218
  * The option 'all' was added in [v3.3.275](https://code.google.com/p/quick-net-fix/source/detail?r=cdd3ca53a7557fcaea038e3b00f294edae9cf741)
  * Support for the symbols (**`& % ! ^`**) was added in [5.0.355](https://code.google.com/p/quick-net-fix/source/detail?r=75be907e1999fd70ee02fc2e1b56b5fd1fcc73d7)


[List of Settings](Settings.md)
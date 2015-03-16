# Setting: errorLog #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf) | Current | errorLog |

Current Prefix: N/A


## Description ##
If this <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> encounters an error and **`errorLog`** is set to '1' (default), the script will generate a crash/error log before continuing. If **`errorLog`** is set to '0' and/or the script does not have write access, the script will not generate a crash/error log.


**This is a BOOLEAN setting, meaning that the value must be 0 or 1.** In this case: 0 is OFF, and 1 is ON.

## Error Log Location ##
To open the error log location you must [run the command](http://www.computerhope.com/issues/chdos.htm): `'explorer "<location>"'` (without single-quotes) where `<location>` is one of the following:
  * `%TEMP%\EXSqNET\ErrorLogs` **(Normal)**
  * `%LOCALAPPDATA%\Temp\EXSqNET\ErrorLogs`
  * `%USERPROFILE%\Local Settings\Temp\EXSqNET\ErrorLogs`
  * `%APPDATA%\EXSqNET\ErrorLogs`
  * `%SYSTEMDRIVE%\Windows\Temp\EXSqNET\ErrorLogs`
  * `%SYSTEMDRIVE%\WINNT\Temp\EXSqNET\ErrorLogs`
  * `%WINDIR%\Temp\EXSqNET\ErrorLogs`



## History ##
  * Added in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf)


[List of Settings](Settings.md)
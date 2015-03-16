# Setting: noStop #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf) | Current | noStop |

Current Prefix: N/A


## Description ##
If this <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> encounters a critical error that causes it to crash and **`noStop`** is set to '1' (default), the script will automatically restart itself in order to continue. If **`noStop`** is set to '0', the script will display an error message stating it crashed and will do no more.


**This is a BOOLEAN setting, meaning that the value must be 0 or 1.** In this case: 0 is OFF, and 1 is ON.



## History ##
  * Added in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf)


[List of Settings](Settings.md)
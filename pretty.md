# Setting: pretty #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| Pre-release | [v2.3.220](https://code.google.com/p/quick-net-fix/source/detail?r=5190f9611a6b8ccb48c55fb5163d6ab2a24590ba) | debgn |
| [v2.4.222](https://code.google.com/p/quick-net-fix/source/detail?r=49760711eb3e553ea984f62ceb46958b9b221614) | Current | pretty |

Current Prefix: N/A


## Description ##
When you run the <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a>, it will only display statistics and current statuses. If you want to see _exactly_ what the script is doing at any one time, set **pretty** to '0'. This is mainly for debugging.

NOTE: Setting this to '0' will make the display incomprehensible to anyone who does not recognize batch scripting.

NOTE: If this is set to '0' the script will run noticeably slower, as it has to not only run the commands, but show them in the console window as well.


**The value for this setting must be a 0 or 1.**



## History ##
  * Added before release versions
  * **debgn** replaced with **pretty** in [v2.4.222](https://code.google.com/p/quick-net-fix/source/detail?r=49760711eb3e553ea984f62ceb46958b9b221614). Value is 1 or 0 instead of "::" or blank


[List of Settings](Settings.md)
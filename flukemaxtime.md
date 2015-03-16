# Setting: flukemaxtime #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v4.1.324](https://code.google.com/p/quick-net-fix/source/detail?r=ae33dfaa63d560c895f403f218cd19199d21f783) | Current | flukemaxtime |

Current Prefix: INT


## Description ##
With normal use, a network may experience tiny "blips" in the connectivity. The <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> needs avoid false-detecting one of these "blips" as a problem that needs to be fixed. Once a network disruption is detected, the script will start re-checking the connectivity. It will re-check it for a maximum of **flukemaxtime** (25 by default) seconds. Only if the connectivity does not return in that time does the script take action to fix it.


**The value for this setting must be an**<a href='http://en.wikipedia.org/wiki/Integer' title='A non-negative number that does not contain a decimal'>integer</a>.

NOTE: [flukechecks](flukechecks.md) must be set to '0' (auto) for this setting to take effect.


## History ##
  * Added in [v4.1.324](https://code.google.com/p/quick-net-fix/source/detail?r=ae33dfaa63d560c895f403f218cd19199d21f783)
  * Removed in [5.0.355](https://code.google.com/p/quick-net-fix/source/detail?r=75be907e1999fd70ee02fc2e1b56b5fd1fcc73d7)


[List of Settings](Settings.md)
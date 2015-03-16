# Setting: checkrouterdelay #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v3.0.251](https://code.google.com/p/quick-net-fix/source/detail?r=2fe2c34c1d4a4c2664560583259f4716ea239495) | [v5.0.361](https://code.google.com/p/quick-net-fix/source/detail?r=9a9067be32a3b87b80dc583bc1e553f36a9fcb28) | checkrouterdelay |
| [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf) | Current | chknetwait |

Current Prefix: INT


## Description ##
While the <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> is running, it will occasionally check the validity of the values for the Router and Adapter. If not forced to check by a momentary disconnect or a network fix, **checkrouterdelay** is the number of successful connects it must wait before checking the validity of those values.

As of [v3.4.297](https://code.google.com/p/quick-net-fix/source/detail?r=66dd341d14543192b3c20fa9a0467fe4ae8db8df) setting the value of [checkrouterdelay](checkrouterdelay.md) to 0 (default) will tell the script to automatically adjust the value depending on how many enabled connections there are and how long it takes to verify the adapter/router combination. The longer it takes to do this, the longer it waits to recheck. **On a normal personal computer system, there should not be more than 10 enabled Network Connections** (There may be more on Servers). With 10 or less connections, verification should only take a few seconds.


The value for this setting must be an <a href='http://en.wikipedia.org/wiki/Integer' title='A non-negative number that does not contain a decimal'>integer</a>.

NOTE: Checking the validity of those values on an average system takes on about 2-3 seconds. If there is a large number of enabled Network Connections, it takes longer to detect which ones are in use.

NOTE: When the script checks the validity of the router and adapter values, it times itself and subtracts the amount of time it takes from the rest of the time it was supposed to wait. For example: if [checkdelay](checkdelay.md) is set to '5' (default), if the validity check takes 3 seconds, it will wait 2 seconds after that for a total of 5. In this way, it avoids causing a longer than usual delay between the connectivity checks.


**NOTE: Dynamic (auto) functionality is removed in [v5.0.355](https://code.google.com/p/quick-net-fix/source/detail?r=75be907e1999fd70ee02fc2e1b56b5fd1fcc73d7) and later**


**NOTE: This setting is renamed to `chknetwait` in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf)**



## History ##
  * Added in [v3.0.251](https://code.google.com/p/quick-net-fix/source/detail?r=2fe2c34c1d4a4c2664560583259f4716ea239495)
  * Changed default value from 5 to 0 (auto) in [v3.4.297](https://code.google.com/p/quick-net-fix/source/detail?r=66dd341d14543192b3c20fa9a0467fe4ae8db8df)
  * Changed default value from 0 to 10 in [v5.0.355](https://code.google.com/p/quick-net-fix/source/detail?r=75be907e1999fd70ee02fc2e1b56b5fd1fcc73d7)
  * Renamed `checkrouterdelay` to `chknetwait` in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf)


[List of Settings](Settings.md)
# Setting: flukechecks #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v2.1.208](https://code.google.com/p/quick-net-fix/source/detail?r=109b06def281e139dcbbf29e1a1279d34c443d64) | [v2.2.215](https://code.google.com/p/quick-net-fix/source/detail?r=fc952b50fb9e610d684c0a6403d65a1d86674790) | doublecheck |
| [v2.3.218](https://code.google.com/p/quick-net-fix/source/detail?r=fa01d88a675b67e8f0a2067274d1040bd0a752ef) | Current | flukechecks |

Current Prefix: INT


## Description ##
With normal use, a network may experience tiny "blips" in the connectivity. The <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> needs to avoid false-detecting one of these "blips" as a problem that needs to be fixed. This is where **flukechecks** comes into play. Once a network disruption is detected, the script will start re-checking the connectivity. It will re-check it **flukechecks** (7 by default) times. When it has received the same result **flukechecks** times in a row, it will attempt to fix it.


**The value for this setting must be an**<a href='http://en.wikipedia.org/wiki/Integer' title='A non-negative number that does not contain a decimal'>integer</a>.

NOTE: The higher the value, the less false-detections are made, but the longer it will take to detect a network problem and try to fix it.

**NOTE: Dynamic (auto) functionality is removed in [5.0.355](https://code.google.com/p/quick-net-fix/source/detail?r=75be907e1999fd70ee02fc2e1b56b5fd1fcc73d7) and later**


## History ##
  * Added in [v2.1.208](https://code.google.com/p/quick-net-fix/source/detail?r=109b06def281e139dcbbf29e1a1279d34c443d64)
  * Renamed in [v2.2.216](https://code.google.com/p/quick-net-fix/source/detail?spec=svnd9d932ac5a7f58689fabbe560a2687ff20163d01&r=d9d932ac5a7f58689fabbe560a2687ff20163d01)
  * Prefix "STN" added in [v2.3.218](https://code.google.com/p/quick-net-fix/source/detail?spec=svnfa01d88a675b67e8f0a2067274d1040bd0a752ef&r=fa01d88a675b67e8f0a2067274d1040bd0a752ef)
  * Default value changed from '3' to '5' in [v2.4.222](https://code.google.com/p/quick-net-fix/source/detail?r=49760711eb3e553ea984f62ceb46958b9b221614)
  * Default value changed from '5' to '7' in [v2.6.229](https://code.google.com/p/quick-net-fix/source/detail?spec=svn62e713b8a36b3aac8cef5f98ededf9eb0adac45f&r=62e713b8a36b3aac8cef5f98ededf9eb0adac45f)
  * Prefix "STN" changed to "INT" in [v2.6.235](https://code.google.com/p/quick-net-fix/source/detail?spec=svnb1a411be221b1f59f03b67dad9a3b89dfed8921d&r=b1a411be221b1f59f03b67dad9a3b89dfed8921d)
  * Default value changed from '7' to '0' (auto) in [v4.1.324](https://code.google.com/p/quick-net-fix/source/detail?r=ae33dfaa63d560c895f403f218cd19199d21f783)
  * Default value changed from '0' to 7 in [5.0.355](https://code.google.com/p/quick-net-fix/source/detail?r=75be907e1999fd70ee02fc2e1b56b5fd1fcc73d7)


[List of Settings](Settings.md)
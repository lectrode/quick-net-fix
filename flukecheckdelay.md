# Setting: flukecheckdelay #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v2.1.208](https://code.google.com/p/quick-net-fix/source/detail?r=109b06def281e139dcbbf29e1a1279d34c443d64) | [v2.2.215](https://code.google.com/p/quick-net-fix/source/detail?r=fc952b50fb9e610d684c0a6403d65a1d86674790) | doublecheckdelay |
| [v2.3.218](https://code.google.com/p/quick-net-fix/source/detail?r=fa01d88a675b67e8f0a2067274d1040bd0a752ef) | [v5.0.361](https://code.google.com/p/quick-net-fix/source/detail?r=9a9067be32a3b87b80dc583bc1e553f36a9fcb28) | flukecheckdelay |
| [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf) | Current | flukechkwait |

Current Prefix: INT


## Description ##
With normal use, a network may experience tiny "blips" in the connectivity. The <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> re-checks the connectivity multiple times (set by [flukechecks](flukechecks.md)) in order to avoid false-detecting one of these "blips" as a problem. The **flukecheckdelay** is the delay in seconds between these checks.


**The value for this setting must be an**<a href='http://en.wikipedia.org/wiki/Integer' title='A non-negative number that does not contain a decimal'>integer</a>.

NOTE: The higher the value, the less false-detections are made, but the longer it will take to detect a network problem and try to fix it.


**NOTE: This setting is renamed to `flukechkwait` in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf)**


## History ##
  * Added in [v2.1.208](https://code.google.com/p/quick-net-fix/source/detail?r=109b06def281e139dcbbf29e1a1279d34c443d64)
  * Renamed in [v2.2.216](https://code.google.com/p/quick-net-fix/source/detail?r=d9d932ac5a7f58689fabbe560a2687ff20163d01)
  * Prefix "STN" added in [v2.3.218](https://code.google.com/p/quick-net-fix/source/detail?spec=svnfa01d88a675b67e8f0a2067274d1040bd0a752ef&r=fa01d88a675b67e8f0a2067274d1040bd0a752ef)
  * Default value changed from '2' to '3' in [v2.4.222](https://code.google.com/p/quick-net-fix/source/detail?r=49760711eb3e553ea984f62ceb46958b9b221614)
  * Default value changed from '3' to '1' in [v2.6.229](https://code.google.com/p/quick-net-fix/source/detail?r=62e713b8a36b3aac8cef5f98ededf9eb0adac45f)
  * Prefix "STN" changed to "INT" in [v2.6.235](https://code.google.com/p/quick-net-fix/source/detail?r=b1a411be221b1f59f03b67dad9a3b89dfed8921d)
  * Renamed 'flukecheckdelay' to 'flukechkwait' in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf)


[List of Settings](Settings.md)
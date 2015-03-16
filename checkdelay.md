# Setting: checkdelay #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v1.1.051](https://code.google.com/p/quick-net-fix/source/detail?r=f13d707fcec6d610eb5ef8b04f5ad1884175cf3c) | [v5.0.361](https://code.google.com/p/quick-net-fix/source/detail?r=9a9067be32a3b87b80dc583bc1e553f36a9fcb28) | checkdelay |
| [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf) | Current | checkwait |

Current Prefix: INT


## Description ##
While monitoring the connectivity of the connection, the <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> will make frequent tests to make sure the computer is still connected to the network. It will wait a period of time between each test so that it is not spamming the router address. The setting **checkdelay** holds the numeric value of seconds the script waits between connectivity checks.


**The value for this setting must be an**<a href='http://en.wikipedia.org/wiki/Integer' title='A non-negative number that does not contain a decimal'>integer</a>.


**NOTE: This setting is renamed to `checkwait` in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf)**


## History ##
  * Changed default value from '2' to '5' in [v2.1.199](https://code.google.com/p/quick-net-fix/source/detail?r=bf70658358fae0fb64f402a4466be5ff8f69f3d4)
  * Prefix "STN" added in [v2.3.218](https://code.google.com/p/quick-net-fix/source/detail?r=fa01d88a675b67e8f0a2067274d1040bd0a752ef)
  * Prefix "STN" changed to "INT" in [v2.6.235](https://code.google.com/p/quick-net-fix/source/detail?r=b1a411be221b1f59f03b67dad9a3b89dfed8921d)
  * Renamed `checkdelay` to `checkwait` in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf)


[List of Settings](Settings.md)
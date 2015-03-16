# Setting: fixdelay #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v2.1.199](https://code.google.com/p/quick-net-fix/source/detail?r=bf70658358fae0fb64f402a4466be5ff8f69f3d4) | [v5.0.361](https://code.google.com/p/quick-net-fix/source/detail?r=9a9067be32a3b87b80dc583bc1e553f36a9fcb28) | fixdelay |
| [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf) | Current | fixwait |

Current Prefix: INT


## Description ##
When the <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> detects a problem with the connection, it will try to fix it. The **fixdelay** is the amount of time in seconds the script waits after it has attempted to fix the internet connection before testing the connectivity again. Older versions needed to wait longer, but newer versions are smart enough to detect when the network adapter is in process of connecting.


**The value for this setting must be an**<a href='http://en.wikipedia.org/wiki/Integer' title='A non-negative number that does not contain a decimal'>integer</a>.


**NOTE: This setting is renamed to `fixwait` in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf)**


## History ##
  * Added in [v2.1.199](https://code.google.com/p/quick-net-fix/source/detail?r=bf70658358fae0fb64f402a4466be5ff8f69f3d4)
  * Prefix "STN" added in [v2.3.218](https://code.google.com/p/quick-net-fix/source/detail?r=fa01d88a675b67e8f0a2067274d1040bd0a752ef)
  * Default value changed from '20' to '2' in [v2.6.229](https://code.google.com/p/quick-net-fix/source/detail?r=62e713b8a36b3aac8cef5f98ededf9eb0adac45f)
  * Prefix "STN" changed to "INT" in [v2.6.235](https://code.google.com/p/quick-net-fix/source/detail?r=b1a411be221b1f59f03b67dad9a3b89dfed8921d)
  * Default value changed from '2' to '10' in [v3.4.302](https://code.google.com/p/quick-net-fix/source/detail?r=553aa061156efcf0703768028dc386047986a374)
  * Renamed 'fixdelay' to 'fixwait' in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf)



[List of Settings](Settings.md)
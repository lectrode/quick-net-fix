## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v2.3.218](https://code.google.com/p/quick-net-fix/source/detail?r=fa01d88a675b67e8f0a2067274d1040bd0a752ef) | [v2.6.230](https://code.google.com/p/quick-net-fix/source/detail?r=3b9cf7e426c5f477a75a716d47f1497c4a819969) | timeoutmilsecs |
| [v2.6.232](https://code.google.com/p/quick-net-fix/source/detail?r=d6405580f707f47757153bb2c6c2a9a5bc03a819) | [v5.0.361](https://code.google.com/p/quick-net-fix/source/detail?r=9a9067be32a3b87b80dc583bc1e553f36a9fcb28) | timeoutsecs |
| [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf) | Current | timeoutmil |

Current Prefix: INT


## Description ##
While monitoring the connectivity of the connection, the <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> will make frequent tests to make sure the computer is still connected to the network. The value of **timeoutsecs** is how long the PING command will wait in seconds before it determines that the test has "Timed out." As of [v3.4.318](https://code.google.com/p/quick-net-fix/source/detail?r=bd01930e3973090a6c273031e193210177e7bc73), the default value is '0' (auto) as the script can now dynamically change this amount according to how much is needed.



**The value for this setting must be an**<a href='http://en.wikipedia.org/wiki/Integer' title='A non-negative number that does not contain a decimal'>integer</a>.


**NOTE: Dynamic (auto) functionality is removed in [5.0.355](https://code.google.com/p/quick-net-fix/source/detail?r=75be907e1999fd70ee02fc2e1b56b5fd1fcc73d7) and later**

**NOTE: As of [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf) the value of this setting is in milliseconds (1/1000th of a second). Default value is 3000**



## History ##
  * Added in [v2.3.218](https://code.google.com/p/quick-net-fix/source/detail?r=fa01d88a675b67e8f0a2067274d1040bd0a752ef)
  * Prefix "STN" added in [v2.3.218](https://code.google.com/p/quick-net-fix/source/detail?r=fa01d88a675b67e8f0a2067274d1040bd0a752ef)
  * timeoutmilsecs replaced with timeoutsecs in v2.6.232. Value is "Seconds" instead of "Milliseconds"
  * Prefix "STN" changed to "INT" in [v2.6.235](https://code.google.com/p/quick-net-fix/source/detail?r=b1a411be221b1f59f03b67dad9a3b89dfed8921d)
  * Default value changed from 1 to 0 (auto) in [v3.4.318](https://code.google.com/p/quick-net-fix/source/detail?r=bd01930e3973090a6c273031e193210177e7bc73)
  * Default value changed from 0 to 3 in [5.0.355](https://code.google.com/p/quick-net-fix/source/detail?r=75be907e1999fd70ee02fc2e1b56b5fd1fcc73d7)
  * timeoutsecs replaced with timeoutmil in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf). Value is "Milliseconds" instead of "Seconds"


[List of Settings](Settings.md)
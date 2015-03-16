# Setting: filterRouters #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v3.0.251](https://code.google.com/p/quick-net-fix/source/detail?r=2fe2c34c1d4a4c2664560583259f4716ea239495) | Current | filterRouters |

Current Prefix: N/A


## Description ##
When you run this <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a>, it will attempt to automatically retrieve the "Default Gateway" address and use that to [periodically test](checkdelay.md) the connectivity. **filterRouters** allows you to manually put in addresses or parts of addresses that will not be used to test the connectivity.


Example values
  * 192.168.0.1
    * will ignore the address "192.168.0.1"
  * 10.0.
    * will ignore any addresses with "10.0." in them
  * feod:345n:
    * will ignore any addresses with "feod:345n:" in them


## History ##
  * Added in [v3.0.251](https://code.google.com/p/quick-net-fix/source/detail?r=2fe2c34c1d4a4c2664560583259f4716ea239495)


[List of Settings](Settings.md)
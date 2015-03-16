# Setting: filterAdapters #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v3.0.251](https://code.google.com/p/quick-net-fix/source/detail?r=2fe2c34c1d4a4c2664560583259f4716ea239495) | Current | filterAdapters |

Current Prefix: N/A


## Description ##
When you run this <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a>, it will attempt to automatically retrieve the [adapter](FAQ_NetworkConnection.md) name and use that to fix the connectivity when problems are detected. **filterAdapters** allows you to manually put in keywords of adapters that will be ignored. Keywords are separated with a space.


Example values
  * Tunnel
    * will ignore Tunnel adapters
  * Tunnel Pseudo
    * will ignore Tunnel or Psuedo adapters
  * Wireless
    * will ignore Wireless adapters


## History ##
  * Added in [v3.0.251](https://code.google.com/p/quick-net-fix/source/detail?r=2fe2c34c1d4a4c2664560583259f4716ea239495) with filters "Tunnel" "`VirtualBox`"
  * Added filters "VMnet" "VMware" in [v3.1.261](https://code.google.com/p/quick-net-fix/source/detail?r=62c4a7bfb02fc84918e9b9f68806995a7907ca4e)
  * Added filters "Loopback" "Pseudo" in [v3.2.263](https://code.google.com/p/quick-net-fix/source/detail?r=e97ee962de6fcbb08b0a39dee59cb477e8afff6d)
  * Added filter "Bluetooth" in [v3.4.300](https://code.google.com/p/quick-net-fix/source/detail?r=a069f12ca1ca78e45abbe46b770ae2cae9e11286)

[List of Settings](Settings.md)
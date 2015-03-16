# Setting: manualRouter #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| Pre-release | [v1.1.051](https://code.google.com/p/quick-net-fix/source/detail?r=f13d707fcec6d610eb5ef8b04f5ad1884175cf3c) | router |
| [v2.2.215](https://code.google.com/p/quick-net-fix/source/detail?r=fc952b50fb9e610d684c0a6403d65a1d86674790) | Current | manualRouter |


## Description ##
The Router address is used to test the connectivity of the network connection. The **manualRouter** setting allows the user to force the <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> to use a certain address. By default this is blank, as the script attempts to automatically determine a suitable value. **If set to "none" it will use the predefined website to test connectivity.**

The address can be one of the following:
  * an IPv4 address (Ex: 192.168.0.1 )
  * an IPv6 address (Ex: FF01:0:0:0:0:0:0:2 )
  * a website address (Ex: www.google.com )
  * none
  * (blank)


## History ##
  * In [v1.1.051](https://code.google.com/p/quick-net-fix/source/detail?r=f13d707fcec6d610eb5ef8b04f5ad1884175cf3c), this setting was mandatory, as the script did not have the functionality to retrieve this value automatically.
  * This setting was removed in [v2.1.199](https://code.google.com/p/quick-net-fix/source/detail?r=bf70658358fae0fb64f402a4466be5ff8f69f3d4) when the ability to automatically retrieve this value was added to the script.
  * In [v2.2.215](https://code.google.com/p/quick-net-fix/source/detail?r=fc952b50fb9e610d684c0a6403d65a1d86674790) this setting was re-added to give the option of manually setting the router address.
  * The option 'none' was added in [v3.3.275](https://code.google.com/p/quick-net-fix/source/detail?r=cdd3ca53a7557fcaea038e3b00f294edae9cf741).


[List of Settings](Settings.md)
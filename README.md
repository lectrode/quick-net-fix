# quick-net-fix
<table width='435px'>
<tr>
<td align='center'>
<h1>Lectrode's Quick Net Fix</h1>
<img src='https://www.mediafire.com/convkey/5d4e/i0bfh32ud6mnt6u6g.jpg' />
</td>
</tr>
</table>

## [Downloads / Changelog](https://github.com/lectrode/quick-net-fix/blob/wiki/Releases_and_Changelog.md) (Updated 2014-06-06) ##
### [Getting Started (Wiki)](https://github.com/lectrode/quick-net-fix/blob/wiki/GettingStarted.md) ###

This <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> was designed with two purposes: to monitor and fix your [internet/network connection](https://github.com/lectrode/quick-net-fix/blob/wiki/FAQ_NetworkConnection.md), and to be simple. This was made with ["flaky" connections](https://github.com/lectrode/quick-net-fix/blob/wiki/FAQ_Flaky.md) in mind.

Besides the simplicity, a few key differences from [it's predecessor](https://github.com/lectrode/quick-net-fix/blob/wiki/NCR.md) are:
  * the automatic determination of the [Network Connection](https://github.com/lectrode/quick-net-fix/blob/wiki/FAQ_NetworkConnection.md)
  * the automatic retrieval of your [router's IP address](https://github.com/lectrode/quick-net-fix/blob/wiki/FAQ_RouterAddress.md)
  * the quickness with which this detects and fixes connectivity issues

With the first 2 features, there is no need to configure the script beforehand. Simply run it, and it will do it's job. It uses the [Network Connection](https://github.com/lectrode/quick-net-fix/blob/wiki/FAQ_NetworkConnection.md) name to reset when the internet connection goes out, and it pings the [router address](https://github.com/lectrode/quick-net-fix/blob/wiki/FAQ_RouterAddress.md) to determine connectivity. In the rare event that it cannot determine one or both, you can manually set it to permanently use a specific Network Connection and/or router by editing the script [Settings](https://github.com/lectrode/quick-net-fix/blob/wiki/Settings.md).


Additional features are listed below:

  * [Compatible](https://github.com/lectrode/quick-net-fix/blob/wiki/Compatibility.md) with all editions of all versions of Windows from _Windows 2000_ to _8.1_ and _Server 2012 R2_ _**New!**_
  * IPv4 and IPv6 supported
  * Visual Depiction of Network Stability in bottom Title Bar
  * Uptime and stability statistics
  * Displays how long ago the script was started
  * Automatic reset of Network Connection when there is no connectivity
  * Faster detection of lack of connectivity (compared to it's predecessor)
  * Automatically [filtered out network adapters](https://github.com/lectrode/quick-net-fix/blob/wiki/filterAdapters.md) include: Tunnel, `VirtualBox`, VMware, VMnet, Loopback, Pseudo, Bluetooth, Internal


Questions and comments are welcome :)

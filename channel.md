# Setting: channel #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v5.0.360](https://code.google.com/p/quick-net-fix/source/detail?r=d1970b70b860d0c3bcde6180f69227376a497fec) | Current | channel |

Current Prefix: N/A


## Description ##
If update checks are enabled, this setting will determine which "channel" to compare the current version number to. For example, if **channel** is set to check against the Release channel (v), the <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> will only notify the user of an update when the latest Release version number is greater than the current version's number.

**This can only be set to one of the following:**| Setting Value | Channel | Critical Bug Likelihood (approx) |
|:--------------|:--------|:---------------------------------|
| **v** | (Release/Stable) | 0.5% |
| **b** | (Beta) | 4% |
| **d** | (Development/Revision) | 27% |



## History ##
  * Added in [v5.0.360](https://code.google.com/p/quick-net-fix/source/detail?r=d1970b70b860d0c3bcde6180f69227376a497fec)


[List of Settings](Settings.md)
# Setting: c4uwait #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v5.0.369](https://code.google.com/p/quick-net-fix/source/detail?r=946992cf5cfc5a8bb0400a127f4621243aff53a1) | Current | c4uwait |

Current Prefix: TME


## Description ##
If this <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> is set to check for the availability of newer versions, **c4uwait** is the minimum amount of time that must pass between update checks. There are certain status and stability attributes that determine whether or not the update check is allowed. If it is not currently allowed when the time is reached, it will not check until it is allowed.

  * An update check is performed only if all of the following are true:
    * Setting: check4update is set to 1
    * Last connectivity test result was "Connected"
    * Script is not due to verify router/adapter
    * There was not a connection reset within the last [25](StabilityHistory.md) (BETA: 50) checks
    * It has been at least 10 minutes since the script started and/or 1 day (default) time has passed since the last update check

**This is a TME (TIME) setting, meaning that the value must be time in the following format:**
  * seconds minutes hours days months years

## TME values ##
| Name | Range | Can be omitted |
|:-----|:------|:---------------|
| seconds | 0-59 | No |
| minutes | 0-59 | Yes |
| hours | 0-23 | Yes |
| days | 0-31 | Yes |
| months | 0-11 | Yes |
| years | 0-2000000000 | Yes |

## Examples: ##
| Time | Setting Format |
|:-----|:---------------|
| 10 minutes | 0 10 |
| 2.5 days | 0 0 12 2 |
| 1 year | 0 0 0 0 0 1 |


## History ##
  * Added in [v5.0.369](https://code.google.com/p/quick-net-fix/source/detail?r=946992cf5cfc5a8bb0400a127f4621243aff53a1)


[List of Settings](Settings.md)
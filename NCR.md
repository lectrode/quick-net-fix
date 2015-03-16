# About [Network Connection Resetter](https://code.google.com/p/nwconnectionresetter/) #

Network Connection Resetter (`NCR`) was made in an attempt to automatically detect loss of internet on a network whose routers could not handle the number of people using them. The routers would frequently begin "ignoring" the devices connected to them after a while and the user would need to reset their connection.

The `PING` test was very simplistic and could be inaccurate. Much of the code is inefficient and sluggish. The overall script became bloated and the method it uses to check for and download updates is detected as malware by some anti-virus software.

[quick-net-fix](FAQ_qNET.md) (`qNET`) was created to replace NCR. The primary focus of qNET is ease of use, automation, accuracy, and compatibility.


# Replacing NCR with qNET #
  * qNET primarily uses the [router address](FAQ_RouterAddress.md) to test connectivity. This can be tested much more frequently than a website address, and the test results are not inaccurate due to ISP issues or website downtime. However, if you would like to use a website address you can set [manualRouter](manualRouter.md) to the site address you'd like to use. You can also set it to 'none' (without quotes) to use predetermined website addresses. If you do this, it is recommended that [checkdelay](checkdelay.md) be set to a minute or more to avoid over-frequent `PING` request issues.


## Setting Conversion ##
| <h3>NCR Setting</h3> | <h3>qNET Setting</h3> | <h3>Notes</h3> |
|:---------------------|:----------------------|:---------------|
| `MINUTES` | N/A |  |
| `NETWORK` | [manualAdapter](manualAdapter.md) | Optional in qNET; Automatically determined by default |
| `CONTINUOUS` | N/A | qNET runs until closed |
| `AUTO_RETRY` | N/A |  |
| `AUTOUPDATE` | [check4update](check4update.md) | qNET **checks only**; new version must be downloaded manually |
| `CHECK_DELAY` | [checkdelay](checkdelay.md) | qNET: seconds; NCR: minutes |
| `SHOW_ALL_ALERTS` | N/A |  |
| `SHOW_ADVANCED_TESTING` | N/A |  |
| `SLWMSG` | N/A |  |
| `TIMER_REFRESH_RATE` | N/A |  |
| `START_AT_LOGON` | N/A |  |
| `START_MINIMIZED` | N/A |  |
| `UPDATECHANNEL` | [channel](channel.md) | qNET: v,b,d; NCR: 1,2,3 (qNET does not require SVN for d/3) |
| `CHECKUPDATEFREQ` | [c4uwait](c4uwait.md) | qNET: time; NCR: integer |
| `USELOGGING` | [errorLog](errorLog.md) | qNET: only logs errors; NCR: logs only connection resets |
| `OMIT_USER_INPUT` | [fullAuto](fullAuto.md) | Much improved in qNET (enabled by default in newest revisions) |
| `SKIP_INITIAL_NTWK_TEST` | N/A |  |
| `CUSTOM_NETWORK_NAME` | [manualAdapter](manualAdapter.md) | Optional; Automatically determined by default |
| `USE_IP_RESET` | N/A |  |
| `USE_NETWORK_RESET_FAST` | N/A |  |
| `USE_NETWORK_RESET` | N/A |  |
| `USE_RESET_ROUTE_TABLE` | N/A |  |
| `TREAT_TIMEOUTS_AS_DISCONNECT` | N/A |  |
| `ONLY_ONE_NETWORK_NAME_TEST` | N/A |  |
| `OS_DETECT_OVERRIDE` | N/A |  |
| `NoEcho` | [pretty](pretty.md) | pretty: 0 or 1 |
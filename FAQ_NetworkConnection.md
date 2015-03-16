[<- Back to \*Frequently Asked Questions / Definitions\*](FAQ.md)

# FAQ: What is a Network Connection? #
In this context, a Network Connection is the name of the connection as listed in the Windows control panel:
  * Windows XP / 2003: In _Network Connections_
  * Windows Vista: _Network and Sharing Center_ -> _View network connections_
  * Windows 7 / 2008 / 8 / 2012 / 8.1: _Network and Sharing Center_ -> _Change adapter settings_


## Aliases: ##
  * Network Interface
  * Network Adapter
  * NIC Adapter
  * Adapter
  * Connection
  * NetConnectionID

## Commands to list Network Connections ##
  * **`WMIC NIC GET NETCONNECTIONID`**
    * Lists all Network Connections
    * Can be slow in retrieving information
    * Bugs may cause it to hang indefinitely ([issue 19](https://code.google.com/p/quick-net-fix/issues/detail?id=19))( [issue 23](https://code.google.com/p/quick-net-fix/issues/detail?id=23) )
    * Not available on Windows XP Home ([issue 14](https://code.google.com/p/quick-net-fix/issues/detail?id=14))


  * **`WMIC PATH win32_networkadapter GET NETCONNECTIONID`**
    * (Same as `WMIC NIC GET NETCONNECTIONID`)


  * **`NETSH INTERFACE SHOW INTERFACE`**
    * Does not list MBN adapters
    * May show obsolete data


  * **`NETSH INT IP SHOW INTERFACES`**
    * Not available in some cases
    * Also shows Loopback and Internal Network Connections
    * Lists only _enabled_ Network Connections


  * **`NETSH MBN SHOW INTERFACES`**
    * Shows only MBN (Mobile Broadband) connections


  * **`IPCONFIG |FINDSTR /C:adapter`**
    * Lists only _enabled_ Network Connections
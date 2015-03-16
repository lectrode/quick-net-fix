[<- Back to \*Frequently Asked Questions / Definitions\*](FAQ.md)

# FAQ: What is a Router Address? #
In this context, a Router Address is the address of the gateway by which the computer communicates with the rest of the network. Specifically, it is the IP address of the device that the computer connects to directly.

On here it is referred to as a "Router" because for most people most of the time, this is what the device actually is. However, this is not necessarily the case. The address this script obtains could be to a modem, or a network server, or a proxy, or a few other things. If the script cannot retrieve an address, it will use one of the "fallback" website domain addresses instead. Whatever the case may be, [qNET](FAQ_qNET.md) pings that address to determine your computer's connectivity.



## Aliases: ##
  * Router
  * Gateway
  * Router IP address
  * gateway address


## Commands to show Router Address ##
  * **`IPCONFIG`**
    * Gateway address may be blank if network configuration flawed


  * **`NETSH INTERFACE IP SHOW ADDRESSES`**
    * Not always available
    * Requires admin
    * Does not always show gateway


  * **`NETSH INTERFACE IP SHOW CONFIG`**
    * (Same as `NETSH INTERFACE IP SHOW ADDRESSES`)


  * **`NETSH INTERFACE IP SHOW DNSSERVERS`**
    * (Same as `NETSH INTERFACE IP SHOW ADDRESSES`)
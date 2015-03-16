[<- Back to \*Frequently Asked Questions / Definitions\*](FAQ.md)

# FAQ: What is a "Flaky" Connection? #
A _flaky_ connection is one in which there is a more than usual amount of interference, causing many packets of data to be lost. When packets are lost using TCP protocol (used by default by most applications), the packets are resent. The more often this happens, the more flaky the connection is said to be. The performance of such a connection degrades quite noticeably the more this happens.

A flaky connection can degrade to such a point that the computer has difficulty communicating with the router at all. One of the reasons for this is "flow control" and "congestion control" between the 2 devices. Each device times how long it takes to get a response from the other device. The more packets that are lost, the longer the response time. The longer the response time, the more throttled the connection gets because each device assumes that the other device needs more time to process the data, or that the increased time is due to network congestion. Either way, the TCP protocol limits the amount of data sent within a certain timespan in order to avoid this percieved "congestion" or slow processing time by the remote device.

That is but one of the possible reasons a flaky connection degrades over time. When the connection degrades to the point where the computer only has limited connectivity, that is where [qNET](FAQ_qNET.md) comes into play. When the connection becomes unusable, qNET will reset the connection and flush the DNS cache, allowing the computer to establish a fresh connection to the remote device. The connection will again be usable, until it degrades again.

If you have a problem with an extremely flaky connection, the best way to repair that is by pinpointing what is causing the interference and resolving the problem at it's root. qNET can help, but it cannot fix problems with constant physical interference.

Of course, the connection does not have to be flaky for [qNET](FAQ_qNET.md) to be useful. There are many reasons why a connection might fail, and any time it can be fixed by resetting it, the script can get the connection working again.
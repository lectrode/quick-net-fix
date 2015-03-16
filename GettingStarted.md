# Purpose of this Product #

The main purpose of this product is to provide Windows users a simple yet powerful <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> that will take the hassle out of keeping a relatively steady network connection. For example, if you are experiencing network problems where you are frequently "kicked off" or need to make sure your PC stays connected to the network without having to do anything manually, then this script is perfect for you. Personally, I use it to keep my remote PC connected so I can connect to it when I need to.

When you run this script on your computer, it will attempt to automatically determine your network configuration. After that, it will monitor your connection and keep it alive, resetting the network connection if it detects you have been disconnected.


# How to use #

One of the best things about this script is how easy it is to use. Simply [download](Releases_and_Changelog.md) the script, run it, and it will do everything for you. The latest version can detect a myriad of common network configurations, including Bridged connections.

In the event that this script cannot automatically determine which [network adapter](FAQ_NetworkConnection.md) and/or [router](FAQ_RouterAddress.md) you use, you may set one manually via the [Settings](Settings.md). One such configuration where this is the case is if you use multiple network adapters to connect to the internet; this script won't know which one to monitor. If one is not set manually in the [Settings](Settings.md), the script will give you a list of active connections and let you choose one. It will remember your choice for the rest of the time the script stays running (see [Setting: fullAuto](fullAuto.md) if you wish to avoid all user interaction).

# Feedback #

If you experience any issues, please let me know by going to the [Issues page](https://code.google.com/p/quick-net-fix/issues/list) and creating a new issue. You can also create a new issue to ask a question. Don't be shy; leave a suggestion! :)
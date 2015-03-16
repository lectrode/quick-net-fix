# Setting: StabilityHistory #


## Old/Current Names ##
| Start Version | End Version | Name |
|:--------------|:------------|:-----|
| [v2.5.224](https://code.google.com/p/quick-net-fix/source/detail?r=00d4f71d139995fad5f39669f7e2b42b866aab14) | [v5.0.361](https://code.google.com/p/quick-net-fix/source/detail?r=9a9067be32a3b87b80dc583bc1e553f36a9fcb28) | StabilityHistory |
| [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf) | Current | fluxHist |
Current Prefix: INT


## Description ##
In order for the <a href='http://en.wikipedia.org/wiki/Batch_file' title="If you don't know what this is, just think of it as a Windows program that can be edited with Notepad">batch script</a> to determine the connection stability, it needs to keep track of the last few connectivity tests. **`StabilityHistory`** is the number of recent tests to base the stability rating on. The test results are displayed in the bottom title bar: failed connectivity tests are shown as "**`=`**", a connection reset is shown as "**`*`**". Successful connectivity tests and spacers are shown as "**`-`**".


**The value for this setting must be an**<a href='http://en.wikipedia.org/wiki/Integer' title='A non-negative number that does not contain a decimal'>integer</a> greater than 0.

<br />

NOTE: Only so many test results can be displayed:
  * [Viewmode: normal](viewmode.md) (default) can display up to 50.
  * [Viewmode: mini](viewmode.md) can display up to 35.
  * [Viewmode: details](viewmode.md) (removed in [5.0.356](https://code.google.com/p/quick-net-fix/source/detail?r=bb580c0630e635d72d011a0bbb77fd72758a1c88)) can display up to 78
<br />
NOTE: If **`StabilityHistory`** is set to a value less than the total amount that can be displayed, additional spacers will be used to fill up the display space. For example, if [viewmode](viewmode.md) is 'normal' (50 display spaces) and **`StabilityHistory`** is set to 20, then each test result will be displayed with 1 spacer (**`-`**) preceding it and 10 spacers at the beginning of the bar to fill up all 50 display spaces (((20\*2)+10)=50).
<br />

**NOTE: `StabilityHistory` is renamed to `fluxHist` in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf) and later.**

<br />
## History ##
  * Added in [v2.5.224](https://code.google.com/p/quick-net-fix/source/detail?r=00d4f71d139995fad5f39669f7e2b42b866aab14)
  * Changed default value from '30' to '25' in [v2.6.229](https://code.google.com/p/quick-net-fix/source/detail?r=62e713b8a36b3aac8cef5f98ededf9eb0adac45f)
  * Prefix "STN" changed to "INT" in [v2.6.235](https://code.google.com/p/quick-net-fix/source/detail?r=b1a411be221b1f59f03b67dad9a3b89dfed8921d)
  * Renamed `StabilityHistory` to `fluxHist` in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf)
  * Changed default value from '25' to '50' in [v5.0.362](https://code.google.com/p/quick-net-fix/source/detail?r=b97310f81cad74b973b16ba57fa00e67bc035ddf)


[List of Settings](Settings.md)
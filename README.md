# SIGTRAP
Find the real Swift SIGTRAP line in a release build.

SIGTRAP's in release builds for the App Store could be from multiple lines and the crash log has the wrong one most of the time.  This script will figure out the correct line for you.

```
./sigtrap.sh -x MyApp.xcarchive -l crash.log -u http://some/crash.log
```

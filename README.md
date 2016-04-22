# SIGTRAP
Find the real Swift SIGTRAP line in a release build.

SIGTRAP's in release builds for the App Store could be from multiple lines and the crash log has the wrong one most of the time.  This script will figure out the correct line for you.

```
./sigtrap.sh -x MyApp.xcarchive -l crash.log -u http://some/crash.log
```
Results look like....

```
(lldb) command source -s 0 '/tmp/lldb-cmd-script.ZpQZ6E'
Executing commands in '/tmp/lldb-cmd-script.ZpQZ6E'.
(lldb) target create -d -a arm MyApp-Release.xcarchive/Products/Applications/MyApp.app
Current executable set to 'MyApp-Release.xcarchive/Products/Applications/MyApp.app' (armv7).
(lldb) target modules load -f MyApp __TEXT 0xf4000
section '__TEXT' loaded at 0xf4000
(lldb) image lookup -v -a  0x0049bbec
error: MyApp Can't parse types because an error occurred creating AST context: Can't load debug information from Swift compiler 2.0; expected 2.1

      Address: MyApp[0x003abbec] (MyApp.__TEXT.__text + 3813164)
      Summary: MyApp`function signature specialization <Arg[0] = Owned To Guaranteed, Arg[1] = Owned To Guaranteed, Arg[3] = Owned To Guaranteed, Arg[4] = Owned To Guaranteed, Arg[5] = Owned To Guaranteed and Exploded> of MyApp.SomeClass.foo (MyApp.SomeClass)(MyApp.OtherClass, reuseIdentifier : Swift.String) -> () + 5672 at **MyFile.swift:602**
       Module: file = "/Users/andrewbradnan/MyApp-Release.xcarchive/Products/Applications/MyApp.app/MyApp", arch = "armv7"
  CompileUnit: id = {0x003472f4}, file = "/Users/olssvcxe/_work/15/s/MyApp/SomeClass.swift", language = "Swift"
     Function: id = {0x0034f235}, name = "<unknown>", range = [0x0049a5c4-0x0049c0f4)
       Blocks: id = {0x0034f235}, range = [0x0049a5c4-0x0049c0f4)
               id = {0x0034f307}, ranges = [0x0049a5e8-0x0049a67c)[0x0049a684-0x0049a6a0)[0x0049a6d0-0x0049ad3c)[0x0049ad44-0x0049ad54)[0x0049ad60-0x0049ad68)[0x0049adc0-0x0049b1bc)[0x0049b1c4-0x0049b324)[0x0049b330-0x0049b338)[0x0049b390-0x0049c0f4)
    LineEntry: [0x0049bbd0-0x0049bbf8): /Users/olssvcxe/_work/15/s/MyApp/**SomeClass.swift:602:28**
       Symbol: id = {0x00004741}, range = [0x0049a5c4-0x0049c0f4), name="___lldb_unnamed_function16452$$MyApp"
     Variable: id = {0x0034f2b9}, name = "self", type = <unknown>, location =  r10, decl = CardCell.swift:544
```

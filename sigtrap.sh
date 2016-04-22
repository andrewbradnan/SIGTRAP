#!/bin/bash
if [ "$#" -ne 4 ]; then
    echo "Usage: ./sigtrap -x [your.xcarchive] -l [crash.log] -u [http://crash/url]"
    echo "       one of -l or -u is required"
    exit
fi

# Use > 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use > 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to > 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# > 1 ]]
do
key="$1"

case $key in
    -l|--logfile)
    LOGFILE="$2"
    shift # past argument
    ;;
    -x|--xcarchive)
    ARCHIVE="$2"
    shift # past argument
    ;;
    -u|--urlcrash)
    URL="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

# if no logfile then use URL
if [[ ! $LOGFILE ]]; then
    LOGFILE=$(mktemp /tmp/crashlog.XXXXXX)
    curl -s -o $LOGFILE $URL
fi
trap_location=`egrep -o "lr:\s*(0x\S*)" $LOGFILE | egrep -o "0x\S*"`
machine=`egrep -o "Code Type:\s*.*" $LOGFILE | egrep -o "\S*$"`
base_address=`egrep -A1 "Binary Images:" $LOGFILE | egrep -o "0x\S*" | head -1`
tmpfile=$(mktemp /tmp/lldb-cmd-script.XXXXXX)
if [[ "$machine" = "ARM" ]]; then
    ARCH=arm
else
    ARCH=arm64
fi
PLIST=$ARCHIVE
PLIST+='/Products/Applications/'
APP=`ls $PLIST | egrep -o '[^\.]*.app' | egrep -o '[^\.]*' | head -1`
PLIST+=$APP
FULLAPP=$PLIST
FULLAPP+='.app'
PLIST+='.app/Info.plist'
EXE=`plutil -convert xml1 -o - $PLIST | grep -A1 CFBundleExecutable | egrep -o '<string>\w*' | egrep -o '\w*$'`
LOAD='target create -d -a '
LOAD+=$ARCH
LOAD+=' '
LOAD+=$FULLAPP
echo $LOAD > $tmpfile
echo target modules load -f $APP __TEXT $base_address >> $tmpfile
echo 'image lookup -v -a ' $trap_location >> $tmpfile
echo 'q' >> $tmpfile
xcrun lldb -s $tmpfile
rm $tmpfile
if [[ $URL ]]; then
    rm $LOGFILE
fi
https://github.com/andrewbradnan/SIGTRAP
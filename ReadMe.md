# Speed-test.bat

A batch file that copies 600mb of tiny files and a single 500mb large file from/to various locations and capture statistics in order measure performance.

There are 3 basic tests, consisting of: copy the set and record how long the operation took and the average transfer rate.

1. **little files** - tens of thousands of tiny files

2. **differential little** - delete a substantial portion of the little files (200mb) in a distributed pattern (from all over the place, not just one or two folders), compare source and target folders, then copy only those files which are missing.

3. **big file** - copy a single large file


Developed and tested on Windows XP & 7 Pro, 64bit, with command extensions enabled. Two additional programs are used: xxcopy (required) and grep (optional, used for reporting).

This test suite may be freely modified and shared. Please don't use the data (`.\source`) for anything other than benchmarking (there's much better stuff available for free).

Primary web page: https://github.com/maphew/Speed-test
Secondary (may not be as up to date): http://goo.gl/skKdq5

(c) Copyright 2014 Environment Yukon
License: MIT/X (open source)
Author:  Matt.Wilkie@gov.yk.ca

# Setup

1. From [home page](https://github.com/maphew/Speed-test) *Download Zip* (right hand navigation menu, ~5mb) and unpack somewhere, e.g. `D:\speed-test`

2. Download copy-test-files.zip (800mb) from http://goo.gl/5gyfrP, unpack to `d:\speed-test\source`


# Usage

Open a command shell and run speed-test:

    speed-test go local2local %temp%

## Usage explained
Copy the speed-test folder and all contents to the machine/device you want to use for your source (copy-from place).

Unpack the copy-test-files.zip archive to the place you want to read from (default is adjacent to the batch file, `speed-test\source\`) 

Open a command shell in there and run the batch file (repeat at least twice more to get an average).

    speed-test go [type] [destination path] {source path} {statistics folder}

**[type]** required. A short label description of the test being done, e.g. *local2local*, *localssd2server*, *server2NAS* for local device to local device, local SSD drive to a server, and from a server to Network Attached Storage device respectively.

**[destination path]** required. The target, a `speed-test-scratch` sub-folder will be created here and the test files copied into it. It is not removed when done.

**{source path}** optional. The folder where the test files will be copied from. If unspecified it defaults to `%location of speed-test.bat%\source`

**{statistics path}** optional. The folder where log files of the copy operation will be saved. If unspecified it defaults to `%location of speed-test.bat%\source`
 

## Examples 

From local machine to a server share:

    pushd d:\speed-test
    speed-test go local2server \\server2\testing_share

From one server to another:

    pushd \\server2\testing_share\speed-test
    speed-test go server2server \\server3\testing_share

From read-only local optical disc to local usb device, storing logs & stats on a server:

    pushd e:\speed-test
    speed-test go dvd2usb3stick f:\temp ^
    e:\speed-test\source ^
    \\server2\testing_share\speed-test\stats

Run with incomplete parameters for some additional usage info.

# File and Folder structure

## `.\source` - files used for copy tests

If you got speed-test from GitHub, you'll still need to fetch the [copy-test-files.zip](https://drive.google.com/folderview?id=0B56GxmszgM49RVJ5TFlVUFR1aVk&usp=sharing) (800mb) and unpack somewhere (suggested is adjacent to speed-test.bat in `.\source`).


**little_files**: a whack load of itty bitty files: 24,344 totalling 641,411,602 bytes, most less than 1kb each.

**big_files**: a single 527,331,269 byte zip archive

For the curious, these are Geographic Information Systems data (ArcInfo coverages) and a satellite raster image. Just use them for benchmarking, there are much improved data of the same available free and gratis from http://geobase.ca/.


## `.\stats` - Logfiles and statistics

Scripts for parsing the logfiles into usable statistics, plus some logs and statistics from my own machine for reference.

The `stats` parameter needs to point to a writeable location, if unspecified the default is `\path\to\speed-test.bat\stats`, and are cumulative (log files are appended).


## `.\bin` - Required binaries

Provided in `.\bin` for convenience. See the respective authors' web sites for latest and/or specific version required for your machine.

### [xxcopy](www.xxcopy.com)

A better than xcopy and robocopy commandline copy program. Chosen for this project chiefly for it's ability to smartly copy only files which are missing or changed, to provide statistics of the operation, and because we've been using it in house for years.

As distributed here, it's set for 64bit. If you're on 32bit Windows simply copy the contents  of `bin\xxcopy_32bit` to `bin\`, overwriting all. (After which the xxcopy_* subfolders can be freely deleted).





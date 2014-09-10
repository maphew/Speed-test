#-------------------------------------------------------------------------------
# Name:        parse_xxcopy_logfile
# Purpose:
#
# Author:      Matt Wilkie
#
# Created:     09/09/2014
# Copyright:   (c) Environment Yukon 2014
# Licence:     X/MIT
#-------------------------------------------------------------------------------
#!/usr/bin/env python
import csv
import sys

def main():
    f = open(r"b:\github\Speed-test\stats\GEOMATT\server2drobo_diff-little_files.log")
    for line in f.readlines():

        # Extract xxcopy & windows version numbers, date & time from:
        #
        #   XXCOPY ver 2.97.5   2008-10-22 09:12:22   Windows Ver 5.2.3790 Service Pack 2
        #

        if line[0:6] == "XXCOPY":
            d = {}
            discard, xxcv_date_time, winver = line.lower().split("ver")
            xxcv, run_date, run_time, discard = xxver_date_time.split()
            d["xxcopy version"] = xxcv
            d["date"] = run_date
            d["time"] = run_time

        if " = " in line:
            field, value = line.split(" = ")
            d[field.strip()] = value.strip()

    if 'd' in locals():
            print(d)

if __name__ == '__main__':
    main()

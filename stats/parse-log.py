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

d = {}
def main():
    f = open(r"b:\github\Speed-test\stats\GEOMATT\server2drobo_diff-little_files.log")
    for line in f.readlines():
        """ Extract xxcopy & windows version numbers, date & time from:

            XXCOPY ver 2.97.5   2008-10-22 09:12:22   Windows Ver 5.2.3790 Service Pack 2
        """
##        d = {}
        # line of ===... marks new log entry, so start new dict
        if line[0:6] == "======":
            d['end_of_record'] = False

        if line[0:6] == "XXCOPY":
            discard, xxcv_date_time, winver = line.lower().split("ver")
            xxcv, run_date, run_time, discard = xxcv_date_time.split()
            d["xxcopy version"] = xxcv
            d["date"] = run_date
            d["time"] = run_time
##            d["windows version"] = winver
##            print(line)
##            print(d)

        if " = " in line:
            field, value = line.split(" = ")
            d[field.strip()] = value.strip()

        print (d.keys())
        if 'Exit code' in d:
            d['end_of_record'] = True
            write_csv(d)
##                print(d)

def recordsFromFile(inputFile):
    """ http://stackoverflow.com/questions/8131197/efficiently-parsing-a-large-text-file-in-python """
    record = ''
##    terminator = '=' * 20
    terminator = '' #
    for line in inputFile:
        if line.startswith('=') and record.endswith(terminator):
            yield record
            record = ''
        record += line
    yield record


def write_csv(d):
##    f = open(sys.argv[1], 'wt')
    # Adapted from http://pymotw.com/2/csv/
    testfile = r'b:\github\Speed-test\stats\from-py.csv'
    f = open(testfile, 'w')
    try:
        fieldnames = sorted(d.keys())
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        headers = dict( (n,n) for n in fieldnames )
        writer.writerow(headers)
        for i in range(10):
            writer.writerow(d)
    finally:
        f.close()

##    print (open(testfile, 'rt').read())
##    print open(sys.argv[1], 'rt').read()

if __name__ == '__main__':
##    main()
    inputFile = open(r"b:\github\Speed-test\stats\GEOMATT\server2drobo_diff-little_files.log")
    for record in recordsFromFile(inputFile):
        for line in (record.splitlines()):
            if line[0:6] == "XXCOPY":
                print(line)

        # Do stuff

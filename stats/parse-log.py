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
import re
import sys
import os

def prune_lines(infile):
    """ Discard all lines which don't have the data we're after
        Adapted from http://stackoverflow.com/questions/17131353/problems-targeting-carriage-return-and-newlines-with-regex-in-python
    """
    result = []
    with open(infile, 'r') as text:
        lines = text.readlines()
    text.close()

    for line in lines:
        line = line.strip() # trim leading and trailing whitespace
        # skip lines that don't contain "===", "XXCOPY" or " = "
        if re.match('===*', line):
            result.append(line)
        elif re.match('^XXCOPY', line):
            result.append(line)
        elif re.match('^.+? = ', line):
            result.append(line)
    return result

def parse_xxcopy_line(line, d):
    """ Extract xxcopy & windows version numbers, date & time from:

        XXCOPY ver 2.97.5   2008-10-22 09:12:22   Windows Ver 5.2.3790 Service Pack 2
    """
    discard, xxcv_date_time, winver = line.lower().split("ver")
    xxcv, run_date, run_time, discard = xxcv_date_time.split()
    d["xxcopy version"] = xxcv
    d["date"] = run_date
    d["time"] = run_time
    d["windows version"] = winver
    return d

def parse_field(line, d):
    """ Extract regular field & value from:

            Destination directory = "R:\speed-test\big_files\"
            Directories processed = 1
            Total data in bytes   = 527,331,269
            ...
    """
    if " = " in line:
        field, value = line.split(" = ")
        d[field.strip()] = value.strip()
    return d

def write_csv(dic, csvfile):
    """ Append a dictionary to a CSV file.

        In it's current state this duplicates header rows. Probable solution is
        to read the existing csv first, append new data, then write all at once.

        Adapted from http://pymotw.com/2/csv/
    """

    f = open(csvfile, 'ab')
##    print("in csv writer DIC (local) %s" % dic['time'])
##    print("in csv writer D (global) %s" % d['time'])
    try:
        fieldnames = sorted(dic.keys())
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        headers = dict( (n,n) for n in fieldnames )
        writer.writerow(headers)
        writer.writerow(dic)
    finally:
        f.close()

def main(pruned_text):
    """ Parse text list containing only data elements into field,value pairs,
        then write out to csv.
    """
    d = {}
    for line in pruned_text:
        if line.startswith('==='):
            # when dict is not empty, we've already looped at least once
            # so write out results from previous run before carrying on
            if d:
                print(d['time'])
                write_csv(d, csvfile)
                d = {} # ensure no old data is carried forward

        elif line[0:6] == 'XXCOPY':
            parse_xxcopy_line(line, d)
            print (line)

        elif line:
            parse_field(line, d)

    # ...and now write out results from the hindmost loop run
    if d:
        print(d['time'],d['Exit code'])
        write_csv(d, csvfile)

if __name__ == '__main__':
    infile = sys.argv[1]
    csvfile = os.path.join(infile + '.csv')
    print(csvfile)

##    infile = r"D:\speed-test\stats\ENV-Y209103\local2NAS-local-user-raid10_diff-little_files.log"
##    csvfile = r'b:\github\Speed-test\stats\from-py.csv'
    text = prune_lines(infile)
    result = main(text)
    print(result)


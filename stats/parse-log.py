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
import fileinput

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

def write_csv(dic, csvfile, out_csvfile):
    """ Append a dictionary to a CSV file.

        Adapted from http://pymotw.com/2/csv/
    """

    # create dummy file if old csv not present
    if not os.path.exists(csvfile):
        open(csvfile, 'a').close()

    f_old = open(csvfile, 'rb')
    csv_old = csv.DictReader(f_old)

    csv_old_fieldnames = ['']
    if csv_old.fieldnames:
        csv_old_fieldnames = csv_old.fieldnames


##    fpath, fname = os.path.split(csvfile)
##    csvfile_new = os.path.join(fpath, 'new_' + fname )
##    print(csvfile_new)
    f = open(out_csvfile, 'ab')
##    print("in csv writer DIC (local) %s" % dic['time'])
##    print("in csv writer D (global) %s" % d['time'])
    try:
        fieldnames = sorted(set(dic.keys() + csv_old_fieldnames))
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        headers = dict( (n,n) for n in fieldnames )
        writer.writerow(headers)
        for row in csv_old:
            writer.writerow(row)
        writer.writerow(dic)
    finally:
        f_old.close()
        f.close()
    return

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
                write_csv(d, csvfile, out_csvfile)
                d = {} # ensure no old data is carried forward

        elif line[0:6] == 'XXCOPY':
            parse_xxcopy_line(line, d)
            print (line)

        elif line:
            parse_field(line, d)

    # ...and now write out results from the hindmost loop run
    if d:
        print(d['time'],d['Exit code'])
        write_csv(d, csvfile, out_csvfile)

def remove_dupes(a_file):
    """ Remove duplicate rows from a file
        from http://stackoverflow.com/questions/15741564/removing-duplicate-rows-from-a-csv-file-using-a-python-script
    """
    seen = set()
    for line in fileinput.FileInput(a_file, inplace=1):
        if line in seen:
            continue
        seen.add(line)
        print line,

if __name__ == '__main__':
    infile = sys.argv[1]
    csvfile = os.path.join(infile + '.csv')
    out_csvfile = sys.argv[2]
##    out_csvfile = os.path.join(infile + '.tmp.csv')
##    infile = r"D:\speed-test\stats\ENV-Y209103\local2NAS-local-user-raid10_diff-little_files.log"
##    csvfile = r'b:\github\Speed-test\stats\from-py.csv'
##    out_csvfile = r'b:\github\Speed-test\stats\from-py_out.csv'
    print(csvfile, out_csvfile)

    text = prune_lines(infile)
    main(text)
    remove_dupes(out_csvfile)


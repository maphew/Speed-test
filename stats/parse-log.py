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
import re

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

def recordsFromFile(inputFile):
    """
    For us, a record is everthing between the line beginning with '=' and ends
    with a closing brance and blank line.

    <<<record begins:

        ===============================================================================
        ...snip...
         Exit code             = 0 (No error, Successful operation)

    /record ends>>>

    It would be more robust to match " Exit code ... )\r\n". Perhaps a later
    enhancement.

    http://stackoverflow.com/questions/8131197/efficiently-parsing-a-large-text-file-in-python
    """
    record = ''
##    terminator = '=' * 20
    terminator = '\r\n\r\n' # with "\rn\r\n\" this is broken, it doesn't match :(
    for line in inputFile:
        if line.startswith('===') and record.endswith(terminator):
            yield record
            record = ''
        record += line
    yield record

def records_with_regex(infile):
    """ Attempt to use regular expressions to parse the records from the log """
    f = open(infile, 'r')
    text = f.read()
    f.close()

    regex = re.compile('''
        ===*     # many equals
        (.+?)    # everything, without being greedy
        \n\n     # 2 newlines in a row
    ''', re.MULTILINE)

    regex = re.compile('(===*)(.+?)\n\n', re.DOTALL)

    matches = [m.groups() for m in regex.finditer(text)]
    for m in matches:
        print(m)

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
    # Adapted from http://pymotw.com/2/csv/
    f = open(csvfile, 'w')
    print("in csv writer DIC %s" % dic['time'])
    print("in csv writer D %s" % d['time'])
    try:
        fieldnames = sorted(dic.keys())
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        headers = dict( (n,n) for n in fieldnames )
        writer.writerow(headers)
        writer.writerow(dic)
    finally:
        f.close()

def main():
##    main()
##    inputFile = open(r"b:\github\Speed-test\stats\GEOMATT\server2drobo_diff-little_files.log")
    inputFile = open(r"D:\speed-test\stats\ENV-Y209103\local2NAS-local-user-raid10_diff-little_files.log")
    csvfile = r'b:\github\Speed-test\stats\from-py.csv'
    for record in recordsFromFile(inputFile):
        print("\n***********************************\n %s" % record)
        d = {} # new dict for each record
        for line in (record.splitlines()):
            if line[0:6] == "XXCOPY":
                print(line)
                parse_xxcopy_line(line,d)
##                print(d['time'])
            elif " = " in line:
##                print(line)
                parse_field(line,d)
##            print(d['time'])
        write_csv(d, csvfile)
        print(d.keys())
        print(d['time'])


if __name__ == '__main__':

    infile = r"D:\speed-test\stats\ENV-Y209103\local2NAS-local-user-raid10_diff-little_files.log"
##    records_with_regex(infile)
    text = prune_lines(infile)
##    print(text)
    d = {}
    for line in text:
        if line.startswith('==='):
            if d:
                print(d['time'])
##            print(line)
            pass
        elif line[0:6] == 'XXCOPY':
            parse_xxcopy_line(line, d)
##            print (line)
        elif line:
            parse_field(line, d)
##            print(line)

##    print(d)

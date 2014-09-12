# parse-log.py

A python script to parse statistics from [xxcopy](http://www.xxcopy.com) logfiles and write them to a .csv file.


## Usage

### Simple

    python parse-log.py infile.log outfile.csv

### Append multiple logs

From a Windows command shell, parse all the logfiles matching a pattern in `env-geomatt` folder and write to `ENV-geomatt.csv`  


    for /r %a in (env-geomatt\*straight*.log) do ^
    python parse-log.py "%a" ENV-geomatt_straight.csv"

Parse-log is not smart about checking for matched column names etc. when appending multiple logs to one csv.  It's up to you to feed it logs of the same type of xxcopy run. So for example attempting to parse a log which includes file deletions ("Zap") as a result of _xxcopy /clone_ with one that doesn't, the csv rows and columns will be mismatched.  

The field names (columns) are anything that appears to the left of a single space delimited ` = ` in the log file:

    Destination directory = "R:\speed-test\big_files\"
    Directories processed = 1
    Total data in bytes   = 527,331,269 

becomes

    Destination directory,Directories Processed,Total Data in Bytes
    R:\speed-test\big_files\,1,"527,331,269"

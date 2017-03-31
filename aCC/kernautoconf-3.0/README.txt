NEWS:

A real homepage is in:
http://cateee.net/lkddb/

----


How to use:


1- building the datase:
----------------------

Optional: you can use prebuild database: "drivers-db"

require python and the scripts:
build-drivers-db.py devicetables.py kbuildparser.py srcparser.py

Run the progam with first argument the kernel top dir.
Optionally you can give limit the directory (and subdirs) to parse
(relative to top dir).  Default: parse all kernel

$ ./build-drivers-db.py /home/cate/kernel/6,v2.6/linux-2.6/

This command will put a lot of trash on terminal: warning about
unimplemented checks, and debug information.

in "drivers-db" you will get the driver list

$ cat drivers-db | grep -v '^#' | sort -u | wc -l

this is my "quality check.
In nearly 2 minutes (warm cache, intermediate machine) it will
discover 6000 checks.


2- hardware detection
---------------------

this is a simple shell script

Simple method:

$ ./kdetect.sh | grep -v "^#' | sort -u > detected.list

remove the pipes for debugging.

this shell command will put in "detected.list"
the hardware detection.


3- putting together driver db and hardware list:
-----------------------------------------------

An other small slow shell script:

$ ./kernautoconf.sh

this script will execute 6000 times grep on "detected.list",
executing "drivers-db" as sources shell.

The output is in config.out

WARNING: the output is not to feed in kernel configuration:
it should be verified.




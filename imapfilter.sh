#!/bin/sh
## this filter assumes the first input is the password needed.
## imapfiler.sh <password>

cd /imapfilter/.imapfilter

trap "exit" INT
while :
do
 echo Start filtering at `date`
 imapfilter <<EOF
$1
EOF
done


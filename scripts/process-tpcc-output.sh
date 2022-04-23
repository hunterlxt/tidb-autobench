#!/bin/bash
set -eu

ver=${1}

echo "${ver}-200"
out=`cat ${ver}-200.log | grep "\[Summary\]\ NEW_ORDER\ "`
echo "${out}" | awk '{print $9}'
echo "${out}" | awk '{print $21}'

echo "${ver}-100"
out=`cat ${ver}-100.log | grep "\[Summary\]\ NEW_ORDER\ "`
echo "${out}" | awk '{print $9}'
echo "${out}" | awk '{print $21}'

echo "${ver}-60"
out=`cat ${ver}-60.log | grep "\[Summary\]\ NEW_ORDER\ "`
echo "${out}" | awk '{print $9}'
echo "${out}" | awk '{print $21}'

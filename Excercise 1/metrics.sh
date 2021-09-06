#!/bin/bash
echo "Host Info:"
uname -a

echo -----
echo

echo Disk Usage:
df -H

echo -----
echo

echo Top 5 CPU Memory consuming processes:
top -b -o +%MEM | head -n 20 | tail -5

echo -----
echo

echo Network Usage:
ifconfig eth0

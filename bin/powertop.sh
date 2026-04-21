#!/bin/bash

TMP=powertop_report.html.tmp
sudo powertop --html=$TMP
cat $TMP | wl-copy
rm -f $TMP


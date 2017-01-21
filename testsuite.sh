#!/bin/bash

# the testsuite script runs program on each test in the test suite (as specified by suite-file) 
# and reports on any tests whose output does not match the expected output
# invoked as:  ./testsuite suite-file program
# for example suite-file contains: test1 test2 test3
# the first one (test1) will use the file test1.in to hold its input, an optional file test1.args to store command line args
# and test1.out to store its expected output.
if [ $# -ne 2 ]; then
  echo "incorrect number of command line arguments" >&2
  exit 1
fi

for file in $(cat "$1"); do
  if [ ! -r ${file}.in ] || [ ! -r ${file}.out ]; then
    echo "missing or unreadable .in or .out files" >&2
    exit 1
  fi
  temp=$(mktemp)
  if [ -r ${file}.args ]; then
    ./$2 $(cat ${file}.args) < ${file}.in > ${temp}
  else
    ./$2 < ${file}.in > ${temp}
  fi
  diff ${file}.out ${temp} > /dev/null
  if [ $? -ne 0 ]; then
     echo "Test failed: ${file}"
     echo "Input:"
     echo "$(cat "${file}.in")"
     echo "Expected:"

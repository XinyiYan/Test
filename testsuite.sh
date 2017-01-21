#!/bin/bash
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

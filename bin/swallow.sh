#!/bin/bash

bin_path=$(dirname $0)
tmp_path=$(dirname $0)/../tmp
test_path=$(dirname $0)/../test

if [ "$#" -eq 0 ]; then
  echo $bin_path
else
  case $1 in
    run)
      ruby $bin_path/swallow.rb
      ;;
    show)
      cp $tmp_path/output.json $test_path
      cd $test_path
      ruby timetable.rb
      firefox index.html
      ;;
    *)
      echo $bin_path
      echo $tmp_path
      ;;
  esac
fi

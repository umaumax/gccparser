#!/bin/sh
true + /; exec gawk -f "$0"; exit; / {}

BEGIN {
  dirpath="."
}

match($0, /^make.* Entering directory '(.*)'.*$/, m) {
  dirpath=m[1]
  printf "dirpath:%s\n", dirpath
}

match($0, /^([^:]*):([0-9]+):[0-9]+: note: .*previous.*here/, m) {
  filepath=m[1]
  line_num=m[2]
  printf "filepath:%s\n", filepath
  printf "line_num:%s\n", line_num
}

#!/usr/bin/env bash

function cmdcheck() { type >/dev/null 2>&1 "$@"; }
! cmdcheck 'ctags' && echo "'ctags' is required" && exit 1

# WARN: don't use regex of sed
MAGIC_WORD=${MAGIC_WORD:-'NFHAAANTYOEAH_TA_E'}
function comment_out() {
	[[ $# -lt 2 ]] && echo "$0 [filepath] [func_start_line]" && return 1
	filepath=$1
	func_start_line=$2
	func_end_line=$(ctags -x --c-types=f $filepath | sed -E 's/ (\W+)( *function)/\1 \2/' | sort -k 3 | sed -E 's/ +function +([0-9]+).*$/$\1/' | awk -F'$' -v line=$func_start_line 'next_func_line==0&&line<int($2){next_func_line=$2;} END{if(next_func_line!=0) printf "%d", next_func_line;}')
	[[ -x $func_end_line ]] && return 1

	cat $filepath | sed -e "$func_start_line,$(($func_end_line - 1)) s:^:// $MAGIC_WORD :"
}

comment_out $1 $2

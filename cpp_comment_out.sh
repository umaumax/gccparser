#!/usr/bin/env bash

function cmdcheck() { type >/dev/null 2>&1 "$@"; }
! cmdcheck 'ctags' && echo "'ctags' is required" && exit 1

# WARN: don't use regex of sed
MAGIC_WORD=${MAGIC_WORD:-'NFHAAANTYOEAH_TA_E'}
function comment_out() {
	filepath=$1
	func_start_line=$2
	[[ ! -f $filepath ]] && echo 1>&2 "no such file '$filepath'" && return 1

	func_end_line=$(ctags -x --c-types=f --c-kinds=+p $filepath | sed -E 's/ (\W+)( *function| *prototype)/\1 function_or_protorype/' | sort -k 3 | sed -E 's/ +function_or_protorype +([0-9]+).*$/$\1/' | awk -F'$' -v line=$func_start_line 'next_func_line==0&&line<int($2){next_func_line=$2;} END{if(next_func_line!=0) printf "%d", next_func_line;}')
	[[ -z $func_end_line ]] && echo "Not found function end line" && return 1

	# NOTE: sedで多重置換が行われないようにMAGIC_WORDごと置換している
	tmp_output=$(cat $filepath | sed -E "$func_start_line,$(($func_end_line - 1)) s:^// $MAGIC_WORD |^:// $MAGIC_WORD :")
	local exit_code=$?
	# NOTE: sed exit code
	if [[ $exit_code == 0 ]]; then
		if [[ $replace_flag == 1 ]]; then
			echo "REPLACE: [$filepath]"
			echo "$tmp_output" >$filepath
			return
		fi
	else
		echo "[FAIL]"
	fi
	echo "$tmp_output"
}

replace_flag=0
[[ $1 == '-i' ]] && replace_flag=1 && shift
[[ $# -lt 2 ]] && echo "$0 [filepath] [func_start_line]" && return 1

comment_out $1 $2

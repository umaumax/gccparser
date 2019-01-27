#!/usr/bin/env bash

BLACK="\033[0;30m" RED="\033[0;31m" GREEN="\033[0;32m" YELLOW="\033[0;33m" BLUE="\033[0;34m" PURPLE="\033[0;35m" LIGHT_BLUE="\033[0;36m" WHITE="\033[0;37m" GRAY="\033[0;39m" DEFAULT="\033[0m"
function echo() { command echo -e "$@"; }

function cmdcheck() { type >/dev/null 2>&1 "$@"; }
! cmdcheck 'ctags' && echo "'ctags' is required" && exit 1

# WARN: don't use regex of sed
MAGIC_WORD=${MAGIC_WORD:-'NFHAAANTYOEAH_TA_E'}
function comment_out() {
	local filepath=$1
	local func_start_line=$2
	[[ ! -f $filepath ]] && echo 1>&2 "no such file '$filepath'" && return 1

	if [[ -n $USE_CTAG ]]; then
		local func_end_line=$(ctags -x --c-types=f --c-kinds=+p $filepath | sed -E 's/ (\W+)( *function| *prototype)/\1 function_or_protorype/' | sort -k 3 | sed -E 's/ +function_or_protorype +([0-9]+).*$/$\1/' | awk -F'$' -v line=$func_start_line 'next_func_line==0&&line<int($2){next_func_line=$2;} END{if(next_func_line!=0) printf "%d", next_func_line;}')
		[[ -z $func_end_line ]] && echo "Not found function end line" && return 1
		local func_end_line=$(($func_end_line - 1))
	else
		local func_range=$(./cpp_func_def.py -l $func_start_line $filepath)
		[[ -z $func_range ]] && echo "Not found function range" && return 1
		local func_start_line=$(echo $func_range | awk '{print $1}')
		local func_end_line=$(echo $func_range | awk '{print $2}')
	fi

	# NOTE: sedで多重置換が行われないようにMAGIC_WORDごと置換している
	local tmp_output=$(cat $filepath | sed -E "$func_start_line,$func_end_line s:^// $MAGIC_WORD |^:// $MAGIC_WORD :")
	local exit_code=$?
	# NOTE: sed exit code
	if [[ $exit_code == 0 ]]; then
		if [[ $replace_flag == 1 ]]; then
			echo "${GREEN}[REPLACE]${DEFAULT}: [$filepath]" 1>&2
			command echo "$tmp_output" >$filepath
			return
		fi
	else
		echo "${RED}[FAIL]${DEFAULT}: [$filepath]" 1>&2
	fi
	echo "$tmp_output"
}

replace_flag=0
[[ $1 == '-i' ]] && replace_flag=1 && shift
[[ $# -lt 2 ]] && echo "$0 [filepath] [func_start_line]" && exit 1

[[ -z $USE_CTAG ]] && [[ $(uname) == "Darwin" ]] && export LD_LIBRARY_PATH="/usr/local/opt/llvm/lib:$LD_LIBRARY_PATH"

comment_out $1 $2

#!/usr/bin/env bash

BLACK="\033[0;30m" RED="\033[0;31m" GREEN="\033[0;32m" YELLOW="\033[0;33m" BLUE="\033[0;34m" PURPLE="\033[0;35m" LIGHT_BLUE="\033[0;36m" WHITE="\033[0;37m" GRAY="\033[0;39m" DEFAULT="\033[0m"
function echo() { command echo -e "$@"; }

shopt -s expand_aliases
[[ $(uname) == "Darwin" ]] && alias sed=gsed

function conv() {
	local input_filepath=$1
	local output_filepath="output.cpp"
	local result_filepath="result.cpp"

	cp $input_filepath $result_filepath

	# NOTE: \b not include ' '
	sed -i -E 's/\bdouble\b/float/g' $result_filepath
	sed -i -E '/\/\//!s/(\b| )([0-9]*\.[0-9]+)((\b|e[-+]?[0-9]+)f?|f?|lf)/\1\2\4f/g' $result_filepath
	sed -i -E '/\/\//!s/(\b| )([0-9]+\.[0-9]*)((\b|e[-+]?[0-9]+)f?|f?|lf)/\1\2\4f/g' $result_filepath
	sed -i -E 's/%lf/%f/g' $result_filepath

	icdiff $output_filepath $result_filepath
	if [[ $? != 0 ]]; then
		echo "${RED}[TEST FAILED]${DEFAULT}"
		cat $input_filepath
		return 1
	else
		echo "${GREEN}[TEST SUCCESS]${DEFAULT}"
		rm $result_filepath
		return 0
	fi
}

conv input.cpp

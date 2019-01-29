#!/usr/bin/env bash

shopt -s expand_aliases
[[ $(uname) == "Darwin" ]] && alias sed=gsed

function conv() {
	local input_filepath=$1
	local output_filepath="output.cpp"
	local result_filepath="result.cpp"

	cp $input_filepath $result_filepath

	# NOTE: \b not include ' '
	sed -i -E 's/\bdouble\b/float/g' $result_filepath
	sed -i -E 's/(\b| )([0-9]*\.[0-9]+)((\b|e[-+][0-9]+)|f?|lf)/\1\2\4f/g' $result_filepath
	sed -i -E 's/(\b| )([0-9]+\.[0-9]*)((\b|e[-+][0-9]+)|f?|lf)/\1\2\4f/g' $result_filepath
	sed -i -E 's/%lf/%f/g' $result_filepath

	icdiff $output_filepath $result_filepath
	[[ $? != 0 ]] && cat $input_filepath
}

conv input.cpp

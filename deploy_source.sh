#!/bin/bash
source ensure_variables.sh

mkdir -p $output 2>/dev/null

cd $boost_path

# Run bcp for every library and install libraries sources and headers only
readarray libs < $install_lib
if [ "$verbose" = true ]; then
	echo -e "${libs[*]/#/\\t}"
fi

>&2 echo "Deploying! Please wait..."
$bcp ${libs[@]} $output &>/dev/null 

cd ->/dev/null
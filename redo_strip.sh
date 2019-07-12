#!/bin/bash
source ensure_variables.sh

cd $boost_path

# Revert some changes made in boost folder at strip_libs.sh
if [ -d "${library}.original" ]; then
	>&2 echo "Redo stripped libraries"
	rm -rf $library
	mv $library.original $library
fi

cd ->/dev/null

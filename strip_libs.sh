#!/bin/bash
source ensure_variables.sh

cd $boost_path

if [ ! -d "${library}.original" ]; then
	if [ ! -d "${library}" ]; then (>&2 echo "$library not found"); exit; fi
	>&2 echo "Stripping libraries"

	mv $library $library.original
	# Copy sources on the second level
	for f in $( find ${library}.original -maxdepth 2 -type d -path '*/src' -printf "%P\n" );
	do
		mkdir -p "${library}/${f}"
		cp -r "${library}.original/${f}" "${library}/${f}/.."
	done
	# Same copy, different (and slower) approach
	#cd $library.original
	#find . -maxdepth 2 -type d -path '*/src' -exec mkdir -p ../$library/{} \; -exec cp -r {} ../$library/{}/.. \;
	#cd -
fi

cd ->/dev/null
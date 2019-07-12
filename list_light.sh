#!/bin/bash
source ensure_variables.sh

missing_libraries="${temp}/00_missing_libraries.txt"
header_only_libraries="${list_out}/01_header_only_libraries.txt"
other_dependency="${list_out}/02_other_dependency_libraries.txt"
own_dependency="${list_out}/03_own_dependency_libraries.txt"
with_dependency_libraries="${list_out}/04_with_dependency_libraries.txt"
all_libraries="${list_out}/05_all_libraries.txt"

# Disable error display (Boost issue, don't care here + rm/mkdir)
exec 2>/dev/null

if [ "$clear" = true ]; then
	# Remove previous lists (if any)
	rm $all_libraries $header_only_libraries $with_dependency_libraries $own_dependency $other_dependency $missing_libraries
	readarray libs < $listing_lib
else
	# continue execution...
	readarray libs < <(grep -v $'\t' $all_libraries | grep -vxf- $listing_lib)
fi
mkdir -p "${list_out}"

# Run bcp for every library and dump libraries with sources and header only libraries
if [ "$verbose" = true ]; then
	echo -e "${libs[*]/#/\\t}"
fi

cd $boost_path

for i in "${libs[@]}"
do
    echo -n "$bcp --list-short $i"
	# Calculate dependencies + filter for important lines
	bcp_output=`$bcp --list-short $i`
	readarray result < <(echo "${bcp_output[*]}" | grep -E "dependencies of library|$library/")
    echo $i >> $all_libraries
	if [ "$verbose" = true ]; then
		echo -ne "${result[*]/#/\\t}"
	fi

    if [ -n "$result" ]; then
		# Dump dependencies and infos
        echo -ne "${result[*]/#/\\t}" >> $all_libraries
		echo $i >> $with_dependency_libraries

		# Separate: Has own libary or not
		if $(echo -ne "${result[*]}" | grep -qEm1 $library/$i); then
			echo $i >> $own_dependency
		else
			echo $i >> $other_dependency
		fi
    else
		# Is missing
		if [ -z "$bcp_output" ]; then
			echo $i >> $missing_libraries
			echo -e "\tLibrary missing" | tee -a $all_libraries $missing_libraries
		else
			echo $i >> $header_only_libraries
		fi
    fi
done
echo

cd ->/dev/null
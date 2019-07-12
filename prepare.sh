#!/bin/bash
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <version: 1.70.0> [-c] [-v]"
  exit 1
fi

boost_version="$1"
shift

# export marking the variables which used by another scripts
export boost_path="$(echo "boost_${boost_version}" | sed 's/\./_/g')"
export output="$(pwd)/output"
export temp="${output}/temp"

if [ "$1" = "-c" ]; then
	export clear=true
	rm -rf $output
	shift
else
	export clear=false
fi

boost_link="https://dl.bintray.com/boostorg/release/${boost_version}/source/${boost_path}.tar.gz"
mkdir -p $temp 2>/dev/null
if [ ! -f "${temp}/to_README.md" ]; then
	# Download json to temp
	(
		echo "# Boost ${boost_version}"
		echo -n "Boost package information **"
		echo -n ${boost_path} | sed 's/_/\\_/g'
		echo ".tar.gz.json** used for this update:"
		echo
		echo \`\`\`json
		wget -qO- "${boost_link}.json"
		echo
		echo \`\`\`
	)> $temp/to_README.md
fi

# Check boost
if [ ! -d "$boost_path" ]; then
	echo -e "$boost_path not found! \nDo you wish to download/unzip it?"
	select answer in "Download" "Exit"; do
		case $answer in
			Download ) break;;
			Exit ) exit;;
		esac
	done
	# Download, unzip boost
	wget -qO- --show-progress $boost_link | tar -xz
fi

./redo_strip.sh

cd $boost_path

export library="libs"
export source="boost"

# Ensure b2 is built
if [ ! -f "./b2" ]; then
	>&2 echo "Bootstrap! Please wait..."
	./bootstrap.sh
fi

>&2 echo "Gather libraries..."
# To get the list of libraries do:
cd $library
ls -d */ -1 | tr -d '/' > $temp/all_libraries 
cd ->/dev/null

# Gather boost lists too, have to combine with all_libraries
cd $source
ls -d */ -1 | tr -d '/' > $temp/source_libraries 
cd ->/dev/null

sort -u $temp/all_libraries $temp/source_libraries -o $temp/all_libraries

# Collect and subtract binary libraries from all the libraries
if [ ! -f "${temp}/binary_libraries" ]; then
	./b2 --show-libraries | grep " - " | awk '{print $2}' | sort > $temp/binary_libraries
fi
grep -vxFf $temp/binary_libraries $temp/all_libraries | sort > $temp/non_binary_result

export listing_lib="${temp}/all_libraries"
if [ -f $output/install_libraries ]; then
	export install_lib="${output}/install_libraries"
fi

# Build Boost BCP from binaries
export bcp="./dist/bin/bcp"
if [ ! -f "${bcp}" ]; then
	>&2 echo "Compile BCP! Please wait..."
	./b2 -j`nproc` tools/bcp
fi

cd ..
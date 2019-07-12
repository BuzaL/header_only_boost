if [ -z ${output+x} ]; then output="$(pwd)/standalone_output"; fi
if [ -z ${temp+x} ]; then temp="${output}/temp"; fi
if [ -z ${boost_path+x} ]; then boost_path="boost_1_70_0"; fi
if [ -z ${library+x} ]; then library="libs"; fi
if [ -z ${list_out+x} ]; then list_out="${output}/doc"; fi
if [ -z ${source+x} ]; then source="boost"; fi
if [ -z ${bcp+x} ]; then bcp="./dist/bin/bcp"; fi
if [[ -z ${verbose+x} && "$1" = "-v" ]]; then verbose=true; fi
if [ -z ${clear+x} ]; then clear=true; fi
if [ -z ${listing_lib+x} ]; then listing_lib="${temp}/all_libraries"; fi
if [ -z ${install_lib+x} ]; then install_lib="${temp}/all_libraries"; fi

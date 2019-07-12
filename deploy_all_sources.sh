#!/bin/bash
source ensure_variables.sh

cd $boost_path

if [ ! -d "${library}" ]; then (>&2 echo "$library not found"); exit; fi

# Copy library sources
>&2 echo "Deploying all! Please wait..."
find ${library} -maxdepth 2 -type d -path '*/src' -exec mkdir -p "${output}/{}" \; -exec cp -r {} "${output}/{}/.." \;

# Copy boost sources (copy whole folder + remove unwanted files)
## tar faster than simple copy
tar c ${source} | tar x -C ${output}
#cp -ar ${source} ${output}
find ${source} -type f \( ! \( -regex '.*\.\(cpp\|hpp\|h\|c\|ipp\)' -or ! -regex '.*\..*' \) \) -printf "${output}/%p\n" | xargs rm

## Whole copy + remove files faster than copy 1-by-1 more than 10k files:
#find ${source} -type f \( -regex '.*\.\(cpp\|hpp\|h\|c\|ipp\)' -or ! -regex '.*\..*' \) | xargs cp -a --parents -t ${output}

cd ->/dev/null
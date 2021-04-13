#!/bin/sh

# change IFS: Internal Field Separator
# see here: https://www.server-memo.net/shellscript/ifs.html
PRE_IFS=$IFS
IFS=$'\n'

# move working directory
cd `dirname $0`

# input cd path
read -p "Input CD path: " cd_path
output_dir=`basename ${cd_path}`
mkdir -p "${output_dir}"

for file in `\find "${cd_path}" -maxdepth 1 -name "*.aiff"`; do
    fname=`basename "${file}"`
    echo "converting ${fname} ..."
    
    # output aiff file
    aiff_path=${output_dir%/}/${fname}
    # intermediate caf file
    caf_path=${aiff_path}$".caf"

    # # test
    # touch ${aiff_path}
    # touch ${caf_path}
    
    # original aiff -> caf
    afconvert -f caff -d BEI16@44100 ${file} ${caf_path}
    # caf -> output aiff
    afconvert -f AIFF -d BEI16@44100 ${caf_path} ${aiff_path}

    # remove intermediate caf file
    rm ${caf_path}
    echo "done"
done

# restore IFS
IFS=$PRE_IFS

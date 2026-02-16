#!/bin/bash
echo "[STARTING COMPATIBILITY LAYER] Pulling dirname"
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "[STARTING COMPATIBILITY LAYER] Process succceded"
echo "[COMPATIBILITY LAYER] dirname=$dir"
echo "[STARTING COMPATIBILITY LAYER] Building array"
files=("$dir"/*)
if [ ! -e "${files[0]}"]; then
    echo "[STARTING COMPATABILITY LAYER] Error when building array, no such file or directory"
    exit 1
fi 

if [ "${#files[@]}" -gt 1 ]; then
    echo "[STARTING COMPATABILITY LAYER] Error when building array, cannot process multiple directories"
    exit 1
fi

echo "[STARTING COMPATABILITY LAYER] Directory found, array built ${files[0]}"

file="${files[0]}"
filedir="$(dirname "$file")"
cd "$filedir"
type=$(file -b "$file")

if [[ "$type" == *"Debian binary package"* ]]; then
    echo "[COMPATABILITY LAYER]Installing .deb"
    sudo dpkg -i "$file"

elif [[ "$type" == *"gzip compressed"* ]]; then
    echo "[COMPATABILITY LAYER] Extracting archive"
    tar -xzf "$file"

elif [[ "$type" == *"executable"* ]]; then
    echo "[COMPATABILITY LAYER] Running executable"
    chmod +x "$file"
    ./"$file"

else
    echo "[COMPATABILITY LAYER] FAILED"
    exit 1 
fi

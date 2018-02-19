#!/bin/bash

files=$(find . -name "*.aff" | xargs -I{} grep -L "SET UTF-8" {})
encodings=$(find . -name *.aff | xargs -I{} grep -L "SET UTF-8" {} | xargs -I{} grep -oP "SET\s+\K[-\w]+" {})
files=($files)
encodings=($encodings)

if [ ${#files[@]} != ${#encodings[@]} ]; then
 echo "Files and encodings should have the same length"
 exit 1
fi
 
for ((i = 0; i < ${#files[@]}; i++)); do
    echo "Encoding ${encodings[$i]}"

    iconv -f ${encodings[$i]} -t UTF-8 ${files[$i]} -o ${files[$i]}.converted
    iconv -f ISO-8859-1 -t UTF-8 ${files[$i]%'.aff'}'.dic' -o ${files[$i]%'.aff'}'.dic'.converted

    sed -i "s/${encodings[$i]}/UTF-8/g" ${files[$i]}.converted
    mv -f ${files[$i]}.converted ${files[$i]}    
    mv -f ${files[$i]%'.aff'}'.dic'.converted ${files[$i]%'.aff'}'.dic'             
done
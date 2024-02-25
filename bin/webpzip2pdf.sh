#!/bin/bash

p_zip=${1}
out_folder=`basename -s .zip $p_zip`
out_folder2=`echo $out_folder | sed 's/\s/_/g'`
mkdir ${out_folder2}
unzip "${p_zip}" -d $out_folder2

cd $out_folder2

find . -name "*.webp" -exec img2pdf {} -o {}.pdf \;
pdftk *.pdf cat output ../${out_folder2}.pdf
# find . -name "*.webp" -exec dwebp {} -o {}.png \;
# convert *.png ../${out_folder2}.pdf
cd -

rm -r $out_folder2

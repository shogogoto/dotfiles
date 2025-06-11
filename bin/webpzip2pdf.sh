#!/bin/bash
find . -name "*.zip" |while read f
do
  new=`echo $f| sed 's/\s/_/g'`
  mv "$f" $new
done

for p_zip in $@
do
  out_folder=`basename -s .zip "$p_zip"`
  out_folder2=`echo $out_folder | sed 's/\s/_/g'`
  mkdir ${out_folder2}
  unzip "${p_zip}" -d $out_folder2

  cd $out_folder2

  find . -name "*.webp" -exec img2pdf {} -o {}.pdf \;

  pdfunite *.pdf ../${out_folder2}.pdf
  # pdftk *.pdf cat output ../${out_folder2}.pdf
  # find . -name "*.webp" -exec dwebp {} -o {}.png \;
  # convert *.png ../${out_folder2}.pdf
  cd -

  rm -r $out_folder2
done

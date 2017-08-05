#!/bin/sh
while read file
do
  echo "$file"
  dropfile=~/Dropbox/images/`basename "$file"`
  echo $dropfile
  convert "$file" -strip -resize 1024x "$dropfile"
  exiv2  -M"set Xmp.xmpRights.Marked True" \
    -M"set Xmp.xmpRights.UsageTerms 'This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License (http://creativecommons.org/licenses/by-sa/4.0/).'" \
    -M"set Xmp.dc.creator void@alfadeo.de" \
    -M"set Xmp.dc.rights 'This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License (http://creativecommons.org/licenses/by-sa/4.0/).'" \
    -M"set Xmp.dc.description Original artwork available from void@alfadeo.de" "$dropfile"
done < "${1:-/dev/stdin}"

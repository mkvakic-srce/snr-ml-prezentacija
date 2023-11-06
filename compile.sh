#!/bin/bash

# pandoc
pandoc presentation.md -o presentation.pptx --reference-doc template/srce-predlozak-16x9-OA-CC-BY-SA-2023-EN.PPTX

# unzip
unzip -q -o -d presentation/ presentation.pptx

# footer
sed -i "s/NAZIV DOGAĐANJA/$(egrep '^title' presentation.md | sed 's/^title: //g')/g" presentation/ppt/slides/*.xml

# zip
cd presentation/ && zip -q -r ../presentation.pptx *

# rm
rm -rf presentation/

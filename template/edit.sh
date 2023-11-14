#!/bin/bash

# rm
rm -rf srce-predlozak-16x9-OA-CC-BY-SA-2023-??/

# unzip
unzip -q -o -d srce-predlozak-16x9-OA-CC-BY-SA-2023-EN/ srce-predlozak-16x9-OA-CC-BY-SA-2023-EN.PPTX
unzip -q -o -d srce-predlozak-16x9-OA-CC-BY-SA-2023-HR/ srce-predlozak-16x9-OA-CC-BY-SA-2023-HR.pptx

# cp
cp \
  srce-predlozak-16x9-OA-CC-BY-SA-2023-HR/ppt/media/*.jpg \
  srce-predlozak-16x9-OA-CC-BY-SA-2023-EN/ppt/media/.

# zip
cd srce-predlozak-16x9-OA-CC-BY-SA-2023-EN/ && zip -q -r ../srce-predlozak-16x9-OA-CC-BY-SA-2023-HR-edited.pptx *

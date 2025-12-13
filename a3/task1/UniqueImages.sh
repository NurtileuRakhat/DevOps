#!/bin/bash

unzip -o duplicate_files.zip -d images && \
find images -type f ! -path "*__MACOSX*" -exec shasum -a 256 {} + \
| awk 'arr[$1]++ {print $2}' \
| xargs rm

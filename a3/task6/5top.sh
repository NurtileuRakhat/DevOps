#!/bin/bash

find /home -type f -exec du -ah {} + | sort -rh | head -n 5

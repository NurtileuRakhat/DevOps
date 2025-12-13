#!/bin/bash

new_job_name="$1"
sed -i "s/job \"[^\"]*\"/job \"$new_job_name\"/" example.nomad

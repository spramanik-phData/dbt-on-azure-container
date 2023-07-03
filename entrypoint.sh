#!/bin/bash
source /dbt_env.sh

echo "==============================="
echo "variables are set"
echo "==============================="

cd /mnt/github/dbt_on_container
echo $( pwd )

dbt deps
dbt build

exit 0
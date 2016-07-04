#!/bin/bash
# You can make this executable with 'chmod u+x set-env.sh'
#added by Anaconda2 2.5.0 installer
export PATH="/home/ulrichwoitek/anaconda2/bin:$PATH"


env_name=${PWD##*/}
# TODO: Set alias for waf.py
# try to activate environment
source activate $env_name >> /dev/null 2>&1
# get return code of activation
OUT=$?

# create environment if it does not exist or create is supplied
# this install packages as well
if [[ ($OUT -eq 1)  || ($1 == "create") || ($1 == "install") ]]; then
    conda create -n $env_name --file conda_versions.txt
    if [ -f requirements.txt ]; then
        source activate $env_name >> /dev/null 2>&1
        pip install -r requirements.txt
    fi
fi

# update packages
if [[ $1 == "update" ]]; then
    conda update --all
    if [ -f requirements.txt ]; then
        # Update all pip packages
        source activate $env_name >> /dev/null 2>&1
        pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
    fi
    # Update requirement files
    picky --update
fi

# check the return code of operations
OUT=$?


if [[ ! ($OUT -eq 1) ]]; then
    source activate $env_name
fi

# Run picky to test environment consistency
picky

# pip install picky >> /dev/null


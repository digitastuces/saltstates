#!/bin/bash -e

### Settings

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

# exit on error
set -e
# exit if script use undeclared variable
set -u


### Variables

export ROOT_SALTSTATES_DIR="${PROGDIR}/.."


### Functions


main() {
    cd ${ROOT_SALTSTATES_DIR}
    saltfiles=$(ls salt/*/salt-formulas)
    for saltfile in ${saltfiles}; do
	saltenv=$(echo ${saltfile}|cut -d '/' -f 2)
	echo
	echo  "### Installing salt formulas for saltenv: ${saltenv}"
	echo
        ./bin/xterrafile install -f ${saltfile}
	echo
    done
}


### Main

main


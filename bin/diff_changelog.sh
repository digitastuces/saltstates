#!/bin/bash

# This simple script parse CHANGELOG.md file and outputs changelog information
# between current version and previous
#
# Use with --html option to generate HTML formatted output
# Use with --txt or no option to generate text output


# changelog file
CHANGELOG='CHANGELOG.md'


# retrieve current version from changelog file
current_version() {
    current=$( egrep '^## [0-9]{4}-[0-9]{2}-[0-9]{2}' ${CHANGELOG} | head -1 | cut -d ' ' -f 2 )
    echo "${current}"
}

# retrieve previous version from changelog file
previous_version() {
    previous=$( egrep '^## [0-9]{4}-[0-9]{2}-[0-9]{2}' ${CHANGELOG} | head -2 | tail -1 | cut -d ' ' -f 2 )
    echo "${previous}"
}

# retrieve changes between previous and current version from changelog file
#
# args:
#   $1: previous
#   $2: current
parse_changelog() {
    local previous="$1"
    local current="$2"

    changes=$( awk "/^## ${current}/{flag=1;next}/^## ${previous}/{flag=0}flag" ${CHANGELOG} | tail -n +2 | sed -e 's/  \* //')
    echo "${changes}"
}

# output changes in text format
#
# args:
#   $1: changes
output_txt() {
    local changes="$1"

    echo "${changes}"
}

# output changes in HTML format
#
# args:
#   $1: changes
output_html() {
    local changes="$1"
    local output=""
    local changes_html=""

    changes_html=$( echo "${changes}" | sed -e 's/.*/  <li>&<\/li>/' )
    output="<ul>
${changes_html}
</ul>"
    echo "${output}"
}



## main code

# default output is text format
OUTPUT="txt"
for arg in "$@"; do
    shift
    case "${arg}" in
        "--html")
            OUTPUT="html"
            ;;
        "--txt")
            OUTPUT="txt"
            ;;
    esac
done

current=$( current_version )
previous=$( previous_version )
changes=$( parse_changelog "${previous}" "${current}" )

case "${OUTPUT}" in
    "html")
        output=$( output_html "${changes}" )
        ;;
    "txt")
        output=$( output_txt "${changes}" )
        ;;
esac

echo "${output}"


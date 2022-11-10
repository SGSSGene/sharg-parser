#!/usr/bin/env bash
# -----------------------------------------------------------------------------------------------------
# Copyright (c) 2006-2022, Knut Reinert & Freie Universität Berlin
# Copyright (c) 2016-2022, Knut Reinert & MPI für molekulare Genetik
# This file may be used, modified and/or redistributed under the terms of the 3-clause BSD-License
# shipped with this file and also available at: https://github.com/seqan/seqan3/blob/master/LICENSE.md
# -----------------------------------------------------------------------------------------------------
#
# Usage: create_all_hpp.sh <SeqAn3 root directory>
# Will update the cookbook to inlcude all snippets of the documentation

COOKBOOK="doc/cookbook/index.md"

if [[ $# -ne 1 ]]; then
    echo "Usage: create_all_hpp.sh <SeqAn3 root directory>"
    exit 1
fi

if [[ ! -d $1 ]]; then
    echo "The directory $1 does not exist."
    exit 1
fi

if [[ ! -f $1/${COOKBOOK} ]]; then
    echo "The directory $1 does not seem to be the SeqAn3 root directory."
    echo "Cannot find cookbook file $1/${COOKBOOK}."
    exit 1
fi

KEY_LINE_IN_COOKBOOK="ALL SNIPPETS START"

if [[ -z $(grep -n "${KEY_LINE_IN_COOKBOOK}" ${COOKBOOK}) ]]; then
    echo "Line '${KEY_LINE_IN_COOKBOOK}' could not be found in ${COOKBOOK}. Update not possible."
    exit 1
fi

LINE_NUMBER_OF_KEY_LINE=$(grep -n "${KEY_LINE_IN_COOKBOOK}" ${COOKBOOK} | cut -d : -f 1)

TMP_FILE=$(mktemp);
# Copy cookbook except the snippet includes into tmp file
head -n ${LINE_NUMBER_OF_KEY_LINE} ${COOKBOOK} > ${TMP_FILE}

# Iterate through all file in include/seqan3/test/snippet/*
for snippet in $(find test/snippet/ -type f -name "*.cpp"); do
    echo "\include ${snippet}" >> $TMP_FILE
done

#Update cookbook
echo "Updating cookbook at ${COOKBOOK}"
cp ${TMP_FILE} ${COOKBOOK}

rm ${TMP_FILE}

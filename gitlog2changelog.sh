#!/usr/bin/env bash

ART_HOST='https://artifactory.example.com'
ART_PATH='api/storage/repo/folder'

# Get commits
function commits () {
  echo hej
  git log --no-merges --pretty=format:%s%n%ai \
    | sed 's|[[:space:]][0-9][0-9]:[0-9][0-9]:[0-9][0-9][[:space:]]+[0-9][0-9][0-9][0-9]||g' \
    | sed '/^[0-9][0-9][0-9][0-9]\-[0-9]/s/^/\n## [0.0.0] /' \
    | sed '/^##/s/$/\n/' \
    | awk '!seen[$0]++' > CHANGELOG-generated.md
}

# Get released versions from artifactory
function releases () {
  curl -s -u user:pass "${ART_HOST}/${ART_PATH}/?list&listFolders=1&mdTimestamps=1" \
    | sed '/size/d' \
    | sed '/folder/d' \
    | sed '/created/d' \
    | sed '/files/d' \
    | sed '/}/d' \
    | sed 's/T.*$//g' \
    | sed 's/"lastModified"[[:space:]]:[[:space:]]"//g' \
    | sed 's/[[:space:]]"uri"[[:space:]]:[[:space:]]"\///g' \
    | sed '/uri/d' \
    | sed '/{/d' \
    | sed 's/",//g' \
    | sed 's/^[[:space:]]*//g' \
    | sed 's/[[:space:]]*$//g' \
    | sed 's/\([0-9]\+\.[0-9]\+\.[0-9]\+\)/ ## [\1] /g' \
    | sed '/[0-9][0-9][0-9][0-9]/s/^/ /g' \
    | awk '!(NR%2){print$0p}{p=$0}' \
    | awk '{print $2 " " $3 " " $1}' \
    | tac > VERSIONS-generated.md
}

# Script entry point
while getopts ":crp:" opt; do
  case $opt in
     c) commits ;;
     r) releases   ;;
     p) ART_PATH="${OPTARG}" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
     :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
  esac
done

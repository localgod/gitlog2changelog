# gitlog2changelog

Script for generating a changelog from a git log

## Prerequisite

`bash` and `git`

You might need to edit the script for updating credentials.

## Run

```
$ cd /path/to/git/repo
$ /path/to/gitlog2changelog.sh -c
$ /path/to/gitlog2changelog.sh -r -p path/on/artifactory
```

Two files are generated:

* CHANGELOG-generated.md
* VERSIONS-generated.md

Combine them as it makes sense in your projects to one file: `CHANGELOG.md`

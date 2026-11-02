#!/bin/bash
##################################################################################
#
# Extract release notes from a CHANGELOG file that is formatted as follows:
#
# * Reverse chronological order (the newest release is the first in the file).
# * Each release starts with a markdown heading (level 2) with the following
#   format: ## [vX.Y.Z] - YYYY-mm-DD
# * The content is formatted using regular markdown.
# * The CHANGELOG follows https://keepachangelog.com/en/2.0.0/, with the
#   types of change indicated by headings of level 3.
# * Links for each version are included in a list at the end of the CHANGELOG.
#
# This script assumes it is being run within a git repository.
#
##################################################################################

if [ -z "$1" ]; then
	echo "Error: Missing path to CHANGELOG file."
	exit 1
fi

CHANGELOG_FILE="$1"

if [ ! -f "$CHANGELOG_FILE" ]; then
	echo "Error: CHANGELOG file does not exist at given path."
	exit 1
fi

## captures versions
## >## v1.0.0
## >## [v1.0.0]
VERSION_PATTERN="^## [\[]v"

## captures url links
## [v1.2.0]: https://github.com/nasa/harmony-gdal-adapter/releases/tags/1.2.0
LINK_PATTERN="^\[.*\]:.*https://github.com/nasa"

# Read the file and extract text between the first two occurrences of the
# VERSION_PATTERN
result=$(awk "/$VERSION_PATTERN/{c++; if(c==2) exit;} c==1" "$CHANGELOG_FILE")

# Get all commit messages since the last release (marked with a git tag). If
# there are no tags, get the full commit history of the repository.
if [[ $(git tag) ]]
then
	# There are git tags, so get the most recent one
	GIT_REF=$(git describe --tags --abbrev=0)
else
	# There are not git tags, so get the initial commit of the repository
	GIT_REF=$(git rev-list --max-parents=0 HEAD)
fi

# Retrieve the title line of all commit messages since $GIT_REF, filtering out
# those from the pre-commit-ci[bot] author and any containing the string
# "nasa/pre-commit-ci-update-config", which may result from merge commits.
GIT_COMMIT_MESSAGES=$(git log --oneline --format="%s" --perl-regexp --author='^(?!pre-commit-ci\[bot\]).*$' --grep="nasa\/pre-commit-ci-update-config" --invert-grep ${GIT_REF}..HEAD)

# Append git commit messages to the release notes:
if [[ ${GIT_COMMIT_MESSAGES} ]]
then
	result+="\n\n## Commits\n\n${GIT_COMMIT_MESSAGES}"
fi

# Print the result
echo -e "$result" |  grep -v "$VERSION_PATTERN" | grep -v "$LINK_PATTERN"

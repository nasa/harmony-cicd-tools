# Release Notes Extractor

This custom action will use the `extract-release-notes.sh` script to parse the
most recent entry in a specified CHANGELOG file.

## Usage:

This action can be placed in a workflow as follows:

```yaml
jobs:
  my-fancy-job:
  runs-on: ubuntu-latest
  steps:
    - name: Checkout repository
      uses: actions/checkout@v7

    - name: Extract release notes
      uses: nasa/harmony-cicd-tools/release-notes-extractor@v1
      with:
        changelog: ./path/to/CHANGELOG.md
```

This action will create an environment variable `RELEASE_NOTES`, which can be
used in subsequent steps of a GitHub workflow via `env.RELEASE_NOTES`.

## CHANGELOG formatting:

The CHANGELOG file must adhere to the following conventions:

* Entries must be in reverse chronological order (the newest release is the
  first in the file).
* Each release starts with a markdown heading (level 2) with the following
  format: `## [vX.Y.Z] - YYYY-mm-DD`
* The content must be formatted using regular markdown.
* The CHANGELOG follows https://keepachangelog.com/en/2.0.0/, with the
  types of change indicated by headings of level 3.
* Links for each version are included in a list at the end of the CHANGELOG.

## Additional assumptions:

The script assumes it is being run within a git repository and has access to
git commands. Test executions with `act` may not have access to git, and will
likely skip git commands in the `extract-release-notes.sh` script.

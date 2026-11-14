# Harmony CI/CD Tools

This repository is a place to consolidate commonly reused scripts, actions and
workflows, instead of maintaining multiple copies across repositories in the
NASA GitHub organisation. A lot of the impacted repositories are for Harmony
backend services, but that should not be seen as a limit to other teams or
projects looking to reuse the content hosted here.

## Reusable actions:

These are stored in the `actions` subdirectory:

### release-notes-extractor

This will use a bash script to extract release notes from a CHANGELOG markdown
file that follows [keepachangelog](https://keepachangelog.com/en/2.0.0/)
conventions, and some other standard practices as described in the action
[README.md](./actions/release-notes-extractor/README.md).

## Local testing:

The [act](https://nektosact.com/introduction.html) tool can be used to locally
invoke GitHub actions and workflows. It can be installed via `brew`.

Some test workflows can be found in `.github/workflows/test_local.yml`. Specific
jobs can be invoked using `act`:

```bash
act -j test-release-notes-extractor
```

In the example above [test_local.yml](.github/workflows/test_local.yml)
contains the job `test-release-notes-extractor`.

Note, `act` executes actions locally using Docker, so some dependencies may not
be available to the container executing the actions.

To avoid Docker-in-Docker issues, this repository has a `.actrc` file to allow
containers to spin up sibling containers using the host machine's Docker engine.

## Releases:

To publish a new version of custom actions, a git tag needs to be added to the
specific commit. This repository hosts multiple custom actions, so there is one
version number that relates to all actions in the repository.

The CI/CD to add a new git tag and publish a new GitHub release is controlled
by changes to the `VERSION` file. When this is updated in a PR, the git tag
will be added to the commit when the PR is merged to `main`. A GitHub release
will also be created using the latest release notes from `CHANGELOG.md`.

## Versioning:

This repository follows semantic versioning `major.minor.patch`.

* Major versions - for breaking changes.
* Minor versions - for new, backwards-compatible, features.
* Patch versions - for minor updates that are largely internal to existing code.

The semantic version of this repository applies across all custom actions at
the time of the commit being tagged.

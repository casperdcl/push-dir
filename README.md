GitHub Action: Push Directory
=============================

[![Test](https://github.com/casperdcl/push-dir/actions/workflows/test.yml/badge.svg)](https://github.com/casperdcl/push-dir/actions/workflows/test.yml)

Cleanly push directory contents to a branch. Particularly useful for `gh-pages` deployment.

## Example

```yaml
    steps:
      - uses: actions/checkout@v2
      - run: build_site_command --output-dir static_site
      - uses: casperdcl/push-dir@v1
        with:
          name: ${{ github.actor }}
          email: ${{ github.actor }}@users.noreply.github.com
          message: update static site
          branch: gh-pages
          dir: static_site
          history: false
          cname: my.domain.com
          nojekyll: true
```

## Why


The main alternative GitHub Action

Other features (supported by both) include:


## Inputs

```yaml
message:
  description: Commit message
  required: true
branch:
  description: Branch to push to
  required: true
name:
  description: Git committer name
  default: github-actions[bot]
  required: false
email:
  description: Git committer email
  default: 41898282+github-actions[bot]@users.noreply.github.com
  required: false
dir:
  description: Directory to push
  default: .
  required: false
force:
  description: Set to "true" to force push
  required: false
history:
  description: |
    Set to "false" to discard any prior commits on the `branch`
    (Note: "false" will override `force` to "true")
  default: true
  required: false
cname:
  description: Text to inject into a `CNAME` file
  default: ''
  required: false
nojekyll:
  description: Set to "true" to add a `.nojekyll` file
  required: false
```

GitHub Action: Push Directory
=============================

[![Test](https://github.com/casperdcl/push-dir/actions/workflows/test.yml/badge.svg)](https://github.com/casperdcl/push-dir/actions/workflows/test.yml)

Cleanly push directory contents to a branch. Particularly useful for `gh-pages` deployment.

## Example

```yaml
    steps:
      - uses: actions/checkout@v3
      - run: build_site_command --output-dir static_site
      - uses: casperdcl/push-dir@v1
        with:
          message: update static site
          branch: gh-pages
          dir: static_site
          history: false
          cname: my.domain.com
          nojekyll: true
```

## Why

Perfect for e.g. `gh-pages` deployment.

- Supports pushing the contents of a directory to a branch
- Supports discarding branch history
- Uses a blazing fast native GitHub composite action
- Has the entirety of the code in a [single file](https://github.com/casperdcl/push-dir/blob/master/action.yml), making it very easy to review
  + If you are [extremely security conscious](https://github.com/casperdcl/deploy-pypi/issues/6#issuecomment-721954322) you can use a commit SHA of a version you've manually reviewed (e.g. `uses: casperdcl/push-dir@`[67a9d1d](https://github.com/casperdcl/push-dir/commit/67a9d1d4123e2e4978ad6ef8a86efaab2300fdc5))

The main alternatives GitHub Actions
[gh-pages-deploy](https://github.com/marketplace/actions/gh-pages-deploy) and
[github-push](https://github.com/marketplace/actions/github-push) currently do
not offer the benefits above.

Other features (supported by some of the alternatives) include:

- Custom committer name & email
- Custom commit message
- Force pushing
- `CNAME` & `.nojekyll` conveniences for GitHub pages

## Inputs

```yaml
message:
  description: Commit message
  required: true
branch:
  description: Branch to push to
  required: true
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
name:
  description: Git committer name
  required: false
email:
  description: Git committer email
  required: false
```

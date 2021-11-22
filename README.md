# Auto-Rebase Notify Action

> A GitHub Action to automatically notify all PRs to rebase when their base 
> branch receives a new push

[![Build Status](https://github.com/snasirca/autorebase-notify-action/workflows/Auto-Rebase Notify/badge.svg)](https://github.com/snasirca/autorebase-notify-action/actions)

## Prerequisites

* You must have set up the [Rebase GitHub Action](https://github.com/cirrus-actions/rebase/)

## Usage

Create a workflow file under `.github/workflows` called `autorebase.yml` with
the following content:

```yml
name: Auto-Rebase Notify

on:
  push:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Trigger rebase
        uses: snasirca/autorebase-notify-action@main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

> NOTE: To ensure GitHub Actions is automatically re-run after a successful 
> rebase action use a [Personal Access Token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) 
> for `snasirca/autorebase-notify-action@main`. See the following [discussion](https://github.community/t/triggering-a-new-workflow-from-another-workflow/16250/37) 
> for more details.

```yaml

...
      - name: Trigger rebase
        uses: snasirca/autorebase-notify-action@main
        env:
          GITHUB_TOKEN: ${{ secrets.PAT_TOKEN }}
```

Add the label `autorebase` to PRs that you want to target.

## License

[MIT](LICENSE)

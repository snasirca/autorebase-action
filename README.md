# Auto-Rebase Action

> A GitHub Action to automatically notify all PRs to rebase when their base 
> branch receives a new push

[![Build Status](https://github.com/snasirca/autorebase-action/workflows/Auto-Rebase/badge.svg)](https://github.com/snasirca/autorebase-action/actions)

## Prerequisites

* You must have set up the [Rebase GitHub Action](https://github.com/cirrus-actions/rebase/)

## Usage

Minimal example

```yml
name: Auto-Rebase

on:
  push:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Trigger rebase
        uses: snasirca/autorebase-action@main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Add the label `autorebase` to PRs that you want to target.

## License

[MIT](LICENSE)

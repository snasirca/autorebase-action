#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

owner=$(echo "${GITHUB_REPOSITORY}" | awk -F/ '{ print $1 }')
repo_name=$(echo "${GITHUB_REPOSITORY}" | awk -F/ '{ print $2 }')

pull_request_ids=()
while read -r line; do
  pull_request_ids+=("${line}")
done < <(
  jq -cn '
    {
      query: $query,
      variables: {
        owner: $owner,
        repoName: $repoName,
        baseRefName: $baseRefName
      }
    }' \
    --arg query '
    query($owner: String!, $repoName: String!, $baseRefName: String!) {
      repository(owner: $owner, name: $repoName) {
        name
        pullRequests(
          first: 10,
          labels: ["autorebase"],
          states: OPEN,
          baseRefName: $baseRefName,
          orderBy: {
            field: UPDATED_AT,
            direction: DESC
          }
        ) {
          nodes {
            id
            title
            baseRefName
            headRefName
          }
        }
      }
    }' \
    --arg owner "${owner}" \
    --arg repoName "${repo_name}" \
    --arg baseRefName "${GITHUB_REF_NAME}" |
    curl \
      --silent \
      --header "Authorization: Bearer ${GITHUB_TOKEN}" \
      --data @- \
      "https://api.github.com/graphql" |
    jq --raw-output '.data.viewer.repository.pullRequests.nodes | map(.id)[]'
)

for pull_request_id in "${pull_request_ids[@]}"; do
  jq -cn '
    {
      query: $query,
      variables: {
        pullRequestId: $pullRequestId
      }
    }' \
    --arg query '
      mutation($pullRequestId: String!) {
        addComment(input: { subjectId: $pullRequestId, body: "/rebase" }) {
          subject {
            id
          }
        }
      }' \
    --arg pullRequestId "${pull_request_id}" |
    curl \
      --silent \
      --header "Authorization: Bearer ${GITHUB_TOKEN}" \
      --data @- \
      "https://api.github.com/graphql"
done

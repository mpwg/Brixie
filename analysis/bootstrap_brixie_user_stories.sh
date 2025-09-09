#!/usr/bin/env bash
#
# bootstrap_brixie_user_stories.sh
#
# Purpose:
#   Parse the Brixie user stories markdown file and create/update:
#     - Milestones (v1.0, v1.1, v1.2)
#     - Labels (epics, priorities, story points, user-story)
#     - Issues (one per user story) with full body content
#
# Idempotency:
#   - Re-running the script will NOT duplicate labels, milestones, or issues.
#   - Milestones created only if missing (or re-opened if closed).
#   - Issues matched by token "[EPIC-###]" in the title; existing issues updated.
#
# Requirements:
#   - bash 3.x compatible
#   - gh (GitHub CLI) authenticated
#   - jq, sed, grep, tr
#
# Usage:
#   ./scripts/bootstrap_brixie_user_stories.sh \
#       [-f analysis/user_stories.md] \
#       [-r owner/repo] \
#       [--dry-run] \
#       [-c COMMIT_SHA]
#
# Options:
#   --dry-run  Show actions without performing writes.
#
set -euo pipefail

FILE="analysis/user_stories.md"
REPO=""
COMMIT_SHA=""
DRY_RUN="false"

while [ $# -gt 0 ]; do
  case "$1" in
    -f|--file) FILE="$2"; shift 2 ;;
    -r|--repo) REPO="$2"; shift 2 ;;
    -c|--commit) COMMIT_SHA="$2"; shift 2 ;;
    --dry-run) DRY_RUN="true"; shift ;;
    -h|--help)
      grep '^# ' "$0" | sed 's/^# //'
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

need() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: Required command not found: $1" >&2
    exit 1
  fi
}
need gh
need jq
need sed
need grep
need tr

# Determine repo if not provided
if [ -z "$REPO" ]; then
  if git remote -v 2>/dev/null | grep -q 'github.com'; then
    REPO=$(git remote -v | grep -m1 'github.com' | sed -E 's#.*github.com[:/ ]([^ ]+)(\.git)? .*#\1#')
  fi
fi
# Strip trailing .git if somehow still present
REPO=$(echo "$REPO" | sed -E 's/\.git$//')

if [ -z "$REPO" ]; then
  echo "ERROR: Could not determine repository (use -r owner/repo)" >&2
  exit 1
fi

echo "Target repository: $REPO"
[ "$DRY_RUN" = "true" ] && echo "Running in DRY RUN mode: no write operations will be performed."

run() {
  if [ "$DRY_RUN" = "true" ]; then
    echo "DRY-RUN: $*"
  else
    eval "$@"
  fi
}

# Milestone handling via gh api (since no native create subcommand exists)
# ensure_milestone <title> <description>
ensure_milestone() {
  local title="$1"
  local desc="$2"
  # Fetch all milestones (open & closed) and try to match exactly
  local existing
  existing=$(gh api -X GET "repos/$REPO/milestones?state=all&per_page=100" \
             --jq ".[] | select(.title==\"$title\") | @base64" 2>/dev/null || true)

  if [ -n "$existing" ]; then
    # Decode and check state
    local decoded state number
    decoded=$(echo "$existing" | head -n1 | base64 --decode)
    state=$(echo "$decoded" | jq -r '.state')
    number=$(echo "$decoded" | jq -r '.number')
    if [ "$state" = "closed" ]; then
      echo "Re-opening closed milestone: $title (#$number)"
      run gh api -X PATCH "repos/$REPO/milestones/$number" -f state=open >/dev/null
    else
      echo "Milestone exists: $title"
    fi
  else
    echo "Creating milestone: $title"
    run gh api -X POST "repos/$REPO/milestones" -f title="$title" -f description="$desc" >/dev/null
  fi
}

# Labels
ensure_label() {
  local name="$1" color="$2" desc="$3"
  if gh label view "$name" --repo "$REPO" >/dev/null 2>&1; then
    # Keep labels up to date (color/desc)
    run gh label edit "$name" --repo "$REPO" --color "$color" --description "$desc"
    echo "Label ok: $name"
  else
    echo "Creating label: $name"
    run gh label create "$name" --repo "$REPO" --color "$color" --description "$desc"
  fi
}

find_issue_by_id() {
  local id="$1"
  local json
  # Use search with brackets in query
  json=$(gh issue list --repo "$REPO" --search "\"$id\" in:title" --state all --limit 300 --json number,title 2>/dev/null || echo "[]")
  echo "$json" | jq -r --arg ID "$id" '.[] | select(.title | contains($ID)) | .number' | head -n1
}

create_or_update_issue() {
  local id_token="$1" title="$2" milestone="$3" labels="$4" body_file="$5"

  local issue_number
  issue_number=$(find_issue_by_id "$id_token" || true)

  if [ -n "$issue_number" ]; then
    echo "Updating issue #$issue_number ($id_token)"
    run gh issue edit "$issue_number" --repo "$REPO" \
        --title "$title" \
        --milestone "$milestone" \
        --add-label "$labels" \
        --body-file "$body_file"
  else
    echo "Creating issue: $title"
    run gh issue create --repo "$REPO" \
        --title "$title" \
        --milestone "$milestone" \
        --label "$labels" \
        --body-file "$body_file"
  fi
}

# Priority normalization to labels
priority_to_label() {
  local p=$(echo "$1" | tr 'A-Z' 'a-z')
  case "$p" in
    must*) echo "priority:must-have" ;;
    should*) echo "priority:should-have" ;;
    could*) echo "priority:could-have" ;;
    *) echo "priority:should-have" ;;
  esac
}

# Map unscoped Apple platform feature stories to milestones
map_future_story_milestone() {
  case "$1" in
    IOS-005|IOS-006|IOS-008) echo "v1.1" ;;
    IOS-007) echo "v1.2" ;;
    *) echo "v1.1" ;;
  esac
}

ensure_milestone "v1.0" "MVP release scope."
ensure_milestone "v1.1" "Post-MVP enhancements."
ensure_milestone "v1.2" "Further roadmap features."

# Epic labels
ensure_label "FOUNDATION" "1f77b4" "Foundation & API Integration"
ensure_label "CONTENT"    "ff7f0e" "Content Discovery"
ensure_label "COLLECTION" "2ca02c" "Collection Management"
ensure_label "BUILD"      "d62728" "Build Intelligence"
ensure_label "IOS"        "9467bd" "iOS / Apple Platform"
ensure_label "PREMIUM"    "8c564b" "Premium Features"

# Classification & meta labels
ensure_label "user-story"           "111111" "User story item"
ensure_label "priority:must-have"   "b60205" "Highest priority"
ensure_label "priority:should-have" "ffdd57" "Important"
ensure_label "priority:could-have"  "c5def5" "Nice to have"

# Story points labels
ensure_label "sp:3" "0e8a16" "Story points 3"
ensure_label "sp:5" "5319e7" "Story points 5"
ensure_label "sp:8" "fbca04" "Story points 8"

[ -f "$FILE" ] || { echo "ERROR: File not found: $FILE" >&2; exit 1; }

echo "Parsing user stories from: $FILE"

stories_tmp=$(mktemp)
trap 'rm -f "$stories_tmp"' EXIT

current_milestone=""
current_id=""
current_title=""
current_block=""

flush_story() {
  if [ -z "$current_id" ]; then
    return
  fi

  local priority story_points epic milestone
  priority=$(echo "$current_block" | grep -E '\*\*Priority:\*\*' | sed -E 's/.*\*\*Priority:\*\* *//; s/\r//' || true)
  story_points=$(echo "$current_block" | grep -E '\*\*Story Points:\*\*' | sed -E 's/.*\*\*Story Points:\*\* *//; s/\r//' || true)
  epic=$(echo "$current_id" | cut -d'-' -f1)

  milestone="$current_milestone"
  if [ -z "$milestone" ]; then
    milestone=$(map_future_story_milestone "$current_id")
  fi

  local pr_label sp_label
  pr_label=$(priority_to_label "$priority")
  sp_label="sp:$story_points"

  printf '%s|%s|%s|%s|%s|%s|%s\n' \
    "$current_id" \
    "$current_title" \
    "$epic" \
    "$pr_label" \
    "$sp_label" \
    "$milestone" \
    "$(printf %s "$current_block" | sed ':a;N;$!ba;s/\n/\\n/g')" >> "$stories_tmp"

  current_id=""
  current_title=""
  current_block=""
}

while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    "## Release v1.0"*) flush_story; current_milestone="v1.0" ;;
    "## Release v1.1"*) flush_story; current_milestone="v1.1" ;;
    "## Release v1.2"*) flush_story; current_milestone="v1.2" ;;
    "#### ["*)
      flush_story
      current_id=$(echo "$line" | sed -E 's/#### \[([^]]+)\].*/\1/')
      current_title=$(echo "$line" | sed -E 's/#### \[[^]]+\] *//')
      current_block="$line"$'\n'
      ;;
    *)
      if [ -n "$current_id" ]; then
        current_block+="$line"$'\n'
      fi
      ;;
  esac
done < "$FILE"
flush_story

total=$(wc -l < "$stories_tmp" | tr -d ' ')
echo "Discovered $total user stories."

idx=0
while IFS='|' read -r sid stitle sepic spriority ssp smilestone sraw; do
  idx=$((idx+1))
  echo "[$idx/$total] Processing $sid"

  tmp_body=$(mktemp)
  {
    echo "#### [$sid] $stitle"
    echo
    printf "%s" "$sraw" | sed 's/\\n/\n/g'
    echo
    echo "## Metadata"
    echo "- Epic: $sepic"
    echo "- Priority Label: $spriority"
    echo "- Story Points Label: $ssp"
    echo "- Milestone: $smilestone"
    [ -n "$COMMIT_SHA" ] && echo "- Source Commit: $COMMIT_SHA"
    echo "- Source File: $FILE"
  } > "$tmp_body"

  labels="user-story,$sepic,$spriority,$ssp"
  issue_title="[$sid] $stitle"
  create_or_update_issue "[$sid]" "$issue_title" "$smilestone" "$labels" "$tmp_body"

  rm -f "$tmp_body"
done < "$stories_tmp"

echo "Done. All user stories processed."
[ "$DRY_RUN" = "true" ] && echo "Note: DRY RUN (no changes applied)."

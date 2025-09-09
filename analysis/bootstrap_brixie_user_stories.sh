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
#   - Existing issues are updated (title/body/labels/milestone) if found by ID in title.
#
# Requirements:
#   - bash 3.x compatible (no associative arrays)
#   - gh (GitHub CLI) authenticated (GH_TOKEN / gh auth login)
#   - jq (lightweight JSON parsing)
#
# Usage:
#   ./scripts/bootstrap_brixie_user_stories.sh [-f analysis/user_stories.md] [-r owner/repo] [-c COMMIT_SHA]
#
# Notes:
#   - The parser is intentionally pragmatic: it detects story blocks starting with lines like: "#### [FOUNDATION-001]"
#   - Release sections (## Release vX.Y ...) define the milestone for subsequent stories until the next release heading.
#   - Apple Platform Specific Features (after v1.0 list) are mapped heuristically:
#       IOS-005, IOS-006, IOS-008 -> v1.1
#       IOS-007 -> v1.2
#     Adjust mapping logic below if desired.
#
# Exit codes:
#   0 success
#   1 usage / missing dependencies / fatal error
#

set -euo pipefail

###############################################################################
# Configuration defaults
###############################################################################
FILE="analysis/user_stories.md"
REPO=""
COMMIT_SHA=""
DRY_RUN="${DRY_RUN:-false}"

while [ $# -gt 0 ]; do
  case "$1" in
    -f|--file) FILE="$2"; shift 2 ;;
    -r|--repo) REPO="$2"; shift 2 ;;
    -c|--commit) COMMIT_SHA="$2"; shift 2 ;;
    --dry-run) DRY_RUN="true"; shift ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

###############################################################################
# Dependency checks
###############################################################################
need() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: '$1' is required." >&2
    exit 1
  fi
}

need gh
need jq
need sed
need grep
need tr

###############################################################################
# Repository detection
###############################################################################
if [ -z "$REPO" ]; then
  if git remote -v 2>/dev/null | grep -q 'github.com'; then
    # Extract owner/repo from first github remote
    REPO=$(git remote -v | grep -m1 'github.com' | sed -E 's#.*github.com[:/ ]([^ ]+)(\.git)? .*#\1#')
  fi
fi

if [ -z "$REPO" ]; then
  echo "ERROR: Unable to determine repository. Use -r owner/repo." >&2
  exit 1
fi

echo "Target repository: $REPO"

###############################################################################
# Helper functions
###############################################################################

run() {
  if [ "$DRY_RUN" = "true" ]; then
    echo "DRY-RUN: $*"
  else
    eval "$@"
  fi
}

ensure_milestone() {
  local title="$1"
  local desc="$2"
  if gh issue milestone view "$title" --repo "$REPO" >/dev/null 2>&1; then
    echo "Milestone exists: $title"
  else
    echo "Creating milestone: $title"
    run gh issue milestone create --repo "$REPO" --title "$title" --description "$desc"
  fi
}

# ensure_label NAME COLOR DESCRIPTION
ensure_label() {
  local name="$1"
  local color="$2"
  local desc="$3"
  if gh label view "$name" --repo "$REPO" >/dev/null 2>&1; then
    # Optional: update color/description to enforce canonical values
    run gh label edit "$name" --repo "$REPO" --color "$color" --description "$desc"
    echo "Label updated/existing: $name"
  else
    echo "Creating label: $name"
    run gh label create "$name" --repo "$REPO" --color "$color" --description "$desc"
  fi
}

# find_issue_by_id ID  -> prints issue number or empty
find_issue_by_id() {
  local id="$1"
  # Search by exact token in title
  local json
  json=$(gh issue list --repo "$REPO" --search "$id in:title" --state all --limit 200 --json number,title 2>/dev/null || echo "[]")
  echo "$json" | jq -r --arg ID "$id" '.[] | select(.title | contains($ID)) | .number' | head -n1
}

# create_or_update_issue ID TITLE MILESTONE LABELS BODY_FILE
create_or_update_issue() {
  local id="$1"
  local title="$2"
  local milestone="$3"
  local labels="$4"
  local body_file="$5"

  local issue_number
  issue_number=$(find_issue_by_id "$id" || true)

  if [ -n "$issue_number" ]; then
    echo "Updating issue #$issue_number ($id)"
    # Add missing labels (gh issue edit with --add-label)
    run gh issue edit "$issue_number" --repo "$REPO" --title "$title" --milestone "$milestone" --add-label "$labels" --body-file "$body_file"
  else
    echo "Creating issue: $title"
    run gh issue create --repo "$REPO" --title "$title" --milestone "$milestone" --label "$labels" --body-file "$body_file"
  fi
}

sanitize_priority_label() {
  echo "$1" | tr 'A-Z ' 'a-z-' | sed -E 's/-+$//'
}

###############################################################################
# Define milestones
###############################################################################
ensure_milestone "v1.0" "MVP release scope."
ensure_milestone "v1.1" "Planned post-MVP enhancements."
ensure_milestone "v1.2" "Further roadmap features."

###############################################################################
# Define labels (colors chosen for contrast)
###############################################################################
# Epic labels
ensure_label "FOUNDATION" "1f77b4" "Foundation & API Integration"
ensure_label "CONTENT"    "ff7f0e" "Content Discovery"
ensure_label "COLLECTION" "2ca02c" "Collection Management"
ensure_label "BUILD"      "d62728" "Build Intelligence"
ensure_label "IOS"        "9467bd" "iOS / Apple Platform"
ensure_label "PREMIUM"    "8c564b" "Premium Features"

# Classification
ensure_label "user-story"        "111111" "User story item"
ensure_label "priority:must-have"   "b60205" "Highest priority"
ensure_label "priority:should-have" "ffdd57" "Important"
ensure_label "priority:could-have"  "c5def5" "Nice to have"

# Story points
ensure_label "sp:3" "0e8a16" "Story points 3"
ensure_label "sp:5" "5319e7" "Story points 5"
ensure_label "sp:8" "fbca04" "Story points 8"

###############################################################################
# Parse user stories file
###############################################################################
if [ ! -f "$FILE" ]; then
  echo "ERROR: File not found: $FILE" >&2
  exit 1
fi

echo "Parsing user stories from: $FILE"

current_milestone=""
current_id=""
current_title=""
current_block=""
stories_tmp=$(mktemp)
trap 'rm -f "$stories_tmp" ' EXIT

# Heuristic milestone mapping for Apple platform features if outside release sections
map_future_story_milestone() {
  case "$1" in
    IOS-005|IOS-006|IOS-008) echo "v1.1" ;;
    IOS-007) echo "v1.2" ;;
    *) echo "v1.1" ;;
  esac
}

flush_story() {
  if [ -z "$current_id" ]; then
    return
  fi
  # Extract priority
  priority=$(echo "$current_block" | grep -E '\*\*Priority:\*\*' | sed -E 's/.*\*\*Priority:\*\* *//; s/\r//' || true)
  story_points=$(echo "$current_block" | grep -E '\*\*Story Points:\*\*' | sed -E 's/.*\*\*Story Points:\*\* *//; s/\r//' || true)

  epic=$(echo "$current_id" | cut -d'-' -f1)

  # If no milestone yet (e.g. after Apple Features section), map
  local milestone="$current_milestone"
  if [ -z "$milestone" ]; then
    milestone=$(map_future_story_milestone "$current_id")
  fi

  # Normalize
  pr_label_raw=$(echo "$priority" | tr 'A-Z' 'a-z')
  case "$pr_label_raw" in
    must*)  pr_label="priority:must-have" ;;
    should*) pr_label="priority:should-have" ;;
    could*) pr_label="priority:could-have" ;;
    *) pr_label="priority:should-have" ;;
  esac

  sp_label="sp:$story_points"
  case "$story_points" in
    3|5|8) : ;;
    *) sp_label="sp:$story_points" ;;
  esac

  # Store fields: ID|Title|Epic|PriorityLabel|SPLabel|Milestone|RawBlock
  printf '%s|%s|%s|%s|%s|%s|%s\n' "$current_id" "$current_title" "$epic" "$pr_label" "$sp_label" "$milestone" "$(printf %s "$current_block" | sed ':a;N;$!ba;s/\n/\\n/g')" >> "$stories_tmp"

  # Reset
  current_id=""
  current_title=""
  current_block=""
}

while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    "## Release v1.0"* ) flush_story; current_milestone="v1.0" ;;
    "## Release v1.1"* ) flush_story; current_milestone="v1.1" ;;
    "## Release v1.2"* ) flush_story; current_milestone="v1.2" ;;
    "#### ["*)
        # New story
        flush_story
        # Parse ID and title
        # Format: #### [FOUNDATION-001] API Key Configuration
        id_part=$(echo "$line" | sed -E 's/#### \[([^]]+)\].*/\1/')
        title_part=$(echo "$line" | sed -E 's/#### \[[^]]+\] *//')
        current_id="$id_part"
        current_title="$title_part"
        current_block="$line"$'\n'
        ;;
    *)
        if [ -n "$current_id" ]; then
          current_block+="$line"$'\n'
        fi
        ;;
  esac
done < "$FILE"

# Flush last story
flush_story

###############################################################################
# Create/update issues
###############################################################################
total=$(wc -l < "$stories_tmp" | tr -d ' ')
echo "Discovered $total user stories."

idx=0
while IFS='|' read -r sid stitle sepic spriority ssp smilestone sraw; do
  idx=$((idx+1))
  echo "[$idx/$total] Processing $sid"

  # Body construction
  tmp_body=$(mktemp)
  {
    echo "#### [$sid] $stitle"
    echo
    # Recover raw block newlines
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
if [ "$DRY_RUN" = "true" ]; then
  echo "NOTE: DRY RUN mode - no changes were applied."
fi

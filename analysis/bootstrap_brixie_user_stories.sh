#!/bin/bash

# Brixie User Stories Import Script
# This script imports user stories from the user_stories.md file as GitHub issues
# It creates labels, milestones, and issues in an idempotent manner

set -e

# Configuration
REPO_OWNER="mpwg"
REPO_NAME="Brixie-Apple"
GITHUB_API_URL="https://api.github.com"

# Check if GitHub CLI is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed. Please install it first."
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Error: GitHub CLI is not authenticated. Please run 'gh auth login' first."
    exit 1
fi

echo "Starting import of user stories for $REPO_OWNER/$REPO_NAME..."

# Function to create or update a label
create_label() {
    local name="$1"
    local color="$2"
    local description="$3"
    
    if gh api "repos/$REPO_OWNER/$REPO_NAME/labels/$name" &> /dev/null; then
        echo "Label '$name' already exists, updating..."
        gh api -X PATCH "repos/$REPO_OWNER/$REPO_NAME/labels/$name" \
            -f color="$color" \
            -f description="$description" &> /dev/null
    else
        echo "Creating label '$name'..."
        gh api -X POST "repos/$REPO_OWNER/$REPO_NAME/labels" \
            -f name="$name" \
            -f color="$color" \
            -f description="$description" &> /dev/null
    fi
}

# Function to create or update a milestone
create_milestone() {
    local title="$1"
    local description="$2"
    local due_date="$3"
    
    # Check if milestone exists
    local existing_milestone=$(gh api "repos/$REPO_OWNER/$REPO_NAME/milestones" --jq ".[] | select(.title == \"$title\") | .number" 2>/dev/null || echo "")
    
    if [[ -n "$existing_milestone" ]]; then
        echo "Milestone '$title' already exists (number: $existing_milestone)"
    else
        echo "Creating milestone '$title'..."
        if [[ -n "$due_date" ]]; then
            gh api -X POST "repos/$REPO_OWNER/$REPO_NAME/milestones" \
                -f title="$title" \
                -f description="$description" \
                -f due_on="$due_date" &> /dev/null
        else
            gh api -X POST "repos/$REPO_OWNER/$REPO_NAME/milestones" \
                -f title="$title" \
                -f description="$description" &> /dev/null
        fi
    fi
}

# Function to create an issue if it doesn't exist
create_issue() {
    local title="$1"
    local body="$2"
    local labels="$3"
    local milestone="$4"
    local assignees="$5"
    
    # Check if issue with this title already exists
    local existing_issue=$(gh api "repos/$REPO_OWNER/$REPO_NAME/issues" --jq ".[] | select(.title == \"$title\") | .number" 2>/dev/null || echo "")
    
    if [[ -n "$existing_issue" ]]; then
        echo "Issue '$title' already exists (number: $existing_issue)"
        return
    fi
    
    echo "Creating issue '$title'..."
    
    # Build the API call
    local api_data="{\"title\": \"$title\", \"body\": \"$body\""
    
    if [[ -n "$labels" ]]; then
        api_data="$api_data, \"labels\": [$labels]"
    fi
    
    if [[ -n "$milestone" ]]; then
        local milestone_number=$(gh api "repos/$REPO_OWNER/$REPO_NAME/milestones" --jq ".[] | select(.title == \"$milestone\") | .number" 2>/dev/null || echo "")
        if [[ -n "$milestone_number" ]]; then
            api_data="$api_data, \"milestone\": $milestone_number"
        fi
    fi
    
    if [[ -n "$assignees" ]]; then
        api_data="$api_data, \"assignees\": [$assignees]"
    fi
    
    api_data="$api_data}"
    
    gh api -X POST "repos/$REPO_OWNER/$REPO_NAME/issues" --input - <<< "$api_data" &> /dev/null
}

echo "Creating labels..."

# Epic labels
create_label "epic:foundation" "0052cc" "Foundation & API Integration Epic"
create_label "epic:content" "1d76db" "Content Discovery Epic" 
create_label "epic:collection" "0e8a16" "Collection Management Epic"
create_label "epic:build" "d73a4a" "Build Intelligence Epic"
create_label "epic:ios" "5319e7" "iOS Experience Epic"
create_label "epic:premium" "fbca04" "Premium Features Epic"

# Priority labels
create_label "priority:must-have" "d73a4a" "Must Have - Critical for MVP"
create_label "priority:should-have" "fbca04" "Should Have - Important but not critical"
create_label "priority:could-have" "0052cc" "Could Have - Nice to have features"

# Story point labels
create_label "story-points:3" "c2e0c6" "3 Story Points"
create_label "story-points:5" "7057ff" "5 Story Points"
create_label "story-points:8" "d93f0b" "8 Story Points"

# Type labels
create_label "type:feature" "a2eeef" "New feature implementation"
create_label "type:enhancement" "84b6eb" "Enhancement to existing feature"

echo "Creating milestones..."

create_milestone "Release v1.0 (MVP)" "Minimum Viable Product release with core functionality" "2025-12-31T23:59:59Z"
create_milestone "Release v1.1" "First iteration after MVP" "2026-03-31T23:59:59Z"
create_milestone "Release v1.2" "Second iteration with advanced features" "2026-06-30T23:59:59Z"

echo "Creating issues for user stories..."

# FOUNDATION-001: API Key Configuration
create_issue "[FOUNDATION-001] API Key Configuration" \
"**As a** developer of Brixie,
**I want** to provide the App securely with an API key once during compilation,
**So that** Users can access Rebrickable API.

## Acceptance Criteria
- [ ] Compilation provides an option to enter the API Key from a build environment variable
- [ ] The Build process fails when no API Key is injected
- [ ] API key is securely compiled in the App
- [ ] The build process injects it into the app
- [ ] API key is used for all subsequent API calls

## API Requirements
- Primary Endpoint: All authenticated endpoints
- Authentication: API key in header

## Technical Considerations
- Error handling for missing keys

**Story Points:** 3
**Priority:** Must Have" \
"\"epic:foundation\", \"priority:must-have\", \"story-points:3\", \"type:feature\"" \
"Release v1.0 (MVP)" \
"\"mpwg\""

# FOUNDATION-002: Offline Mode Support
create_issue "[FOUNDATION-002] Offline Mode Support" \
"**As a** user,
**I want** the app to function with previously loaded data when offline,
**So that** I can view my collection and saved items without an internet connection.

## Acceptance Criteria
- [ ] App detects network connectivity status
- [ ] Previously viewed data is cached and accessible offline
- [ ] Clear indication of offline status is shown
- [ ] Automatic sync when connectivity is restored
- [ ] Appropriate error messages when trying to load new data offline

## Technical Considerations
- CoreData or similar for local storage
- Network reachability monitoring
- Data synchronization strategy

**Story Points:** 5
**Priority:** Should Have" \
"\"epic:foundation\", \"priority:should-have\", \"story-points:5\", \"type:feature\"" \
"Release v1.0 (MVP)" \
"\"mpwg\""

# FOUNDATION-003: App Settings and Preferences
create_issue "[FOUNDATION-003] App Settings and Preferences" \
"**As a** user,
**I want** to configure app settings and preferences,
**So that** I can personalize my experience.

## Acceptance Criteria
- [ ] Settings for display preferences (grid/list views)
- [ ] Cache management options
- [ ] Data usage controls
- [ ] Theme selection (light/dark/system)
- [ ] Regional settings (units, currency)

## Technical Considerations
- UserDefaults integration
- Settings bundle for iOS
- Support for dynamic theme switching

**Story Points:** 3
**Priority:** Should Have" \
"\"epic:foundation\", \"priority:should-have\", \"story-points:3\", \"type:feature\"" \
"Release v1.0 (MVP)" \
"\"mpwg\""

# CONTENT-001: Browse MOCs with Filtering
create_issue "[CONTENT-001] Browse MOCs with Filtering" \
"**As a** LEGO enthusiast,
**I want** to browse and search MOCs with filtering options,
**So that** I can discover builds that interest me.

## Acceptance Criteria
- [ ] Grid/list view of MOCs with images
- [ ] Filter by theme, parts count, and difficulty
- [ ] Sort by popularity, newest, etc.
- [ ] Search by name or description
- [ ] Pagination support for efficient loading
- [ ] Image caching for performance

## API Requirements
- Primary Endpoint: MOCs related endpoints

## Technical Considerations
- Image loading and caching library
- Efficient list rendering for performance
- Filter state persistence

**Story Points:** 5
**Priority:** Must Have" \
"\"epic:content\", \"priority:must-have\", \"story-points:5\", \"type:feature\"" \
"Release v1.0 (MVP)" \
"\"mpwg\""

# CONTENT-002: Set Details View
create_issue "[CONTENT-002] Set Details View" \
"**As a** LEGO collector,
**I want** to view detailed information about official LEGO sets,
**So that** I can learn about sets I own or am interested in.

## Acceptance Criteria
- [ ] Display set number, name, theme, and year
- [ ] Show part count and minifigure count
- [ ] Display high-quality set image
- [ ] Show pricing information (if available)
- [ ] List included minifigures with thumbnails
- [ ] Option to add to my collection

## API Requirements
- Primary Endpoint: \`/api/v3/lego/sets/{set_num}/\`
- Supporting Endpoints: 
  - \`/api/v3/lego/sets/{set_num}/minifigs/\`
  - \`/api/v3/lego/sets/{set_num}/parts/\`

## Technical Considerations
- Efficient loading of related data
- Image caching
- Local storage for collection management

**Story Points:** 3
**Priority:** Must Have" \
"\"epic:content\", \"priority:must-have\", \"story-points:3\", \"type:feature\"" \
"Release v1.0 (MVP)" \
"\"mpwg\""

# CONTENT-003: Part Browser and Details
create_issue "[CONTENT-003] Part Browser and Details" \
"**As a** LEGO builder,
**I want** to browse and search the parts database,
**So that** I can find specific parts I need or am interested in.

## Acceptance Criteria
- [ ] Browse parts by category
- [ ] Search by part name or number
- [ ] Filter by color, category, and year
- [ ] View detailed part information
- [ ] See what sets a part appears in
- [ ] View part in different colors

## API Requirements
- Primary Endpoint: \`/api/v3/lego/parts/\`
- Supporting Endpoints:
  - \`/api/v3/lego/parts/{part_num}/\`
  - \`/api/v3/lego/parts/{part_num}/colors/\`
  - \`/api/v3/lego/parts/{part_num}/colors/{color_id}/sets/\`

## Technical Considerations
- Efficient catalog navigation
- Image caching
- Search optimization

**Story Points:** 5
**Priority:** Should Have" \
"\"epic:content\", \"priority:should-have\", \"story-points:5\", \"type:feature\"" \
"Release v1.0 (MVP)" \
"\"mpwg\""

# COLLECTION-001: Add Sets to My Collection
create_issue "[COLLECTION-001] Add Sets to My Collection" \
"**As a** LEGO collector,
**I want** to add sets to my personal collection in the app,
**So that** I can keep track of what I own.

## Acceptance Criteria
- [ ] Add sets by scanning barcode or set number
- [ ] Manual search and add functionality
- [ ] Specify quantity owned
- [ ] Add optional notes per set
- [ ] Local storage with iCloud sync
- [ ] Batch import option

## API Requirements
- Primary Endpoint: \`/api/v3/lego/sets/{set_num}/\`

## Technical Considerations
- CoreData with iCloud sync
- Barcode scanning capability
- Efficient search interface

**Story Points:** 5
**Priority:** Must Have" \
"\"epic:collection\", \"priority:must-have\", \"story-points:5\", \"type:feature\"" \
"Release v1.0 (MVP)" \
"\"mpwg\""

# COLLECTION-002: Collection Statistics and Insights
create_issue "[COLLECTION-002] Collection Statistics and Insights" \
"**As a** LEGO collector,
**I want** to view statistics and insights about my collection,
**So that** I can better understand what I own.

## Acceptance Criteria
- [ ] Total set count and part count
- [ ] Distribution by theme
- [ ] Value estimation (if pricing data available)
- [ ] Collection history and growth over time
- [ ] Visual charts and graphs
- [ ] Export reports

## Technical Considerations
- Local analytics processing
- Chart/graph libraries
- PDF/CSV export capability

**Story Points:** 5
**Priority:** Should Have" \
"\"epic:collection\", \"priority:should-have\", \"story-points:5\", \"type:feature\"" \
"Release v1.0 (MVP)" \
"\"mpwg\""

# COLLECTION-003: iCloud Sync for Collection Data
create_issue "[COLLECTION-003] iCloud Sync for Collection Data" \
"**As an** Apple ecosystem user,
**I want** my collection data to sync across my devices,
**So that** I have consistent access regardless of which device I'm using.

## Acceptance Criteria
- [ ] Automatic sync of collection data via iCloud
- [ ] Conflict resolution for simultaneous edits
- [ ] Background sync with status indicators
- [ ] Option to enable/disable sync
- [ ] Error recovery for sync issues

## Technical Considerations
- CloudKit integration
- CoreData with NSPersistentCloudKitContainer
- Conflict resolution strategy
- Bandwidth and storage optimization

**Story Points:** 8
**Priority:** Must Have" \
"\"epic:collection\", \"priority:must-have\", \"story-points:8\", \"type:feature\"" \
"Release v1.0 (MVP)" \
"\"mpwg\""

# BUILD-001: Part Inventory Analysis
create_issue "[BUILD-001] Part Inventory Analysis" \
"**As a** LEGO builder,
**I want** to analyze what parts I own based on my collection,
**So that** I know what I can build.

## Acceptance Criteria
- [ ] Calculate total inventory based on owned sets
- [ ] Account for quantity of each set owned
- [ ] Search and filter parts inventory
- [ ] View parts by category or color
- [ ] Export part list

## API Requirements
- Primary Endpoint: \`/api/v3/lego/sets/{set_num}/parts/\`

## Technical Considerations
- Efficient local database for parts inventory
- Complex calculation logic
- Memory management for large collections

**Story Points:** 8
**Priority:** Should Have" \
"\"epic:build\", \"priority:should-have\", \"story-points:8\", \"type:feature\"" \
"Release v1.0 (MVP)" \
"\"mpwg\""

# BUILD-002: "What Can I Build?" Feature
create_issue "[BUILD-002] \"What Can I Build?\" Feature" \
"**As a** LEGO collector,
**I want** to see what MOCs I can build with my existing parts,
**So that** I can make the most of my collection.

## Acceptance Criteria
- [ ] Compare user's part inventory with MOC requirements
- [ ] Show match percentage for partially buildable MOCs
- [ ] List missing parts for near-matches
- [ ] Filter by build completeness percentage
- [ ] Sort by most buildable

## API Requirements
- Primary Endpoint: MOC-related endpoints and parts data

## Technical Considerations
- Complex comparison algorithm
- Performance optimization for large collections
- Local processing of inventory data

**Story Points:** 8
**Priority:** Could Have" \
"\"epic:build\", \"priority:could-have\", \"story-points:8\", \"type:feature\"" \
"Release v1.1" \
"\"mpwg\""

# IOS-001: Widget Support
create_issue "[IOS-001] Widget Support" \
"**As an** iOS user,
**I want** home screen widgets showing collection stats or random sets,
**So that** I can quickly access information without opening the app.

## Acceptance Criteria
- [ ] Small, medium, and large widget options
- [ ] Collection statistics widget
- [ ] \"Random set from my collection\" widget
- [ ] \"Set of the day\" widget
- [ ] Configurable widget options
- [ ] Tappable areas that deep-link into the app

## Technical Considerations
- WidgetKit implementation
- Timeline providers for data updates
- Memory and performance constraints
- Deep linking architecture

**Story Points:** 5
**Priority:** Should Have" \
"\"epic:ios\", \"priority:should-have\", \"story-points:5\", \"type:feature\"" \
"Release v1.0 (MVP)" \
"\"mpwg\""

# IOS-002: Spotlight Search Integration
create_issue "[IOS-002] Spotlight Search Integration" \
"**As an** iOS user,
**I want** my LEGO collection to be searchable via Spotlight,
**So that** I can quickly find sets without opening the app.

## Acceptance Criteria
- [ ] Index sets in user's collection for Spotlight search
- [ ] Include set numbers, names, and themes in search metadata
- [ ] Tapping search result opens directly to the set detail
- [ ] Update search index when collection changes
- [ ] Respect iOS energy and performance guidelines

## Technical Considerations
- Core Spotlight framework integration
- Search indexing strategy
- Deep linking to specific content

**Story Points:** 3
**Priority:** Could Have" \
"\"epic:ios\", \"priority:could-have\", \"story-points:3\", \"type:feature\"" \
"Release v1.1" \
"\"mpwg\""

# IOS-003: Shortcuts App Integration
create_issue "[IOS-003] Shortcuts App Integration" \
"**As an** iOS power user,
**I want** to create shortcuts that interact with the app,
**So that** I can automate common tasks.

## Acceptance Criteria
- [ ] Shortcuts for adding sets to collection
- [ ] Shortcuts for searching sets/parts
- [ ] Shortcuts for viewing collection statistics
- [ ] Support for parameters in shortcuts
- [ ] Voice command support via Siri

## Technical Considerations
- SiriKit and Shortcuts framework implementation
- Intent definition and handling
- Parameter passing and validation

**Story Points:** 5
**Priority:** Could Have" \
"\"epic:ios\", \"priority:could-have\", \"story-points:5\", \"type:feature\"" \
"Release v1.1" \
"\"mpwg\""

# IOS-004: iCloud Backup Support
create_issue "[IOS-004] iCloud Backup Support" \
"**As an** iOS user,
**I want** my collection data included in device backups,
**So that** I don't lose my data if I switch devices.

## Acceptance Criteria
- [ ] Collection data included in iCloud backups
- [ ] Proper data restoration after app reinstall
- [ ] Clear documentation on backup/restore process
- [ ] Minimal backup size through efficient data storage

## Technical Considerations
- iOS backup API integration
- Data storage optimization
- Recovery testing

**Story Points:** 3
**Priority:** Must Have" \
"\"epic:ios\", \"priority:must-have\", \"story-points:3\", \"type:feature\"" \
"Release v1.0 (MVP)" \
"\"mpwg\""

# PREMIUM-001: Import from CSV/Spreadsheet
create_issue "[PREMIUM-001] Import from CSV/Spreadsheet" \
"**As a** serious LEGO collector,
**I want** to import my collection from a spreadsheet or CSV file,
**So that** I don't have to manually enter large collections.

## Acceptance Criteria
- [ ] Support standard file formats (CSV, Excel)
- [ ] Column mapping for flexible import
- [ ] Preview before import
- [ ] Error handling for invalid data
- [ ] Import progress indicator
- [ ] Summary report after import

## Technical Considerations
- File handling in iOS
- Document picker integration
- Parse library for spreadsheet formats
- Error handling strategy

**Story Points:** 5
**Priority:** Could Have" \
"\"epic:premium\", \"priority:could-have\", \"story-points:5\", \"type:feature\"" \
"Release v1.1" \
"\"mpwg\""

# PREMIUM-002: Advanced Collection Analytics
create_issue "[PREMIUM-002] Advanced Collection Analytics" \
"**As a** premium user,
**I want** advanced analytics about my collection,
**So that** I can gain deeper insights into my LEGO holdings.

## Acceptance Criteria
- [ ] Value tracking over time
- [ ] Rarity analysis
- [ ] Completion percentage for themes
- [ ] Investment performance metrics
- [ ] Comparative analysis to global averages
- [ ] Visual reports and charts

## Technical Considerations
- Complex local data processing
- Chart/visualization libraries
- Data aggregation strategies

**Story Points:** 8
**Priority:** Could Have" \
"\"epic:premium\", \"priority:could-have\", \"story-points:8\", \"type:feature\"" \
"Release v1.2" \
"\"mpwg\""

# IOS-005: App Clips
create_issue "[IOS-005] App Clips" \
"**As a** potential user,
**I want** to try core app functionality via App Clips,
**So that** I can experience the app before downloading the full version.

## Acceptance Criteria
- [ ] App Clip for scanning a set and viewing details
- [ ] Small footprint (<10MB) App Clip experience
- [ ] Clear path to download full app
- [ ] Cached data transfer when upgrading to full app
- [ ] App Clip Card with engaging visuals

## Technical Considerations
- App Clips framework implementation
- Code sharing between main app and App Clip
- Size optimization

**Story Points:** 8
**Priority:** Could Have" \
"\"epic:ios\", \"priority:could-have\", \"story-points:8\", \"type:feature\"" \
"Release v1.2" \
"\"mpwg\""

# IOS-006: Multi-platform Support
create_issue "[IOS-006] Multi-platform Support" \
"**As an** Apple ecosystem user,
**I want** the app to work across iPhone, iPad, and Mac (via Catalyst),
**So that** I have a consistent experience across all my devices.

## Acceptance Criteria
- [ ] Responsive UI that adapts to different screen sizes
- [ ] iPad-specific optimizations (split view, popovers)
- [ ] Mac Catalyst support with keyboard shortcuts
- [ ] Consistent data access across platforms
- [ ] Device-specific feature utilization

## Technical Considerations
- SwiftUI for responsive interface
- UIKit adaptations where needed
- Catalyst-specific adjustments
- Input method abstraction

**Story Points:** 8
**Priority:** Should Have" \
"\"epic:ios\", \"priority:should-have\", \"story-points:8\", \"type:feature\"" \
"Release v1.1" \
"\"mpwg\""

# IOS-007: AR Parts Visualization
create_issue "[IOS-007] AR Parts Visualization" \
"**As an** iOS user,
**I want** to visualize LEGO parts in AR,
**So that** I can see how they look in real-world context.

## Acceptance Criteria
- [ ] AR view for supported parts
- [ ] Ability to place part in real environment
- [ ] Scale adjustments
- [ ] Multiple part viewing in same scene
- [ ] Screenshot/recording capabilities

## Technical Considerations
- ARKit implementation
- 3D model conversion/acquisition
- Performance optimization
- Device compatibility checking

**Story Points:** 8
**Priority:** Could Have" \
"\"epic:ios\", \"priority:could-have\", \"story-points:8\", \"type:feature\"" \
"Release v1.2" \
"\"mpwg\""

# IOS-008: Focus Modes Integration
create_issue "[IOS-008] Focus Modes Integration" \
"**As an** iOS user,
**I want** the app to respect my Focus modes,
**So that** notifications and interactions match my current activity status.

## Acceptance Criteria
- [ ] Adapt notifications based on Focus state
- [ ] Custom Focus filter support
- [ ] Time Sensitive notification classification when appropriate
- [ ] Activity-aware UI adjustments

## Technical Considerations
- Focus API integration
- Notification priority management
- UI state management based on Focus

**Story Points:** 3
**Priority:** Should Have" \
"\"epic:ios\", \"priority:should-have\", \"story-points:3\", \"type:feature\"" \
"Release v1.2" \
"\"mpwg\""

echo ""
echo "Import completed successfully!"
echo ""
echo "Summary:"
echo "- Created 6 epic labels"
echo "- Created 3 priority labels"
echo "- Created 3 story point labels"  
echo "- Created 2 type labels"
echo "- Created 3 milestones"
echo "- Created 20 user story issues"
echo ""
echo "You can view the imported issues at: https://github.com/$REPO_OWNER/$REPO_NAME/issues"
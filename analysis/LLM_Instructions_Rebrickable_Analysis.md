# LLM Instructions: Rebrickable Website Analysis and Mobile App User Stories

## Objective
Analyze the Rebrickable website (https://rebrickable.com/) and create detailed user stories for developing a mobile application that serves as a front-end to the Rebrickable LEGO database using their official API.

## Phase 1: Website Analysis

### 1.1 Deep Website Analysis Tasks
Perform a comprehensive analysis of the Rebrickable website by examining:

1. **Main Landing Page Analysis**
   - Analyze https://rebrickable.com/ for core features and value propositions
   - Identify primary user actions and call-to-action elements
   - Document the main navigation structure and user flows

2. **Sitemap Exploration**
   - Review the sitemap at https://rebrickable.com/sitemap.xml
   - Explore key subsections like:
     - MOCs (My Own Creations) section
     - Sets catalog
     - Parts database
     - User profiles and accounts
     - Build functionality
     - Search and discovery features

3. **Core Feature Identification**
   Based on initial analysis, focus on these key areas:
   - **MOC Discovery**: 164,000+ custom LEGO designs with building instructions
   - **Collection Management**: Organize and track personal LEGO collections
   - **Build Matching**: Find MOCs buildable with existing parts
   - **Set Information**: Access to 25,524+ official LEGO sets
   - **Parts Database**: 59,589+ LEGO parts catalog
   - **Minifigure Database**: 16,021+ minifigures
   - **Designer Community**: Follow creators and designers
   - **Marketplace**: Premium MOC buying/selling
   - **Alternative Builds**: Rebuild existing sets into new creations

### 1.2 User Journey Mapping
Document typical user journeys for:
- New LEGO enthusiasts discovering MOCs
- Experienced builders managing large collections
- MOC designers sharing/selling creations
- Casual users looking for building inspiration

### 1.3 API Capabilities Review
Cross-reference website features with the provided OpenAPI specification to identify:
- Which features can be implemented via API
- API limitations that might affect mobile experience
- Additional features that could enhance mobile usage

## Phase 2: User Story Creation

### 2.1 User Story Guidelines
Follow these best practices when creating user stories:

**Format**: Use the standard format:
```
As a [user type],
I want [functionality],
So that [benefit/value].
```

**Acceptance Criteria**: Each story must include:
- Clear, testable acceptance criteria
- Definition of Done
- API endpoints required
- Mock-up/wireframe suggestions

**Story Sizing**: Split stories to be:
- Implementable within 1-3 days by a developer
- Independently testable
- Deliverable as standalone features

### 2.2 User Personas
Create stories for these primary personas:

1. **LEGO Collector** - Manages large LEGO collection, wants to find buildable MOCs
2. **Casual Builder** - Occasional LEGO fan looking for inspiration and simple builds
3. **MOC Designer** - Creates and shares custom designs, wants community engagement
4. **LEGO Parent** - Helps children find age-appropriate builds and manage family collection
5. **Set Completionist** - Focuses on official LEGO sets, alternative builds, and set information

### 2.3 Story Categories
Organize user stories into these categories:

#### Core Features (MVP - Release 1.0)
- User authentication and profile management
- MOC browsing and search
- Basic collection management
- Set and parts lookup
- Favorites and wish lists

#### Enhanced Features (Release 1.1)
- Advanced search and filtering
- Build matching with user's collection
- Designer following and notifications
- Alternative build discovery
- Detailed part information

#### Premium Features (Release 1.2+)
- Premium MOC marketplace integration
- Advanced collection analytics
- Social features and community
- AR/camera features for part recognition
- Offline capabilities

## Phase 3: GitHub Issues Creation

### 3.1 Issue Structure
Create each GitHub issue with:

**Title Format**: `[EPIC/STORY] Brief descriptive title`

**Issue Template**:
```markdown
## User Story
As a [user type],
I want [functionality],
So that [benefit].

## Description
[Detailed description of the feature]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## API Requirements
- Endpoint: [API endpoint from legoAPI.yaml]
- Authentication: [Required auth level]
- Data model: [Expected data structure]

## Technical Notes
- [Any technical considerations]
- [Dependencies on other stories]
- [Performance considerations]

## Design Considerations
- [UI/UX requirements]
- [Mobile-specific considerations]
- [Accessibility requirements]

## Definition of Done
- [ ] Feature implemented and tested
- [ ] Unit tests written
- [ ] API integration tested
- [ ] UI/UX reviewed
- [ ] Documentation updated

## Priority: [High/Medium/Low]
## Estimate: [1-5 story points]
## Labels: [epic/story/bug/enhancement]
```

### 3.2 Epic Organization
Create epics for major feature areas:
- **User Management Epic**
- **MOC Discovery Epic**
- **Collection Management Epic**
- **Set Information Epic**
- **Search & Discovery Epic**
- **Community Features Epic**

## Phase 4: Milestone Planning

### 4.1 Release Strategy

**Release 1.0 (MVP) - Core Functionality**
Target: 3-4 months
Focus: Essential features that provide immediate value

Priority Stories:
- User registration and authentication
- Browse and search MOCs
- View MOC details and instructions
- Basic user profile
- Favorite MOCs
- Browse official sets
- Basic parts lookup

**Release 1.1 - Enhanced Discovery**
Target: 2-3 months after 1.0
Focus: Improved user experience and discovery

Priority Stories:
- Advanced search and filtering
- Collection management basics
- Designer profiles and following
- Alternative builds
- Improved navigation and UI

**Release 1.2 - Community & Premium**
Target: 3-4 months after 1.1
Focus: Community features and premium functionality

Priority Stories:
- Premium MOC marketplace
- Advanced collection features
- Social features and sharing
- Build matching with user collection
- Notifications and updates

### 4.2 Story Prioritization Framework
Use MoSCoW method:
- **Must Have**: Core functionality for MVP
- **Should Have**: Important for user experience
- **Could Have**: Nice-to-have features
- **Won't Have**: Future consideration

Consider these factors for prioritization:
1. **User Value**: How much value does this provide to users?
2. **Technical Complexity**: How difficult is it to implement?
3. **API Dependency**: Does the API support this feature?
4. **Mobile Optimization**: How well does this work on mobile?
5. **Business Impact**: Does this drive user engagement/retention?

## Phase 5: Quality Assurance

### 5.1 Story Validation Checklist
Ensure each story meets these criteria:
- [ ] Follows standard user story format
- [ ] Has clear, testable acceptance criteria
- [ ] Is appropriately sized (1-5 story points)
- [ ] Includes API requirements
- [ ] Has technical and design considerations
- [ ] Is assigned to appropriate milestone
- [ ] Has correct priority and labels

### 5.2 Mobile-First Considerations
Ensure all stories consider:
- Touch interface optimization
- Responsive design requirements
- Performance on mobile networks
- Battery usage implications
- Platform-specific features (iOS/Android)
- Accessibility on mobile devices

## Deliverables Expected

1. **Comprehensive Website Analysis Report**
   - Feature inventory
   - User journey documentation
   - API capability mapping

2. **Complete User Story Backlog**
   - 50-100 well-defined user stories
   - Organized by epics and themes
   - Properly sized and estimated

3. **GitHub Issues**
   - All stories created as GitHub issues
   - Proper labeling and milestone assignment
   - Epic linking and organization

4. **Milestone Roadmap**
   - 3-release roadmap with clear goals
   - Story distribution across releases
   - Time estimates and dependencies

5. **Priority Matrix**
   - All stories prioritized using MoSCoW
   - Justification for priority decisions
   - Release 1.0 scope clearly defined

## Success Criteria

The final deliverable should provide:
- Clear roadmap for MVP mobile app development
- Implementable user stories with technical specifications
- Strategic release planning for sustainable development
- Foundation for agile development process
- Comprehensive understanding of Rebrickable ecosystem for mobile context

Remember: Focus on creating a mobile-first experience that leverages the rich Rebrickable database while providing intuitive, touch-optimized interfaces for LEGO enthusiasts of all levels.

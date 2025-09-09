# User Story Template for Rebrickable Mobile App

## Template for Creating Consistent User Stories

Use this template for each user story to ensure consistency and completeness.

---

### Issue Title Format
`[EPIC-ID] Brief descriptive title (1-7 words)`

Examples:
- `[AUTH-001] User login with Rebrickable account`
- `[CONTENT-001] Browse MOCs with basic filters`
- `[COLLECTION-001] Add sets to personal collection`

---

### Issue Body Template

```markdown
## User Story
As a [specific user persona],
I want [specific functionality],
So that [clear benefit/outcome].

## Description
[2-3 sentences providing context and explaining the feature in detail. Include any important business rules or constraints.]

## Acceptance Criteria
- [ ] [Specific, testable criterion 1]
- [ ] [Specific, testable criterion 2]
- [ ] [Specific, testable criterion 3]
- [ ] [Additional criteria as needed - aim for 3-7 total]

## API Requirements
- **Primary Endpoint**: `[main API endpoint from legoAPI.yaml]`
- **Supporting Endpoints**: `[any additional endpoints needed]`
- **Authentication**: [Required/Optional/Token-based]
- **Rate Limiting**: [Considerations for mobile usage]
- **Data Model**: [Expected response structure]

## Technical Considerations
- **Mobile Optimization**: [Specific mobile requirements]
- **Performance**: [Loading time expectations, data usage]
- **Offline Support**: [What functionality works without internet]
- **Platform Features**: [iOS/Android specific considerations]
- **Dependencies**: [Other stories that must be completed first]

## UI/UX Requirements
- **Screen Layout**: [Brief description of interface layout]
- **Navigation**: [How users access this feature]
- **Interactions**: [Touch gestures, animations, transitions]
- **Accessibility**: [Screen reader, voice control, contrast requirements]
- **Error States**: [How errors are displayed and handled]

## Testing Requirements
- **Unit Tests**: [Key functions/methods to test]
- **Integration Tests**: [API integration scenarios]
- **UI Tests**: [User interaction flows to test]
- **Edge Cases**: [Boundary conditions and error scenarios]

## Definition of Done
- [ ] Feature implemented according to acceptance criteria
- [ ] Unit tests written and passing
- [ ] API integration tested with error handling
- [ ] UI tested on multiple device sizes (iPhone SE, iPhone Pro, iPad)
- [ ] Accessibility requirements verified
- [ ] Performance benchmarks met
- [ ] Code reviewed and approved
- [ ] Documentation updated

## Estimates and Priority
- **Story Points**: [1, 2, 3, 5, 8 using Fibonacci sequence]
- **Priority**: [Must Have/Should Have/Could Have/Won't Have]
- **Complexity**: [Low/Medium/High/Very High]

## Labels to Apply
- Epic: `epic:[authentication|content|collection|build|community|premium]`
- Priority: `priority:[must-have|should-have|could-have]`
- Complexity: `complexity:[low|medium|high|very-high]`
- Platform: `platform:[ios|android|all]`
- Type: `type:[feature|enhancement|bug]`
```

---

## Epic Categories and Prefixes

Use these standardized epic prefixes for issue titles:

| Epic | Prefix | Description |
|------|---------|-------------|
| Foundation & Authentication | AUTH | Login, registration, user management |
| Content Discovery | CONTENT | Browsing MOCs, sets, parts, search |
| Collection Management | COLLECTION | Managing personal LEGO collections |
| Build Intelligence | BUILD | Build matching, suggestions, analysis |
| Community Features | COMMUNITY | Social features, following, sharing |
| Premium Features | PREMIUM | Marketplace, subscriptions, advanced features |

---

## Priority Guidelines

### Must Have (MVP - v1.0)
**Criteria**: Essential for core value proposition
- User authentication and basic profile
- Browse and search MOCs/sets
- View details and instructions
- Basic favorites functionality
- Responsive mobile interface

**Characteristics**:
- Blocks other features if not implemented
- Provides immediate user value
- Core to the app's purpose
- Well-supported by API

### Should Have (v1.1)
**Criteria**: Important for user experience but not critical
- Advanced search and filtering
- Collection management basics
- Designer profiles and following
- Alternative builds discovery
- Enhanced UI/UX features

**Characteristics**:
- Significantly improves user experience
- Can be delayed without breaking core functionality
- May have some API limitations but workable
- Differentiates from basic functionality

### Could Have (v1.2+)
**Criteria**: Nice to have features for competitive advantage
- Collection sync with Rebrickable
- Build matching with personal collection
- Premium MOC marketplace
- Advanced analytics and insights
- Social sharing features

**Characteristics**:
- Enhances user engagement
- May require complex implementation
- Could have API limitations requiring workarounds
- Provides competitive differentiation

### Won't Have (This Release)
**Criteria**: Out of scope for planned releases
- Features requiring significant API changes
- Complex social features beyond basic following
- Advanced AR/VR functionality
- Complex inventory management
- Third-party marketplace integrations

---

## Story Sizing Guide

Use Fibonacci sequence for story points:

- **1 Point**: Simple configuration changes, basic UI updates
- **2 Points**: Simple feature addition with minimal complexity
- **3 Points**: Standard feature with API integration and basic UI
- **5 Points**: Complex feature with multiple API calls and advanced UI
- **8 Points**: Very complex feature requiring significant architecture

**Guidelines**:
- If a story is more than 8 points, split it into smaller stories
- Consider dependencies and technical complexity
- Account for testing and documentation time
- Include API integration complexity in estimates

---

## Quality Checklist

Before creating each GitHub issue, verify:

### Story Quality
- [ ] Follows "As a... I want... So that..." format
- [ ] Specific user persona identified
- [ ] Clear benefit/value articulated
- [ ] Story is independently valuable

### Acceptance Criteria
- [ ] 3-7 specific, testable criteria
- [ ] Criteria are measurable
- [ ] Success conditions are clear
- [ ] Edge cases considered

### Technical Details
- [ ] API endpoints identified and verified in legoAPI.yaml
- [ ] Authentication requirements specified
- [ ] Mobile-specific considerations included
- [ ] Performance expectations defined

### Implementation Ready
- [ ] Story is appropriately sized (1-8 points)
- [ ] Dependencies clearly identified
- [ ] Technical approach is feasible
- [ ] Testing strategy outlined

### Milestone Alignment
- [ ] Priority matches milestone assignment
- [ ] Story supports milestone goals
- [ ] Dependencies don't cross milestone boundaries
- [ ] Effort distribution is balanced across milestones

---

This template ensures consistency and completeness across all user stories while maintaining focus on mobile-first development and API-driven functionality.

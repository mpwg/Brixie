# Instructions for LLM: Complete Rebrickable Mobile App Analysis

## Overview

You are tasked with creating a comprehensive analysis of the Rebrickable website and generating detailed user stories for a mobile application. This project will use the official Rebrickable API to create a mobile-first LEGO enthusiast app.

## Your Mission

Transform the Rebrickable website (https://rebrickable.com/) into a well-defined set of user stories that can guide mobile app development, prioritized across meaningful release milestones.

## Resources Provided

1. **`LLM_Instructions_Rebrickable_Analysis.md`** - Detailed technical instructions
2. **`Rebrickable_Analysis_Execution_Guide.md`** - Step-by-step execution plan  
3. **`User_Story_Template.md`** - Standardized template for user stories
4. **`legoAPI.yaml`** - Complete OpenAPI specification for Rebrickable API
5. **`import-github-issues.sh`** - Script for creating GitHub issues (reference only)

## Required Deliverables

### 1. Website Analysis Report
- Complete feature inventory of Rebrickable website
- User journey documentation for key personas
- Mobile optimization recommendations

### 2. User Story Backlog
- 50-80 detailed user stories following the provided template
- Stories organized into 6 main epics
- Each story sized and prioritized appropriately

### 3. GitHub Issues Structure
- Issues ready for import using the provided script
- Proper labeling and milestone assignment
- Clear epic organization and linking

### 4. Release Roadmap
- v1.0 (MVP): Must-have features for core value proposition
- v1.1: Should-have features for enhanced experience  
- v1.2: Could-have features for competitive advantage

## Execution Steps

### Step 1: Deep Website Analysis (2-3 hours)
1. Thoroughly explore https://rebrickable.com/
2. Document all major features and user workflows
3. Analyze the sitemap structure
4. Identify mobile optimization opportunities

### Step 2: API Mapping (1 hour)
1. Review the provided `legoAPI.yaml` specification
2. Map website features to available API endpoints
3. Identify feature gaps and limitations
4. Note mobile-specific API considerations

### Step 3: User Story Creation (4-6 hours)
1. Use the standardized template from `User_Story_Template.md`
2. Create stories for all 6 epic categories:
   - Foundation & Authentication (AUTH)
   - Content Discovery (CONTENT)
   - Collection Management (COLLECTION)
   - Build Intelligence (BUILD)
   - Community Features (COMMUNITY)
   - Premium Features (PREMIUM)

### Step 4: Prioritization & Milestone Assignment (1-2 hours)
1. Apply MoSCoW prioritization (Must/Should/Could/Won't Have)
2. Assign stories to appropriate milestones (v1.0, v1.1, v1.2)
3. Ensure balanced effort distribution across releases

### Step 5: Quality Review & Documentation (1-2 hours)
1. Validate all stories against the quality checklist
2. Create summary documentation
3. Prepare GitHub issue import structure

## Key Success Criteria

✅ **Complete Coverage**: All major Rebrickable features analyzed and addressed
✅ **API Alignment**: Stories align with available API capabilities  
✅ **Mobile Optimization**: All stories consider mobile-first design
✅ **Actionable Stories**: Each story is implementable by a development team
✅ **Strategic Prioritization**: Clear MVP definition with logical progression
✅ **Quality Standards**: All stories follow template and meet quality criteria

## Important Guidelines

### User Personas (Priority Order)
1. **LEGO Collector** (Primary) - Manages collection, seeks buildable MOCs
2. **Casual Builder** (Primary) - Occasional use, wants inspiration
3. **MOC Designer** (Secondary) - Creates content, community engagement
4. **LEGO Parent** (Secondary) - Family collection management
5. **Set Enthusiast** (Tertiary) - Official sets and alternatives

### Story Sizing
- Use Fibonacci sequence: 1, 2, 3, 5, 8 story points
- 1-2 points: Simple features with basic API integration
- 3-5 points: Standard features with complex UI or multiple API calls
- 8 points: Complex features requiring significant architecture

### Milestone Distribution Target
- **v1.0 (MVP)**: ~40% of total effort (Must-have features only)
- **v1.1**: ~35% of total effort (Should-have features)
- **v1.2**: ~25% of total effort (Could-have features)

## Quality Gates

Before considering the work complete, ensure:

### Story Quality
- Each story follows "As a... I want... So that..." format
- Acceptance criteria are specific and testable (3-7 criteria per story)
- API requirements are clearly documented
- Mobile considerations are addressed

### Technical Feasibility  
- All required API endpoints exist in legoAPI.yaml
- Authentication and rate limiting are considered
- Performance implications are noted
- Dependencies are clearly identified

### Strategic Alignment
- MVP provides clear value proposition
- Story progression is logical across releases
- Effort distribution is realistic
- Business goals are supported

## Expected Output Format

Organize your deliverables as follows:

```
/analysis-output/
├── website-analysis-report.md
├── user-stories-backlog.md
├── github-issues-export.json
├── release-roadmap.md
└── implementation-recommendations.md
```

## Timeline Expectations

**Total Estimated Time**: 8-13 hours of focused analysis and documentation

This comprehensive approach will provide the mobile development team with everything needed to begin implementing a successful Rebrickable mobile application that serves the LEGO enthusiast community effectively.

## Getting Started

1. Begin with the `Rebrickable_Analysis_Execution_Guide.md` for detailed steps
2. Use `User_Story_Template.md` for consistent story creation
3. Reference `legoAPI.yaml` for all technical requirements
4. Follow the quality criteria throughout the process

Your analysis will directly impact the success of the mobile app development, so thoroughness and attention to detail are critical.

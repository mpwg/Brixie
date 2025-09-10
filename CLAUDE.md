# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Brixie is an iOS/macOS SwiftUI application designed to be a mobile-first LEGO enthusiast app built around the Rebrickable API. The project is currently in initial development with basic SwiftUI scaffolding.

## Project Structure

```
Brixie/
├── Brixie/                    # Main app target
│   ├── BrixieApp.swift       # App entry point with SwiftData model container
│   ├── ContentView.swift     # Main navigation view
│   └── Item.swift           # Basic SwiftData model (placeholder)
├── BrixieTests/              # Unit tests using Swift Testing framework
├── BrixieUITests/           # UI tests
└── Brixie.xcodeproj         # Xcode project
```

## Architecture

- **UI Framework**: SwiftUI with NavigationSplitView for cross-platform support
- **Data Persistence**: SwiftData for local data storage
- **Target Platforms**: iOS and macOS (conditional compilation with `#if os()`)
- **Testing**: Swift Testing framework (not XCTest)

## Development Commands

### API Key Configuration
Before building the app, you must set the `REBRICKABLE_API_KEY` environment variable:
```bash
export REBRICKABLE_API_KEY="your_rebrickable_api_key_here"
```

### Building and Running
- **Build**: Use Xcode or `xcodebuild` command line tools
- **Run**: Use Xcode simulator or device deployment
- **Testing**: Use Xcode Test Navigator or `xcodebuild test` command

**Important**: The build process will fail if `REBRICKABLE_API_KEY` is not set. The API key is injected during build time via the `Scripts/inject-api-key.sh` script.

### Testing Framework
The project uses the Swift Testing framework (imported as `Testing`, not `XCTest`). Tests use `@Test` attribute and `#expect(...)` assertions.

## CI/CD Pipeline

### GitHub Actions Workflows
- **`ci.yml`**: Main CI pipeline with linting, building, and testing on multiple iOS versions
- **`pr-validation.yml`**: Pull request validation with security checks and code quality analysis
- **`release.yml`**: Automated release builds triggered by version tags

### Code Quality
- **SwiftLint**: Configured with `.swiftlint.yml` for consistent code style
- **Security validation**: Prevents accidental API key commits
- **Multi-device testing**: Tests on iPhone and iPad simulators

### Dependabot
- Automated dependency updates for Swift packages and GitHub Actions
- Configured in `.github/dependabot.yml` with weekly updates

## Future Implementation Context

The project is planned to implement a comprehensive LEGO enthusiast app with these main feature areas:
- **Authentication**: Rebrickable account integration
- **Content Discovery**: MOC browsing with filters
- **Collection Management**: Personal LEGO set tracking
- **Build Intelligence**: MOC building assistance
- **Community Features**: User interactions and sharing
- **Premium Features**: Paid content access

User stories and detailed requirements are documented in `user_stories.md` and the `analysis/` directory.

## Key Development Notes

- The app targets both iOS and macOS with platform-specific UI adaptations
- SwiftData model container is configured for persistent storage (not in-memory)
- Navigation uses NavigationSplitView for optimal cross-platform experience
- Current codebase is basic scaffolding; major features need implementation
- this app should never use UIKit or AppKit. all implementation must be Swift only if at all possible
- ensure that the project builds and all tests pass
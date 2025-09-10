# Brixie

A mobile-first LEGO enthusiast app built with SwiftUI, designed to work with the Rebrickable API.

## Setup

### Prerequisites
- Xcode 15.0+
- iOS 17.0+ or macOS 14.0+
- Rebrickable API key

### Getting Your API Key
1. Create an account at [Rebrickable.com](https://rebrickable.com)
2. Go to your account settings
3. Generate an API key in the API section

### Building the App

1. Clone the repository:
```bash
git clone <repository-url>
cd Brixie
```

2. Set your Rebrickable API key as an environment variable:
```bash
export REBRICKABLE_API_KEY="your_api_key_here"
```

3. Open the project in Xcode:
```bash
open Brixie/Brixie.xcodeproj
```

4. Build and run the app in Xcode

**Important**: The build will fail if the `REBRICKABLE_API_KEY` environment variable is not set. The API key is securely injected during build time and never committed to version control.

## Project Structure

- `Brixie/` - Main app source code
- `BrixieTests/` - Unit tests
- `BrixieUITests/` - UI tests  
- `Scripts/` - Build scripts including API key injection
- `analysis/` - Project planning and user story documentation

## API Integration

The app uses the Rebrickable API v3 with key-based authentication. API requests are handled through the `APIClient` class with built-in error handling and rate limiting awareness.

## CI/CD Pipeline

### Automated Workflows

The project includes comprehensive GitHub Actions workflows:

- **Continuous Integration** (`ci.yml`): Runs on every push and PR
  - SwiftLint code quality checks
  - Multi-device testing (iPhone 15, iPhone 15 Pro, iPad Pro)
  - Debug and Release builds
  - Artifact archival for failed builds

- **Pull Request Validation** (`pr-validation.yml`): Additional PR checks
  - Security validation (prevents API key leaks)
  - Code quality analysis
  - iOS version compatibility testing
  - Build analysis reports

- **Release Automation** (`release.yml`): Triggered by version tags
  - Creates iOS device and simulator archives
  - Generates changelogs from git commits
  - Creates GitHub releases with downloadable assets
  - Requires production API key for release builds

### Dependencies

- **Dependabot**: Automated dependency updates
  - Weekly Swift package updates
  - GitHub Actions version updates
  - Auto-assigns to repository maintainers

### Setup for Contributors

1. Fork the repository
2. Set `REBRICKABLE_API_KEY` environment variable locally
3. Make changes and create pull request
4. CI will validate your changes automatically

### Release Process

1. Create and push a version tag: `git tag v1.0.0 && git push origin v1.0.0`
2. GitHub Actions will automatically:
   - Build release archives
   - Generate changelog
   - Create GitHub release
   - Upload build artifacts

**Note**: Release builds require the `REBRICKABLE_API_KEY` secret to be configured in repository settings.
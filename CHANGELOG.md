# Changelog CAMARA SessionInsights

## Table of Contents

- **[r1.1](#r11)**

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

- for an alpha release, the delta with respect to the previous release
- for the first release-candidate, all changes since the last public release
- for subsequent release-candidate(s), only the delta to the previous release-candidate
- for a public release, the consolidated changes since the previous public release

# r1.1

## Release Notes

This release contains the definition and documentation of

- session-insights v0.1.0

The API definition(s) are based on

- Commonalities v0.6.0
- Identity and Consent Management v0.4.0

## session-insights v0.1.0

**Initial contribution of Session Insights API definition, including initial documentation, linting, test cases, and OpenAPI spec.**

- API definition **with inline documentation**:
  - OpenAPI [YAML spec file](https://github.com/camaraproject/SessionInsights/blob/r1.1/main/code/API_definitions/session-insights.yaml)
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/SessionInsights/r1.1/code/API_definitions/session-insights.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/SessionInsights/r1.1/code/API_definitions/session-insights.yaml)

- @benhepworth did most of the work on this initial release
- @kevsy helped out and co-authored several PRs and participated in PR reviews
- This "release" is only tagged to document the history of the API, it is not intended to be used by implementors or API customers
- It was originally an implementation by the CableLabs team, and is now maintained by the Camara Project

### Added

- Publish initial yaml
- Add Linting
- Add Test cases
- Align with Commonalities 0.6
- Update User Story

### Changed

### Fixed

### Removed

*Full Changelog**: [https://github.com/camaraproject/SessionInsights/commits/r1.1](https://github.com/camaraproject/SessionInsights/commits/r1.1)

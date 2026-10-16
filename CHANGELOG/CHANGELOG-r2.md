# Changelog SessionInsights

<!-- TOC:START -->
## Table of Contents
- [r2.2](#r22)
- [r2.1](#r21)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r2.2

## Release Notes

This release candidate contains the definition and documentation of
* session-insights 0.2.0-rc.2

The API definition(s) are based on
* Commonalities r4.4 (0.9.0)
* Identity and Consent Management r4.2 (0.5.0)

## session-insights 0.2.0-rc.2

**session-insights 0.2.0-rc.2 is a release-candidate version of this API.**

Changes documented below are compared to version 0.2.0-rc.1.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/SessionInsights/r2.2/code/API_definitions/session-insights.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/SessionInsights/r2.2/code/API_definitions/session-insights.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/SessionInsights/blob/r2.2/code/API_definitions/session-insights.yaml)

### Breaking changes

* N/A

### Added

* Align with Commonalities r4.4 (0.9.0)
* Add test scenarios for `createSession` 429 `TOO_MANY_REQUESTS` and 400 `INVALID_CREDENTIAL` /
  `INVALID_TOKEN` / `INVALID_SINK`

### Changed

* Migrate error responses off the deprecated `Generic<status>` responses to the Commonalities r4.4 response catalogue and shared examples
* Use the common `Sink` schema in place of local inline definitions
* Align documentation with Commonalities template text

### Fixed

* Remove declared error codes that operations cannot return: `sendSessionMetrics` 422; `OUT_OF_RANGE` on 400 for `getSession`, `deleteSession`, `retrieveSessionsByDevice` and notifications; `IDENTIFIER_NOT_FOUND` on 404 for `getSession`, `deleteSession`, `sendSessionMetrics`; `NOT_FOUND` on 404 for `retrieveSessionsByDevice`
* Expect `OUT_OF_RANGE` instead of `INVALID_ARGUMENT` in `sendSessionMetrics` test scenarios for out-of-range `packetDelay.value` and `packetLossErrorRate`

### Removed

* N/A

**Full Changelog**: https://github.com/camaraproject/SessionInsights/compare/r2.1...r2.2

# r2.1

## Release Notes

This release candidate contains the definition and documentation of
* session-insights 0.2.0-rc.1

The API definition(s) are based on
* Commonalities 0.8.0
* Identity and Consent Management 0.5.0

## session-insights 0.2.0-rc.1

**session-insights 0.2.0-rc.1 is a release-candidate version of this API.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/SessionInsights/r2.1/code/API_definitions/session-insights.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/SessionInsights/r2.1/code/API_definitions/session-insights.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/SessionInsights/blob/r2.1/code/API_definitions/session-insights.yaml)

### Breaking changes

* N/A

### Added

* Align with Commonalities r4.3(0.8.0)
* Align with Identity and Consent Management r4.2(0.5.0)

### Changed

* N/A

### Fixed

* N/A

### Removed

* Remove MQTT and consolidate to HTTP-only implicit notification subscriptions

**Full Changelog**: https://github.com/camaraproject/SessionInsights/commits/r2.1


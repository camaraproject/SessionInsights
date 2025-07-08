# Test Definitions for CAMARA Session Insights API

This directory contains the test definitions for the CAMARA Session Insights API, written using the Gherkin language for Behavior-Driven Development (BDD) testing.

## Overview

The Session Insights API test definitions ensure compliance with the API specification and validate the correct implementation of all endpoints and operations. These tests are designed to be executed using Cucumber or other BDD testing frameworks that support Gherkin syntax.

## Test Files

The following Gherkin feature files are provided:

| File | Description | Endpoints Covered |
|------|-------------|-------------------|
| `session-insights-createSession.feature` | Session creation and validation | `POST /sessions` |
| `session-insights-getSession.feature` | Session retrieval by ID | `GET /sessions/{sessionId}` |
| `session-insights-deleteSession.feature` | Session deletion and cleanup | `DELETE /sessions/{sessionId}` |
| `session-insights-retrieveSessions.feature` | Device-based session retrieval | `POST /retrieve-sessions` |
| `session-insights-sendMetrics.feature` | Session metrics streaming | `POST /sessions/{sessionId}/metrics` |

## Test Coverage

### CAMARA Compliance Structure

All test files follow the [CAMARA API Testing Guidelines](https://github.com/camaraproject/Commonalities/blob/main/documentation/API-Testing-Guidelines.md) structure:

- **Feature Headers**: Include implementation indications and testing assets documentation
- **Background Sections**: Standard CAMARA environment setup with `apiRoot`, proper resource paths, and required headers
- **Scenario Tags**: Follow `@session_insights_operationName_XX_description` format for unique identification
- **Error Organization**: Scenarios grouped by HTTP status codes (400, 401, 403, 404, 409, 410, 422, 429)
- **Response Validation**: Explicit validation of status, code, message properties and OAS schema compliance

### Functional Areas Covered

Each test file covers both **sunny day scenarios** (successful operations) and **rainy day scenarios** (error conditions) as required by CAMARA testing guidelines:

#### 🌞 Sunny Day Scenarios
- **Session Management**: Create, retrieve, and delete sessions with valid parameters
- **Protocol Support**: HTTP, MQTT3, and MQTT5 protocol configurations  
- **Device Identifiers**: phoneNumber, IPv4/IPv6 addresses, networkAccessIdentifier
- **Metrics Streaming**: Valid KPI submission and processing
- **Authentication**: 2-legged and 3-legged token flows
- **Schema Compliance**: Response validation against OpenAPI specifications

#### 🌧️ Rainy Day Scenarios  
- **Input Validation**: Invalid formats, missing required fields, malformed data
- **Authentication & Authorization**: Missing credentials, invalid tokens, insufficient permissions
- **Resource Management**: Non-existent resources, expired sessions, conflicts
- **Protocol Errors**: Unsupported methods, invalid content types
- **Business Logic**: Rate limiting, payload size limits, session lifecycle violations
- **CAMARA Error Codes**: Standard error responses (UNAUTHENTICATED, PERMISSION_DENIED, etc.)

### Key Testing Areas

1. **CAMARA API Compliance**
   - Request/response schema validation against OpenAPI specification
   - HTTP status code verification per CAMARA standards
   - Header validation (x-correlator, content-type) with proper roundtrip testing
   - Error response format compliance with CAMARA error schemas
   - Background section setup following CAMARA environment patterns

2. **Security & Authentication**
   - CAMARA-compliant token handling (2-legged vs 3-legged)
   - Device identifier validation with MISSING_IDENTIFIER and UNNECESSARY_IDENTIFIER scenarios
   - Scope and permission enforcement per CAMARA security guidelines
   - Standard authentication error responses (UNAUTHENTICATED, PERMISSION_DENIED)

3. **Session Lifecycle Management**
   - Session creation with various protocol configurations (HTTP, MQTT3, MQTT5)
   - Session state transitions and proper resource cleanup
   - Expiration handling with GONE (410) responses
   - Conflict detection for duplicate session scenarios

4. **Multi-Protocol Support**
   - HTTP webhook configurations with sink credentials
   - MQTT broker settings for MQTT3/MQTT5 protocols
   - Protocol-specific features and validation
   - protocolSettings schema compliance testing

5. **Metrics and Quality Assessment**
   - KPI validation (latency, jitter, packet loss, bitrate, resolution)
   - Data type and range validation per MetricsPayload schema
   - Streaming frequency limits and rate limiting scenarios
   - Negative value and boundary condition testing

6. **CAMARA Error Handling**
   - Standard error codes: INVALID_ARGUMENT, NOT_FOUND, CONFLICT, GONE
   - Device identifier errors: MISSING_IDENTIFIER, UNNECESSARY_IDENTIFIER  
   - Rate limiting: TOO_MANY_REQUESTS, QUOTA_EXCEEDED
   - Proper error message and status code validation

## Prerequisites

Before running the tests, ensure you have:

### Environment Setup
- A running Session Insights API implementation
- Valid access tokens (2-legged and 3-legged) with appropriate scopes
- Test devices with known identifiers (phoneNumber, IP addresses, etc.)
- Valid Application Profile IDs
- MQTT broker access (for MQTT protocol tests)

### Test Framework
- Cucumber-compatible test runner (Java, JavaScript, Python, etc.)
- HTTP client for API requests
- JSON schema validation libraries

## Environment Variables

The following environment variables should be configured for test execution following CAMARA testing patterns:

```bash
# API Configuration
API_ROOT=https://api.example.com  # Used as apiRoot in Background sections
API_TIMEOUT=30000

# Authentication (CAMARA-compliant tokens)
TWO_LEGGED_ACCESS_TOKEN=your_2legged_token_here
THREE_LEGGED_ACCESS_TOKEN=your_3legged_token_here
EXPIRED_ACCESS_TOKEN=expired_token_for_testing
INVALID_ACCESS_TOKEN=invalid_token_for_testing

# Test Data (must exist in test environment)
VALID_APPLICATION_PROFILE_ID=550e8400-e29b-41d4-a716-446655440000
NON_EXISTENT_APPLICATION_PROFILE_ID=550e8400-e29b-41d4-a716-446655440001

# Device Identifiers (test assets)
VALID_PHONE_NUMBER=+1234567890
INVALID_PHONE_NUMBER=invalid-phone
VALID_IPV4_ADDRESS=192.168.1.100
VALID_IPV4_PORT=8080
INVALID_IPV4_ADDRESS=999.999.999.999
VALID_IPV6_ADDRESS=2001:db8::1
INVALID_IPV6_ADDRESS=invalid-ipv6
VALID_NETWORK_ACCESS_ID=user@domain.com

# Application Server Configuration
APP_SERVER_DOMAIN=app.example.com
APP_SERVER_IPV4=203.0.113.1
APP_SERVER_IPV6=2001:db8::2
APP_SERVER_PORT=443

# Protocol Settings
HTTP_WEBHOOK_URL=https://webhook.example.com/notifications
HTTP_SINK_CREDENTIAL=webhook_bearer_token
MQTT_BROKER_URI=mqtt://broker.example.com:1883
MQTT_USERNAME=testuser
MQTT_PASSWORD=testpass

# Session Test Data
EXISTING_SESSION_ID=existing-session-uuid
EXPIRED_SESSION_ID=expired-session-uuid
DELETED_SESSION_ID=deleted-session-uuid
NON_EXISTENT_SESSION_ID=550e8400-e29b-41d4-a716-446655440999

# Test Configuration (CAMARA standard)
X_CORRELATOR_VALID=test-correlator-123
X_CORRELATOR_INVALID=invalid@correlator!
MALFORMED_UUID=123e4567-e89b-12d3-a456-42661417400
RANDOM_UUID=random-generated-uuid-here
```

## Running the Tests

### Using Cucumber with Java/Maven

```bash
# Run all tests
mvn test

# Run specific feature file
mvn test -Dcucumber.options="src/test/resources/session-insights-createSession.feature"

# Run tests with specific tags
mvn test -Dcucumber.options="--tags @sunny-day"
```

### Using Cucumber with Node.js

```bash
# Install dependencies
npm install

# Run all tests
npm test

# Run specific feature
npx cucumber-js features/session-insights-createSession.feature

# Run with tags
npx cucumber-js --tags "@sunny-day"
```

### Using Behave (Python)

```bash
# Install dependencies
pip install behave requests

# Run all tests
behave

# Run specific feature
behave features/session-insights-createSession.feature

# Run with tags
behave --tags=sunny-day
```

## Test Data Management

### Device Test Data
Ensure you have access to devices with the following characteristics:
- **Valid devices**: Devices that exist and are accessible via the network
- **Invalid devices**: Device identifiers that are properly formatted but non-existent
- **Multiple identifiers**: Devices that can be identified by different methods

### Session Test Data
- **Application Profile IDs**: Both valid and invalid UUIDs
- **Application Sessions**: Various session identifiers for correlation
- **Webhook URLs**: Valid and invalid webhook endpoints for HTTP protocol testing

### Metrics Test Data
- **Valid KPI ranges**: Realistic values for latency, jitter, packet loss, bitrate
- **Edge cases**: Zero values, very large values, boundary conditions
- **Invalid data**: Wrong data types, negative values, missing fields

## Test Result Interpretation

### Expected Results

**✅ Successful Test Indicators:**
- All sunny day scenarios pass with expected HTTP status codes per CAMARA standards
- Response schemas validate against OpenAPI specification schemas
- Error scenarios return appropriate CAMARA error codes and messages
- x-correlator headers are properly handled in request/response roundtrip
- Background environment setup executes successfully
- OAS schema compliance validation passes for all response bodies

**❌ Common Failure Scenarios:**
- Schema validation failures (check API implementation against session-insights.yaml)
- Authentication errors (verify tokens have required scopes per CAMARA security)
- Network connectivity issues (check apiRoot endpoint accessibility)
- Missing environment variables (verify CAMARA test assets configuration)
- Incorrect error response format (ensure CAMARA error schema compliance)

### Debugging Failed Tests

1. **Check API Logs**: Review server-side logs for detailed error information
2. **Validate Environment**: Ensure all required environment variables are set
3. **Network Connectivity**: Verify API endpoint accessibility
4. **Token Validity**: Confirm access tokens are valid and have required scopes
5. **Test Data**: Ensure test devices and profiles exist in the test environment

## Contributing to Tests

When modifying or adding test scenarios, follow CAMARA testing guidelines:

1. **Follow CAMARA Structure**: Use proper Background sections, scenario tags, and Given/When/Then patterns
2. **Maintain Scenario Tags**: Use format `@session_insights_operationName_XX_description` 
3. **Cover Edge Cases**: Include boundary testing and error conditions per CAMARA standards
4. **Update Documentation**: Keep this README current with any changes
5. **Test Locally**: Validate new scenarios against CAMARA-compliant implementations
6. **Schema References**: Use correct OAS schema paths like `/components/schemas/SchemaName`
7. **Error Scenarios**: Organize by HTTP status code and include CAMARA error codes

### Test Naming Conventions

- **Scenario Tags**: `@session_insights_operationName_XX_description`
  - Examples: `@session_insights_createSession_01_http_session_creation`
  - Examples: `@session_insights_getSession_400.1_invalid_session_id_format`
- **Given/When/Then**: Use specific, testable conditions
  - Given: Setup conditions and test data
  - When: Single action (`When the request "operationName" is sent`)
  - Then: Expected outcomes with specific validations
- **Error Scenarios**: Include HTTP status and CAMARA error code
  - Examples: `400.1_invalid_argument`, `401.1_no_authorization_header`, `422.1_missing_identifier`

## API Versioning

These tests are designed for **Session Insights API vwip** following CAMARA versioning standards. When the API version changes:

1. Update version references in feature file headers (`vwip` → `v1.0.0`)
2. Update resource paths in Background sections (`/session-insights/vwip/` → `/session-insights/v1.0.0/`)
3. Review and update test scenarios for any breaking changes
4. Validate all existing tests against the new API version per CAMARA guidelines
5. Add new test cases for any new functionality following CAMARA structure
6. Ensure OAS schema references remain accurate

## Related Documentation

- [CAMARA Session Insights API Specification](../API_definitions/session-insights.yaml)
- [CAMARA API Testing Guidelines](https://github.com/camaraproject/Commonalities/blob/main/documentation/API-Testing-Guidelines.md)
- [CAMARA API Design Guidelines](https://github.com/camaraproject/Commonalities/blob/main/documentation/API-design-guidelines.md)
- [Gherkin Reference](https://cucumber.io/docs/gherkin/reference/)
- [Behavior-Driven Development (BDD)](https://cucumber.io/docs/bdd/)

## Support

For questions or issues related to these test definitions:

1. **API Issues**: Report to the Session Insights API working group
2. **Test Framework Issues**: Check Cucumber/Gherkin documentation
3. **CAMARA Guidelines**: Refer to Commonalities working group documentation

## License

This test suite is part of the CAMARA project and follows the same licensing terms as the Session Insights API specification.

---

**Note**: These tests are designed to validate API implementation compliance and should be run in appropriate test environments. Do not run tests against production systems without proper authorization and safeguards.

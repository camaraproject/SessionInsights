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

### Functional Areas Covered

Each test file covers both **sunny day scenarios** (successful operations) and **rainy day scenarios** (error conditions) as required by CAMARA testing guidelines:

#### 🌞 Sunny Day Scenarios

- **Session Management**: Create, retrieve, and delete sessions with valid parameters
- **Protocol Support**: HTTP, MQTT3, and MQTT5 protocol configurations
- **Device Identifiers**: phoneNumber, IPv4/IPv6 addresses, networkAccessIdentifier
- **Metrics Streaming**: Valid KPI submission and processing
- **Authentication**: 2-legged and 3-legged token flows

#### 🌧️ Rainy Day Scenarios

- **Input Validation**: Invalid formats, missing required fields, malformed data
- **Authentication & Authorization**: Missing credentials, invalid tokens, insufficient permissions
- **Resource Management**: Non-existent resources, expired sessions, conflicts
- **Protocol Errors**: Unsupported methods, invalid content types
- **Business Logic**: Rate limiting, payload size limits, session lifecycle violations

### Key Testing Areas

1. **API Compliance**
   - Request/response schema validation
   - HTTP status code verification
   - Header validation (x-correlator, content-type)
   - Error response format compliance

2. **Security & Authentication**
   - CAMARA-compliant token handling
   - Device identifier validation
   - Scope and permission enforcement
   - 2-legged vs 3-legged token behavior

3. **Session Lifecycle Management**
   - Session creation with various configurations
   - Session state transitions
   - Proper resource cleanup
   - Expiration handling

4. **Multi-Protocol Support**
   - HTTP webhook configurations
   - MQTT broker settings (MQTT3/MQTT5)
   - Protocol-specific features and limitations

5. **Metrics and Quality Assessment**
   - KPI validation (latency, jitter, packet loss, bitrate, resolution)
   - Data type and range validation
   - Streaming frequency limits

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

The following environment variables should be configured for test execution:

```bash
# API Configuration
API_BASE_URL=https://api.example.com/session-insights/v0
API_TIMEOUT=30000

# Authentication
TWO_LEGGED_ACCESS_TOKEN=your_2legged_token_here
THREE_LEGGED_ACCESS_TOKEN=your_3legged_token_here
INVALID_ACCESS_TOKEN=invalid_token_for_testing

# Test Data
VALID_PHONE_NUMBER=+1234567890
VALID_IPV4_ADDRESS=192.168.1.100
VALID_IPV4_PORT=8080
VALID_IPV6_ADDRESS=2001:db8::1
VALID_NETWORK_ACCESS_ID=user@domain.com
VALID_APPLICATION_PROFILE_ID=550e8400-e29b-41d4-a716-446655440000

# Application Server
APP_SERVER_DOMAIN=app.example.com
APP_SERVER_IPV4=203.0.113.1
APP_SERVER_PORT=443

# Protocol Settings
HTTP_WEBHOOK_URL=https://webhook.example.com/notifications
MQTT_BROKER_URI=mqtt://broker.example.com:1883
MQTT_USERNAME=testuser
MQTT_PASSWORD=testpass

# Test Configuration
X_CORRELATOR_VALID=test-correlator-123
X_CORRELATOR_INVALID=invalid@correlator!
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

- All sunny day scenarios pass with expected HTTP status codes
- Response schemas match API specification
- Error scenarios return appropriate error codes and messages
- x-correlator headers are properly handled

**❌ Common Failure Scenarios:**

- Schema validation failures (check API implementation)
- Authentication errors (verify tokens and scopes)
- Network connectivity issues (check endpoints and firewall rules)
- Missing environment variables (verify configuration)

### Debugging Failed Tests

1. **Check API Logs**: Review server-side logs for detailed error information
2. **Validate Environment**: Ensure all required environment variables are set
3. **Network Connectivity**: Verify API endpoint accessibility
4. **Token Validity**: Confirm access tokens are valid and have required scopes
5. **Test Data**: Ensure test devices and profiles exist in the test environment

## Contributing to Tests

When modifying or adding test scenarios:

1. **Follow Gherkin Conventions**: Use clear Given/When/Then structure
2. **Maintain CAMARA Compliance**: Ensure tests align with CAMARA testing guidelines
3. **Cover Edge Cases**: Include boundary testing and error conditions
4. **Update Documentation**: Keep this README current with any changes
5. **Test Locally**: Validate new scenarios before submitting

### Test Naming Conventions

- Use descriptive scenario names that clearly indicate the test purpose
- Follow the pattern: `[Action] [Entity] [Condition/Context]`
- Examples:
  - `Create HTTP session with valid parameters`
  - `Retrieve session with invalid sessionId format`
  - `Send metrics to expired session`

## API Versioning

These tests are designed for **Session Insights API v0.wip**. When the API version changes:

1. Update the version references in feature file headers
2. Review and update test scenarios for any breaking changes
3. Validate all existing tests against the new API version
4. Add new test cases for any new functionality

## Related Documentation

- [CAMARA Session Insights API Specification](../API_definitions/session-insights.yaml)
- [CAMARA API Testing Guidelines](https://github.com/camaraproject/Commonalities/blob/main/documentation/API-Testing-Guidelines.md)
- [CAMARA API Design Guide](https://github.com/camaraproject/Commonalities/blob/main/documentation/CAMARA-API-Design-Guide.md)
- [Gherkin Reference](https://cucumber.io/docs/gherkin/reference/)
- [Behavior-Driven Development (BDD)](https://cucumber.io/docs/bdd/)

## Support

For questions or issues related to these test definitions:

1. **API Issues**: Report to the Session Insights API working group or open issue on GitHub
2. **Test Framework Issues**: Check Cucumber/Gherkin documentation
3. **CAMARA Guidelines**: Refer to Commonalities working group documentation

## License

This test suite is part of the CAMARA project and follows the same licensing terms as the Session Insights API specification.

---

**Note**: These tests are designed to validate API implementation compliance and should be run in appropriate test environments. Do not run tests against production systems without proper authorization and safeguards.

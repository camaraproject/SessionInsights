Feature: CAMARA Session Insights API, v0.wip - Operation createSession
  As a developer integrating with CAMARA Session Insights API
  I want to create a sessions for real-time quality assessment
  So that I can monitor and optimize my application's network performance

  Background:
    Given the Session Insights API is available
    And I have a valid access token with appropriate scopes
    And I have a valid Application Profile ID

  # Sunny day scenarios - HTTP protocol
  Scenario: Create HTTP session with valid parameters
    Given I have a valid device with phoneNumber
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    When I send POST request to "/sessions" with valid HTTP session data
    Then I receive a 201 response
    And the response contains "id" property with UUID format
    And the response contains "protocol" property with value "HTTP"
    And the response contains "sink" property with webhook URL
    And the response contains "sinkCredential" property for HTTP callbacks
    And the response contains "startTime" property with valid date-time
    And the response contains "expiresAt" property with valid date-time
    And the response headers contain "x-correlator"

  Scenario: Create MQTT3 session with valid parameters
    Given I have a valid device with phoneNumber
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify MQTT3 protocol
    When I send POST request to "/sessions" with valid MQTT3 session data
    Then I receive a 201 response
    And the response contains "id" property with UUID format
    And the response contains "protocol" property with value "MQTT3"
    And the response contains "protocolSettings" with MQTT broker configuration
    And the response contains "sinkCredential" property for MQTT access
    And the response headers contain "x-correlator"

  Scenario: Create MQTT5 session with valid parameters
    Given I have a valid device with phoneNumber
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify MQTT5 protocol
    When I send POST request to "/sessions" with valid MQTT5 session data
    Then I receive a 201 response
    And the response contains "id" property with UUID format
    And the response contains "protocol" property with value "MQTT5"
    And the response contains "protocolSettings" with MQTT broker configuration
    And the response headers contain "x-correlator"

  Scenario: Create session with optional applicationSessionId
    Given I have a valid device with phoneNumber
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    And I provide an applicationSessionId "meet-12345"
    When I send POST request to "/sessions" with session data including applicationSessionId
    Then I receive a 201 response
    And the response contains "applicationSessionId" property with value "meet-12345"

  Scenario: Create session with IPv4 device identifier
    Given I have a valid device with IPv4 address and port
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    When I send POST request to "/sessions" with valid session data
    Then I receive a 201 response
    And the response contains device information with IPv4 address

  Scenario: Create session with IPv6 device identifier
    Given I have a valid device with IPv6 address
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    When I send POST request to "/sessions" with valid session data
    Then I receive a 201 response
    And the response contains device information with IPv6 address

  Scenario: Create session with network access identifier
    Given I have a valid device with networkAccessIdentifier
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    When I send POST request to "/sessions" with valid session data
    Then I receive a 201 response
    And the response contains device information with networkAccessIdentifier

  # Rainy day scenarios - Input validation

  Scenario: Create session without required applicationProfileId
    Given I have a valid device with phoneNumber
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    But I do not provide applicationProfileId
    When I send POST request to "/sessions" with incomplete session data
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"
    And the response headers contain "x-correlator"

  Scenario: Create session without required device
    Given I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    But I do not provide device information
    When I send POST request to "/sessions" with incomplete session data
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Create session without required applicationServer
    Given I have a valid device with phoneNumber
    And I have a valid Application Profile ID
    And I specify HTTP protocol with webhook URL
    But I do not provide applicationServer information
    When I send POST request to "/sessions" with incomplete session data
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Create session without required protocol
    Given I have a valid device with phoneNumber
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    But I do not specify protocol
    When I send POST request to "/sessions" with incomplete session data
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Create session with invalid protocol value
    Given I have a valid device with phoneNumber
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify an invalid protocol "INVALID_PROTOCOL"
    When I send POST request to "/sessions" with invalid session data
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Create HTTP session without required sink
    Given I have a valid device with phoneNumber
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol
    But I do not provide sink webhook URL
    When I send POST request to "/sessions" with incomplete HTTP session data
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Create session with invalid applicationProfileId format
    Given I have a valid device with phoneNumber
    And I have an invalid Application Profile ID "not-a-uuid"
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    When I send POST request to "/sessions" with invalid session data
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Create session with invalid device phoneNumber format
    Given I have a device with invalid phoneNumber "invalid-phone"
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    When I send POST request to "/sessions" with invalid session data
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Create session with device having no identifiers
    Given I have a device object with no identifiers
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    When I send POST request to "/sessions" with invalid session data
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # Error scenarios - Authorization and permissions

  Scenario: Create session without authentication
    Given I do not have an access token
    And I have valid session data
    When I send POST request to "/sessions" without authentication
    Then I receive a 401 response
    And the response contains error code "UNAUTHENTICATED"

  Scenario: Create session with invalid access token
    Given I have an invalid access token
    And I have valid session data
    When I send POST request to "/sessions" with invalid authentication
    Then I receive a 401 response
    And the response contains error code "UNAUTHENTICATED"

  Scenario: Create session without sufficient permissions
    Given I have an access token without required scopes
    And I have valid session data
    When I send POST request to "/sessions" with insufficient permissions
    Then I receive a 403 response
    And the response contains error code indicating insufficient permissions

  # Error scenarios - Business logic

  Scenario: Create session with non-existent applicationProfileId
    Given I have a valid device with phoneNumber
    And I have a non-existent Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    When I send POST request to "/sessions" with non-existent profile
    Then I receive a 404 response
    And the response contains error code indicating resource not found

  Scenario: Create session that conflicts with existing session
    Given I have a valid device with phoneNumber
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    And a session already exists for this device and application profile
    When I send POST request to "/sessions" with conflicting session data
    Then I receive a 409 response
    And the response contains error code "CONFLICT"

  # Device identifier validation scenarios

  Scenario: Create session with device using 3-legged token and device parameter
    Given I have a 3-legged access token
    And I provide device information in the request
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    When I send POST request to "/sessions" with device parameter
    Then I receive a 422 response
    And the response contains error code "UNNECESSARY_IDENTIFIER"

  Scenario: Create session with 2-legged token but no device parameter
    Given I have a 2-legged access token
    And I do not provide device information in the request
    And I have a valid Application Profile ID
    And I have a valid application server configuration
    And I specify HTTP protocol with webhook URL
    When I send POST request to "/sessions" without device parameter
    Then I receive a 422 response
    And the response contains error code "MISSING_IDENTIFIER"

  # Content-Type and format validation

  Scenario: Create session with invalid Content-Type
    Given I have valid session data
    And I set Content-Type to "text/plain"
    When I send POST request to "/sessions" with invalid content type
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Create session with malformed JSON
    Given I have malformed JSON in the request body
    When I send POST request to "/sessions" with malformed JSON
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # x-correlator header validation

  Scenario: Create session with valid x-correlator header
    Given I have valid session data
    And I provide a valid x-correlator header
    When I send POST request to "/sessions" with correlator
    Then I receive a 201 response
    And the response headers contain the same x-correlator value

  Scenario: Create session with invalid x-correlator header format
    Given I have valid session data
    And I provide an invalid x-correlator header with special characters
    When I send POST request to "/sessions" with invalid correlator
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

Feature: CAMARA Session Insights API, v0.wip - Operation getSession
  As a developer integrating with CAMARA Session Insights API
  I want to retrieve details of an existing session
  So that I can check session status and configuration

  Background:
    Given the Session Insights API is available
    And I have a valid access token with appropriate scopes

  # Sunny day scenarios

  Scenario: Retrieve existing HTTP session by sessionId
    Given I have created an HTTP session with sessionId
    When I send GET request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 200 response
    And the response contains "id" property with the requested sessionId
    And the response contains "protocol" property with value "HTTP"
    And the response contains "device" property with device information
    And the response contains "applicationServer" property
    And the response contains "sink" property with webhook URL
    And the response contains "subscribedEventTypes" array
    And the response contains "startTime" property with valid date-time
    And the response contains "expiresAt" property with valid date-time
    And the response headers contain "x-correlator"

  Scenario: Retrieve existing MQTT3 session by sessionId
    Given I have created an MQTT3 session with sessionId
    When I send GET request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 200 response
    And the response contains "id" property with the requested sessionId
    And the response contains "protocol" property with value "MQTT3"
    And the response contains "protocolSettings" with MQTT configuration
    And the response contains "device" property with device information
    And the response contains "applicationServer" property
    And the response contains "subscribedEventTypes" array
    And the response headers contain "x-correlator"

  Scenario: Retrieve existing MQTT5 session by sessionId
    Given I have created an MQTT5 session with sessionId
    When I send GET request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 200 response
    And the response contains "id" property with the requested sessionId
    And the response contains "protocol" property with value "MQTT5"
    And the response contains "protocolSettings" with MQTT configuration
    And the response headers contain "x-correlator"

  Scenario: Retrieve session with applicationSessionId
    Given I have created a session with applicationSessionId "meet-12345"
    When I send GET request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 200 response
    And the response contains "applicationSessionId" property with value "meet-12345"

  Scenario: Retrieve session created with device phoneNumber
    Given I have created a session with device phoneNumber
    When I send GET request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 200 response
    And the response contains "device" property with phoneNumber
    And the device object contains exactly one identifier

  Scenario: Retrieve session created with device IPv4 address
    Given I have created a session with device IPv4 address
    When I send GET request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 200 response
    And the response contains "device" property with IPv4 address
    And the device object contains exactly one identifier

  Scenario: Retrieve session created with device IPv6 address
    Given I have created a session with device IPv6 address
    When I send GET request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 200 response
    And the response contains "device" property with IPv6 address
    And the device object contains exactly one identifier

  Scenario: Retrieve session created with network access identifier
    Given I have created a session with device networkAccessIdentifier
    When I send GET request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 200 response
    And the response contains "device" property with networkAccessIdentifier
    And the device object contains exactly one identifier

  # Rainy day scenarios - Path parameter validation

  Scenario: Retrieve session with invalid sessionId format
    Given I have an invalid sessionId "not-a-uuid"
    When I send GET request to "/sessions/{sessionId}" with invalid sessionId
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"
    And the response headers contain "x-correlator"

  Scenario: Retrieve session with empty sessionId
    Given I have an empty sessionId
    When I send GET request to "/sessions/{sessionId}" with empty sessionId
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Retrieve session with malformed UUID sessionId
    Given I have a malformed UUID sessionId "123e4567-e89b-12d3-a456-42661417400"
    When I send GET request to "/sessions/{sessionId}" with malformed sessionId
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # Error scenarios - Resource not found

  Scenario: Retrieve non-existent session
    Given I have a valid but non-existent sessionId
    When I send GET request to "/sessions/{sessionId}" with non-existent sessionId
    Then I receive a 404 response
    And the response contains error code indicating resource not found
    And the response headers contain "x-correlator"

  # Error scenarios - Authorization and permissions

  Scenario: Retrieve session without authentication
    Given I do not have an access token
    And I have a valid sessionId
    When I send GET request to "/sessions/{sessionId}" without authentication
    Then I receive a 401 response
    And the response contains error code "UNAUTHENTICATED"

  Scenario: Retrieve session with invalid access token
    Given I have an invalid access token
    And I have a valid sessionId
    When I send GET request to "/sessions/{sessionId}" with invalid authentication
    Then I receive a 401 response
    And the response contains error code "UNAUTHENTICATED"

  Scenario: Retrieve session without sufficient permissions
    Given I have an access token without required scopes
    And I have a valid sessionId
    When I send GET request to "/sessions/{sessionId}" with insufficient permissions
    Then I receive a 403 response
    And the response contains error code indicating insufficient permissions

  Scenario: Retrieve session belonging to different user/device
    Given I have a valid access token for user A
    And I have a sessionId created by user B
    When I send GET request to "/sessions/{sessionId}" to access other user's session
    Then I receive a 403 response
    And the response contains error code indicating insufficient permissions

  # Error scenarios - Session lifecycle

  Scenario: Retrieve expired session
    Given I have a sessionId for an expired session
    When I send GET request to "/sessions/{sessionId}" with expired sessionId
    Then I receive a 410 response
    And the response contains error code "GONE"
    And the response headers contain "x-correlator"

  Scenario: Retrieve deleted session
    Given I have a sessionId for a deleted session
    When I send GET request to "/sessions/{sessionId}" with deleted sessionId
    Then I receive a 410 response
    And the response contains error code "GONE"

  # x-correlator header validation

  Scenario: Retrieve session with valid x-correlator header
    Given I have a valid sessionId
    And I provide a valid x-correlator header
    When I send GET request to "/sessions/{sessionId}" with correlator
    Then I receive a 200 response
    And the response headers contain the same x-correlator value

  Scenario: Retrieve session with invalid x-correlator header format
    Given I have a valid sessionId
    And I provide an invalid x-correlator header with special characters
    When I send GET request to "/sessions/{sessionId}" with invalid correlator
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # Content negotiation

  Scenario: Retrieve session with unsupported Accept header
    Given I have a valid sessionId
    And I set Accept header to "text/xml"
    When I send GET request to "/sessions/{sessionId}" with unsupported Accept
    Then I receive a 406 response
    And the response contains error indicating unsupported media type

  # Response schema validation

  Scenario: Verify response schema compliance for HTTP session
    Given I have created an HTTP session
    When I send GET request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 200 response
    And the response body complies with Session schema
    And all required properties are present
    And all property types match the specification

  Scenario: Verify response schema compliance for MQTT session
    Given I have created an MQTT session
    When I send GET request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 200 response
    And the response body complies with Session schema
    And the protocolSettings contain required MQTT properties
    And all property types match the specification

  # Edge cases

  Scenario: Retrieve session multiple times
    Given I have created a session with sessionId
    When I send GET request to "/sessions/{sessionId}" multiple times
    Then I receive a 200 response each time
    And the response data is consistent across requests

  Scenario: Retrieve session near expiration time
    Given I have created a session that is near expiration
    When I send GET request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 200 response
    And the response contains "expiresAt" property showing near expiration

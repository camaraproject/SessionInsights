Feature: CAMARA Session Insights API, v0.wip - Operation retrieveSessionsByDevice
  As a developer integrating with CAMARA Session Insights API
  I want to retrieve all sessions associated with a specific device
  So that I can manage and monitor device-specific sessions

  Background:
    Given the Session Insights API is available
    And I have a valid access token with appropriate scopes

  # Sunny day scenarios

  Scenario: Retrieve sessions for device with phoneNumber using 2-legged token
    Given I have a 2-legged access token
    And I have created multiple sessions for device with phoneNumber
    When I send POST request to "/retrieve-sessions" with device phoneNumber
    Then I receive a 200 response
    And the response contains an array of sessions
    And all sessions in the array belong to the specified device
    And each session contains required properties (id, device, applicationServer, protocol, sink, subscribedEventTypes, startTime)
    And the response headers contain "x-correlator"

  Scenario: Retrieve sessions for device with IPv4 address using 2-legged token
    Given I have a 2-legged access token
    And I have created sessions for device with IPv4 address
    When I send POST request to "/retrieve-sessions" with device IPv4 address
    Then I receive a 200 response
    And the response contains an array of sessions
    And all sessions belong to the device with specified IPv4 address

  Scenario: Retrieve sessions for device with IPv6 address using 2-legged token
    Given I have a 2-legged access token
    And I have created sessions for device with IPv6 address
    When I send POST request to "/retrieve-sessions" with device IPv6 address
    Then I receive a 200 response
    And the response contains an array of sessions
    And all sessions belong to the device with specified IPv6 address

  Scenario: Retrieve sessions for device with networkAccessIdentifier using 2-legged token
    Given I have a 2-legged access token
    And I have created sessions for device with networkAccessIdentifier
    When I send POST request to "/retrieve-sessions" with device networkAccessIdentifier
    Then I receive a 200 response
    And the response contains an array of sessions
    And all sessions belong to the device with specified networkAccessIdentifier

  Scenario: Retrieve sessions using 3-legged token without device parameter
    Given I have a 3-legged access token for a specific device
    And I have created sessions for the authenticated device
    When I send POST request to "/retrieve-sessions" without device parameter
    Then I receive a 200 response
    And the response contains an array of sessions
    And all sessions belong to the authenticated device

  Scenario: Retrieve empty array when device has no sessions
    Given I have a 2-legged access token
    And I have a device with phoneNumber that has no sessions
    When I send POST request to "/retrieve-sessions" with device phoneNumber
    Then I receive a 200 response
    And the response contains an empty array
    And the response headers contain "x-correlator"

  Scenario: Retrieve sessions including different protocol types
    Given I have a 2-legged access token
    And I have created HTTP sessions for a device
    And I have created MQTT3 sessions for the same device
    And I have created MQTT5 sessions for the same device
    When I send POST request to "/retrieve-sessions" with device identifier
    Then I receive a 200 response
    And the response contains sessions with different protocol types
    And each session contains appropriate protocol-specific properties

  Scenario: Retrieve sessions including sessions with different states
    Given I have a 2-legged access token
    And I have active sessions for a device
    And I have expired sessions for the same device
    When I send POST request to "/retrieve-sessions" with device identifier
    Then I receive a 200 response
    And the response includes all sessions regardless of state
    And each session shows its current state information

  # Rainy day scenarios - Request validation

  Scenario: Retrieve sessions with 2-legged token but no device parameter
    Given I have a 2-legged access token
    And I do not provide device information in the request
    When I send POST request to "/retrieve-sessions" without device parameter
    Then I receive a 422 response
    And the response contains error code "MISSING_IDENTIFIER"
    And the response headers contain "x-correlator"

  Scenario: Retrieve sessions with 3-legged token and device parameter
    Given I have a 3-legged access token
    And I provide device information in the request
    When I send POST request to "/retrieve-sessions" with device parameter
    Then I receive a 422 response
    And the response contains error code "UNNECESSARY_IDENTIFIER"
    And the response headers contain "x-correlator"

  Scenario: Retrieve sessions with invalid device phoneNumber format
    Given I have a 2-legged access token
    And I provide device with invalid phoneNumber "invalid-phone"
    When I send POST request to "/retrieve-sessions" with invalid phoneNumber
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Retrieve sessions with invalid device IPv4 address format
    Given I have a 2-legged access token
    And I provide device with invalid IPv4 address "999.999.999.999"
    When I send POST request to "/retrieve-sessions" with invalid IPv4 address
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Retrieve sessions with invalid device IPv6 address format
    Given I have a 2-legged access token
    And I provide device with invalid IPv6 address "invalid-ipv6"
    When I send POST request to "/retrieve-sessions" with invalid IPv6 address
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Retrieve sessions with device having no identifiers
    Given I have a 2-legged access token
    And I provide device object with no identifiers
    When I send POST request to "/retrieve-sessions" with empty device
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Retrieve sessions with device having multiple identifiers
    Given I have a 2-legged access token
    And I provide device object with both phoneNumber and IPv4 address
    When I send POST request to "/retrieve-sessions" with multiple identifiers
    Then I receive a 200 response
    And the response contains sessions for the device
    And the response device object contains only one identifier

  # Error scenarios - HTTP method and content type

  Scenario: Use GET method instead of POST
    Given I have a valid access token
    When I send GET request to "/retrieve-sessions"
    Then I receive a 405 response
    And the response contains error indicating method not allowed

  Scenario: Retrieve sessions with invalid Content-Type
    Given I have a 2-legged access token
    And I have valid device information
    And I set Content-Type to "text/plain"
    When I send POST request to "/retrieve-sessions" with invalid content type
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Retrieve sessions with malformed JSON
    Given I have a 2-legged access token
    And I have malformed JSON in the request body
    When I send POST request to "/retrieve-sessions" with malformed JSON
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # Error scenarios - Authorization and permissions

  Scenario: Retrieve sessions without authentication
    Given I do not have an access token
    And I have valid device information
    When I send POST request to "/retrieve-sessions" without authentication
    Then I receive a 401 response
    And the response contains error code "UNAUTHENTICATED"

  Scenario: Retrieve sessions with invalid access token
    Given I have an invalid access token
    And I have valid device information
    When I send POST request to "/retrieve-sessions" with invalid authentication
    Then I receive a 401 response
    And the response contains error code "UNAUTHENTICATED"

  Scenario: Retrieve sessions without sufficient permissions
    Given I have an access token without required scopes
    And I have valid device information
    When I send POST request to "/retrieve-sessions" with insufficient permissions
    Then I receive a 403 response
    And the response contains error code indicating insufficient permissions

  Scenario: Retrieve sessions for device not belonging to authenticated user
    Given I have a 3-legged access token for user A
    And I have device information for user B
    When I send POST request to "/retrieve-sessions" for other user's device
    Then I receive a 403 response
    And the response contains error code indicating insufficient permissions

  # Error scenarios - Device not found

  Scenario: Retrieve sessions for non-existent device
    Given I have a 2-legged access token
    And I have a valid but non-existent device phoneNumber
    When I send POST request to "/retrieve-sessions" with non-existent device
    Then I receive a 404 response
    And the response contains error code indicating device not found
    And the response headers contain "x-correlator"

  # Rate limiting scenarios

  Scenario: Retrieve sessions with rate limiting exceeded
    Given I have a valid access token
    And I have exceeded the rate limit for this endpoint
    When I send POST request to "/retrieve-sessions" exceeding rate limit
    Then I receive a 429 response
    And the response contains error code "TOO_MANY_REQUESTS" or "QUOTA_EXCEEDED"
    And the response headers contain "x-correlator"

  # x-correlator header validation

  Scenario: Retrieve sessions with valid x-correlator header
    Given I have a 2-legged access token
    And I have valid device information
    And I provide a valid x-correlator header
    When I send POST request to "/retrieve-sessions" with correlator
    Then I receive a 200 response
    And the response headers contain the same x-correlator value

  Scenario: Retrieve sessions with invalid x-correlator header format
    Given I have a 2-legged access token
    And I have valid device information
    And I provide an invalid x-correlator header with special characters
    When I send POST request to "/retrieve-sessions" with invalid correlator
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # Response schema validation

  Scenario: Verify response schema compliance for session array
    Given I have a 2-legged access token
    And I have created sessions for a device
    When I send POST request to "/retrieve-sessions" with device identifier
    Then I receive a 200 response
    And the response body complies with RetrieveSessionsOutput schema
    And the response is an array of Session objects
    And each session object contains all required properties
    And all property types match the specification

  # Edge cases and filtering

  Scenario: Retrieve large number of sessions for device
    Given I have a 2-legged access token
    And I have created many sessions (50+) for a device
    When I send POST request to "/retrieve-sessions" with device identifier
    Then I receive a 200 response
    And the response contains all sessions for the device
    And the response time is reasonable

  Scenario: Retrieve sessions with various applicationSessionIds
    Given I have a 2-legged access token
    And I have created sessions with different applicationSessionIds for a device
    When I send POST request to "/retrieve-sessions" with device identifier
    Then I receive a 200 response
    And each session shows its respective applicationSessionId

  Scenario: Retrieve sessions created at different times
    Given I have a 2-legged access token
    And I have created sessions at different times for a device
    When I send POST request to "/retrieve-sessions" with device identifier
    Then I receive a 200 response
    And sessions are returned with their respective creation timestamps
    And sessions may be ordered by creation time

  # Content negotiation

  Scenario: Retrieve sessions with unsupported Accept header
    Given I have a 2-legged access token
    And I have valid device information
    And I set Accept header to "text/xml"
    When I send POST request to "/retrieve-sessions" with unsupported Accept
    Then I receive a 406 response
    And the response contains error indicating unsupported media type

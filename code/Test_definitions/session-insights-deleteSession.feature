Feature: CAMARA Session Insights API, v0.wip - Operation deleteSession
  As a developer integrating with CAMARA Session Insights API
  I want to delete a Session Insights sessions
  So that I can clean up resources when monitoring is no longer needed

  Background:
    Given the Session Insights API is available
    And I have a valid access token with appropriate scopes

  # Sunny day scenarios

  Scenario: Delete existing HTTP session
    Given I have created an HTTP session with sessionId
    When I send DELETE request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 204 response
    And the response body is empty
    And the response headers contain "x-correlator"

  Scenario: Delete existing MQTT3 session
    Given I have created an MQTT3 session with sessionId
    When I send DELETE request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 204 response
    And the response body is empty
    And the response headers contain "x-correlator"

  Scenario: Delete existing MQTT5 session
    Given I have created an MQTT5 session with sessionId
    When I send DELETE request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 204 response
    And the response body is empty
    And the response headers contain "x-correlator"

  Scenario: Delete session with applicationSessionId
    Given I have created a session with applicationSessionId "meet-12345"
    When I send DELETE request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 204 response
    And the response body is empty

  Scenario: Verify session is no longer accessible after deletion
    Given I have created a session with sessionId
    And I have successfully deleted the session
    When I send GET request to "/sessions/{sessionId}" to verify deletion
    Then I receive a 410 response
    And the response contains error code "GONE"

  Scenario: Verify notifications stop after session deletion
    Given I have created a session with notifications enabled
    And I have been receiving notifications for the session
    When I send DELETE request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 204 response
    And no further notifications are sent for this session

  Scenario: Delete session created with different device identifiers
    Given I have created a session with device phoneNumber
    When I send DELETE request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 204 response
    And the session is successfully deleted

  # Rainy day scenarios - Path parameter validation

  Scenario: Delete session with invalid sessionId format
    Given I have an invalid sessionId "not-a-uuid"
    When I send DELETE request to "/sessions/{sessionId}" with invalid sessionId
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"
    And the response headers contain "x-correlator"

  Scenario: Delete session with empty sessionId
    Given I have an empty sessionId
    When I send DELETE request to "/sessions/{sessionId}" with empty sessionId
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Delete session with malformed UUID sessionId
    Given I have a malformed UUID sessionId "123e4567-e89b-12d3-a456-42661417400"
    When I send DELETE request to "/sessions/{sessionId}" with malformed sessionId
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # Error scenarios - Resource not found

  Scenario: Delete non-existent session
    Given I have a valid but non-existent sessionId
    When I send DELETE request to "/sessions/{sessionId}" with non-existent sessionId
    Then I receive a 404 response
    And the response contains error code indicating resource not found
    And the response headers contain "x-correlator"

  # Error scenarios - Authorization and permissions

  Scenario: Delete session without authentication
    Given I do not have an access token
    And I have a valid sessionId
    When I send DELETE request to "/sessions/{sessionId}" without authentication
    Then I receive a 401 response
    And the response contains error code "UNAUTHENTICATED"

  Scenario: Delete session with invalid access token
    Given I have an invalid access token
    And I have a valid sessionId
    When I send DELETE request to "/sessions/{sessionId}" with invalid authentication
    Then I receive a 401 response
    And the response contains error code "UNAUTHENTICATED"

  Scenario: Delete session without sufficient permissions
    Given I have an access token without required scopes
    And I have a valid sessionId
    When I send DELETE request to "/sessions/{sessionId}" with insufficient permissions
    Then I receive a 403 response
    And the response contains error code indicating insufficient permissions

  Scenario: Delete session belonging to different user/device
    Given I have a valid access token for user A
    And I have a sessionId created by user B
    When I send DELETE request to "/sessions/{sessionId}" to delete other user's session
    Then I receive a 403 response
    And the response contains error code indicating insufficient permissions

  # Error scenarios - Session lifecycle

  Scenario: Delete already expired session
    Given I have a sessionId for an expired session
    When I send DELETE request to "/sessions/{sessionId}" with expired sessionId
    Then I receive a 410 response
    And the response contains error code "GONE"
    And the response headers contain "x-correlator"

  Scenario: Delete already deleted session (idempotency test)
    Given I have a sessionId for a session that was already deleted
    When I send DELETE request to "/sessions/{sessionId}" with previously deleted sessionId
    Then I receive a 410 response
    And the response contains error code "GONE"

  # HTTP method validation

  Scenario: Use unsupported HTTP method on sessions endpoint
    Given I have a valid sessionId
    When I send PATCH request to "/sessions/{sessionId}"
    Then I receive a 405 response
    And the response contains error indicating method not allowed

  # x-correlator header validation

  Scenario: Delete session with valid x-correlator header
    Given I have a valid sessionId
    And I provide a valid x-correlator header
    When I send DELETE request to "/sessions/{sessionId}" with correlator
    Then I receive a 204 response
    And the response headers contain the same x-correlator value

  Scenario: Delete session with invalid x-correlator header format
    Given I have a valid sessionId
    And I provide an invalid x-correlator header with special characters
    When I send DELETE request to "/sessions/{sessionId}" with invalid correlator
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # Edge cases and integration

  Scenario: Delete session with pending metrics
    Given I have created a session with sessionId
    And I have sent metrics to the session that are still being processed
    When I send DELETE request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 204 response
    And all pending metrics processing is stopped

  Scenario: Delete session with active webhook notifications
    Given I have created an HTTP session with webhook notifications
    And the session is actively sending notifications
    When I send DELETE request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 204 response
    And no further webhook notifications are sent

  Scenario: Delete session with active MQTT subscriptions
    Given I have created an MQTT session with active subscriptions
    And the session is actively publishing to MQTT topics
    When I send DELETE request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 204 response
    And all MQTT subscriptions are terminated

  # Concurrency scenarios

  Scenario: Delete session while sending metrics
    Given I have created a session with sessionId
    And I am actively sending metrics to the session
    When I send DELETE request to "/sessions/{sessionId}" concurrently
    Then I receive a 204 response
    And subsequent metric submissions to this session fail

  Scenario: Multiple delete requests for same session
    Given I have created a session with sessionId
    When I send multiple DELETE requests to "/sessions/{sessionId}" simultaneously
    Then the first request receives a 204 response
    And subsequent requests receive a 410 response

  # Content validation

  Scenario: Delete session with request body (should be ignored)
    Given I have created a session with sessionId
    And I include a request body in the DELETE request
    When I send DELETE request to "/sessions/{sessionId}" with body
    Then I receive a 204 response
    And the request body is ignored

  # Resource cleanup verification

  Scenario: Verify all session resources are cleaned up after deletion
    Given I have created a session with full configuration
    And the session has active metrics streaming
    And the session has active notifications
    When I send DELETE request to "/sessions/{sessionId}" with valid sessionId
    Then I receive a 204 response
    And all webhook endpoints stop receiving notifications
    And all MQTT topics stop receiving messages
    And session metrics are no longer accepted
    And session cannot be retrieved via GET request

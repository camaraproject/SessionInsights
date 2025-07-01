Feature: CAMARA Session Insights API, v0.wip - Operation sendSessionMetrics
  As a developer integrating with CAMARA Session Insights API
  I want to send application-level KPIs to monitoring sessions
  So that the network operator can evaluate session quality and provide insights

  Background:
    Given the Session Insights API is available
    And I have a valid access token with appropriate scopes
    And I have created a session with valid sessionId

  # Sunny day scenarios

  Scenario: Send valid metrics to HTTP session
    Given I have an active HTTP session with sessionId
    And I have valid metrics payload with all required fields
    When I send POST request to "/sessions/{sessionId}/metrics" with valid metrics
    Then I receive a 204 response
    And the response body is empty
    And the response headers contain "x-correlator"

  Scenario: Send valid metrics to MQTT3 session
    Given I have an active MQTT3 session with sessionId
    And I have valid metrics payload with all required fields
    When I send POST request to "/sessions/{sessionId}/metrics" with valid metrics
    Then I receive a 204 response
    And the response body is empty
    And the response headers contain "x-correlator"

  Scenario: Send valid metrics to MQTT5 session
    Given I have an active MQTT5 session with sessionId
    And I have valid metrics payload with all required fields
    When I send POST request to "/sessions/{sessionId}/metrics" with valid metrics
    Then I receive a 204 response
    And the response body is empty

  Scenario: Send metrics with minimum required fields
    Given I have an active session with sessionId
    And I have metrics payload with latency, jitter, packetLoss, bitrate, and resolution
    When I send POST request to "/sessions/{sessionId}/metrics" with minimum metrics
    Then I receive a 204 response

  Scenario: Send metrics with all valid field types
    Given I have an active session with sessionId
    And I have metrics with latency as float (15.5)
    And I have metrics with jitter as float (2.1)
    And I have metrics with packetLoss as number (0.01)
    And I have metrics with bitrate as number (1000000)
    And I have metrics with resolution as string ("1920x1080")
    When I send POST request to "/sessions/{sessionId}/metrics" with typed metrics
    Then I receive a 204 response

  Scenario: Send metrics multiple times to same session
    Given I have an active session with sessionId
    And I have valid metrics payload
    When I send POST request to "/sessions/{sessionId}/metrics" multiple times
    Then I receive a 204 response each time
    And each metrics submission is processed independently

  Scenario: Send different metric values over time
    Given I have an active session with sessionId
    When I send metrics with latency 10.5 at time T1
    And I send metrics with latency 15.2 at time T2
    And I send metrics with latency 8.7 at time T3
    Then I receive a 204 response for each submission
    And all metric values are processed

  # Rainy day scenarios - Path parameter validation

  Scenario: Send metrics with invalid sessionId format
    Given I have an invalid sessionId "not-a-uuid"
    And I have valid metrics payload
    When I send POST request to "/sessions/{sessionId}/metrics" with invalid sessionId
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"
    And the response headers contain "x-correlator"

  Scenario: Send metrics with empty sessionId
    Given I have an empty sessionId
    And I have valid metrics payload
    When I send POST request to "/sessions/{sessionId}/metrics" with empty sessionId
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics with malformed UUID sessionId
    Given I have a malformed UUID sessionId "123e4567-e89b-12d3-a456-42661417400"
    And I have valid metrics payload
    When I send POST request to "/sessions/{sessionId}/metrics" with malformed sessionId
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # Error scenarios - Missing required fields

  Scenario: Send metrics without required latency field
    Given I have an active session with sessionId
    And I have metrics payload without latency field
    When I send POST request to "/sessions/{sessionId}/metrics" with incomplete metrics
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics without required jitter field
    Given I have an active session with sessionId
    And I have metrics payload without jitter field
    When I send POST request to "/sessions/{sessionId}/metrics" with incomplete metrics
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics without required packetLoss field
    Given I have an active session with sessionId
    And I have metrics payload without packetLoss field
    When I send POST request to "/sessions/{sessionId}/metrics" with incomplete metrics
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics without required bitrate field
    Given I have an active session with sessionId
    And I have metrics payload without bitrate field
    When I send POST request to "/sessions/{sessionId}/metrics" with incomplete metrics
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics without required resolution field
    Given I have an active session with sessionId
    And I have metrics payload without resolution field
    When I send POST request to "/sessions/{sessionId}/metrics" with incomplete metrics
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # Error scenarios - Invalid field types and values

  Scenario: Send metrics with invalid latency type
    Given I have an active session with sessionId
    And I have metrics with latency as string "invalid"
    When I send POST request to "/sessions/{sessionId}/metrics" with invalid latency
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics with negative latency value
    Given I have an active session with sessionId
    And I have metrics with latency as negative number (-5.0)
    When I send POST request to "/sessions/{sessionId}/metrics" with negative latency
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics with invalid jitter type
    Given I have an active session with sessionId
    And I have metrics with jitter as boolean true
    When I send POST request to "/sessions/{sessionId}/metrics" with invalid jitter
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics with negative jitter value
    Given I have an active session with sessionId
    And I have metrics with jitter as negative number (-2.5)
    When I send POST request to "/sessions/{sessionId}/metrics" with negative jitter
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics with invalid packetLoss type
    Given I have an active session with sessionId
    And I have metrics with packetLoss as string "low"
    When I send POST request to "/sessions/{sessionId}/metrics" with invalid packetLoss
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics with packetLoss greater than 1
    Given I have an active session with sessionId
    And I have metrics with packetLoss as 1.5 (greater than 100%)
    When I send POST request to "/sessions/{sessionId}/metrics" with invalid packetLoss
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics with invalid bitrate type
    Given I have an active session with sessionId
    And I have metrics with bitrate as string "high"
    When I send POST request to "/sessions/{sessionId}/metrics" with invalid bitrate
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics with negative bitrate value
    Given I have an active session with sessionId
    And I have metrics with bitrate as negative number (-1000)
    When I send POST request to "/sessions/{sessionId}/metrics" with negative bitrate
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics with invalid resolution type
    Given I have an active session with sessionId
    And I have metrics with resolution as number 1080
    When I send POST request to "/sessions/{sessionId}/metrics" with invalid resolution
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # Error scenarios - Session state

  Scenario: Send metrics to non-existent session
    Given I have a valid but non-existent sessionId
    And I have valid metrics payload
    When I send POST request to "/sessions/{sessionId}/metrics" with non-existent sessionId
    Then I receive a 404 response
    And the response contains error code indicating resource not found
    And the response headers contain "x-correlator"

  Scenario: Send metrics to expired session
    Given I have a sessionId for an expired session
    And I have valid metrics payload
    When I send POST request to "/sessions/{sessionId}/metrics" with expired sessionId
    Then I receive a 410 response
    And the response contains error code "GONE"
    And the response headers contain "x-correlator"

  Scenario: Send metrics to deleted session
    Given I have a sessionId for a deleted session
    And I have valid metrics payload
    When I send POST request to "/sessions/{sessionId}/metrics" with deleted sessionId
    Then I receive a 410 response
    And the response contains error code "GONE"

  # Error scenarios - Authorization and permissions

  Scenario: Send metrics without authentication
    Given I do not have an access token
    And I have a valid sessionId
    And I have valid metrics payload
    When I send POST request to "/sessions/{sessionId}/metrics" without authentication
    Then I receive a 401 response
    And the response contains error code "UNAUTHENTICATED"

  Scenario: Send metrics with invalid access token
    Given I have an invalid access token
    And I have a valid sessionId
    And I have valid metrics payload
    When I send POST request to "/sessions/{sessionId}/metrics" with invalid authentication
    Then I receive a 401 response
    And the response contains error code "UNAUTHENTICATED"

  Scenario: Send metrics without sufficient permissions
    Given I have an access token without required scopes
    And I have a valid sessionId
    And I have valid metrics payload
    When I send POST request to "/sessions/{sessionId}/metrics" with insufficient permissions
    Then I receive a 403 response
    And the response contains error code indicating insufficient permissions

  Scenario: Send metrics to session belonging to different user/device
    Given I have a valid access token for user A
    And I have a sessionId created by user B
    And I have valid metrics payload
    When I send POST request to "/sessions/{sessionId}/metrics" to other user's session
    Then I receive a 403 response
    And the response contains error code indicating insufficient permissions

  # Error scenarios - Request validation

  Scenario: Send metrics with invalid Content-Type
    Given I have an active session with sessionId
    And I have valid metrics payload
    And I set Content-Type to "text/plain"
    When I send POST request to "/sessions/{sessionId}/metrics" with invalid content type
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics with malformed JSON
    Given I have an active session with sessionId
    And I have malformed JSON in the request body
    When I send POST request to "/sessions/{sessionId}/metrics" with malformed JSON
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics with empty request body
    Given I have an active session with sessionId
    When I send POST request to "/sessions/{sessionId}/metrics" with empty body
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  Scenario: Send metrics with extra unknown fields
    Given I have an active session with sessionId
    And I have metrics payload with additional unknown field "extraField"
    When I send POST request to "/sessions/{sessionId}/metrics" with extra fields
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # Validation scenarios - Business logic

  Scenario: Send metrics payload that exceeds size limits
    Given I have an active session with sessionId
    And I have metrics payload that exceeds maximum allowed size
    When I send POST request to "/sessions/{sessionId}/metrics" with oversized payload
    Then I receive a 422 response
    And the response contains error code indicating payload too large

  Scenario: Send metrics at too high frequency
    Given I have an active session with sessionId
    And I have valid metrics payload
    When I send POST requests to "/sessions/{sessionId}/metrics" at very high frequency
    Then some requests may receive a 429 response
    And the response contains error code "TOO_MANY_REQUESTS"

  # x-correlator header validation

  Scenario: Send metrics with valid x-correlator header
    Given I have an active session with sessionId
    And I have valid metrics payload
    And I provide a valid x-correlator header
    When I send POST request to "/sessions/{sessionId}/metrics" with correlator
    Then I receive a 204 response
    And the response headers contain the same x-correlator value

  Scenario: Send metrics with invalid x-correlator header format
    Given I have an active session with sessionId
    And I have valid metrics payload
    And I provide an invalid x-correlator header with special characters
    When I send POST request to "/sessions/{sessionId}/metrics" with invalid correlator
    Then I receive a 400 response
    And the response contains error code "INVALID_ARGUMENT"

  # Edge cases and boundary testing

  Scenario: Send metrics with zero values
    Given I have an active session with sessionId
    And I have metrics with latency 0.0, jitter 0.0, packetLoss 0.0, bitrate 0
    When I send POST request to "/sessions/{sessionId}/metrics" with zero values
    Then I receive a 204 response

  Scenario: Send metrics with very large values
    Given I have an active session with sessionId
    And I have metrics with very large but valid values
    When I send POST request to "/sessions/{sessionId}/metrics" with large values
    Then I receive a 204 response

  Scenario: Send metrics with very small positive values
    Given I have an active session with sessionId
    And I have metrics with very small positive values (0.001)
    When I send POST request to "/sessions/{sessionId}/metrics" with small values
    Then I receive a 204 response

  # HTTP method validation

  Scenario: Use unsupported HTTP method on metrics endpoint
    Given I have an active session with sessionId
    When I send GET request to "/sessions/{sessionId}/metrics"
    Then I receive a 405 response
    And the response contains error indicating method not allowed

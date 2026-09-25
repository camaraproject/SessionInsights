Feature: CAMARA Session Insights API, v0.2.0-rc.2 - Operation sendSessionMetrics
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * The sessionId of an existing active session
    # * The sessionId of an expired session
    # * The sessionId of a deleted session
    # * Valid metrics payload with all required fields (packetDelay, jitter, packetLossErrorRate) and optional fields (upstreamRate, downstreamRate)
    # * Access tokens with appropriate scopes for sending metrics
    #
    # References to OAS spec schemas refer to schemas specified in session-insights.yaml

  Background: Common sendSessionMetrics setup
    Given an environment at "apiRoot"
    And the resource "/session-insights/v0.2rc2/sessions/{sessionId}/metrics"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "sessionId" is set by default to an existing active session sessionId

    # Success scenarios

  @session_insights_sendSessionMetrics_01_valid_metrics
  Scenario: Send valid metrics to an active session
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.packetDelay.value" is set to 15
    And the request body property "$.packetDelay.unit" is set to "Milliseconds"
    And the request body property "$.jitter.value" is set to 2
    And the request body property "$.jitter.unit" is set to "Milliseconds"
    And the request body property "$.packetLossErrorRate" is set to 3
    And the request body property "$.upstreamRate.value" is set to 10
    And the request body property "$.upstreamRate.unit" is set to "Mbps"
    And the request body property "$.downstreamRate.value" is set to 50
    And the request body property "$.downstreamRate.unit" is set to "Mbps"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 204
    And the response body is empty
    And the response header "x-correlator" has same value as the request header "x-correlator"

  @session_insights_sendSessionMetrics_02_minimum_required_fields
  Scenario: Send metrics with only the required fields
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.packetDelay.value" is set to 10
    And the request body property "$.packetDelay.unit" is set to "Milliseconds"
    And the request body property "$.jitter.value" is set to 1
    And the request body property "$.jitter.unit" is set to "Milliseconds"
    And the request body property "$.packetLossErrorRate" is set to 5
    But the request body property "$.upstreamRate" is not included
    And the request body property "$.downstreamRate" is not included
    When the request "sendSessionMetrics" is sent
    Then the response status code is 204

  @session_insights_sendSessionMetrics_03_minimum_boundary_values
  Scenario: Send metrics with minimum boundary values
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.packetDelay.value" is set to 1
    And the request body property "$.packetDelay.unit" is set to "Milliseconds"
    And the request body property "$.jitter.value" is set to 1
    And the request body property "$.jitter.unit" is set to "Milliseconds"
    And the request body property "$.packetLossErrorRate" is set to 1
    And the request body property "$.upstreamRate.value" is set to 0
    And the request body property "$.upstreamRate.unit" is set to "Bps"
    And the request body property "$.downstreamRate.value" is set to 0
    And the request body property "$.downstreamRate.unit" is set to "Bps"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 204

  @session_insights_sendSessionMetrics_04_maximum_boundary_values
  Scenario: Send metrics with maximum boundary values
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.packetDelay.value" is set to 500
    And the request body property "$.packetDelay.unit" is set to "Milliseconds"
    And the request body property "$.jitter.value" is set to 500
    And the request body property "$.jitter.unit" is set to "Milliseconds"
    And the request body property "$.packetLossErrorRate" is set to 10
    And the request body property "$.upstreamRate.value" is set to 1024
    And the request body property "$.upstreamRate.unit" is set to "Gbps"
    And the request body property "$.downstreamRate.value" is set to 1024
    And the request body property "$.downstreamRate.unit" is set to "Gbps"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 204

    # Errors 400

  @session_insights_sendSessionMetrics_400.1_invalid_session_id_format
  Scenario: Invalid sessionId format
    Given the path parameter "sessionId" is set to "not-a-uuid"
    And the request body complies with the OAS schema at "#/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_400.2_malformed_uuid_session_id
  Scenario: Malformed UUID sessionId
    Given the path parameter "sessionId" is set to "123e4567-e89b-12d3-a456-42661417400"
    And the request body complies with the OAS schema at "#/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_400.3_missing_packet_delay_field
  Scenario: Missing required packetDelay field
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.jitter.value" is set to 2
    And the request body property "$.jitter.unit" is set to "Milliseconds"
    And the request body property "$.packetLossErrorRate" is set to 3
    But the request body property "$.packetDelay" is not included
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_400.4_missing_jitter_field
  Scenario: Missing required jitter field
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.packetDelay.value" is set to 15
    And the request body property "$.packetDelay.unit" is set to "Milliseconds"
    And the request body property "$.packetLossErrorRate" is set to 3
    But the request body property "$.jitter" is not included
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_400.5_missing_packet_loss_error_rate_field
  Scenario: Missing required packetLossErrorRate field
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.packetDelay.value" is set to 15
    And the request body property "$.packetDelay.unit" is set to "Milliseconds"
    And the request body property "$.jitter.value" is set to 2
    And the request body property "$.jitter.unit" is set to "Milliseconds"
    But the request body property "$.packetLossErrorRate" is not included
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_400.6_invalid_packet_delay_type
  Scenario: Invalid packetDelay value data type
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.packetDelay.value" is set to "invalid"
    And the request body property "$.packetDelay.unit" is set to "Milliseconds"
    And the request body property "$.jitter.value" is set to 2
    And the request body property "$.jitter.unit" is set to "Milliseconds"
    And the request body property "$.packetLossErrorRate" is set to 3
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_400.7_negative_packet_delay_value
  Scenario: Negative packetDelay value
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.packetDelay.value" is set to -5
    And the request body property "$.packetDelay.unit" is set to "Milliseconds"
    And the request body property "$.jitter.value" is set to 2
    And the request body property "$.jitter.unit" is set to "Milliseconds"
    And the request body property "$.packetLossErrorRate" is set to 3
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_400.8_packet_loss_error_rate_out_of_range
  Scenario: packetLossErrorRate value exceeds maximum
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.packetDelay.value" is set to 15
    And the request body property "$.packetDelay.unit" is set to "Milliseconds"
    And the request body property "$.jitter.value" is set to 2
    And the request body property "$.jitter.unit" is set to "Milliseconds"
    And the request body property "$.packetLossErrorRate" is set to 11
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_400.9_invalid_content_type
  Scenario: Invalid Content-Type header
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the header "Content-Type" is set to "text/plain"
    And a valid metrics payload
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_400.10_malformed_json
  Scenario: Malformed JSON in request body
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body is set to malformed JSON
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_400.11_empty_request_body
  Scenario: Empty request body
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body is empty
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    # Generic 401 errors

  @session_insights_sendSessionMetrics_401.1_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    And an existing active session sessionId
    And the request body complies with the OAS schema at "#/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_401.2_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    And an existing active session sessionId
    And the request body complies with the OAS schema at "#/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_401.3_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    And an existing active session sessionId
    And the request body complies with the OAS schema at "#/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

    # Generic 403 errors

  @session_insights_sendSessionMetrics_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    And an existing active session sessionId
    And the request body complies with the OAS schema at "#/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_403.2_session_token_mismatch
  Scenario: Session not accessible by the API client given in the access token
    Given the header "Authorization" is set to a valid access token emitted to a client which did not create the session
    And the request body complies with the OAS schema at "#/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

    # Errors 404

  @session_insights_sendSessionMetrics_404.1_session_not_found
  Scenario: sessionId of a non-existing session
    Given the path parameter "sessionId" is set to a random UUID
    And the request body complies with the OAS schema at "#/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

    # Errors 410

  @session_insights_sendSessionMetrics_410.1_expired_session
  Scenario: Send metrics to expired session
    Given the path parameter "sessionId" is set to the value of an expired session
    And the request body complies with the OAS schema at "#/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 410
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 410
    And the response property "$.code" is "GONE"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendSessionMetrics_410.2_deleted_session
  Scenario: Send metrics to deleted session
    Given the path parameter "sessionId" is set to the value of a previously deleted session
    And the request body complies with the OAS schema at "#/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 410
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 410
    And the response property "$.code" is "GONE"
    And the response property "$.message" contains a user friendly text

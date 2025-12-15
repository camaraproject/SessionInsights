Feature: CAMARA Session Insights API, vwip - Operation sendSessionMetrics
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * The sessionId of an existing active HTTP session
    # * The sessionId of an existing active MQTT3 session
    # * The sessionId of an existing active MQTT5 session
    # * The sessionId of an expired session
    # * The sessionId of a deleted session
    # * Valid metrics payload with all required fields (latency, jitter, packetLoss, bitrate, resolution)
    # * Access tokens with appropriate scopes for sending metrics
    #
    # References to OAS spec schemas refer to schemas specified in session-insights.yaml

  Background: Common sendSessionMetrics setup
    Given an environment at "apiRoot"
    And the resource "/session-insights/vwip/sessions/{sessionId}/metrics"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "sessionId" is set by default to an existing active session sessionId

    # Success scenarios

  @session_insights_sendMetrics_01_valid_metrics_http_session
  Scenario: Send valid metrics to HTTP session
    Given an existing active HTTP session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.latency" is set to 15.5
    And the request body property "$.jitter" is set to 2.1
    And the request body property "$.packetLoss" is set to 0.01
    And the request body property "$.bitrate" is set to 1000000
    And the request body property "$.resolution" is set to "1920x1080"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 204
    And the response body is empty
    And the response header "x-correlator" has same value as the request header "x-correlator"

  @session_insights_sendMetrics_02_valid_metrics_mqtt3_session
  Scenario: Send valid metrics to MQTT3 session
    Given an existing active MQTT3 session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 204
    And the response body is empty
    And the response header "x-correlator" has same value as the request header "x-correlator"

  @session_insights_sendMetrics_03_valid_metrics_mqtt5_session
  Scenario: Send valid metrics to MQTT5 session
    Given an existing active MQTT5 session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 204
    And the response body is empty

  @session_insights_sendMetrics_04_minimum_required_fields
  Scenario: Send metrics with minimum required fields
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.latency" is set to 10.0
    And the request body property "$.jitter" is set to 1.5
    And the request body property "$.packetLoss" is set to 0.001
    And the request body property "$.bitrate" is set to 500000
    And the request body property "$.resolution" is set to "1280x720"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 204

  @session_insights_sendMetrics_05_zero_values
  Scenario: Send metrics with zero values
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.latency" is set to 0.0
    And the request body property "$.jitter" is set to 0.0
    And the request body property "$.packetLoss" is set to 0.0
    And the request body property "$.bitrate" is set to 0
    And the request body property "$.resolution" is set to "640x480"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 204

  @session_insights_sendMetrics_06_large_values
  Scenario: Send metrics with large valid values
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.latency" is set to 999.9
    And the request body property "$.jitter" is set to 100.0
    And the request body property "$.packetLoss" is set to 0.1
    And the request body property "$.bitrate" is set to 1000000000
    And the request body property "$.resolution" is set to "4096x2160"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 204

    # Errors 400

  @session_insights_sendMetrics_400.1_invalid_session_id_format
  Scenario: Invalid sessionId format
    Given the path parameter "sessionId" is set to "not-a-uuid"
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_400.2_malformed_uuid_session_id
  Scenario: Malformed UUID sessionId
    Given the path parameter "sessionId" is set to "123e4567-e89b-12d3-a456-42661417400"
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_400.3_missing_latency_field
  Scenario: Missing required latency field
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.jitter" is set to 2.1
    And the request body property "$.packetLoss" is set to 0.01
    And the request body property "$.bitrate" is set to 1000000
    And the request body property "$.resolution" is set to "1920x1080"
    But the request body property "$.latency" is not included
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_400.4_missing_jitter_field
  Scenario: Missing required jitter field
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.latency" is set to 15.5
    And the request body property "$.packetLoss" is set to 0.01
    And the request body property "$.bitrate" is set to 1000000
    And the request body property "$.resolution" is set to "1920x1080"
    But the request body property "$.jitter" is not included
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_400.5_missing_packet_loss_field
  Scenario: Missing required packetLoss field
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.latency" is set to 15.5
    And the request body property "$.jitter" is set to 2.1
    And the request body property "$.bitrate" is set to 1000000
    And the request body property "$.resolution" is set to "1920x1080"
    But the request body property "$.packetLoss" is not included
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_400.6_missing_bitrate_field
  Scenario: Missing required bitrate field
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.latency" is set to 15.5
    And the request body property "$.jitter" is set to 2.1
    And the request body property "$.packetLoss" is set to 0.01
    And the request body property "$.resolution" is set to "1920x1080"
    But the request body property "$.bitrate" is not included
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_400.7_missing_resolution_field
  Scenario: Missing required resolution field
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.latency" is set to 15.5
    And the request body property "$.jitter" is set to 2.1
    And the request body property "$.packetLoss" is set to 0.01
    And the request body property "$.bitrate" is set to 1000000
    But the request body property "$.resolution" is not included
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_400.8_invalid_latency_type
  Scenario: Invalid latency data type
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.latency" is set to "invalid"
    And the request body property "$.jitter" is set to 2.1
    And the request body property "$.packetLoss" is set to 0.01
    And the request body property "$.bitrate" is set to 1000000
    And the request body property "$.resolution" is set to "1920x1080"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_400.9_negative_latency_value
  Scenario: Negative latency value
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.latency" is set to -5.0
    And the request body property "$.jitter" is set to 2.1
    And the request body property "$.packetLoss" is set to 0.01
    And the request body property "$.bitrate" is set to 1000000
    And the request body property "$.resolution" is set to "1920x1080"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_400.10_packet_loss_greater_than_one
  Scenario: packetLoss value greater than 1
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.latency" is set to 15.5
    And the request body property "$.jitter" is set to 2.1
    And the request body property "$.packetLoss" is set to 1.5
    And the request body property "$.bitrate" is set to 1000000
    And the request body property "$.resolution" is set to "1920x1080"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_400.11_invalid_resolution_type
  Scenario: Invalid resolution data type
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body property "$.latency" is set to 15.5
    And the request body property "$.jitter" is set to 2.1
    And the request body property "$.packetLoss" is set to 0.01
    And the request body property "$.bitrate" is set to 1000000
    And the request body property "$.resolution" is set to 1080
    When the request "sendSessionMetrics" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_400.12_invalid_content_type
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

  @session_insights_sendMetrics_400.13_malformed_json
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

  @session_insights_sendMetrics_400.14_empty_request_body
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

  @session_insights_sendMetrics_401.1_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    And an existing active session sessionId
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_401.2_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    And an existing active session sessionId
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_401.3_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    And an existing active session sessionId
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

    # Generic 403 errors

  @session_insights_sendMetrics_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    And an existing active session sessionId
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_403.2_session_token_mismatch
  Scenario: Session not accessible by the API client given in the access token
    Given the header "Authorization" is set to a valid access token emitted to a client which did not create the session
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

    # Errors 404

  @session_insights_sendMetrics_404.1_session_not_found
  Scenario: sessionId of a non-existing session
    Given the path parameter "sessionId" is set to a random UUID
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

    # Errors 410

  @session_insights_sendMetrics_410.1_expired_session
  Scenario: Send metrics to expired session
    Given the path parameter "sessionId" is set to the value of an expired session
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 410
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 410
    And the response property "$.code" is "GONE"
    And the response property "$.message" contains a user friendly text

  @session_insights_sendMetrics_410.2_deleted_session
  Scenario: Send metrics to deleted session
    Given the path parameter "sessionId" is set to the value of a previously deleted session
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 410
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 410
    And the response property "$.code" is "GONE"
    And the response property "$.message" contains a user friendly text

    # Errors 422

  @session_insights_sendMetrics_422.1_payload_too_large
  Scenario: Metrics payload exceeds size limits
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the request body contains a metrics payload that exceeds maximum allowed size
    When the request "sendSessionMetrics" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNPROCESSABLE_ENTITY"
    And the response property "$.message" contains a user friendly text

    # Errors 429

  @session_insights_sendMetrics_429.1_too_many_requests
  Scenario: Send metrics at too high frequency
    Given an existing active session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the rate limit for sending metrics has been exceeded
    And the request body complies with the OAS schema at "/components/schemas/MetricsPayload"
    When the request "sendSessionMetrics" is sent
    Then the response status code is 429
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 429
    And the response property "$.code" is "TOO_MANY_REQUESTS"
    And the response property "$.message" contains a user friendly text

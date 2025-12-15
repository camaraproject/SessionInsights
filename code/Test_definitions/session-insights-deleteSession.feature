Feature: CAMARA Session Insights API, vwip - Operation deleteSession
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * The sessionId of an existing HTTP session
    # * The sessionId of an existing MQTT3 session
    # * The sessionId of an existing MQTT5 session
    # * The sessionId of an existing session with active notifications
    # * The sessionId of an existing session with active metrics streaming
    # * Access tokens with appropriate scopes for session deletion
    #
    # References to OAS spec schemas refer to schemas specified in session-insights.yaml

  Background: Common deleteSession setup
    Given an environment at "apiRoot"
    And the resource "/session-insights/vwip/sessions/{sessionId}"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "sessionId" is set by default to an existing session sessionId

    # Success scenarios

  @session_insights_deleteSession_01_delete_http_session
  Scenario: Delete an existing HTTP session
    Given an existing HTTP session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    When the request "deleteSession" is sent
    Then the response status code is 204
    And the response body is empty
    And the response header "x-correlator" has same value as the request header "x-correlator"

  @session_insights_deleteSession_02_delete_mqtt3_session
  Scenario: Delete an existing MQTT3 session
    Given an existing MQTT3 session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    When the request "deleteSession" is sent
    Then the response status code is 204
    And the response body is empty
    And the response header "x-correlator" has same value as the request header "x-correlator"

  @session_insights_deleteSession_03_delete_mqtt5_session
  Scenario: Delete an existing MQTT5 session
    Given an existing MQTT5 session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    When the request "deleteSession" is sent
    Then the response status code is 204
    And the response body is empty
    And the response header "x-correlator" has same value as the request header "x-correlator"

  @session_insights_deleteSession_04_delete_session_with_application_session_id
  Scenario: Delete session with applicationSessionId
    Given an existing session created with applicationSessionId "meet-12345"
    And the path parameter "sessionId" is set to the value for that session
    When the request "deleteSession" is sent
    Then the response status code is 204
    And the response body is empty

  @session_insights_deleteSession_05_verify_session_deleted
  Scenario: Verify session is no longer accessible after deletion
    Given an existing session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    And the session has been successfully deleted
    When the request "getSession" is sent to verify deletion
    Then the response status code is 410
    And the response property "$.code" is "GONE"

  @session_insights_deleteSession_06_stop_notifications_after_deletion
  Scenario: Verify notifications stop after session deletion
    Given an existing HTTP session with active webhook notifications
    And the path parameter "sessionId" is set to the value for that session
    When the request "deleteSession" is sent
    Then the response status code is 204
    And no further notifications are sent for this session

  @session_insights_deleteSession_07_stop_mqtt_subscriptions_after_deletion
  Scenario: Verify MQTT subscriptions terminate after session deletion
    Given an existing MQTT session with active subscriptions
    And the path parameter "sessionId" is set to the value for that session
    When the request "deleteSession" is sent
    Then the response status code is 204
    And all MQTT subscriptions are terminated for this session

    # Errors 400

  @session_insights_deleteSession_400.1_invalid_session_id_format
  Scenario: Invalid sessionId format
    Given the path parameter "sessionId" is set to "not-a-uuid"
    When the request "deleteSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_deleteSession_400.2_malformed_uuid_session_id
  Scenario: Malformed UUID sessionId
    Given the path parameter "sessionId" is set to "123e4567-e89b-12d3-a456-42661417400"
    When the request "deleteSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    # Generic 401 errors

  @session_insights_deleteSession_401.1_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "deleteSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @session_insights_deleteSession_401.2_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "deleteSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @session_insights_deleteSession_401.3_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "deleteSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

    # Generic 403 errors

  @session_insights_deleteSession_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    When the request "deleteSession" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @session_insights_deleteSession_403.2_session_token_mismatch
  Scenario: Session not created by the API client given in the access token
    Given the header "Authorization" is set to a valid access token emitted to a client which did not create the session
    When the request "deleteSession" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

    # Errors 404

  @session_insights_deleteSession_404.1_session_not_found
  Scenario: sessionId of a non-existing session
    Given the path parameter "sessionId" is set to a random UUID
    When the request "deleteSession" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

    # Errors 410

  @session_insights_deleteSession_410.1_expired_session
  Scenario: Delete already expired session
    Given the path parameter "sessionId" is set to the value of an expired session
    When the request "deleteSession" is sent
    Then the response status code is 410
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 410
    And the response property "$.code" is "GONE"
    And the response property "$.message" contains a user friendly text

  @session_insights_deleteSession_410.2_already_deleted_session
  Scenario: Delete already deleted session (idempotency test)
    Given the path parameter "sessionId" is set to the value of a previously deleted session
    When the request "deleteSession" is sent
    Then the response status code is 410
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 410
    And the response property "$.code" is "GONE"
    And the response property "$.message" contains a user friendly text

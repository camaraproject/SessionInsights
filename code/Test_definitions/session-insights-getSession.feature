Feature: CAMARA Session Insights API, vwip - Operation getSession
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * The sessionId of an existing HTTP session
    # * The sessionId of an existing MQTT3 session
    # * The sessionId of an existing MQTT5 session
    # * The sessionId of an existing session with applicationSessionId
    # * The sessionId of sessions created with different device identifier types
    # * Access tokens with appropriate scopes for session retrieval
    #
    # References to OAS spec schemas refer to schemas specified in session-insights.yaml

  Background: Common getSession setup
    Given an environment at "apiRoot"
    And the resource "/session-insights/vwip/sessions/{sessionId}"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "sessionId" is set by default to an existing session sessionId

    # Success scenarios

  @session_insights_getSession_01_retrieve_http_session
  Scenario: Retrieve existing HTTP session by sessionId
    Given an existing HTTP session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    When the request "getSession" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Session"
    And the response property "$.id" has the same value as the path parameter "sessionId"
    And the response property "$.protocol" is "HTTP"
    And the response property "$.device" is present
    And the response property "$.applicationServer" is present
    And the response property "$.sink" is present
    And the response property "$.subscribedEventTypes" is present
    And the response property "$.startTime" is present and complies with date-time format
    And the response property "$.expiresAt" is present and complies with date-time format

  @session_insights_getSession_02_retrieve_mqtt3_session
  Scenario: Retrieve existing MQTT3 session by sessionId
    Given an existing MQTT3 session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    When the request "getSession" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Session"
    And the response property "$.id" has the same value as the path parameter "sessionId"
    And the response property "$.protocol" is "MQTT3"
    And the response property "$.protocolSettings" is present
    And the response property "$.device" is present
    And the response property "$.subscribedEventTypes" is present

  @session_insights_getSession_03_retrieve_mqtt5_session
  Scenario: Retrieve existing MQTT5 session by sessionId
    Given an existing MQTT5 session created by operation createSession
    And the path parameter "sessionId" is set to the value for that session
    When the request "getSession" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.protocol" is "MQTT5"
    And the response property "$.protocolSettings" is present

  @session_insights_getSession_04_session_with_application_session_id
  Scenario: Retrieve session with applicationSessionId
    Given an existing session created with applicationSessionId "meet-12345"
    And the path parameter "sessionId" is set to the value for that session
    When the request "getSession" is sent
    Then the response status code is 200
    And the response property "$.applicationSessionId" is "meet-12345"

  @session_insights_getSession_05_session_with_phone_number
  Scenario: Retrieve session created with device phoneNumber
    Given an existing session created with device phoneNumber
    And the path parameter "sessionId" is set to the value for that session
    When the request "getSession" is sent
    Then the response status code is 200
    And the response property "$.device.phoneNumber" is present
    And the response property "$.device" contains exactly one identifier property

  @session_insights_getSession_06_session_with_ipv4_address
  Scenario: Retrieve session created with device IPv4 address
    Given an existing session created with device IPv4 address
    And the path parameter "sessionId" is set to the value for that session
    When the request "getSession" is sent
    Then the response status code is 200
    And the response property "$.device.ipv4Address" is present
    And the response property "$.device" contains exactly one identifier property

  @session_insights_getSession_07_session_with_ipv6_address
  Scenario: Retrieve session created with device IPv6 address
    Given an existing session created with device IPv6 address
    And the path parameter "sessionId" is set to the value for that session
    When the request "getSession" is sent
    Then the response status code is 200
    And the response property "$.device.ipv6Address" is present
    And the response property "$.device" contains exactly one identifier property

  @session_insights_getSession_08_session_with_network_access_identifier
  Scenario: Retrieve session created with network access identifier
    Given an existing session created with device networkAccessIdentifier
    And the path parameter "sessionId" is set to the value for that session
    When the request "getSession" is sent
    Then the response status code is 200
    And the response property "$.device.networkAccessIdentifier" is present
    And the response property "$.device" contains exactly one identifier property

    # Errors 400

  @session_insights_getSession_400.1_invalid_session_id_format
  Scenario: Invalid sessionId format
    Given the path parameter "sessionId" is set to "not-a-uuid"
    When the request "getSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_getSession_400.2_malformed_uuid_session_id
  Scenario: Malformed UUID sessionId
    Given the path parameter "sessionId" is set to "123e4567-e89b-12d3-a456-42661417400"
    When the request "getSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    # Generic 401 errors

  @session_insights_getSession_401.1_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "getSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @session_insights_getSession_401.2_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "getSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @session_insights_getSession_401.3_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "getSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

    # Generic 403 errors

  @session_insights_getSession_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    When the request "getSession" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @session_insights_getSession_403.2_session_token_mismatch
  Scenario: Session not accessible by the API client given in the access token
    Given the header "Authorization" is set to a valid access token emitted to a client which did not create the session
    When the request "getSession" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

    # Errors 404

  @session_insights_getSession_404.1_session_not_found
  Scenario: sessionId of a non-existing session
    Given the path parameter "sessionId" is set to a random UUID
    When the request "getSession" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

    # Errors 410

  @session_insights_getSession_410.1_expired_session
  Scenario: sessionId of an expired session
    Given the path parameter "sessionId" is set to the value of an expired session
    When the request "getSession" is sent
    Then the response status code is 410
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 410
    And the response property "$.code" is "GONE"
    And the response property "$.message" contains a user friendly text

  @session_insights_getSession_410.2_deleted_session
  Scenario: sessionId of a deleted session
    Given the path parameter "sessionId" is set to the value of a previously deleted session
    When the request "getSession" is sent
    Then the response status code is 410
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 410
    And the response property "$.code" is "GONE"
    And the response property "$.message" contains a user friendly text

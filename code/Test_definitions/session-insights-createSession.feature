Feature: CAMARA Session Insights API, v0.2.0-rc.2 - Operation createSession
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * A valid Application Profile ID that exists in the system
    # * Valid device identifiers (phoneNumber, IPv4/IPv6 addresses, networkAccessIdentifier)
    # * Valid application server configuration (domain name or IP addresses with ports)
    # * Valid HTTPS webhook URLs for notification delivery testing
    # * Access tokens with appropriate scopes for 2-legged and 3-legged authentication
    #
    # References to OAS spec schemas refer to schemas specified in session-insights.yaml

  Background: Common createSession setup
    Given an environment at "apiRoot"
    And the resource "/session-insights/v0.2rc2/sessions"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

    # Success scenarios

  @session_insights_createSession_01_session_creation
  Scenario: Create session with valid parameters
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    When the request "createSession" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Session"
    And the response property "$.id" is present and complies with the OAS schema at "#/components/schemas/SessionId"
    And the response property "$.sink" is present
    And the response property "$.startsAt" is present and complies with date-time format
    And the response property "$.expiresAt" complies with date-time format if present

  @session_insights_createSession_02_with_application_session_id
  Scenario: Create session with optional applicationSessionId
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    And the request body property "$.applicationSessionId" is set to "meet-12345"
    When the request "createSession" is sent
    Then the response status code is 201
    And the response property "$.applicationSessionId" is "meet-12345"

  @session_insights_createSession_03_ipv4_device_identifier
  Scenario: Create session with IPv4 device identifier
    Given a valid device with IPv4 address and port
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    When the request "createSession" is sent
    Then the response status code is 201
    And the response property "$.device" contains IPv4 address information

  @session_insights_createSession_04_ipv6_device_identifier
  Scenario: Create session with IPv6 device identifier
    Given a valid device with IPv6 address
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    When the request "createSession" is sent
    Then the response status code is 201
    And the response property "$.device" contains IPv6 address information

  @session_insights_createSession_05_network_access_identifier
  Scenario: Create session with network access identifier
    Given a valid device with networkAccessIdentifier
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    When the request "createSession" is sent
    Then the response status code is 201
    And the response property "$.device" contains networkAccessIdentifier information

    # Errors 400

  @session_insights_createSession_400.1_missing_application_profile_id
  Scenario: Missing required applicationProfileId
    Given a valid device with phoneNumber
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    But the request body property "$.applicationProfileId" is not included
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.2_missing_application_server
  Scenario: Missing required applicationServer
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And the request body property "$.sink" is set to a valid webhook URL
    But the request body property "$.applicationServer" is not included
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.3_missing_sink
  Scenario: Missing required sink
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    But the request body property "$.sink" is not included
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.4_invalid_sink_value
  Scenario: Invalid sink value
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to "not-a-valid-uri"
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.5_invalid_application_profile_id_format
  Scenario: Invalid applicationProfileId format
    Given a valid device with phoneNumber
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    And the request body property "$.applicationProfileId" is set to "not-a-uuid"
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.6_invalid_phone_number_format
  Scenario: Invalid phoneNumber format
    Given a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    And the request body property "$.device.phoneNumber" is set to "invalid-phone"
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.7_device_no_identifiers
  Scenario: Device object with no identifiers
    Given a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    And the request body property "$.device" is set to an empty object
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.8_invalid_content_type
  Scenario: Invalid Content-Type header
    Given a valid session request body
    And the header "Content-Type" is set to "text/plain"
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.9_malformed_json
  Scenario: Malformed JSON in request body
    Given the request body is set to malformed JSON
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.10_empty_request_body
  Scenario: Empty request body
    Given the request body is empty
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.11_unsupported_sink_credential_type
  Scenario: Sink credential type not supported by the API provider
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    And the API provider does not support the "PRIVATE_KEY_JWT" sink credential type
    And the request body property "$.sinkCredential.credentialType" is set to "PRIVATE_KEY_JWT"
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_CREDENTIAL"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.12_expired_sink_credential_token
  Scenario: Expired access token in the sink credential
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    And the request body property "$.sinkCredential.credentialType" is set to "ACCESSTOKEN"
    And the request body property "$.sinkCredential.accessTokenType" is set to "bearer"
    And the request body property "$.sinkCredential.accessToken" is set to an expired access token
    And the request body property "$.sinkCredential.accessTokenExpiresUtc" is set to a timestamp in the past
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_TOKEN"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.13_sink_not_accepted
  Scenario: Sink URL is well-formed but not accepted by the API provider
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a well-formed HTTPS URL that the API provider cannot reach
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_SINK"
    And the response property "$.message" contains a user friendly text

    # Generic 401 errors

  @session_insights_createSession_401.1_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    And a valid session request body
    When the request "createSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_401.2_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    And a valid session request body
    When the request "createSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_401.3_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    And a valid session request body
    When the request "createSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

    # Generic 403 errors

  @session_insights_createSession_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    And a valid session request body
    When the request "createSession" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

    # Errors 409

  @session_insights_createSession_409.1_session_already_exists
  Scenario: Session already exists for this device and application profile
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    And a session already exists for this device and application profile combination
    When the request "createSession" is sent
    Then the response status code is 409
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 409
    And the response property "$.code" is "ALREADY_EXISTS"
    And the response property "$.message" contains a user friendly text

    # Errors 422

  @session_insights_createSession_422.1_three_legged_token_with_device_parameter
  Scenario: 3-legged token used with device parameter
    Given the header "Authorization" is set to a valid 3-legged access token
    And a valid device with phoneNumber is provided in the request body
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    When the request "createSession" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_422.2_two_legged_token_without_device_parameter
  Scenario: 2-legged token used without device parameter
    Given the header "Authorization" is set to a valid 2-legged access token
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    But the request body property "$.device" is not included
    When the request "createSession" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

    # Errors 429

  @session_insights_createSession_429.1_rate_limit_exceeded
  Scenario: Rate limit exceeded
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.sink" is set to a valid webhook URL
    And the rate limit for this endpoint has been exceeded
    When the request "createSession" is sent
    Then the response status code is 429
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 429
    And the response property "$.code" is "TOO_MANY_REQUESTS"
    And the response property "$.message" contains a user friendly text

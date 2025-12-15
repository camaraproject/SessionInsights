Feature: CAMARA Session Insights API, vwip - Operation createSession
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * A valid Application Profile ID that exists in the system
    # * Valid device identifiers (phoneNumber, IPv4/IPv6 addresses, networkAccessIdentifier)
    # * Valid application server configuration (domain name or IP addresses with ports)
    # * Valid webhook URLs for HTTP protocol testing
    # * Valid MQTT broker configuration for MQTT protocol testing
    # * Access tokens with appropriate scopes for 2-legged and 3-legged authentication
    #
    # References to OAS spec schemas refer to schemas specified in session-insights.yaml

  Background: Common createSession setup
    Given an environment at "apiRoot"
    And the resource "/session-insights/vwip/sessions"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

    # Success scenarios

  @session_insights_createSession_01_http_session_creation
  Scenario: Create HTTP session with valid parameters
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    When the request "createSession" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/CreateSessionResponse"
    And the response property "$.id" is present and complies with the OAS schema at "/components/schemas/SessionId"
    And the response property "$.protocol" is "HTTP"
    And the response property "$.sink" is present
    And the response property "$.startTime" is present and complies with date-time format
    And the response property "$.expiresAt" is present and complies with date-time format

  @session_insights_createSession_02_mqtt3_session_creation
  Scenario: Create MQTT3 session with valid parameters
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "MQTT3"
    When the request "createSession" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/CreateSessionResponse"
    And the response property "$.id" is present and complies with the OAS schema at "/components/schemas/SessionId"
    And the response property "$.protocol" is "MQTT3"
    And the response property "$.protocolSettings" is present

  @session_insights_createSession_03_mqtt5_session_creation
  Scenario: Create MQTT5 session with valid parameters
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "MQTT5"
    When the request "createSession" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.protocol" is "MQTT5"
    And the response property "$.protocolSettings" is present

  @session_insights_createSession_04_with_application_session_id
  Scenario: Create session with optional applicationSessionId
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    And the request body property "$.applicationSessionId" is set to "meet-12345"
    When the request "createSession" is sent
    Then the response status code is 201
    And the response property "$.applicationSessionId" is "meet-12345"

  @session_insights_createSession_05_ipv4_device_identifier
  Scenario: Create session with IPv4 device identifier
    Given a valid device with IPv4 address and port
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    When the request "createSession" is sent
    Then the response status code is 201
    And the response property "$.device" contains IPv4 address information

  @session_insights_createSession_06_ipv6_device_identifier
  Scenario: Create session with IPv6 device identifier
    Given a valid device with IPv6 address
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    When the request "createSession" is sent
    Then the response status code is 201
    And the response property "$.device" contains IPv6 address information

  @session_insights_createSession_07_network_access_identifier
  Scenario: Create session with network access identifier
    Given a valid device with networkAccessIdentifier
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    When the request "createSession" is sent
    Then the response status code is 201
    And the response property "$.device" contains networkAccessIdentifier information

    # Errors 400

  @session_insights_createSession_400.1_missing_application_profile_id
  Scenario: Missing required applicationProfileId
    Given a valid device with phoneNumber
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    But the request body property "$.applicationProfileId" is not included
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.2_missing_device
  Scenario: Missing required device information
    Given a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    But the request body property "$.device" is not included
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.3_missing_application_server
  Scenario: Missing required applicationServer
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    But the request body property "$.applicationServer" is not included
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.4_missing_protocol
  Scenario: Missing required protocol
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    But the request body property "$.protocol" is not included
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.5_invalid_protocol_value
  Scenario: Invalid protocol value
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "INVALID_PROTOCOL"
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.6_http_missing_sink
  Scenario: HTTP session missing required sink
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    But the request body property "$.sink" is not included
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.7_invalid_application_profile_id_format
  Scenario: Invalid applicationProfileId format
    Given a valid device with phoneNumber
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    And the request body property "$.applicationProfileId" is set to "not-a-uuid"
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.8_invalid_phone_number_format
  Scenario: Invalid phoneNumber format
    Given a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    And the request body property "$.device.phoneNumber" is set to "invalid-phone"
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.9_device_no_identifiers
  Scenario: Device object with no identifiers
    Given a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    And the request body property "$.device" is set to an empty object
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_createSession_400.10_invalid_content_type
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

  @session_insights_createSession_400.11_malformed_json
  Scenario: Malformed JSON in request body
    Given the request body is set to malformed JSON
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
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

    # Errors 404

  @session_insights_createSession_404.1_application_profile_not_found
  Scenario: applicationProfileId not found
    Given a valid device with phoneNumber
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    And the request body property "$.applicationProfileId" is set to a valid UUID that does not exist
    When the request "createSession" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

    # Errors 409

  @session_insights_createSession_409.1_session_conflict
  Scenario: Session already exists for this device and application profile
    Given a valid device with phoneNumber
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    And a session already exists for this device and application profile combination
    When the request "createSession" is sent
    Then the response status code is 409
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 409
    And the response property "$.code" is "CONFLICT"
    And the response property "$.message" contains a user friendly text

    # Errors 422

  @session_insights_createSession_422.1_three_legged_token_with_device_parameter
  Scenario: 3-legged token used with device parameter
    Given the header "Authorization" is set to a valid 3-legged access token
    And a valid device with phoneNumber is provided in the request body
    And a valid Application Profile ID
    And a valid application server configuration
    And the request body property "$.protocol" is set to "HTTP"
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
    And the request body property "$.protocol" is set to "HTTP"
    And the request body property "$.sink" is set to a valid webhook URL
    But the request body property "$.device" is not included
    When the request "createSession" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

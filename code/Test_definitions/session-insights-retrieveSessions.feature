Feature: CAMARA Session Insights API, vwip - Operation retrieveSessionsByDevice
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * Valid device identifiers (phoneNumber, IPv4/IPv6 addresses, networkAccessIdentifier) with existing sessions
    # * Valid device identifiers with no existing sessions
    # * Access tokens with appropriate scopes for 2-legged and 3-legged authentication
    # * Device identifiers that exist but belong to different users/clients
    #
    # References to OAS spec schemas refer to schemas specified in session-insights.yaml

  Background: Common retrieveSessionsByDevice setup
    Given an environment at "apiRoot"
    And the resource "/session-insights/vwip/retrieve-sessions"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

    # Success scenarios

  @session_insights_retrieveSessions_01_phone_number_2legged_token
  Scenario: Retrieve sessions for device with phoneNumber using 2-legged token
    Given the header "Authorization" is set to a valid 2-legged access token
    And multiple existing sessions for a device with phoneNumber
    And the request body property "$.device.phoneNumber" is set to that device phoneNumber
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/RetrieveSessionsOutput"
    And the response property "$" is an array
    And each item in the response array complies with the OAS schema at "/components/schemas/Session"
    And all sessions in the response belong to the specified device

  @session_insights_retrieveSessions_02_ipv4_address_2legged_token
  Scenario: Retrieve sessions for device with IPv4 address using 2-legged token
    Given the header "Authorization" is set to a valid 2-legged access token
    And existing sessions for a device with IPv4 address
    And the request body property "$.device.ipv4Address" is set to that device IPv4 address
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And all sessions in the response belong to the device with specified IPv4 address

  @session_insights_retrieveSessions_03_ipv6_address_2legged_token
  Scenario: Retrieve sessions for device with IPv6 address using 2-legged token
    Given the header "Authorization" is set to a valid 2-legged access token
    And existing sessions for a device with IPv6 address
    And the request body property "$.device.ipv6Address" is set to that device IPv6 address
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And all sessions in the response belong to the device with specified IPv6 address

  @session_insights_retrieveSessions_04_network_access_identifier_2legged_token
  Scenario: Retrieve sessions for device with networkAccessIdentifier using 2-legged token
    Given the header "Authorization" is set to a valid 2-legged access token
    And existing sessions for a device with networkAccessIdentifier
    And the request body property "$.device.networkAccessIdentifier" is set to that device networkAccessIdentifier
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And all sessions in the response belong to the device with specified networkAccessIdentifier

  @session_insights_retrieveSessions_05_3legged_token_without_device
  Scenario: Retrieve sessions using 3-legged token without device parameter
    Given the header "Authorization" is set to a valid 3-legged access token for a specific device
    And existing sessions for the authenticated device
    And the request body does not include "$.device" property
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And all sessions in the response belong to the authenticated device

  @session_insights_retrieveSessions_06_empty_array_no_sessions
  Scenario: Retrieve empty array when device has no sessions
    Given the header "Authorization" is set to a valid 2-legged access token
    And a device with phoneNumber that has no existing sessions
    And the request body property "$.device.phoneNumber" is set to that device phoneNumber
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$" is an empty array

  @session_insights_retrieveSessions_07_different_protocol_types
  Scenario: Retrieve sessions including different protocol types
    Given the header "Authorization" is set to a valid 2-legged access token
    And existing HTTP, MQTT3, and MQTT5 sessions for a device
    And the request body property "$.device.phoneNumber" is set to that device phoneNumber
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 200
    And the response contains sessions with different protocol types
    And each session contains appropriate protocol-specific properties

  @session_insights_retrieveSessions_08_multiple_device_identifiers
  Scenario: Retrieve sessions with device having multiple identifiers
    Given the header "Authorization" is set to a valid 2-legged access token
    And the request body property "$.device.phoneNumber" is set to a valid phoneNumber
    And the request body property "$.device.ipv4Address" is set to a valid IPv4 address
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 200
    And the response device objects contain only one identifier property

    # Errors 400

  @session_insights_retrieveSessions_400.1_invalid_phone_number_format
  Scenario: Invalid phoneNumber format
    Given the header "Authorization" is set to a valid 2-legged access token
    And the request body property "$.device.phoneNumber" is set to "invalid-phone"
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_retrieveSessions_400.2_invalid_ipv4_address_format
  Scenario: Invalid IPv4 address format
    Given the header "Authorization" is set to a valid 2-legged access token
    And the request body property "$.device.ipv4Address.publicAddress" is set to "999.999.999.999"
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_retrieveSessions_400.3_invalid_ipv6_address_format
  Scenario: Invalid IPv6 address format
    Given the header "Authorization" is set to a valid 2-legged access token
    And the request body property "$.device.ipv6Address" is set to "invalid-ipv6"
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_retrieveSessions_400.4_device_no_identifiers
  Scenario: Device object with no identifiers
    Given the header "Authorization" is set to a valid 2-legged access token
    And the request body property "$.device" is set to an empty object
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_retrieveSessions_400.5_invalid_content_type
  Scenario: Invalid Content-Type header
    Given the header "Authorization" is set to a valid 2-legged access token
    And the header "Content-Type" is set to "text/plain"
    And a valid device identifier in the request body
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @session_insights_retrieveSessions_400.6_malformed_json
  Scenario: Malformed JSON in request body
    Given the header "Authorization" is set to a valid 2-legged access token
    And the request body is set to malformed JSON
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    # Generic 401 errors

  @session_insights_retrieveSessions_401.1_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    And a valid device identifier in the request body
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @session_insights_retrieveSessions_401.2_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    And a valid device identifier in the request body
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @session_insights_retrieveSessions_401.3_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    And a valid device identifier in the request body
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

    # Generic 403 errors

  @session_insights_retrieveSessions_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include the required scope
    And a valid device identifier in the request body
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @session_insights_retrieveSessions_403.2_device_access_denied
  Scenario: Device not accessible by the API client given in the access token
    Given the header "Authorization" is set to a valid 3-legged access token for user A
    And the request body property "$.device.phoneNumber" is set to a device belonging to user B
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

    # Errors 404

  @session_insights_retrieveSessions_404.1_device_not_found
  Scenario: Device not found
    Given the header "Authorization" is set to a valid 2-legged access token
    And the request body property "$.device.phoneNumber" is set to a valid but non-existent phoneNumber
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

    # Errors 422

  @session_insights_retrieveSessions_422.1_2legged_token_missing_device
  Scenario: 2-legged token used without device parameter
    Given the header "Authorization" is set to a valid 2-legged access token
    And the request body does not include "$.device" property
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @session_insights_retrieveSessions_422.2_3legged_token_with_device
  Scenario: 3-legged token used with device parameter
    Given the header "Authorization" is set to a valid 3-legged access token
    And the request body property "$.device.phoneNumber" is set to a valid phoneNumber
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

    # Errors 429

  @session_insights_retrieveSessions_429.1_rate_limit_exceeded
  Scenario: Rate limit exceeded
    Given the header "Authorization" is set to a valid access token
    And the rate limit for this endpoint has been exceeded
    And a valid device identifier in the request body
    When the request "retrieveSessionsByDevice" is sent
    Then the response status code is 429
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 429
    And the response property "$.code" is "TOO_MANY_REQUESTS"
    And the response property "$.message" contains a user friendly text

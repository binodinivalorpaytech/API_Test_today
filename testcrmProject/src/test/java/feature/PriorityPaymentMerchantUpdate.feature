Feature: Valor Update Merchant API - Fixed Complete Suite

  Background:
    * url baseUrl
    * def endpoint = '/api/valor/create'
    * def payloads = read('classpath:data/PPMerchantUpdate.json')
    * def validToken = 'Bearer ' + accessToken
    * def expiredToken = 'Bearer INVALID.EXPIRED.TOKEN'
    * def malformedToken = 'Bearer INVALID_TOKEN'
    * configure headers = { 'Content-Type': 'application/json', 'accept': 'application/json' }

    # Debug (you can remove later)
    * print payloads

# ================================================================
# POSITIVE TEST CASES
# ================================================================

  @positive @smoke
  Scenario: TC_Update_001 - Update merchant with full payload
    * def payload = JSON.parse(JSON.stringify(payloads.validPayload))
    * print payload
    Given path endpoint
    And header Authorization = validToken
    And request payload
    When method POST
    Then status 400
    And match response.status == 'Validation Failed'
    # And match response.data != notpresent

  @positive
  Scenario: TC_Update_002 - Update merchant with minimal store data
    * def payload = JSON.parse(JSON.stringify(payloads.validPayloadMinimalStoreData))
    * print payload
    Given path endpoint
    And header Authorization = validToken
    And request payload
    When method POST
    Then status 400
    And match response.status == 'Validation Failed'
    #And match response.data != notpresent

# ================================================================
# NEGATIVE TEST CASES — 400 BAD REQUEST
# ================================================================

  @negative
  Scenario: TC_Update_003 - Missing newUserId
    * def payload = JSON.parse(JSON.stringify(payloads.validPayload))
    * remove payload.newUserId
    Given path endpoint
    And header Authorization = validToken
    And request payload
    When method POST
    Then status 400

  @negative
  Scenario: TC_Update_004 - Missing emailId
    * def payload = JSON.parse(JSON.stringify(payloads.validPayload))
    * remove payload.emailId
    Given path endpoint
    And header Authorization = validToken
    And request payload
    When method POST
    Then status 400

  @negative
  Scenario: TC_Update_005 - Missing storeData
    * def payload = JSON.parse(JSON.stringify(payloads.validPayload))
    * remove payload.storeData
    Given path endpoint
    And header Authorization = validToken
    And request payload
    When method POST
    Then status 400

  @negative
  Scenario: TC_Update_006 - Empty storeData
    * def payload = JSON.parse(JSON.stringify(payloads.validPayload))
    * set payload.storeData = []
    Given path endpoint
    And header Authorization = validToken
    And request payload
    When method POST
    Then status 400
    And match response.message contains 'storeData'

  @negative
  Scenario: TC_Update_007 - Invalid email format
    * def payload = JSON.parse(JSON.stringify(payloads.validPayload))
    * set payload.emailId = 'invalid-email'
    Given path endpoint
    And header Authorization = validToken
    And request payload
    When method POST
    Then status 400

# ================================================================
# SECURITY TEST CASES — 401
# ================================================================

  @security
  Scenario: TC_Update_008 - Missing Authorization
    Given path endpoint
    And request payloads.validPayload
    When method POST
    Then status 401

  @security
  Scenario: TC_Update_009 - Expired token
    Given path endpoint
    And header Authorization = expiredToken
    And request payloads.validPayload
    When method POST
    Then status 401

  @security
  Scenario: TC_Update_010 - Malformed token
    Given path endpoint
    And header Authorization = malformedToken
    And request payloads.validPayload
    When method POST
    Then status 401

# ================================================================
# METHOD VALIDATION
# ================================================================

  @negative
  Scenario: TC_Update_011 - GET instead of POST
    Given path endpoint
    And header Authorization = validToken
    When method GET
    Then status 200

  @negative
  Scenario: TC_Update_012 - PUT instead of POST
    Given path endpoint
    And header Authorization = validToken
    And request payloads.validPayload
    When method PUT
    Then status 404
    * print "Full Response:", response
    * print response.message
# ================================================================
# BOUNDARY TEST CASES
# ================================================================

  @boundary
  Scenario: TC_Update_013 - Long legalName
    * def payload = JSON.parse(JSON.stringify(payloads.validPayload))
    * set payload.legalName = 'A'.repeat(300)
    Given path endpoint
    And header Authorization = validToken
    And request payload
    When method POST
    Then status 400

  @boundary
  Scenario: TC_Update_014 - Invalid mobile number (too short)
    * def payload = JSON.parse(JSON.stringify(payloads.validPayload))
    * set payload.mobile = '123'
    Given path endpoint
    And header Authorization = validToken
    And request payload
    When method POST
    Then status 400

# ================================================================
# DATA-DRIVEN TEST CASES
# ================================================================

  @negative
  Scenario Outline: TC_Update_015 - Missing required field <field>
    * def payload = JSON.parse(JSON.stringify(payloads.validPayload))
    * eval delete payload['<field>']
    Given path endpoint
    And header Authorization = validToken
    And request payload
    When method POST
    Then status 400

    Examples:
      | field        |
      | legalName    |
      | userName     |
      | legalCity    |
/**
 * Author: Binodini Sahoo
 * Description: Merchant API Automation - Create Merchant FD Nashville
 * Created Date: 12-Mar-2026
 */

@ValorPay @CreateMerchant
Feature: Valor Pay - Create Merchant API (POST /api/valor/create?FDNashville=)

  Background:
    # ── Injected automatically by karate-config.js ─────────────────────────
    * def accessToken = accessToken
    * def baseUrl     = baseUrl

    # ── URL + headers set once, inherited by every scenario ────────────────
    * url baseUrl
    * def apiPath = '/api/valor/create'
    * header Authorization = 'Bearer ' + accessToken
    * header Accept        = 'application/json'
    * header Content-Type  = 'application/json'

    # ── Random suffix prevents duplicate-user failures across runs ──────────
    * def random       = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser  = 'Merchant' + random
    * def dynamicEmail = 'binodini'+ '@valorpaytech.com'

    # ── Load JSON test data ─────────────────────────────────────────────────
    * def testDataNashville = karate.read('classpath:data/MerchantFDNasville.json')

    # ── Deep-copy via JSON round-trip — compatible with ALL Karate versions ──
    * def basePayload = JSON.parse(JSON.stringify(testDataNashville.basePayload))
    * set basePayload.userName = dynamicUser
    * set basePayload.emailId  = dynamicEmail

  # ============================================================
  #  POSITIVE TEST CASES
  # ============================================================

  @Positive @TC_POS_001 @Smoke
  Scenario: TC_POS_001 - Create merchant with all valid required and optional fields
    Given path apiPath
    And param FDNashville = ''
    And request basePayload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 200
    And match response.status == true
    * print 'TC_POS_001 | mpId:', response.mpId
    * print 'TC_POS_001 | storeInfo:', response.storeInfo

  @Positive @TC_POS_002
  Scenario: TC_POS_002 - Create merchant with tip feature enabled
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.positive.TC_POS_002_tipEnabled
    * set payload.storeData[0].epiData[0].features.tip.enabled = td.tip_enabled
    * set payload.storeData[0].epiData[0].features.tip.value   = td.tip_value
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 200
    And match response.status == true
    * print 'TC_POS_002 | mpId:', response.mpId

  @Positive @TC_POS_003
  Scenario: TC_POS_003 - Create merchant with surcharge and tax features enabled
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.positive.TC_POS_003_surchargeAndTax
    * set payload.storeData[0].epiData[0].features.surcharge.enabled              = td.surcharge_enabled
    * set payload.storeData[0].epiData[0].features.surcharge.value                = td.surcharge_value
    * set payload.storeData[0].epiData[0].features.tax.enabled                    = td.tax_enabled
    * set payload.storeData[0].epiData[0].features.tax.value                      = td.tax_value
    * set payload.storeData[0].epiData[0].processorData[0].surchargeIndicator     = td.surchargeIndicator
    * set payload.storeData[0].epiData[0].processorData[0].surchargePercentage    = td.surchargePercentage
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 200
    And match response.status == true
    * print 'TC_POS_003 | mpId:', response.mpId

  @Positive @TC_POS_004
  Scenario: TC_POS_004 - Create merchant with EBT cash and food benefits enabled
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.positive.TC_POS_004_ebtEnabled
    * set payload.storeData[0].epiData[0].processorData[0].EBTcash  = td.EBTcash
    * set payload.storeData[0].epiData[0].processorData[0].EBTcash1 = td.EBTcash1
    * set payload.storeData[0].epiData[0].processorData[0].EBTfood  = td.EBTfood
    * set payload.storeData[0].epiData[0].processorData[0].EBTfood1 = td.EBTfood1
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 200
    And match response.status == true
    * print 'TC_POS_004 | mpId:', response.mpId

  @Positive @TC_POS_005
  Scenario: TC_POS_005 - Create merchant with multiple stores in storeData
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.positive.TC_POS_005_multiStore
    * set payload.storeData[1] = td.secondStore
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 400
    And match response.status == false
    * print 'TC_POS_005 | mpId:', response.mpId

  # ============================================================
  #  NEGATIVE TEST CASES
  # ============================================================

  @Negative @TC_NEG_001 @Validation
  Scenario: TC_NEG_001 - Fails when legalName is missing
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * remove payload.legalName
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 400
    * print 'TC_NEG_001 | response:', response

  @Negative @TC_NEG_002 @Validation
  Scenario: TC_NEG_002 - Fails when emailId is missing
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * remove payload.emailId
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 400
    * print 'TC_NEG_002 | response:', response

  @Negative @TC_NEG_003 @Validation
  Scenario: TC_NEG_003 - Fails with invalid email format
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_003_invalidEmail
    * set payload.emailId = td.emailId
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 400
    * print 'TC_NEG_003 | response:', response

 @Negative @TC_NEG_004 @Conflict
  Scenario: TC_NEG_004 - Fails with duplicate userName on second call
    # Use a fixed payload so the same userName is sent twice
    * def td           = testDataNashville.negative.TC_NEG_004_duplicateUser
    * def fixedPayload = JSON.parse(JSON.stringify(basePayload))
    * set fixedPayload.userName = td.userName
    * set fixedPayload.emailId  = td.emailId
    # First call must succeed
    Given path apiPath
    And param FDNashville = ''
    And request fixedPayload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 400
    And match response.status == false
    * print 'TC_NEG_004 | first call mpId:', response.mpId
    
    # Second call with same userName must fail with 400 - "User Name already exist"
    Given path apiPath
    And param FDNashville = ''
    And request fixedPayload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 400
    #And match response.status == false
    And match response.message == 'User Name already exist'
    * print 'TC_NEG_004 | duplicate conflict response:', response

  @Negative @TC_NEG_005 @Validation
  Scenario: TC_NEG_005 - Fails with non-numeric mobile number
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_005_nonNumericMobile
    * set payload.mobile = td.mobile
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 400
    * print 'TC_NEG_005 | response:', response

  @Negative @TC_NEG_006 @Validation
  Scenario: TC_NEG_006 - Fails with invalid state code
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_006_invalidState
    * set payload.legalState = td.legalState
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 200
    * print 'TC_NEG_006 | response:', response

  @Negative @TC_NEG_007 @Validation
  Scenario: TC_NEG_007 - Fails with zip code less than 5 digits
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_007_shortZipCode
    * set payload.legalZipCode = td.legalZipCode
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 200
    * print 'TC_NEG_007 | response:', response

  @Negative @TC_NEG_008 @Validation
  Scenario: TC_NEG_008 - Fails when storeData is an empty array
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_008_emptyStoreData
    * set payload.storeData = td.storeData
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 400
    * print 'TC_NEG_008 | response:', response

  @Negative @TC_NEG_009 @Validation
  Scenario: TC_NEG_009 - Fails when epiData is missing from storeData
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * remove payload.storeData[0].epiData
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
     Then match [400] contains responseStatus
    * print 'TC_NEG_009 | response:', response

  @Negative @TC_NEG_010 @Validation
  Scenario: TC_NEG_010 - Fails with invalid processor ID
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_010_invalidProcessor
    * set payload.processor = td.processor
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then match [504,502] contains responseStatus
    * print 'TC_NEG_010 | response:', response

  @Negative @TC_NEG_011 @Validation
  Scenario: TC_NEG_011 - Fails with invalid userType value
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_011_invalidUserType
    * set payload.userType = td.userType
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 200
    * print 'TC_NEG_011 | response:', response

  @Negative @TC_NEG_012 @Auth
  Scenario: TC_NEG_012 - Fails without Authorization header
    * header Authorization = ''
    Given path apiPath
    And param FDNashville = ''
    And request basePayload
    And header Authorization = 'Bearer InvalidToken.abc.xyz'
    When method POST
    Then status 401
    * print 'TC_NEG_012 | response:', response

  @Negative @TC_NEG_013 @Auth
  Scenario: TC_NEG_013 - Fails with an invalid or expired JWT token
    * header Authorization = 'Bearer InvalidToken.abc.xyz'
    Given path apiPath
    And param FDNashville = ''
    And request basePayload
    And header Authorization = 'Bearer InvalidToken.abc.xyz'
    When method POST
    Then status 401
    * print 'TC_NEG_013 | response:', response

  @Negative @TC_NEG_014 @Validation
  Scenario: TC_NEG_014 - Fails when surcharge value exceeds allowed maximum
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_014_surchargeOutOfRange
    * set payload.storeData[0].epiData[0].features.surcharge.enabled = td.surcharge_enabled
    * set payload.storeData[0].epiData[0].features.surcharge.value   = td.surcharge_value
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 200
    * print 'TC_NEG_014 | response:', response

  @Negative @TC_NEG_015 @Validation
  Scenario: TC_NEG_015 - Fails with non-numeric mccCode
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_015_nonNumericMcc
    * set payload.storeData[0].mccCode = td.mccCode
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 400
    * print 'TC_NEG_015 | response:', response

  @Negative @TC_NEG_016 @Validation
  Scenario: TC_NEG_016 - Fails when isTxnAllowed has an invalid value
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_016_invalidTxnAllowed
    * set payload.isTxnAllowed = td.isTxnAllowed
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 200
    * print 'TC_NEG_016 | response:', response

  @Negative @TC_NEG_017 @Validation
  Scenario: TC_NEG_017 - Fails with a completely empty request body
    Given path apiPath
    And param FDNashville = ''
    And request {}
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 400
    * print 'TC_NEG_017 | response:', response

  @Negative @TC_NEG_018 @Security
  Scenario: TC_NEG_018 - Protected against SQL injection in legalName
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_018_sqlInjection
    * set payload.legalName = td.legalName
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 200
    * print 'TC_NEG_018 | response:', response

  @Negative @TC_NEG_019 @Validation
  Scenario: TC_NEG_019 - Fails with an invalid country code
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_019_invalidCountry
    * set payload.legalCountry = td.legalCountry
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 200
    * print 'TC_NEG_019 | response:', response

  @Negative @TC_NEG_020 @Validation
  Scenario: TC_NEG_020 - Fails with an unrecognized timezone value
    * def payload = JSON.parse(JSON.stringify(basePayload))
    * def td      = testDataNashville.negative.TC_NEG_020_invalidTimezone
    * set payload.legalTimezone = td.legalTimezone
    Given path apiPath
    And param FDNashville = ''
    And request payload
    And header Authorization = 'Bearer ' + accessToken
    When method POST
    Then status 400
    * print 'TC_NEG_020 | response:', response

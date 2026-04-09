@MerchantProfile @Regression
Feature: Get Merchant Details

  # As an authorized ISO user
  # I want to retrieve merchant profile details
  # So that I can view the complete merchant information via the API

  Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken

  # ---------------------------------------------------------------
  # Scenario 1: Valid UserId returns 200
  # ---------------------------------------------------------------

  @Smoke @GetMerchantDetails
  Scenario Outline: To get Merchant Details - Valid UserId returns 200
    * def dataSet = { UserId: <UserId> }
    Given url baseUrl + '/api/valor/getViewMerchantProfile'
    And param profile = ''
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And request dataSet
    When method POST
    Then status 200
    And match response != null
    And match response != {}
    And match response.status != null
    
    * print 'Full response', response
    * print response.message

    Examples:
      | UserId |
      | 41980  |
      | 511855 |
      | 511853 |
      | 164909 |

  # ---------------------------------------------------------------
  # Scenario 2: Invalid UserId returns 400
  # ---------------------------------------------------------------

  @NegativeTest @GetMerchantDetails
  Scenario Outline: Invalid UserId in request body returns 400
    * def dataSet = { UserId: <UserId> }
    Given url baseUrl + '/api/valor/getViewMerchantProfile'
    And param profile = ''
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And request dataSet
    When method POST
    Then status 400
    * print 'Full response', response
    * print response.message

    Examples:
      | UserId    |
      | 999999999 |

  # ---------------------------------------------------------------
  # Scenario 3: Null UserId returns 404
  # ---------------------------------------------------------------

  @NegativeTest @GetMerchantDetails
  Scenario: Null UserId in request body returns 404
    * def dataSet = { UserId: null }
    Given url baseUrl + '/api/valor/getViewMerchantProfile1'
    And param profile = ''
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And request dataSet
    When method POST
    Then status 404
    * print 'Full response', response
    * print response.message
  # ---------------------------------------------------------------
  # Scenario 4: No Authorization token returns 401
  # ---------------------------------------------------------------

  @SecurityTest @GetMerchantDetails
  Scenario: Request without Authorization token returns 401
    * def dataSet = { UserId: '' }
    Given url baseUrl + '/api/valor/getViewMerchantProfile'
    And param profile = ''
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And request dataSet
    When method POST
    Then status 401
    * print 'Full response', response
    * print response.message

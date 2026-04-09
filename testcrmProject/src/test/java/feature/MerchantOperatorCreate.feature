@MerchantOperator @Regression
Feature: Create Merchant Operator

  # As an authorized ISO user
  # I want to create a merchant operator
  # So that the operator can access merchant modules and features

  Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken

  # ---------------------------------------------------------------
  # Scenario 1: Successfully create a merchant operator
  # ---------------------------------------------------------------

  @Smoke @CreateMerchantOperator
  Scenario Outline: Create Merchant Operator - Valid payload returns 200
    * def dataSet = read('classpath:data/CreateMerchantOperator.json')
    * set dataSet.userName           = '<userName>'
    * set dataSet.emailId            = '<emailId>'
    * set dataSet.firstName          = '<firstName>'
    * set dataSet.lastName           = '<lastName>'
    * set dataSet.mobile             = <mobile>
    * set dataSet.merchantUserName   = '<merchantUserName>'
    * set dataSet.associate_user_name = '<associate_user_name>'
    Given url baseUrl + '/api/valor/createMerchantOperator'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And request dataSet
    When method POST
    Then status 200
    And match response != null
    And match response.status != null

    Examples:
      | userName | emailId                      | firstName | lastName | mobile     | merchantUserName | associate_user_name |
      | test3    | test@valorpaytech.com        | MERCHANT  | PORTAL   | 5287963652 | merchanttest     | demovaloriso        |
      | test4    | test4@valorpaytech.com       | JOHN      | DOE      | 5287963653 | merchanttest2    | demovaloriso        |

  # ---------------------------------------------------------------
  # Scenario 2: Duplicate userName returns 409
  # ---------------------------------------------------------------

  @NegativeTest @CreateMerchantOperator
  Scenario Outline: Create Merchant Operator - Duplicate userName returns 409
    * def dataSet = read('classpath:data/CreateMerchantOperator.json')
    * set dataSet.userName = '<userName>'
    Given url baseUrl + '/api/valor/createMerchantOperator'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And request dataSet
    When method POST
    Then status 409

    Examples:
      | userName |
      | test3    |

  # ---------------------------------------------------------------
  # Scenario 3: Missing required fields returns 400
  # ---------------------------------------------------------------

  @NegativeTest @CreateMerchantOperator
  Scenario Outline: Create Merchant Operator - Missing required field returns 400
    * def dataSet = { userName: '<userName>', emailId: '<emailId>' }
    Given url baseUrl + '/api/valor/createMerchantOperator'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And request dataSet
    When method POST
    Then status 400

    Examples:
      | userName | emailId               |
      |          | test@valorpaytech.com |
      | test3    |                       |

  # ---------------------------------------------------------------
  # Scenario 4: Invalid email format returns 422
  # ---------------------------------------------------------------

  @NegativeTest @CreateMerchantOperator
  Scenario Outline: Create Merchant Operator - Invalid email returns 422
    * def dataSet = read('classpath:data/CreateMerchantOperator.json')
    * set dataSet.emailId = '<emailId>'
    Given url baseUrl + '/api/valor/createMerchantOperator'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And request dataSet
    When method POST
    Then status 422

    Examples:
      | emailId         |
      | invalid-email   |
      | test@           |
      | @nouser.com     |

  # ---------------------------------------------------------------
  # Scenario 5: No Authorization token returns 401
  # ---------------------------------------------------------------

  @SecurityTest @CreateMerchantOperator
  Scenario: Create Merchant Operator - No token returns 401
    * def dataSet = read('classpath:data/CreateMerchantOperator.json')
    Given url baseUrl + '/api/valor/createMerchantOperator'
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And request dataSet
    When method POST
    Then status 401

  # ---------------------------------------------------------------
  # Scenario 6: Invalid Authorization token returns 401
  # ---------------------------------------------------------------

  @SecurityTest @CreateMerchantOperator
  Scenario: Create Merchant Operator - Invalid token returns 401
    * def dataSet = read('classpath:data/CreateMerchantOperator.json')
    Given url baseUrl + '/api/valor/createMerchantOperator'
    And header Authorization = 'Bearer invalid_token_12345'
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And request dataSet
    When method POST
    Then status 401

  # ---------------------------------------------------------------
  # Scenario 7: Empty request body returns 400
  # ---------------------------------------------------------------

  @NegativeTest @CreateMerchantOperator
  Scenario: Create Merchant Operator - Empty body returns 400
    * def dataSet = {}
    Given url baseUrl + '/api/valor/createMerchantOperator'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And request dataSet
    When method POST
    Then status 400

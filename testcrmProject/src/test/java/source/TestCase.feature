Feature: Login API - Positive and Negative Scenarios

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'

  Scenario Outline: Validate Login API with multiple test data
    Given path '/api/auth/login'
    And request
    """
    {
      "mailId": "<mailId>",
      "SubmailId": "<SubmailId>",
      "passCode": "<passCode>"
    }
    """
    When method POST
    Then status <expectedStatus>
    * def accessToken = expectedStatus == 200 ? response.access_token : null
    * print 'Generated Token:', accessToken

    Examples:
      | mailId                      | SubmailId                   | passCode   | expectedStatus |
      | name@protonmail.com         | name@protonmail.com         | Pass@1234  | 200            |
      | invalidemail                | invalidemail                | Pass@1234  | 400            |
      | name@protonmail.com         | name@protonmail.com         |            | 400            |
      |                             |                             | Pass@1234  | 400            |
      | wrong@protonmail.com        | wrong@protonmail.com        | WrongPass  | 401            |

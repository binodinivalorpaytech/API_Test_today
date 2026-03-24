@ignore
Feature: Generate Token

  Scenario: Login and Get Token
    Given url baseUrl
    And path '/api/valor/login'
    And header Content-Type = 'application/json'
    And request
    """
    {
      "mailId":    "#(mailId)",
      "SubmailId": "#(SubmailId)",
      "passCode":  "#(passCode)"
    }
    """
    When method post
    Then status 200
    * def accessToken = response.access_token
    * print 'Generated Token:', accessToken
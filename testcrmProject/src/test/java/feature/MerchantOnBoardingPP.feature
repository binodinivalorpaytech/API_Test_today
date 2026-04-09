@merchant @create @valorpay
Feature: Create Merchant via Valor Pay API

  Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * url 'https://vpuat.valorpaytech.com/api'
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    # Generate a dynamic userName using current timestamp
    * def dynamicUserName = 'APIPPMer' + java.lang.System.currentTimeMillis()
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('PPSupervisor' + random).substring(0, 25)

  @smoke @regression
  Scenario: Successfully create a merchant with a single store and Soft POS device
    * def requestPayload =
      """
      {
  "legalName": "EPX Store 6a",
  "dbaName": "EPX Store 6a",
  "firstName": "MERCHANT",
  "lastName": "EPX Store 6a",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUserName)",
  "mobile": "8327287578",
  "legalAddress": "Test Address",
  "legalCity": "CLIFFSIDE PARK",
  "legalState": "NY",
  "legalCountry": "US",
  "legalZipCode": "07010",
  "legalTimezone": "EST",
  "role": "10",
  "userType": "4",
  "isTxnAllowed": "1",
  "selectedState": "NY",
  "programType": "1",
  "processor": "9",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "EL TRI MX RESTA Add",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "LA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "EL TRI MX RESTA",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "9",
          "epiLabel": "VT",
          "features": {
            "tip": {
              "enabled": false,
              "value": [
                5,
                10,
                15,
                20
              ]
            },
            "surcharge": {
              "enabled": false,
              "value": "4.00"
            },
            "tax": {
              "enabled": false,
              "value": "0"
            }
          },
          "selectedState": "NJ",
          "processorData": [
            {
              "midPriority": "RCTST1000089931",
              "midPriority1": "",
              "termNoPriority": "12345678",
              "termNoPriority1": "",
              "consumerApiKeyPriority": "12345678910",
              "consumerApiKeyPriority1": "",
              "consumerApiSecretPriority": "1234567890",
              "consumerApiSecretPriority1": "",
              "surchargeIndicator": 0,
              "surchargePercentage": "4.00",
              "label": "MERCHANT PORTAL LOGIN",
              "programType": "surcharge"
            }
          ]
        }
      ]
    }
  ]
}
      """
    Given path '/valor/create'
    And param prioritypaymnet = ''
    And request requestPayload
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    When method POST
    Then status 200
    And match response.status == true
    And match response != null

  @negative
  Scenario: Fail to create merchant with missing required legalName
    * def requestPayload =
      """
      {
        "dbaName": "EPX Store 6a",
        "firstName": "MERCHANT",
        "lastName": "EPX Store 6a",
        "emailId": "#(dynamicEmail)",
        "userName": "#(dynamicUserName)",
        "mobile": "8327287578",
        "legalAddress": "Test Address",
        "legalCity": "CLIFFSIDE PARK",
        "legalState": "NY",
        "legalCountry": "US",
        "legalZipCode": "07010",
        "legalTimezone": "EST",
        "role": "10",
        "userType": "4",
        "isTxnAllowed": "1",
        "selectedState": "NY",
        "programType": "1",
        "processor": "9",
        "rollUp": "0",
        "storeData": []
      }
      """
    Given path '/valor/create'
    And param prioritypaymnet = ''
    And request requestPayload
     And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response.message contains 'storeData must be a non-empty array.'

  @negative
  Scenario: Fail to create merchant with invalid email format
    * def requestPayload =
      """
      {
        "legalName": "EPX Store 6a",
        "dbaName": "EPX Store 6a",
        "firstName": "MERCHANT",
        "lastName": "EPX Store 6a",
        "emailId": "binodini.@hh",
        "userName": "#(dynamicUserName)",
        "mobile": "8327287578",
        "legalAddress": "Test Address",
        "legalCity": "CLIFFSIDE PARK",
        "legalState": "NY",
        "legalCountry": "US",
        "legalZipCode": "07010",
        "legalTimezone": "EST",
        "role": "10",
        "userType": "4",
        "isTxnAllowed": "1",
        "selectedState": "NY",
        "programType": "1",
        "processor": "9",
        "rollUp": "0",
        "storeData": []
      }
      """
    Given path '/valor/create'
    And param prioritypaymnet = ''
    And request requestPayload
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response.message contains 'storeData must be a non-empty array.'

  @negative
  Scenario: Fail to create merchant with an expired or invalid Bearer token
    * header Authorization = 'Bearer invalid_token'
    * def requestPayload =
      """
      {
        "legalName": "EPX Store 6a",
        "dbaName": "EPX Store 6a",
        "firstName": "MERCHANT",
        "lastName": "EPX Store 6a",
        "emailId": "#(dynamicEmail)",
        "userName": "#(dynamicUserName)",
        "mobile": "8327287578",
        "legalAddress": "Test Address",
        "legalCity": "CLIFFSIDE PARK",
        "legalState": "NY",
        "legalCountry": "US",
        "legalZipCode": "07010",
        "legalTimezone": "EST",
        "role": "10",
        "userType": "4",
        "isTxnAllowed": "1",
        "selectedState": "NY",
        "programType": "1",
        "processor": "9",
        "rollUp": "0",
        "storeData": []
      }
      """
    Given path '/valor/create'
    And param prioritypaymnet = ''
    And request requestPayload
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    When method POST
    Then status 400

  @negative
  Scenario: Fail to create merchant with empty storeData
    * def requestPayload =
      """
      {
        "legalName": "EPX Store 6a",
        "dbaName": "EPX Store 6a",
        "firstName": "MERCHANT",
        "lastName": "EPX Store 6a",
        "emailId": "#(dynamicEmail)",
        "userName": "#(dynamicUserName)",
        "mobile": "8327287578",
        "legalAddress": "Test Address",
        "legalCity": "CLIFFSIDE PARK",
        "legalState": "NY",
        "legalCountry": "US",
        "legalZipCode": "07010",
        "legalTimezone": "EST",
        "role": "10",
        "userType": "4",
        "isTxnAllowed": "1",
        "selectedState": "NY",
        "programType": "1",
        "processor": "9",
        "rollUp": "0",
        "storeData": []
      }
      """
    Given path '/valor/create'
    And param prioritypaymnet = ''
    And request requestPayload
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
   # And match response.message contains 'storCannot read properties of undefined (reading 'epiData')eData'

  @negative
  Scenario: Fail to create merchant with duplicate userName
    # First create a merchant to register the userName
    * def firstPayload =
      """
      {
  "legalName": "EPX Store 6a",
  "dbaName": "EPX Store 6a",
  "firstName": "MERCHANT",
  "lastName": "EPX Store 6a",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUserName)",
  "mobile": "8327287578",
  "legalAddress": "Test Address",
  "legalCity": "CLIFFSIDE PARK",
  "legalState": "NY",
  "legalCountry": "US",
  "legalZipCode": "07010",
  "legalTimezone": "EST",
  "role": "10",
  "userType": "4",
  "isTxnAllowed": "1",
  "selectedState": "NY",
  "programType": "1",
  "processor": "9",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "EL TRI MX RESTA Add",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "LA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "EL TRI MX RESTA",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "9",
          "epiLabel": "VT",
          "features": {
            "tip": {
              "enabled": false,
              "value": [
                5,
                10,
                15,
                20
              ]
            },
            "surcharge": {
              "enabled": false,
              "value": "4.00"
            },
            "tax": {
              "enabled": false,
              "value": "0"
            }
          },
          "selectedState": "NJ",
          "processorData": [
            {
              "midPriority": "RCTST1000089931",
              "midPriority1": "",
              "termNoPriority": "12345678",
              "termNoPriority1": "",
              "consumerApiKeyPriority": "12345678910",
              "consumerApiKeyPriority1": "",
              "consumerApiSecretPriority": "1234567890",
              "consumerApiSecretPriority1": "",
              "surchargeIndicator": 0,
              "surchargePercentage": "4.00",
              "label": "MERCHANT PORTAL LOGIN",
              "programType": "surcharge"
            }
          ]
        }
      ]
    }
  ]
}
      """
    Given path '/valor/create'
    And param prioritypaymnet = ''
    And request firstPayload
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    When method POST
    Then status 200

    # Attempt to create again with the same userName
    Given path '/valor/create'
    And param prioritypaymnet = ''
    And request firstPayload
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response.message contains 'User Name already exist'

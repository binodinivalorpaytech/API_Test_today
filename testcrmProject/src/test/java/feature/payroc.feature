Feature: ElavonPay Merchant on boarding - with valid data set
# ============================================================
# Feature: ElavonPay Merchant Creation - positive Test Cases
# API   : POST /api/valor/create?Payrocadd=
# Author: QA Automation
# ============================================================

 Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'payroc' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('payroc' + random).substring(0, 25)

  # =====================================================================
  # SCENARIO 1: Merchant onboarding with positive dataset - Positive Flow
  # =====================================================================
  Scenario: Create Merchant - Payroc Surcharge Positive Flow
    * def dataSet = read('classpath:data/Payroc.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param Payrocadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
{
  "legalName": "#(dataSet.legalName)",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "#(dataSet.firstName)",
  "lastName": "#(dataSet.lastName)",
  "ownerName": "#(dataSet.ownerName)",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
  "mobile": "#(dataSet.mobile)",
  "legalAddress": "#(dataSet.legalAddress)",
  "legalCity": "#(dataSet.legalCity)",
  "legalState": "NJ",
  "legalCountry": "US",
  "legalZipCode": "07010",
  "legalTimezone": "EST",
  "role": "10",
  "userType": 4,
  "isTxnAllowed": "1",
  "businessType": "Direct Marketing",
  "selectedState": "NJ",
  "processor": "14",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "LA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "2345678976",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "14",
          "epiLabel": "VT",
          "features": {
            "tip": {
              "enabled": false,
              "value": [5, 10, 15, 20]
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
              "midPayroc": "12345678",
              "mid1Payroc": "12345678",
              "termNoPayroc": "1234567",
              "termNoPayroc1": "11234567",
              "EBTcash": "0",
              "EBTcash1": "0",
              "EBTfood": "0",
              "EBTfood1": "0",
              "surchargeIndicator": "1",
              "surchargePercentage": "1.000",
              "label": "MERCHANT PORTAL LOGIN",
              "programType": "surcharge",
              "c_namePayroc3": "1",
              "tidPayroc3": "611525",
              "clientID_Payroc": "45c4ddcc-feb1-4cb1-99f0-1ba71d6d8f69"
            }
          ]
        }
      ]
    }
  ]
}
"""
    When method post
    Then status 200
    * match response.status == true
    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * print 'storeInfo:', response.storeInfo
    
# =====================================================================
  # SCENARIO 2: Missing required fields - expect 400
  # =====================================================================
  Scenario: Create Merchant - Missing Required Fields (400)
    * def dataSet = read('classpath:data/Payroc.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param Payrocadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName":    "#(dataSet.legalName)",
        "dbaName":      "#(dataSet.dbaName)",
        "firstName":    "#(dataSet.firstName)",
        "lastName":     "#(dataSet.lastName)",
        "ownerName":    "MERCHANT PORTAL",
        "emailId":      "#(dynamicEmail)",
        "userName":     "#(dynamicUser)",
        "mobile":       "#(dataSet.mobile)",
        "legalZipCode": "#(dataSet.legalZipCode)"
      }
      """
    When method post
    Then status 400
    * match response.status == 'Validation Failed'
    * match response.code == 400
    * print 'Negative flow response:', response

  # =====================================================================
  # SCENARIO 3: Invalid endpoint - expect 404
  # =====================================================================
  Scenario: Create Merchant - Invalid Endpoint (404)
    * def dataSet = read('classpath:data/Payroc.json')

    Given url baseUrl
    And path '/api/valor/create1'
    And param Payrocadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName":    "#(dataSet.legalName)",
        "dbaName":      "#(dataSet.dbaName)",
        "firstName":    "#(dataSet.firstName)",
        "lastName":     "#(dataSet.lastName)",
        "ownerName":    "MERCHANT PORTAL",
        "emailId":      "#(dynamicEmail)",
        "userName":     "#(dynamicUser)",
        "legalZipCode": "#(dataSet.legalZipCode)"
      }
      """
    When method post
    Then status 404
    * print 'Invalid endpoint response:', response

  # =====================================================================
  # SCENARIO 4: Invalid token - expect 401 Unauthorized
  # =====================================================================
  Scenario: Create Merchant - Invalid Auth Token (401)
    * def dataSet = read('classpath:data/Payroc.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param Payrocadd = true
    And header Authorization = 'Bearer INVALID_TOKEN'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName":    "#(dataSet.legalName)",
        "dbaName":      "#(dataSet.dbaName)",
        "firstName":    "#(dataSet.firstName)",
        "lastName":     "#(dataSet.lastName)",
        "ownerName":    "MERCHANT PORTAL",
        "emailId":      "#(dynamicEmail)",
        "userName":     "#(dynamicUser)",
        "legalZipCode": "#(dataSet.legalZipCode)"
      }
      """
    When method post
    Then status 401
    * print 'Unauthorized response:', response

  # =====================================================================
  # SCENARIO 5: Full valid payload - verify response fields
  # =====================================================================
  Scenario: Create Merchant - Verify Full Response Fields
    * def dataSet = read('classpath:data/Payroc.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param Payrocadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
   {
  "legalName": "#(dataSet.legalName)",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "#(dataSet.firstName)",
  "lastName": "#(dataSet.lastName)",
  "ownerName": "#(dataSet.ownerName)",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
  "mobile": "#(dataSet.mobile)",
  "legalAddress": "#(dataSet.legalAddress)",
  "legalCity": "#(dataSet.legalCity)",
  "legalState": "NJ",
  "legalCountry": "US",
  "legalZipCode": "07010",
  "legalTimezone": "EST",
  "role": "10",
  "userType": 4,
  "isTxnAllowed": "1",
  "businessType": "Direct Marketing",
  "selectedState": "NJ",
  "processor": "14",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "LA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "2345678976",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "14",
          "epiLabel": "VT",
          "features": {
            "tip": {
              "enabled": false,
              "value": [5, 10, 15, 20]
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
              "midPayroc": "12345678",
              "mid1Payroc": "12345678",
              "termNoPayroc": "1234567",
              "termNoPayroc1": "11234567",
              "EBTcash": "0",
              "EBTcash1": "0",
              "EBTfood": "0",
              "EBTfood1": "0",
              "surchargeIndicator": "1",
              "surchargePercentage": "1.000",
              "label": "MERCHANT PORTAL LOGIN",
              "programType": "surcharge",
              "c_namePayroc3": "1",
              "tidPayroc3": "611525",
              "clientID_Payroc": "45c4ddcc-feb1-4cb1-99f0-1ba71d6d8f69"
            }
          ]
        }
      ]
    }
  ]
}
      """
    When method post
    Then status 200
    * match response.status == true
    * match response.mpId == '#notnull'
    * match response.newUserId == '#notnull'
    * print 'mpId:', response.mpId
    * print 'message:', response.message
    * print 'code:', response.code
    * print 'storeInfo:', response.storeInfo


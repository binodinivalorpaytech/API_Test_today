Feature: Worldpay Merchant on boarding - with valid data set
# ============================================================
# Feature: Worldpay Merchant Creation - positive Test Cases
# API   : POST /api/valor/create?Worldpayadd=
# Author: QA Automation
# ============================================================

 Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'Worldpayadd' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('Worldpayadd' + random).substring(0, 25)

  # =====================================================================
  # SCENARIO 1: Merchant onboarding with positive dataset - Positive Flow
  # =====================================================================
  Scenario: Create Merchant - Worldpay Surcharge Positive Flow
    * def dataSet = read('classpath:data/Worldpay.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param Worldpayadd = true
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
        "mobile": "8327287578",
        "legalAddress": "Test Address",
        "legalCity": "CLIFFSIDE PARK",
        "legalState": "NJ",
        "legalCountry": "US",
        "legalZipCode": "07010",
        "legalTimezone": "EST",
        "role": "10",
        "userType": 4,
        "isTxnAllowed": "1",
        "businessType": "Direct Marketing",
        "selectedState": "NJ",
        "processor": "11",
        "rollUp": "1",
        "programType": "1",
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
            "superVisorContact": "3377040344",
            "mccCode": "5812",
            "epiData": [
              {
                "device": "139",
                "deviceType": "Soft POS",
                "processor": "11",
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
                    "midWorldpay": "123456789012",
                    "midWorldpay1": "",
                    "termNoWorldpay": "123",
                    "termNoWorldpay1": "",
                    "bankIdWorldpay": "1234",
                    "bankIdWorldpay1": "",
                    "EBTcash": 0,
                    "EBTcash1": 0,
                    "EBTfood": 0,
                    "EBTfood1": 0,
                    "surchargeIndicator": 0,
                    "surchargePercentage": "3.000",
                    "label": "MERCHANT PORTAL LOGIN",
                    "programType": "surcharge",
                    "c_nameWorldpay3": "1",
                    "tidWorldpay3": "5454",
                    "clientID_Worldpay": "455",
                    "mid_flexfactor": "123",
                    "tid_flexfactor": "12345678",
                    "site_id_flexfactor": "1234567890",
                    "app_key_flexfactor": "1234567890",
                    "app_secret_flexfactor": "1234567890"
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
    * print 'message: ',response.message
    * print 'mpId:',response.mpId
    * print 'newUserId: ', response.newUserId
    
# =====================================================================
  # SCENARIO 2: Missing required fields - expect 400
  # =====================================================================
  Scenario: Create Merchant - Missing Required Fields (400)
    * def dataSet = read('classpath:data/Worldpay.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param Worldpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName":    "#(dataSet.legalName)",
        "dbaName":      "#(dataSet.dbaName)",
        "firstName":    "#(dataSet.firstName)",
        "lastName":     "#(dataSet.lastName)",
        "ownerName":    "#(dataSet.ownerName)",
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
    * print 'message: ',response.message

  # =====================================================================
  # SCENARIO 3: Invalid endpoint - expect 404
  # =====================================================================
  Scenario: Create Merchant - Invalid Endpoint (404)
    * def dataSet = read('classpath:data/Worldpay.json')

    Given url baseUrl
    And path '/api/valor/create1'
    And param Worldpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName":    "#(dataSet.legalName)",
        "dbaName":      "#(dataSet.dbaName)",
        "firstName":    "#(dataSet.firstName)",
        "lastName":     "#(dataSet.lastName)",
        "ownerName":    "#(dataSet.ownerName)",
        "emailId":      "#(dynamicEmail)",
        "userName":     "#(dynamicUser)",
        "legalZipCode": "#(dataSet.legalZipCode)"
      }
      """
    When method post
    Then status 404
    * print 'Invalid endpoint response:', response
    * print 'message: ',response.message

  # =====================================================================
  # SCENARIO 4: Invalid token - expect 401 Unauthorized
  # =====================================================================
  Scenario: Create Merchant - Invalid Auth Token (401)
    * def dataSet = read('classpath:data/Worldpay.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param Worldpayadd = true
    And header Authorization = 'Bearer INVALID_TOKEN'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName":    "#(dataSet.legalName)",
        "dbaName":      "#(dataSet.dbaName)",
        "firstName":    "#(dataSet.firstName)",
        "lastName":     "#(dataSet.lastName)",
        "ownerName":    "#(dataSet.ownerName)",
        "emailId":      "#(dynamicEmail)",
        "userName":     "#(dynamicUser)",
        "legalZipCode": "#(dataSet.legalZipCode)"
      }
      """
    When method post
    Then status 401
    * print 'Unauthorized response:', response
    * print 'message: ',response.message
    

  # =====================================================================
  # SCENARIO 5: Full valid payload - verify response fields
  # =====================================================================
  Scenario: Create Merchant - Verify Full Response Fields
    * def dataSet = read('classpath:data/Worldpay.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param Worldpayadd = true
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
        "mobile": "8327287578",
        "legalAddress": "Test Address",
        "legalCity": "CLIFFSIDE PARK",
        "legalState": "NJ",
        "legalCountry": "US",
        "legalZipCode": "07010",
        "legalTimezone": "EST",
        "role": "10",
        "userType": 4,
        "isTxnAllowed": "1",
        "businessType": "Direct Marketing",
        "selectedState": "NJ",
        "processor": "11",
        "rollUp": "1",
        "programType": "1",
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
            "superVisorContact": "3377040344",
            "mccCode": "5812",
            "epiData": [
              {
                "device": "139",
                "deviceType": "Soft POS",
                "processor": "11",
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
                    "midWorldpay": "123456789012",
                    "midWorldpay1": "",
                    "termNoWorldpay": "123",
                    "termNoWorldpay1": "",
                    "bankIdWorldpay": "1234",
                    "bankIdWorldpay1": "",
                    "EBTcash": 0,
                    "EBTcash1": 0,
                    "EBTfood": 0,
                    "EBTfood1": 0,
                    "surchargeIndicator": 0,
                    "surchargePercentage": "3.000",
                    "label": "MERCHANT PORTAL LOGIN",
                    "programType": "surcharge",
                    "c_nameWorldpay3": "1",
                    "tidWorldpay3": "5454",
                    "clientID_Worldpay": "455",
                    "mid_flexfactor": "123",
                    "tid_flexfactor": "12345678",
                    "site_id_flexfactor": "1234567890",
                    "app_key_flexfactor": "1234567890",
                    "app_secret_flexfactor": "1234567890"
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


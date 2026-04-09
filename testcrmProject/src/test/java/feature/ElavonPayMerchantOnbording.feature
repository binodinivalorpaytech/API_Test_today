 Feature: ElavonPay Merchant on boarding - with valid data set
# ============================================================
# Feature: ElavonPay Merchant Creation - positive Test Cases
# API   : POST /api/valor/create?elavonpayadd=
# Author: QA Automation
# ============================================================

 Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'elavonpayadd' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('ElavonSupervisor' + random).substring(0, 25)

  # =====================================================================
  # SCENARIO 1: Merchant onboarding with positive dataset - Positive Flow
  # =====================================================================
  Scenario: Create Merchant - Elavon Surcharge Positive Flow
    * def dataSet = read('classpath:data/Elovantestdata_p.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param elavonpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
{
  "legalName": "#(dataSet.legalName)",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "#(dataSet.dbaName)",
  "lastName": "#(dataSet.dbaName)",
  "ownerName": "MERCHANT PORTAL",
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
  "processor": "12",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#(dataSet.storeName)",
      "storeAddress": "#(dataSet.storeAddress)",
      "storeCity": "#(dataSet.storeCity)",
      "storeState": "#(dataSet.storeState)",
      "storeCountry": "#(dataSet.storeCountry)",
      "storeZipCode": "#(dataSet.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "12",
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
              "midElavonpay": "#(dataSet.midElavonpay)",
              "midElavonpay1": "#(dataSet.midElavonpay1)",
              "termNoElavonpay": "123",
              "termNoElavonpay1": "123",
              "bankIdElavonpay": "123456",
              "bankIdElavonpay1": "123456",
              "EBTcash": "0",
              "EBTfood": "0",
              "surchargeIndicator": "0",
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
    When method post
    Then status 200
    * match response.status == true
    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * print 'storeInfo:', response.storeInfo
    
 @auth @expired-token
 Scenario: Submit request with an invalid Bearer token
  Given url baseUrl
    And path '/api/valor/create'
    And param elavonpayadd = true
    And header Authorization = 'Bearer 67' + accessToken
    And header Content-Type = 'application/json'
    And request
"""
{
  "legalName": "#(dataSet.legalName)",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "#(dataSet.dbaName)",
  "lastName": "#(dataSet.dbaName)",
  "ownerName": "MERCHANT PORTAL",
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
  "processor": "12",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#(dataSet.storeName)",
      "storeAddress": "#(dataSet.storeAddress)",
      "storeCity": "#(dataSet.storeCity)",
      "storeState": "#(dataSet.storeState)",
      "storeCountry": "#(dataSet.storeCountry)",
      "storeZipCode": "#(dataSet.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "12",
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
              "midElavonpay": "#(dataSet.midElavonpay)",
              "midElavonpay1": "#(dataSet.midElavonpay1)",
              "termNoElavonpay": "123",
              "termNoElavonpay1": "123",
              "bankIdElavonpay": "123456",
              "bankIdElavonpay1": "123456",
              "EBTcash": "0",
              "EBTfood": "0",
              "surchargeIndicator": "0",
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
    When method post
    Then status 401
    * print 'Full response:', response
    * print response.message
    

  @mandatory @legal-name
  Scenario: Submit request with empty legalName
  Given url baseUrl
    And path '/api/valor/create'
    And param elavonpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
"""
{
  "legalName": "",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "#(dataSet.dbaName)",
  "lastName": "#(dataSet.dbaName)",
  "ownerName": "MERCHANT PORTAL",
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
  "processor": "12",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#(dataSet.storeName)",
      "storeAddress": "#(dataSet.storeAddress)",
      "storeCity": "#(dataSet.storeCity)",
      "storeState": "#(dataSet.storeState)",
      "storeCountry": "#(dataSet.storeCountry)",
      "storeZipCode": "#(dataSet.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(dataSet.superVisorName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "12",
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
              "midElavonpay": "#(dataSet.midElavonpay)",
              "midElavonpay1": "#(dataSet.midElavonpay1)",
              "termNoElavonpay": "123",
              "termNoElavonpay1": "123",
              "bankIdElavonpay": "123456",
              "bankIdElavonpay1": "123456",
              "EBTcash": "0",
              "EBTfood": "0",
              "surchargeIndicator": "0",
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
    When method post
    Then status 400
    * print 'Full response:', response
    * print response.message   
  
  @mandatory @legal-name
  Scenario: Submit request with more than 35 character in legalName
  Given url baseUrl
    And path '/api/valor/create'
    And param elavonpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
"""
{
  "legalName": "It should be exactly two characters.,storeZipCode is required and should be numeric and length between 5 and 6 characters",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "#(dataSet.dbaName)",
  "lastName": "#(dataSet.lastName)",
  "ownerName": "MERCHANT PORTAL",
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
  "processor": "12",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#(dataSet.storeName)",
      "storeAddress": "#(dataSet.storeAddress)",
      "storeCity": "#(dataSet.storeCity)",
      "storeState": "#(dataSet.storeState)",
      "storeCountry": "#(dataSet.storeCountry)",
      "storeZipCode": "#(dataSet.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(dataSet.superVisorName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "12",
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
              "midElavonpay": "#(dataSet.midElavonpay)",
              "midElavonpay1": "#(dataSet.midElavonpay1)",
              "termNoElavonpay": "123",
              "termNoElavonpay1": "123",
              "bankIdElavonpay": "123456",
              "bankIdElavonpay1": "123456",
              "EBTcash": "0",
              "EBTfood": "0",
              "surchargeIndicator": "0",
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
    When method post
    Then status 400
    * print 'Full response:', response
    * print response.message   
    
  @mandatory @firstName-name  
 Scenario: Create Merchant - with firstname empty dataset
    * def dataSet = read('classpath:data/Elovantestdata_p.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param elavonpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
{
  "legalName": "#(dataSet.legalName)",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "",
  "lastName": "#(dataSet.lastName)",
  "ownerName": "MERCHANT PORTAL",
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
  "processor": "12",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#(dataSet.storeName)",
      "storeAddress": "#(dataSet.storeAddress)",
      "storeCity": "#(dataSet.storeCity)",
      "storeState": "#(dataSet.storeState)",
      "storeCountry": "#(dataSet.storeCountry)",
      "storeZipCode": "#(dataSet.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "12",
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
              "midElavonpay": "#(dataSet.midElavonpay)",
              "midElavonpay1": "#(dataSet.midElavonpay1)",
              "termNoElavonpay": "123",
              "termNoElavonpay1": "123",
              "bankIdElavonpay": "123456",
              "bankIdElavonpay1": "123456",
              "EBTcash": "0",
              "EBTfood": "0",
              "surchargeIndicator": "0",
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
    When method post
    Then status 400
    * print 'Full response:', response

    
   @mandatory @firstName-name  
 Scenario: Create Merchant - More than 35 character
    * def dataSet = read('classpath:data/Elovantestdata_p.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param elavonpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
{
  "legalName": "#(dataSet.legalName)",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "The length of legalName must not exceed 48 characters.,Invalid storeState. It should be exactly two characters.,storeZipCode is required and should be numeric and length between 5 and 6 characters",
  "lastName": "#(dataSet.lastName)",
  "ownerName": "MERCHANT PORTAL",
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
  "processor": "12",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#(dataSet.storeName)",
      "storeAddress": "#(dataSet.storeAddress)",
      "storeCity": "#(dataSet.storeCity)",
      "storeState": "#(dataSet.storeState)",
      "storeCountry": "#(dataSet.storeCountry)",
      "storeZipCode": "#(dataSet.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "12",
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
              "midElavonpay": "#(dataSet.midElavonpay)",
              "midElavonpay1": "#(dataSet.midElavonpay1)",
              "termNoElavonpay": "123",
              "termNoElavonpay1": "123",
              "bankIdElavonpay": "123456",
              "bankIdElavonpay1": "123456",
              "EBTcash": "0",
              "EBTfood": "0",
              "surchargeIndicator": "0",
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
    When method post
    Then status 400
    * print 'Full response:', response

 @mandatory @firstName-name  
 Scenario: Create Merchant - with firstname empty dataset
    * def dataSet = read('classpath:data/Elovantestdata_p.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param elavonpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
{
  "legalName": "#(dataSet.legalName)",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "#(dataSet.firstName)",
  "lastName": "",
  "ownerName": "MERCHANT PORTAL",
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
  "processor": "12",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#(dataSet.storeName)",
      "storeAddress": "#(dataSet.storeAddress)",
      "storeCity": "#(dataSet.storeCity)",
      "storeState": "#(dataSet.storeState)",
      "storeCountry": "#(dataSet.storeCountry)",
      "storeZipCode": "#(dataSet.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "12",
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
              "midElavonpay": "#(dataSet.midElavonpay)",
              "midElavonpay1": "#(dataSet.midElavonpay1)",
              "termNoElavonpay": "123",
              "termNoElavonpay1": "123",
              "bankIdElavonpay": "123456",
              "bankIdElavonpay1": "123456",
              "EBTcash": "0",
              "EBTfood": "0",
              "surchargeIndicator": "0",
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
    When method post
    Then status 400
    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * print 'storeInfo:', response.storeInfo 
    
   @mandatory @firstName-name  
 Scenario: Create Merchant - More than 35 character
    * def dataSet = read('classpath:data/Elovantestdata_p.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param elavonpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
{
  "legalName": "#(dataSet.legalName)",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "#(dataSet.firstName)",
  "lastName": "The length of legalName must not exceed 48 characters.,Invalid storeState. It should be exactly two characters.,storeZipCode is required and should be numeric and length between 5 and 6 characters",
  "ownerName": "MERCHANT PORTAL",
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
  "processor": "12",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#(dataSet.storeName)",
      "storeAddress": "#(dataSet.storeAddress)",
      "storeCity": "#(dataSet.storeCity)",
      "storeState": "#(dataSet.storeState)",
      "storeCountry": "#(dataSet.storeCountry)",
      "storeZipCode": "#(dataSet.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "12",
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
              "midElavonpay": "#(dataSet.midElavonpay)",
              "midElavonpay1": "#(dataSet.midElavonpay1)",
              "termNoElavonpay": "123",
              "termNoElavonpay1": "123",
              "bankIdElavonpay": "123456",
              "bankIdElavonpay1": "123456",
              "EBTcash": "0",
              "EBTfood": "0",
              "surchargeIndicator": "0",
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
    When method post
    Then status 400
    * print 'Full response:', response

    
 @format @email
  Scenario: Submit request with invalid emailId format
  * def dataSet = read('classpath:data/Elovantestdata_p.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param elavonpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
{
  "legalName": "#(dataSet.legalName)",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "#(dataSet.dbaName)",
  "lastName": "#(dataSet.dbaName)",
  "ownerName": "MERCHANT PORTAL",
  "emailId": "bino@uu",
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
  "processor": "12",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#(dataSet.storeName)",
      "storeAddress": "#(dataSet.storeAddress)",
      "storeCity": "#(dataSet.storeCity)",
      "storeState": "#(dataSet.storeState)",
      "storeCountry": "#(dataSet.storeCountry)",
      "storeZipCode": "#(dataSet.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "12",
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
              "midElavonpay": "#(dataSet.midElavonpay)",
              "midElavonpay1": "#(dataSet.midElavonpay1)",
              "termNoElavonpay": "123",
              "termNoElavonpay1": "123",
              "bankIdElavonpay": "123456",
              "bankIdElavonpay1": "123456",
              "EBTcash": "0",
              "EBTfood": "0",
              "surchargeIndicator": "0",
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
    When method post
    Then status 400
    * print 'Full response:', response
    * print 'message: ', response.message
   
    
  @format @mobile
  Scenario: Submit request with mobile number less than 10 digits  
  * def dataSet = read('classpath:data/Elovantestdata_p.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param elavonpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
{
  "legalName": "#(dataSet.legalName)",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "#(dataSet.firstName)",
  "lastName": "#(dataSet.lastName)",
  "ownerName": "MERCHANT PORTAL",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
  "mobile": "83272875",
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
  "processor": "12",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#(dataSet.storeName)",
      "storeAddress": "#(dataSet.storeAddress)",
      "storeCity": "#(dataSet.storeCity)",
      "storeState": "#(dataSet.storeState)",
      "storeCountry": "#(dataSet.storeCountry)",
      "storeZipCode": "#(dataSet.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "12",
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
              "midElavonpay": "#(dataSet.midElavonpay)",
              "midElavonpay1": "#(dataSet.midElavonpay1)",
              "termNoElavonpay": "123",
              "termNoElavonpay1": "123",
              "bankIdElavonpay": "123456",
              "bankIdElavonpay1": "123456",
              "EBTcash": "0",
              "EBTfood": "0",
              "surchargeIndicator": "0",
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
    When method post
    Then status 400
    * print 'Full response:', response
    * print 'message:', response.message
   
@format @mobile
  Scenario: Submit request with mobile number more than 10 digits  
  * def dataSet = read('classpath:data/Elovantestdata_p.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param elavonpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
{
  "legalName": "#(dataSet.legalName)",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "#(dataSet.firstName)",
  "lastName": "#(dataSet.lastName)",
  "ownerName": "MERCHANT PORTAL",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
  "mobile": "83272875353454",
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
  "processor": "12",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#(dataSet.storeName)",
      "storeAddress": "#(dataSet.storeAddress)",
      "storeCity": "#(dataSet.storeCity)",
      "storeState": "#(dataSet.storeState)",
      "storeCountry": "#(dataSet.storeCountry)",
      "storeZipCode": "#(dataSet.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "12",
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
          "processorData": []
        }
      ]
    }
  ]
}
"""
    When method post
    Then status 400
    * print 'Full response:', response
    * print 'message:', response.message
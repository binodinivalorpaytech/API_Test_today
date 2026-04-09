@merchant @api
Feature: Valor Pay - Merchant on boarding for postilion 
  As an ISO user
  I want to create merchants via the POST /api/valor/create endpoint
  So that new merchants can be onboarded to the Valor Pay platform
     
    Background:
    * url 'https://vpuat.valorpaytech.com/api/valor'
     * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'postilioon' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * def shortSuperName = ('Supervisor' + random).substring(0,25)
  # ─────────────────────────────────────────────
  # POSITIVE TEST CASES
  # ─────────────────────────────────────────────

  @positive @smoke @TC_POS_001
  Scenario: Submit registration with valid dataset
    * def testDataepx = read('classpath:data/Postilion.json')
    Given url baseUrl
    And path '/api/valor/create'
    And param postilion = true
    And header Authorization = 'Bearer ' + accessToken
    And request 
    """
{
  "legalName": "#(testDataepx.legalName)",
  "dbaName": "#(testDataepx.dbaName)",
  "firstName": "#(testDataepx.firstName)",
  "lastName": "#(testDataepx.lastName)",
  "ownerName": "#(testDataepx.ownerName)",
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
  "processor": "6",
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
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "6",
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
          "dp_direct_indicator": "1",
          "dp_processor": "10",
          "processorData": [
            {
              "midDP": "RCTST1000089931",
              "groupIdDP": "12345",
              "termNoDP": "123456",
              "websiteDP": "buypass.com",
              "mid_Dp6": "123456",
              "tid_Dp6": "123456",
              "certificateNo": "123456",
              "EBTcash": 0,
              "EBTfood": 0,
              "surchargeIndicator": 0,
              "label": "surcharge",
              "programType": "surcharge",
              "c_nameDP3": "1",
              "tidDP3": "6584",
              "clientID_DP": "3596565",
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
    When method POST
    Then status 200
    And response.success == true
    * print 'Full response:', response
    * print 'message:', response.message
    * print 'status', response.status
    * print 'storeinfo', response.storeinfo
    
# ============================================================
  # SECTION 1: Merchant-Level Field Validations
  # ============================================================

  @mandatory @legal-name
  
  Scenario: Submit registration with empty legalName
    * def testDataepx = read('classpath:data/Postilion.json')
    Given url baseUrl
    And path '/api/valor/create'
    And param postilion = true
    And header Authorization = 'Bearer ' + accessToken
    And request 
    """
    {
  "legalName": "#(testDataepx.legalName)",
  "dbaName": "#(testDataepx.dbaName)",
  "firstName": "#(testDataepx.firstName)",
  "lastName": "",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
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
  "businessType": "Direct Marketing",
  "processor": "7",
  "programType": "1",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "CA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "test@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "7",
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
              "midEPX": "901018",
              "midEPX1": "",
              "termNoEPX": "2",
              "termNoEPX1": "",
              "custId": "9001",
              "custId1": "",
              "dbaNo": "1",
              "dbaNo1": "",
              "EBTcash": "0",
              "EBTcash1": "",
              "EBTfood": "0",
              "EBTfood1": "",
              "EbtNoEPX": "",
              "EbtNoEPX1": "",
              "surchargePercentage": "1.000",
              "programType": "cashdiscount",
              "label": "surcharge"
            }
          ]
        }
      ]
    }
  ]
}
    """
    When method POST
    Then status 400
    And response.success == false
    * print 'Full response:', response
    * print 'message:', response.message
    
  Scenario: Submit registration with empty lastName
    * def testDataepx = read('classpath:data/Postilion.json')
   
    Given url baseUrl
    And path '/api/valor/create'
    And param postilion = true
    And header Authorization = 'Bearer ' + accessToken
    And request 
    """
    {
  "legalName": "Postilion Store 6a",
  "dbaName": "#(testDataepx.dbaName)",
  "firstName": "#(testDataepx.firstName)",
  "lastName": "",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
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
  "businessType": "Direct Marketing",
  "processor": "7",
  "programType": "1",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "CA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "test@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "7",
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
              "midEPX": "901018",
              "midEPX1": "",
              "termNoEPX": "2",
              "termNoEPX1": "",
              "custId": "9001",
              "custId1": "",
              "dbaNo": "1",
              "dbaNo1": "",
              "EBTcash": "0",
              "EBTcash1": "",
              "EBTfood": "0",
              "EBTfood1": "",
              "EbtNoEPX": "",
              "EbtNoEPX1": "",
              "surchargePercentage": "1.000",
              "programType": "cashdiscount",
              "label": "surcharge"
            }
          ]
        }
      ]
    }
  ]
}
    """
    When method POST
    Then status 400
    And response.success == false
    * print 'Full response:', response
    * print 'message:', response.message
    
    Scenario: Submit registration with more than 35 character in lastName
    * def testDataepx = read('classpath:data/Postilion.json')
   
    Given url baseUrl
    And path '/api/valor/create'
    And param postilion = true
    And header Authorization = 'Bearer ' + accessToken
    And request 
    """
    {
  "legalName": "EPX Store 6a",
  "dbaName": "#(testDataepx.dbaName)",
  "firstName": "#(testDataepx.firstName)",
  "lastName": "file:///C:/Users/binodini/git/reposAPIAuto/TestRepo/testcrmProject/target/karate-reports/karate-summary.html",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
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
  "businessType": "Direct Marketing",
  "processor": "7",
  "programType": "1",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "CA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "test@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "7",
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
              "midEPX": "901018",
              "midEPX1": "",
              "termNoEPX": "2",
              "termNoEPX1": "",
              "custId": "9001",
              "custId1": "",
              "dbaNo": "1",
              "dbaNo1": "",
              "EBTcash": "0",
              "EBTcash1": "",
              "EBTfood": "0",
              "EBTfood1": "",
              "EbtNoEPX": "",
              "EbtNoEPX1": "",
              "surchargePercentage": "1.000",
              "programType": "cashdiscount",
              "label": "surcharge"
            }
          ]
        }
      ]
    }
  ]
}
    """
    When method POST
    Then status 400
    And response.success == false
    * print 'Full response:', response
    * print 'message:', response.message
  
  Scenario: Submit registration with more than 35 character for firstName
    * def testDataepx = read('classpath:data/Postilion.json')
   
   Given url baseUrl
    And path '/api/valor/create'
    And param postilion = true
    And header Authorization = 'Bearer ' + accessToken
    And request
    """
    {
  "legalName": "EPX Store 6a",
  "dbaName": "#(testDataepx.dbaName)",
  "firstName": "response time in milliseconds: 1754, url: https://vpuat.valorpaytech.com/api/valor/create?epx=true",
  "lastName": "Postilion Store 6a",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
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
  "businessType": "Direct Marketing",
  "processor": "7",
  "programType": "1",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "CA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "test@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "7",
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
              "midEPX": "901018",
              "midEPX1": "",
              "termNoEPX": "2",
              "termNoEPX1": "",
              "custId": "9001",
              "custId1": "",
              "dbaNo": "1",
              "dbaNo1": "",
              "EBTcash": "0",
              "EBTcash1": "",
              "EBTfood": "0",
              "EBTfood1": "",
              "EbtNoEPX": "",
              "EbtNoEPX1": "",
              "surchargePercentage": "1.000",
              "programType": "cashdiscount",
              "label": "surcharge"
            }
          ]
        }
      ]
    }
  ]
}
    """
    When method POST
    Then status 400
    And response.success == false
    * print 'Full response:', response
    * print 'message:', response.message
 
 
 Scenario: Submit registration with invalid emailId format
    * def testDataepx = read('classpath:data/Postilion.json')
   
    Given url baseUrl
    And path '/api/valor/create'
    And param postilion = true
    And header Authorization = 'Bearer ' + accessToken
    And request 
    """
    {
  "legalName": "EPX Store 6a",
  "dbaName": "#(testDataepx.dbaName)",
  "firstName": "#(testDataepx.firstName)",
  "lastName": "EPX Store 6a",
  "emailId": "xyz@in",
  "userName": "#(dynamicUser)",
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
  "businessType": "Direct Marketing",
  "processor": "7",
  "programType": "1",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "CA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "test@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "7",
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
              "midEPX": "901018",
              "midEPX1": "",
              "termNoEPX": "2",
              "termNoEPX1": "",
              "custId": "9001",
              "custId1": "",
              "dbaNo": "1",
              "dbaNo1": "",
              "EBTcash": "0",
              "EBTcash1": "",
              "EBTfood": "0",
              "EBTfood1": "",
              "EbtNoEPX": "",
              "EbtNoEPX1": "",
              "surchargePercentage": "1.000",
              "programType": "cashdiscount",
              "label": "surcharge"
            }
          ]
        }
      ]
    }
  ]
}
    """
    When method POST
    Then status 400
    And response.success == false
    * print 'Full response:', response
    * print 'message:', response.message

Scenario: Submit registration with Invalid mobile format
    * def testDataepx = read('classpath:data/Postilion.json')
   
    Given url baseUrl
    And path '/api/valor/create'
    And param postilion = true
    And header Authorization = 'Bearer ' + accessToken
    And request  
    """
    {
  "legalName": "EPX Store 6a",
  "dbaName": "#(testDataepx.dbaName)",
  "firstName": "#(testDataepx.firstName)",
  "lastName": "EPX Store 6a",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
  "mobile": "8327287578999",
  "legalAddress": "Test Address",
  "legalCity": "CLIFFSIDE PARK",
  "legalState": "NY",
  "legalCountry": "US",
  "legalZipCode": "07010",
  "legalTimezone": "EST",
  "role": "10",
  "userType": "4",
  "isTxnAllowed": "1",
  "businessType": "Direct Marketing",
  "processor": "7",
  "programType": "1",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "CA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "test@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "7",
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
              "midEPX": "901018",
              "midEPX1": "",
              "termNoEPX": "2",
              "termNoEPX1": "",
              "custId": "9001",
              "custId1": "",
              "dbaNo": "1",
              "dbaNo1": "",
              "EBTcash": "0",
              "EBTcash1": "",
              "EBTfood": "0",
              "EBTfood1": "",
              "EbtNoEPX": "",
              "EbtNoEPX1": "",
              "surchargePercentage": "1.000",
              "programType": "cashdiscount",
              "label": "surcharge"
            }
          ]
        }
      ]
    }
  ]
}
    """
    When method POST
    Then status 400
    And response.success == false
    * print 'Full response:', response
    * print 'message:', response.message
       
 Scenario: Submit registration with Blank processor data format
    * def testDataepx = read('classpath:data/Postilion.json')
   
    Given url baseUrl
    And path '/api/valor/create'
    And param postilion = true
    And header Authorization = 'Bearer ' + accessToken
    And request  
    """
    {
  "legalName": "EPX Store 6a",
  "dbaName": "#(testDataepx.dbaName)",
  "firstName": "#(testDataepx.firstName)",
  "lastName": "Postilion Store 6a",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
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
  "businessType": "Direct Marketing",
  "processor": "7",
  "programType": "1",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "CA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "test@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "7",
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
    When method POST
    Then status 400
    And response.success == false
    * print 'Full response:', response
    * print 'message:', response.message 
      
  Scenario: Submit registration with blank storedata format
    * def testDataepx = read('classpath:data/Postilion.json')
   
    Given url baseUrl
    And path '/api/valor/create'
    And param postilion = true
    And header Authorization = 'Bearer ' + accessToken
    And request  
    """
    {
  "legalName": "EPX Store 6a",
  "dbaName": "#(testDataepx.dbaName)",
  "firstName": "#(testDataepx.firstName)",
  "lastName": "EPX Store 6a",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
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
  "businessType": "Direct Marketing",
  "processor": "7",
  "programType": "1",
  "rollUp": "0",
  "storeData": []
}
    """
    When method POST
    Then status 400
    And response.success == false
    * print 'Full response:', response
    * print 'message:', response.message
  
  Scenario: Submit registration with Invalid accesstoken
    * def testDataepx = read('classpath:data/Postilion.json')
    Given url baseUrl
    And path '/api/valor/create'
    And param postilion = true
    And header Authorization = 'Bearer 7' + accessToken
    And request 
    """
    {
  "legalName": "EPX Store 6a",
  "dbaName": "#(testDataepx.dbaName)",
  "firstName": "#(testDataepx.firstName)",
  "lastName": "Postilion Store 6a",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
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
  "businessType": "Direct Marketing",
  "processor": "7",
  "programType": "1",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "CA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "test@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "7",
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
              "midEPX": "901018",
              "midEPX1": "",
              "termNoEPX": "2",
              "termNoEPX1": "",
              "custId": "9001",
              "custId1": "",
              "dbaNo": "1",
              "dbaNo1": "",
              "EBTcash": "0",
              "EBTcash1": "",
              "EBTfood": "0",
              "EBTfood1": "",
              "EbtNoEPX": "",
              "EbtNoEPX1": "",
              "surchargePercentage": "1.000",
              "programType": "cashdiscount",
              "label": "surcharge"
            }
          ]
        }
      ]
    }
  ]
}
    """
    When method POST
    Then status 401
    And response.success == false
    * print 'Full response:', response
    * print 'message:', response.message    
    
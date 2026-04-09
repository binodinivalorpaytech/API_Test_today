# ============================================================
# Feature: Merchant Registration - Negative Test Cases
# Description: BDD scenarios covering all invalid/boundary
#              inputs derived from the provided JSON payload.
# ============================================================
@negative @merchant-registration
Feature: Merchant Registration - Negative Validations
    Background:
    * url 'https://vpuat.valorpaytech.com/api/valor'
     * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'EPX' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * def shortSuperName = ('Supervisor' + random).substring(0,25)

  # ============================================================
  # SECTION 1: Merchant-Level Field Validations
  # ============================================================

  @mandatory @legal-name
  
  Scenario: Submit registration with empty legalName
    * def testDataepx = read('classpath:data/EPX_MerchantOnBoardingNegative.json')
    Given url baseUrl
    And path '/api/valor/create'
    And param epx = true
    And header Authorization = 'Bearer ' + accessToken
    And request 
    """
    {
  "legalName": "#(testDataepx.legalName)",
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
    * def testDataepx = read('classpath:data/EPX_MerchantOnBoardingNegative.json')
   
   Given url baseUrl
    And path '/api/valor/create'
    And param epx = true
    And header Authorization = 'Bearer ' + accessToken
    And request 
    """
    {
  "legalName": "EPX Store 6a",
  "dbaName": "#(testDataepx.dbaName)",
  "firstName": "#(testDataepx.firstName)",
  "lastName": "#(testDataepx.lastName)",
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
    * def testDataepx = read('classpath:data/EPX_MerchantOnBoardingNegative.json')
   
   Given url baseUrl
    And path '/api/valor/create'
    And param epx = true
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
    * def testDataepx = read('classpath:data/EPX_MerchantOnBoardingNegative.json')
   
   Given url baseUrl
    And path '/api/valor/create'
    And param epx = true
    And header Authorization = 'Bearer ' + accessToken
    And request 
    """
    {
  "legalName": "EPX Store 6a",
  "dbaName": "#(testDataepx.dbaName)",
  "firstName": "response time in milliseconds: 1754, url: https://vpuat.valorpaytech.com/api/valor/create?epx=true",
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
    * def testDataepx = read('classpath:data/EPX_MerchantOnBoardingNegative.json')
   
   Given url baseUrl
    And path '/api/valor/create'
    And param epx = true
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
    * def testDataepx = read('classpath:data/EPX_MerchantOnBoardingNegative.json')
   
    Given url baseUrl
    And path '/api/valor/create'
    And param epx = true
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
    * def testDataepx = read('classpath:data/EPX_MerchantOnBoardingNegative.json')
   
    Given url baseUrl
    And path '/api/valor/create'
    And param epx = true
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
    * def testDataepx = read('classpath:data/EPX_MerchantOnBoardingNegative.json')
   
    Given url baseUrl
    And path '/api/valor/create'
    And param epx = true
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
    * def testDataepx = read('classpath:data/EPX_MerchantOnBoardingNegative.json')
     Given url baseUrl
    And path '/api/valor/create'
    And param epx = true
    And header Authorization = 'Bearer 7' + accessToken
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
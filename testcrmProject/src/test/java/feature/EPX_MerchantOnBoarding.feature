@positive @smoke
Feature: ValoRpaytech Merchant Creation - Positive Scenarios

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

  @positive @critical
  Scenario: Create merchant with valid store and EPI configuration
   * def testDataepx = read('classpath:data/EPX_MerchantOnBoarding.json')
   
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
    Then status 200, 201
    And response.success == true
    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * match response.status == true

  @positive @regression
  Scenario: Verify merchant details in response
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
    Then status 200, 201
    And response.success == true
    
    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * match response.status == true
    * print 'storeInfo:', response.storeInfo
    * print 'storeInfo:', response.code
    * print 'storeInfo:', response.message
    * print 'storeInfo:', response.newUserId
    
  @positive @regression
  Scenario: Verify store configuration in response
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
      "storeName": "EPX Store 6a",
      "storeAddress": "4100 JOHNSTON ST",
      "storeCity": "LAFAYETTE",
      "storeState": "CA",
      "storeCountry": "US",
      "storeZipCode": "70503",
      "storeTimezone": "EST",
      "superVisorName": "Michel Jhon",
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
    Then status 200, 201
  
    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * match response.status == true
    * print 'storeInfo:', response.storeInfo
    * print 'storeInfo:', response.code
    * print 'storeInfo:', response.message
    * print 'storeInfo:', response.newUserId

  @positive @regression
  Scenario: Verify EPI configuration in response
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
    Then status 200, 201
    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * match response.status == true
    * print 'storeInfo:', response.storeInfo
    * print 'storeInfo:', response.code
    * print 'storeInfo:', response.message
    * print 'storeInfo:', response.newUserId

  @positive @performance
  Scenario: Verify API response time
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
    Then status 200, 201
    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * match response.status == true
    * print 'storeInfo:', response.storeInfo
    * print 'storeInfo:', response.code
    * print 'storeInfo:', response.message
    * print 'storeInfo:', response.newUserId

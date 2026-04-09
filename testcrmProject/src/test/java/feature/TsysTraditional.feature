Feature: Merchant - TSYS Traditional

  Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'Surcharge' + random 
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('Supervisor' + random).substring(0,25)
    
    
    Scenario Outline: Create Merchant with TSYS Traditional - <flowType> Flow
    * def testDataset = read('classpath:traditional/<payloadFile>')
    
    Given url baseUrl
    And path '/api/valor/create'
    And param tsystraditional = testDataset.tsystraditionalParam
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
    """
    {
      "legalName":     "#(testDataset.legalName)",
      "dbaName":       "#(testDataset.dbaName)",
      "firstName":     "#(testDataset.firstName)",
      "lastName":      "PORTAL",
      "ownerName":     "MERCHANT PORTAL",
      "emailId":       "#(dynamicEmail)",
      "userName":      "#(dynamicUser)",
      "mobile":        "#(testDataset.mobile)",
      "legalAddress":  "#(testDataset.legalAddress)",
      "legalCity":     "CLIFFSIDE PARK",
      "legalState":    "NJ",
      "legalCountry":  "US",
      "legalZipCode":  "#(testDataset.legalZipCode)",
      "role":          "10",
      "legalTimezone": "EST",
      "userType":      "4",
      "isTxnAllowed":  "1",
      "businessType":  "Direct Marketing",
      "selectedState": "NJ",
      "processor":     "1",
      "programType":   "1",
      "rollUp":        "0",
      "storeData": [
        {
          "storeName":         "#('Store ' + random)",
          "storeAddress":      "170 7th Ave S",
          "storeCity":         "NEW YORK",
          "storeState":        "NY",
          "storeCountry":      "US",
          "storeZipCode":      "10014",
          "storeTimezone":     "EST",
          "superVisorName":    "#(shortSuperName)",
          "superVisorEmail":   "valorbaseadmin@protonmail.com",
          "superVisorContact": "2124637932",
          "mccCode":           "5993",
          "epiData": [
            {
              "device":     139,
              "deviceType": "Soft Pos",
              "epiLabel":   "VT",
              "processor":  "1",
              "features": {
                "tip": {
                  "enabled": false,
                  "value": [5, 10, 15, 20]
                },
                "surcharge": {
                  "enabled": #(testDataset.surchargeEnabled),
                  "value":   "#(testDataset.surchargeValue)"
                },
                "tax": {
                  "enabled": false,
                  "value":   "0"
                }
              },
              "processorData": [
                {
                  "mid":                 "#(testDataset.mid)",
                  "mid1":                "",
                  "vNumber":             "#(testDataset.vNumber)",
                  "vNumber1":            "",
                  "storeNo":             "#(testDataset.storeNo)",
                  "storeNo1":            "",
                  "termNo":              "#(testDataset.termNo)",
                  "termNo1":             "",
                  "association":         "#(testDataset.association)",
                  "association1":        "",
                  "chain":               "111111",
                  "chain1":              "",
                  "agent":               "0001",
                  "agent1":              "",
                  "EbtNo":               "",
                  "EbtNo1":              "",
                  "binnumber":           "#(testDataset.binnumber)",
                  "binnumber1":          "",
                  "agentBank":           "#(testDataset.agentBank)",
                  "agentBank1":          "",
                  "industry":            "#(testDataset.industry)",
                  "industry1":           "",
                  "surchargePercentage": "#(testDataset.surchargePercentage)",
                  "surchargeIndicator":  #(testDataset.surchargeIndicator),
                  "EBTfood":             0,
                  "EBTfood1":            0,
                  "EBTcash":             0,
                  "EBTcash1":            0,
                  "label":               "MERCHANT PORTAL LOGIN",
                  "programType":         "#(testDataset.programType)",
                  "tid3":                "#(testDataset.tid3)",
                  "ClientID":            "#(testDataset.clientID)"
                }
              ]
            }
          ]
        }
      ]
    }
    """
      When method post
      Then status <expectedStatus>
    # * def isPositive = <expectedStatus> == 200
* print response.code 
* print response.message 
* print response.mpId 
* print response.newUserId 
  Examples:
    | flowType | payloadFile           | expectedStatus |
    | Positive | Tsys_positive-payload.json | 200            |
    | Negative | Tsys_negative-payload.json | 400            |
    
  # =====================================================================
  # SCENARIO 3: DB Validation using mpId from Scenario 1
  # =====================================================================
  Scenario: Validate Merchant exists in DB
    * def mpId = karate.get('sharedMpId')
    * print 'Retrieved sharedMpId:', mpId
    #* assert mpId != null

    # ✅ STEP 1: Once you confirm table+column from prints above, use correct query:
    * def query = "select * from merchant_info where Mp_Id = " + mpId
    * print query
    * def dbResult = call read('classpath:common/db.feature') { query: '#(query)' }
    * def rows = karate.toJson(dbResult.result)
    * print '>>> QUERY RESULT rows.length:', rows.length
    * print '>>> QUERY RESULT:', rows
    #* assert rows.length > 0
   
 #* Author: Binodini Sahoo
 #* Description: Merchant API Automation
 #* Created Date: 12-Mar-2026
  
  # =====================================================================
  # SCENARIO 4: Unauthorized Request to get 401
  # =====================================================================
  Scenario Outline: Create Merchant with TSYS Traditional - <flowType> Flow
  * def testDataset = read('classpath:traditional/<payloadFile>')
    Given url baseUrl
    And path '/api/valor/create'
    And param tsystraditional = testDataset.tsystraditionalParam
    And header Authorization = 'Bearer 5' + accessToken
    And header Content-Type = 'application/json'
    And request
    """
    {
      "legalName":     "#(testDataset.legalName)",
      "dbaName":       "#(testDataset.dbaName)",
      "firstName":     "#(testDataset.firstName)",
      "lastName":      "PORTAL",
      "ownerName":     "MERCHANT PORTAL",
      "emailId":       "#(dynamicEmail)",
      "userName":      "#(dynamicUser)",
      "mobile":        "#(testDataset.mobile)",
      "legalAddress":  "#(testDataset.legalAddress)",
      "legalCity":     "CLIFFSIDE PARK",
      "legalState":    "NJ",
      "legalCountry":  "US",
      "legalZipCode":  "#(testDataset.legalZipCode)",
      "role":          "10",
      "legalTimezone": "EST",
      "userType":      "4",
      "isTxnAllowed":  "1",
      "businessType":  "Direct Marketing",
      "selectedState": "NJ",
      "processor":     "1",
      "programType":   "1",
      "rollUp":        "0",
      "storeData": [
        {
          "storeName":         "#('Store ' + random)",
          "storeAddress":      "170 7th Ave S",
          "storeCity":         "NEW YORK",
          "storeState":        "NY",
          "storeCountry":      "US",
          "storeZipCode":      "10014",
          "storeTimezone":     "EST",
          "superVisorName":    "#(shortSuperName)",
          "superVisorEmail":   "valorbaseadmin@protonmail.com",
          "superVisorContact": "2124637932",
          "mccCode":           "5993",
          "epiData": [
            {
              "device":     139,
              "deviceType": "Soft Pos",
              "epiLabel":   "VT",
              "processor":  "1",
              "features": {
                "tip": {
                  "enabled": false,
                  "value": [5, 10, 15, 20]
                },
                "surcharge": {
                  "enabled": #(testDataset.surchargeEnabled),
                  "value":   "#(testDataset.surchargeValue)"
                },
                "tax": {
                  "enabled": false,
                  "value":   "0"
                }
              },
              "processorData": [
                {
                  "mid":                 "#(testDataset.mid)",
                  "mid1":                "",
                  "vNumber":             "#(testDataset.vNumber)",
                  "vNumber1":            "",
                  "storeNo":             "#(testDataset.storeNo)",
                  "storeNo1":            "",
                  "termNo":              "#(testDataset.termNo)",
                  "termNo1":             "",
                  "association":         "#(testDataset.association)",
                  "association1":        "",
                  "chain":               "",
                  "chain1":              "111111",
                  "agent":               "",
                  "agent1":              "0001",
                  "EbtNo":               "",
                  "EbtNo1":              "",
                  "binnumber":           "#(testDataset.binnumber)",
                  "binnumber1":          "",
                  "agentBank":           "#(testDataset.agentBank)",
                  "agentBank1":          "",
                  "industry":            "#(testDataset.industry)",
                  "industry1":           "",
                  "surchargePercentage": "#(testDataset.surchargePercentage)",
                  "surchargeIndicator":  #(testDataset.surchargeIndicator),
                  "EBTfood":             0,
                  "EBTfood1":            0,
                  "EBTcash":             0,
                  "EBTcash1":            0,
                  "label":               "MERCHANT PORTAL LOGIN",
                  "programType":         "#(testDataset.programType)",
                  "tid3":                "#(testDataset.tid3)",
                  "ClientID":            "#(testDataset.clientID)"
                }
              ]
            }
          ]
        }
      ]
    }
    """
      When method post
      Then status <expectedStatus>
    # * def isPositive = <expectedStatus> == 401
* print response.code 
* print response.message 
 Examples:
    | flowType | payloadFile           | expectedStatus |
    | Negative | Tsys_positive-payload.json | 401            |
    
  # =====================================================================
  # SCENARIO 4: 404 Status code with Invalid End point
  # ===================================================================== 
  Scenario Outline: Create Merchant with TSYS Traditional - <flowType> Flow
    * def testDataset = read('classpath:traditional/<payloadFile>')
    
    Given url baseUrl
    And path '/api/valor/creat'
    And param tsystraditional = testDataset.tsystraditionalParam
    And header Authorization = 'Bearer 5' + accessToken
    And header Content-Type = 'application/json'
    And request
    """
    {
      "legalName":     "#(testDataset.legalName)",
      "dbaName":       "#(testDataset.dbaName)",
      "firstName":     "#(testDataset.firstName)",
      "lastName":      "PORTAL",
      "ownerName":     "MERCHANT PORTAL",
      "emailId":       "#(dynamicEmail)",
      "userName":      "#(dynamicUser)",
      "mobile":        "#(testDataset.mobile)",
      "legalAddress":  "#(testDataset.legalAddress)",
      "legalCity":     "CLIFFSIDE PARK",
      "legalState":    "NJ",
      "legalCountry":  "US",
      "legalZipCode":  "#(testDataset.legalZipCode)",
      "role":          "10",
      "legalTimezone": "EST",
      "userType":      "4",
      "isTxnAllowed":  "1",
      "businessType":  "Direct Marketing",
      "selectedState": "NJ",
      "processor":     "1",
      "programType":   "1",
      "rollUp":        "0",
      "storeData": [
        {
          "storeName":         "#('Store ' + random)",
          "storeAddress":      "170 7th Ave S",
          "storeCity":         "NEW YORK",
          "storeState":        "NY",
          "storeCountry":      "US",
          "storeZipCode":      "10014",
          "storeTimezone":     "EST",
          "superVisorName":    "#(shortSuperName)",
          "superVisorEmail":   "valorbaseadmin@protonmail.com",
          "superVisorContact": "2124637932",
          "mccCode":           "5993",
          "epiData": [
            {
              "device":     139,
              "deviceType": "Soft Pos",
              "epiLabel":   "VT",
              "processor":  "1",
              "features": {
                "tip": {
                  "enabled": false,
                  "value": [5, 10, 15, 20]
                },
                "surcharge": {
                  "enabled": #(testDataset.surchargeEnabled),
                  "value":   "#(testDataset.surchargeValue)"
                },
                "tax": {
                  "enabled": false,
                  "value":   "0"
                }
              },
              "processorData": [
                {
                  "mid":                 "#(testDataset.mid)",
                  "mid1":                "",
                  "vNumber":             "#(testDataset.vNumber)",
                  "vNumber1":            "",
                  "storeNo":             "#(testDataset.storeNo)",
                  "storeNo1":            "",
                  "termNo":              "#(testDataset.termNo)",
                  "termNo1":             "",
                  "association":         "#(testDataset.association)",
                  "association1":        "",
                  "chain":               "",
                  "chain1":              "111111",
                  "agent":               "",
                  "agent1":              "0001",
                  "EbtNo":               "",
                  "EbtNo1":              "",
                  "binnumber":           "#(testDataset.binnumber)",
                  "binnumber1":          "",
                  "agentBank":           "#(testDataset.agentBank)",
                  "agentBank1":          "",
                  "industry":            "#(testDataset.industry)",
                  "industry1":           "",
                  "surchargePercentage": "#(testDataset.surchargePercentage)",
                  "surchargeIndicator":  #(testDataset.surchargeIndicator),
                  "EBTfood":             0,
                  "EBTfood1":            0,
                  "EBTcash":             0,
                  "EBTcash1":            0,
                  "label":               "MERCHANT PORTAL LOGIN",
                  "programType":         "#(testDataset.programType)",
                  "tid3":                "#(testDataset.tid3)",
                  "ClientID":            "#(testDataset.clientID)"
                }
              ]
            }
          ]
        }
      ]
    }
    """
      When method post
      Then status <expectedStatus>
    # * def isPositive = <expectedStatus> == 404
* print response.code 
* print response.message 
 Examples:
    | flowType | payloadFile           | expectedStatus |
    | Negative | Tsys_positive-payload.json | 404            |
    
    # ====================================================================================
  # SCENARIO 5: Create Merchant with invalid dataset - Negative Flow for 500 server error
  # =====================================================================================
  Scenario: Create Merchant - TSYS Surcharge Positive Flow
  * def testData = read('classpath:data/Tsys_positive-payload.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param surchargetsys = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
    """
   {
      "legalName":     "#(testDataset.legalName)",
      "dbaName":       "#(testDataset.dbaName)",
      "firstName":     "#(testDataset.firstName)",
      "lastName":      "PORTAL",
      "ownerName":     "MERCHANT PORTAL",
      "emailId":       "#(dynamicEmail)",
      "userName":      "#(dynamicUser)",
      "mobile":        "#(testDataset.mobile)",
      "legalAddress":  "#(testDataset.legalAddress)",
      "legalCity":     "CLIFFSIDE PARK",
      "legalState":    "NJ",
      "legalCountry":  "US",
      "legalZipCode":  "#(testDataset.legalZipCode)",
      "role":          "10",
      "legalTimezone": "EST",
      "userType":      "4",
      "isTxnAllowed":  "1",
      "businessType":  "Direct Marketing",
      "selectedState": "NJ",
      "processor":     "1",
      "programType":   "1",
      "rollUp":        "0",
      "storeData": [
        {
          "storeName":         "#('Store ' + random)",
          "storeAddress":      "170 7th Ave S",
          "storeCity":         "NEW YORK",
          "storeState":        "NY",
          "storeCountry":      "US",
          "storeZipCode":      "10014",
          "storeTimezone":     "EST",
          "superVisorName":    "#(shortSuperName)",
          "superVisorEmail":   "valorbaseadmin@protonmail.com",
          "superVisorContact": "2124637932",
          "mccCode":           "5993",
          "epiData": [
            {
              "device":     139,
              "deviceType": "Soft Pos",
              "epiLabel":   "VT",
              "processor":  "1",
              "features": {
                "tip": {
                  "enabled": false,
                  "value": [5, 10, 15, 20]
                },
                "surcharge": {
                  "enabled": #(testDataset.surchargeEnabled),
                  "value":   "#(testDataset.surchargeValue)"
                },
                "tax": {
                  "enabled": false,
                  "value":   "0"
                }
              },
              "processorData": []
            }
          ]
        }
      ]
    }
    """
    When method post
     Then match [400] contains responseStatus

    * print 'Full response:', response
    * print 'code', response.code
    * print 'status', response.status
    * print 'message', response.message
   

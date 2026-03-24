Feature: Merchant - FD Surcharge

  Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'FDSurcharge' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('FDSupervisor' + random).substring(0, 25)

  # =====================================================================
  # SCENARIO 1: Create Merchant - Positive Flow
  # =====================================================================
  Scenario: Create Merchant - FD Surcharge Positive Flow
    * def dataSet = read('classpath:data/FDpositive-payload.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param surchargefd = true
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
        "legalAddress": "#(dataSet.legalAddress)",
        "legalCity":    "CLIFFSIDE PARK",
        "legalState":   "NJ",
        "legalCountry": "US",
        "legalZipCode": "#(dataSet.legalZipCode)",
        "role":         "10",
        "legalTimezone":"EST",
        "userType":     "4",
        "isTxnAllowed": "1",
        "businessType": "Direct Marketing",
        "selectedState":"NJ",
        "processor":    "2",
        "programType":  "1",
        "rollUp":       "0",
        "storeData": [
          {
            "storeName":         "#('Store ' + random)",
            "storeAddress":      "20987 N John Wayne Pkwy",
            "storeCity":         "MARICOPA",
            "storeState":        "AZ",
            "storeCountry":      "US",
            "storeZipCode":      "85138",
            "storeTimezone":     "EST",
            "superVisorName":    "#(shortSuperName)",
            "superVisorEmail":   "office@valorpaytech.com",
            "superVisorContact": "5208396263",
            "mccCode":           "1761",
            "epiData": [
              {
                "device":     "139",
                "deviceType": "Soft Pos",
                "processor":  "2",
                "epiLabel":   "VT",
                "processorData": [
                  {
                    "surchargePercentage": "3.846",
                    "groupId":             "40001",
                    "groupId1":            "",
                    "midFD":               "#(dataSet.midFD)",
                    "midFD1":              "",
                    "termNoFD":            "#(dataSet.termNoFD)",
                    "termNoFD1":           "",
                    "EbtNoFD":             "123456",
                    "EbtNoFD1":            "",
                    "website":             "https://vpuat.binskit.com",
                    "website1":            "",
                    "mid3":                "",
                    "termNo3":             "",
                    "location_id":         "",
                    "client_key":          "",
                    "c_name":              "",
                    "EBTfood":             1,
                    "EBTfood1":            0,
                    "EBTcash":             0,
                    "EBTcash1":            0,
                    "surchargeIndicator":  0,
                    "label":               "UNIVERSAL ROOFING SPECIALISTS",
                    "programType":         "surcharge"
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
    * def dataSet = read('classpath:data/FDnegative-payload.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param surchargefd = true
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
    * def dataSet = read('classpath:data/FDnegative-payload.json')

    Given url baseUrl
    And path '/api/valor/create1'
    And param surchargefd = true
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
    * def dataSet = read('classpath:data/FDnegative-payload.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param surchargefd = true
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
    * def dataSet = read('classpath:data/FDpositive-payload.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param surchargefd = true
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
        "legalAddress": "#(dataSet.legalAddress)",
        "legalCity":    "CLIFFSIDE PARK",
        "legalState":   "NJ",
        "legalCountry": "US",
        "legalZipCode": "#(dataSet.legalZipCode)",
        "role":         "10",
        "legalTimezone":"EST",
        "userType":     "4",
        "isTxnAllowed": "1",
        "businessType": "Direct Marketing",
        "selectedState":"NJ",
        "processor":    "2",
        "programType":  "1",
        "rollUp":       "0",
        "storeData": [
          {
            "storeName":         "#('Store ' + random)",
            "storeAddress":      "20987 N John Wayne Pkwy",
            "storeCity":         "MARICOPA",
            "storeState":        "AZ",
            "storeCountry":      "US",
            "storeZipCode":      "85138",
            "storeTimezone":     "EST",
            "superVisorName":    "#(shortSuperName)",
            "superVisorEmail":   "office@valorpaytech.com",
            "superVisorContact": "5208396263",
            "mccCode":           "1761",
            "epiData": [
              {
                "device":     "139",
                "deviceType": "Soft Pos",
                "processor":  "2",
                "epiLabel":   "VT",
                "processorData": [
                  {
                    "surchargePercentage": "3.846",
                    "groupId":             "40001",
                    "groupId1":            "",
                    "midFD":               "#(dataSet.midFD)",
                    "midFD1":              "",
                    "termNoFD":            "#(dataSet.termNoFD)",
                    "termNoFD1":           "",
                    "EbtNoFD":             "123456",
                    "EbtNoFD1":            "",
                    "website":             "https://vpuat.binskit.com",
                    "website1":            "",
                    "mid3":                "",
                    "termNo3":             "",
                    "location_id":         "",
                    "client_key":          "",
                    "c_name":              "",
                    "EBTfood":             1,
                    "EBTfood1":            0,
                    "EBTcash":             0,
                    "EBTcash1":            0,
                    "surchargeIndicator":  0,
                    "label":               "UNIVERSAL ROOFING SPECIALISTS",
                    "programType":         "surcharge"
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

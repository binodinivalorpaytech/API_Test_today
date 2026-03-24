Feature: Merchant Validation in DB

  Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'FDSurcharge' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('Supervisor' + random).substring(0, 25)
    * def dbConfig = karate.get('dbConfig')
    #test

  Scenario: Create Merchant and Validate in DB

    # ── Load test data ──────────────────────────────────────────────────────────
    * def dataSet = read('classpath:data/FDpositive-payload.json')

    # ── Step 1: Create Merchant via API ─────────────────────────────────────────
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

    # ── Step 2: Validate API response ───────────────────────────────────────────
    * match response.status == true
    * def mpId   = response.mpId
    * def userId = response.newUserId
    * print 'Created mpId:', mpId
    * print 'Created userId:', userId

    # ── Step 3: DB Validation — merchant_info table ──────────────────────────────
    * def merchantQuery = "SELECT Mp_Id FROM merchant_info WHERE Mp_Id = " + mpId
    * def dbResult1 = call read('classpath:common/db.feature') { query: '#(merchantQuery)' }
    * def merchantRows = karate.toJson(dbResult1.result, true)
    * assert merchantRows.length > 0
    * print 'merchant_info rows found:', merchantRows.length

    # ── Step 4: DB Validation — usermaster JOIN merchant_info ────────────────────
    # Confirmed actual column names from DB output: UserId, Mp_Id, dbaName, userName
    * def joinQuery = "SELECT u.UserId, u.UserName, mi.Mp_Id, mi.dbaName FROM usermaster u JOIN merchant_info mi ON u.UserId = mi.User_Id WHERE u.UserId = '" + userId + "'"
    * def dbResult2 = call read('classpath:common/db.feature') { query: '#(joinQuery)' }
    * def joinRows = karate.toJson(dbResult2.result, true)

    * print 'JOIN raw row:', joinRows[0]
    * assert joinRows.length == 1

    # Use karate.jsonPath with confirmed exact column names from the DB
    * def actualUserId   = karate.jsonPath(joinRows, '$[0].UserId') + ''
    * def actualMpId     = karate.jsonPath(joinRows, '$[0].Mp_Id') + ''
    * def actualUserName = karate.jsonPath(joinRows, '$[0].userName') + ''

    * print 'Resolved UserId from DB:',   actualUserId
    * print 'Resolved MpId from DB:',     actualMpId
    * print 'Resolved UserName from DB:', actualUserName

    * match actualUserId   == userId + ''
    * match actualMpId     == mpId + ''
    * match actualUserName == dynamicUser + ''
    * print 'JOIN validation passed for UserId:', userId
    * print 'JOIN validation passed for UserName:', actualUserName

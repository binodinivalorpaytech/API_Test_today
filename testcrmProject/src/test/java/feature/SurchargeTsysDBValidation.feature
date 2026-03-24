Feature: Merchant Validation in DB

  Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'Surcharge' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('Supervisor' + random).substring(0, 25)
    * def dbConfig = karate.get('dbConfig')
    # test

  Scenario: Create Merchant and Validate in DB

    # ── Load test data ──────────────────────────────────────────────────────────
    * def testData = read('classpath:data/positive-payload.json')

    # ── Step 1: Create Merchant via API ─────────────────────────────────────────
    Given url baseUrl
    And path '/api/valor/create'
    And param surchargetsys = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName":    "#(testData.legalName)",
        "dbaName":      "#(testData.dbaName)",
        "firstName":    "#(testData.firstName)",
        "lastName":     "PORTAL",
        "ownerName":    "MERCHANT PORTAL",
        "emailId":      "#(dynamicEmail)",
        "userName":     "#(dynamicUser)",
        "mobile":       "#(testData.mobile)",
        "legalAddress": "Test Address",
        "legalCity":    "CLIFFSIDE PARK",
        "legalState":   "NJ",
        "legalCountry": "US",
        "legalZipCode": "#(testData.legalZipCode)",
        "role":         "10",
        "legalTimezone":"EST",
        "userType":     "4",
        "isTxnAllowed": "1",
        "businessType": "Direct Marketing",
        "selectedState":"NJ",
        "processor":    "1",
        "programType":  "1",
        "rollUp":       "0",
        "storeData": [
          {
            "storeName":         "#('Store ' + random)",
            "storeAddress":      "4100 JOHNSTON ST",
            "storeCity":         "LAFAYETTE",
            "storeState":        "LA",
            "storeCountry":      "US",
            "storeZipCode":      "70503",
            "storeTimezone":     "EST",
            "superVisorName":    "#(shortSuperName)",
            "superVisorEmail":   "office@valorpaytech.com",
            "superVisorContact": "3377040344",
            "mccCode":           "5812",
            "epiData": [
              {
                "device":     "139",
                "deviceType": "Soft POS",
                "processor":  "1",
                "epiLabel":   "VT",
                "features": {
                  "tip":       { "enabled": false, "value": [5, 10, 15, 20] },
                  "surcharge": { "enabled": #(testData.surchargeEnabled), "value": "#(testData.surchargePercentage)" },
                  "tax":       { "enabled": false, "value": "0" }
                },
                "selectedState": "NJ",
                "processorData": [
                  {
                    "mid":                 "#(testData.mid)",          "mid1":         "",
                    "vNumber":             "#(testData.vNumber)",       "vNumber1":     "",
                    "storeNo":             "#(testData.storeNo)",       "storeNo1":     "",
                    "termNo":              "#(testData.termNo)",        "termNo1":      "",
                    "association":         "949006",                    "association1": "",
                    "chain":               "111111",                    "chain1":       "",
                    "agent":               "0001",                      "agent1":       "",
                    "EbtNo":               "",                          "EbtNo1":       "",
                    "binnumber":           "#(testData.binnumber)",     "binnumber1":   "",
                    "agentBank":           "#(testData.agentBank)",     "agentBank1":   "",
                    "industry":            "#(testData.industry)",      "industry1":    "",
                    "EBTcash":             0,                           "EBTcash1":     0,
                    "EBTfood":             0,                           "EBTfood1":     0,
                    "surchargeIndicator":  #(testData.surchargeIndicator),
                    "surchargePercentage": "#(testData.surchargePercentage)",
                    "label":               "MERCHANT PORTAL LOGIN",
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

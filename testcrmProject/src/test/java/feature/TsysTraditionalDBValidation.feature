Feature: Merchant - TSYS Traditional

  Scenario: Create Merchant with TSYS Traditional and Validate in DB
    # ✅ accessToken comes directly from karate-config.js - no callonce needed
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'Traditional' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('Supervisor' + random).substring(0,25)
    * def randomStoreNumber = Math.floor(1000 + Math.random() * 9000)
    * print randomStoreNumber
    * def dbConfig = karate.get('dbConfig')
    # test

    # ══════════════════════════════════════════════════════════════════
    # STEP 1: Create Merchant via API
    # ══════════════════════════════════════════════════════════════════
    Given url baseUrl
    And path '/api/valor/create'
    And param tsystraditional = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
    """
    {
  "legalName": "Valor Store",
  "dbaName": "Valor Store LLC",
  "firstName": "MERCHANT",
  "lastName": "PORTAL",
  "ownerName": "MERCHANT PORTAL",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
  "mobile": "8327287578",
  "legalAddress": "Test Address",
  "legalCity": "CLIFFSIDE PARK",
  "legalState": "NJ",
  "legalCountry": "US",
  "legalZipCode": "07010",
  "role": "10",
  "legalTimezone": "EST",
  "userType": "4",
  "isTxnAllowed": "1",
  "businessType": "Direct Marketing",
  "selectedState": "NJ",
  "processor": "1",
  "programType": "2",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "170 7th Ave S",
      "storeCity": "NEW YORK",
      "storeState": "NY",
      "storeCountry": "US",
      "storeZipCode": "10014",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "valorbaseadmin@protonmail.com",
      "superVisorContact": "2124637932",
      "mccCode": "5993",
      "epiData": [
        {
          "device": 139,
          "deviceType": "Soft Pos",
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
          "processor": "1",
          "processorData": [
            {
              "mid": "",
              "mid1": "887000003191",
              "vNumber": "",
              "vNumber1": "75021670",
              "storeNo": "",
              "storeNo1": "5999",
              "termNo": "",
              "termNo1": "1515",
              "association": "",
              "association1": "949006",
              "chain": "",
              "chain1": "111111",
              "agent": "",
              "agent1": "0001",
              "EbtNo": "",
              "EbtNo1": "",
              "binnumber": "",
              "binnumber1": "999991",
              "agentBank": "",
              "agentBank1": "000001",
              "industry": "",
              "industry1": "Direct Marketing",
              "surchargePercentage": "\"\"",
              "surchargeIndicator": 0,
              "EBTfood": 0,
              "EBTfood1": 0,
              "EBTcash": 0,
              "EBTcash1": 0,
              "label": "MERCHANT PORTAL LOGIN",
              "programType": "surcharge",
              "tid3": "tid001",
              "ClientID": "ClientID001"
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

    * print 'Full response:', response
    * print response.status
    * print response.mpId
    * print response.message
    * print response.code

    # ✅ Validate API response
    * match response.status == true

    # ✅ Capture values directly from response - same scenario, no sharing needed
    * def mpId   = response.mpId
    * def userId = response.newUserId
    * print 'Created mpId:', mpId
    * print 'Created userId:', userId

    # ══════════════════════════════════════════════════════════════════
    # STEP 2: DB Validation - merchant_info table
    # ══════════════════════════════════════════════════════════════════
    * def merchantQuery = "SELECT Mp_Id FROM merchant_info WHERE Mp_Id = " + mpId
    * print 'merchantQuery:', merchantQuery
    * def dbResult1 = call read('classpath:common/db.feature') { query: '#(merchantQuery)' }
    * def merchantRows = karate.toJson(dbResult1.result, true)
    * assert merchantRows.length > 0
    * print 'merchant_info rows found:', merchantRows.length

    # ══════════════════════════════════════════════════════════════════
    # STEP 3: DB Validation - usermaster JOIN merchant_info
    # ══════════════════════════════════════════════════════════════════
    * def joinQuery = "SELECT u.UserId, u.UserName, mi.Mp_Id, mi.dbaName FROM usermaster u JOIN merchant_info mi ON u.UserId = mi.User_Id WHERE u.UserId = '" + userId + "'"
    * print 'joinQuery:', joinQuery
    * def dbResult2 = call read('classpath:common/db.feature') { query: '#(joinQuery)' }
    * def joinRows = karate.toJson(dbResult2.result, true)

    * print 'JOIN raw row:', joinRows[0]
    * assert joinRows.length == 1

    # ══════════════════════════════════════════════════════════════════
    # STEP 4: Extract and match column values
    # ══════════════════════════════════════════════════════════════════
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

    * print 'DB validation passed for UserId:', userId
    * print 'DB validation passed for UserName:', actualUserName

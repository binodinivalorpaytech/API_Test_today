Feature: Merchant - EPX DB Validation Test Case

  Scenario: Create Merchant with EPX  and Validate in DB
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
    And param epx = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
    """
   {
  "legalName": "EPX Store 6a",
  "dbaName": "EPX Store 6a",
  "firstName": "MERCHANT",
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

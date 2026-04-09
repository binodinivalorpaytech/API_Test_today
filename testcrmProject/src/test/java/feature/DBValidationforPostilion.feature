Feature: Merchant - DB Validation for Postilion

  Scenario: Create Merchant with Postilion Traditional and Validate in DB
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
     * def testDataPostilion = read('classpath:data/Postilion.json')
    Given url baseUrl
    And path '/api/valor/create'
    And param postilion = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
    """
  {
  "legalName": "#(testDataPostilion.legalName)",
  "dbaName": "#(testDataPostilion.dbaName)",
  "firstName": "#(testDataPostilion.firstName)",
  "lastName": "#(testDataPostilion.lastName)",
  "ownerName": "#(testDataPostilion.ownerName)",
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

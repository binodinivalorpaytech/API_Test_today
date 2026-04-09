Feature: Payroc DB validation for Merchant on boarding - with valid data set
# ============================================================
# Feature: Payroc DB validation for Merchant on boarding - positive Test Cases
# API   : POST /api/valor/create?Payrocadd=
# Author: QA Automation
# ============================================================

 Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'Worldpayadd' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('Worldpayadd' + random).substring(0, 25)

  # =====================================================================
  # SCENARIO 1: Merchant onboarding with positive dataset - Positive Flow
  # =====================================================================
  Scenario: Create Merchant - Worldpay Surcharge Positive Flow
    * def dataSet = read('classpath:data/Worldpay.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param Worldpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
{
        "legalName": "#(dataSet.legalName)",
        "dbaName": "#(dataSet.dbaName)",
        "firstName": "#(dataSet.firstName)",
        "lastName": "#(dataSet.lastName)",
        "ownerName": "#(dataSet.ownerName)",
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
        "processor": "11",
        "rollUp": "1",
        "programType": "1",
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
                "processor": "11",
                "epiLabel": "VT",
                "features": {
                  "tip": {
                    "enabled": false,
                    "value": [5, 10, 15, 20]
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
                    "midWorldpay": "123456789012",
                    "midWorldpay1": "",
                    "termNoWorldpay": "123",
                    "termNoWorldpay1": "",
                    "bankIdWorldpay": "1234",
                    "bankIdWorldpay1": "",
                    "EBTcash": 0,
                    "EBTcash1": 0,
                    "EBTfood": 0,
                    "EBTfood1": 0,
                    "surchargeIndicator": 0,
                    "surchargePercentage": "3.000",
                    "label": "MERCHANT PORTAL LOGIN",
                    "programType": "surcharge",
                    "c_nameWorldpay3": "1",
                    "tidWorldpay3": "5454",
                    "clientID_Worldpay": "455",
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
    * match response.status == true
    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * print 'storeInfo:', response.storeInfo
    * print 'message: ',response.message
    * print 'mpId:',response.mpId
    * print 'newUserId: ', response.newUserId
    
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
    
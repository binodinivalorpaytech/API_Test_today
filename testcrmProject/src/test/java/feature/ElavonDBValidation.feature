Feature: ElavonPay Merchant on boarding - with valid data set
# ============================================================
# Feature: ElavonPay Merchant Creation - positive Test Cases
# API   : POST /api/valor/create?elavonpayadd=
# Author: QA Automation
# ============================================================

 Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'elavonpayadd' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('ElavonSupervisor' + random).substring(0, 25)

  # =====================================================================
  # SCENARIO 1: Merchant onboarding with positive dataset - Positive Flow
  # =====================================================================
  Scenario: Create Merchant - Elavon Surcharge Positive Flow
    * def dataSet = read('classpath:data/Elovantestdata_p.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param elavonpayadd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
{
  "legalName": "#(dataSet.legalName)",
  "dbaName": "#(dataSet.dbaName)",
  "firstName": "#(dataSet.dbaName)",
  "lastName": "#(dataSet.dbaName)",
  "ownerName": "MERCHANT PORTAL",
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
  "processor": "12",
  "rollUp": "1",
  "programType": "2",
  "storeData": [
    {
      "storeName": "#(dataSet.storeName)",
      "storeAddress": "#(dataSet.storeAddress)",
      "storeCity": "#(dataSet.storeCity)",
      "storeState": "#(dataSet.storeState)",
      "storeCountry": "#(dataSet.storeCountry)",
      "storeZipCode": "#(dataSet.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "3377040344",
      "mccCode": "5812",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "12",
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
              "midElavonpay": "#(dataSet.midElavonpay)",
              "midElavonpay1": "#(dataSet.midElavonpay1)",
              "termNoElavonpay": "123",
              "termNoElavonpay1": "123",
              "bankIdElavonpay": "123456",
              "bankIdElavonpay1": "123456",
              "EBTcash": "0",
              "EBTfood": "0",
              "surchargeIndicator": "0",
              "label": "MERCHANT PORTAL LOGIN",
              "programType": "surcharge"
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
    
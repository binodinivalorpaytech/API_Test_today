Feature: Merchant Validation in DB

  Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'FDSurcharge' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('Supervisor' + random).substring(0, 25)
    * def dbConfig = karate.get('dbConfig')
    # test

  Scenario: Create Merchant and Validate in DB

    # ── Load test data ──────────────────────────────────────────────────────────
    * def setData = read('classpath:traditional/FDpositive-payload.json')

    # ── DEBUG: Print payload values ─────────────────────────────────────────────
    * print '=== PAYLOAD VALUES FROM JSON ==='
    * print 'legalName    :', setData.legalName
    * print 'midFD        :', setData.midFD
    * print 'termNoFD     :', setData.termNoFD
    * print 'groupId      :', setData.groupId
    * print 'legalZipCode :', setData.legalZipCode
    * print 'storeZipCode :', setData.storeZipCode

    # ── Step 1: Create Merchant via API ─────────────────────────────────────────
    Given url baseUrl
    And path '/api/valor/create'
    And param surchargefd = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
    """
{
  "legalName": "#(setData.legalName)",
  "dbaName": "#(setData.dbaName)",
  "firstName": "#(setData.firstName)",
  "lastName": "#(setData.lastName)",
  "ownerName": "#(setData.ownerName)",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
  "mobile": "#(setData.mobile)",
  "legalAddress": "#(setData.legalAddress)",
  "legalCity": "#(setData.legalCity)",
  "legalState": "#(setData.legalState)",
  "legalCountry": "#(setData.legalCountry)",
  "legalZipCode": "#(setData.legalZipCode)",
  "role": "10",
  "legalTimezone": "EST",
  "userType": "4",
  "isTxnAllowed": "1",
  "businessType": "#(setData.businessType)",
  "selectedState": "#(setData.selectedState)",
  "processor": "2",
  "programType": "2",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "#(setData.storeAddress)",
      "storeCity": "#(setData.storeCity)",
      "storeState": "#(setData.storeState)",
      "storeCountry": "#(setData.storeCountry)",
      "storeZipCode": "#(setData.storeZipCode)",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "#(setData.superVisorEmail)",
      "superVisorContact": "#(setData.superVisorContact)",
      "mccCode": "#(setData.mccCode)",
      "epiData": [
        {
          "device": "#(setData.device)",
          "deviceType": "#(setData.deviceType)",
          "processor": "2",
          "epiLabel": "#(setData.epiLabel)",
          "features": {
            "tip": {
              "enabled": false,
              "value": [5, 10, 15, 20]
            },
            "surcharge": {
              "enabled": true,
              "value": "#(setData.surchargePercentage)"
            },
            "tax": {
              "enabled": false,
              "value": "0"
            }
          },
          "processorData": [
            {
              "surchargePercentage": "#(setData.surchargePercentage)",
              "groupId": "",
              "groupId1": "#(setData.groupId)",
              "midFD": "",
              "midFD1": "#(setData.midFD)",
              "termNoFD": "",
              "termNoFD1": "#(setData.termNoFD)",
              "EbtNoFD": "",
              "EbtNoFD1": "12345",
              "website": "",
              "website1": "https://vpuat.binskit.com",
              "mid3": "",
              "termNo3": "1234",
              "location_id": "",
              "client_key": "",
              "c_name": "",
              "label": "#(setData.label)",
              "EBTfood": 0,
              "EBTfood1": 0,
              "EBTcash": 0,
              "EBTcash1": 0,
              "surchargeIndicator": 0,
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

    # ── DEBUG: Print full API response ──────────────────────────────────────────
    * print '=== FULL API RESPONSE ==='
    * print response
    * print 'response.status  :', response.status
    * print 'response.message :', response.message
    * print 'response.code    :', response.code
    * print 'response.mpId    :', response.mpId

    
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
    
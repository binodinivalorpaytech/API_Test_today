Feature: Merchant - Add Merchant for FD Cardnet feature
 Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'Surcharge' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('Supervisor' + random).substring(0,25)
    
  # =====================================================================
  # SCENARIO 1: Add Merchant for FD Cardnet  - Positive Flow
  # =====================================================================
  Scenario: Create Merchant - Add Merchant for FD Cardnet 
    * def testBuypassData = read('classpath:data/FDbypass.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param FDcardnet = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
"""
   {
        "legalName": "#(testBuypassData.legalName)",
        "dbaName": "#(testBuypassData.dbaName)",
        "firstName": "#(testBuypassData.firstName)",
        "lastName": "#(testBuypassData.lastName)",
        "emailId": "#(dynamicEmail)",
        "userName": "#(dynamicUser)",
        "mobile": "#(testBuypassData.mobile)",
        "legalAddress": "#(testBuypassData.legalAddress)",
        "legalCity": "#(testBuypassData.legalCity)",
        "legalState": "NY",
        "legalCountry": "US",
        "legalZipCode": "#(testBuypassData.legalZipCode)",
        "legalTimezone": "EST",
        "role": "10",
        "userType": "4",
        "isTxnAllowed": "1",
        "selectedState": "NY",
        "programType": "1",
        "processor": "4",
        "rollUp": "0",
        "storeData": [
          {
            "storeName": "#('Store ' + random)",
            "storeAddress": "20987 N John Wayne Pkwy",
            "storeCity": "MARICOPA",
            "storeState": "AZ",
            "storeCountry": "US",
            "storeZipCode": "85138",
            "storeTimezone": "EST",
            "superVisorName": "#(shortSuperName)",
            "superVisorEmail": "office@valorpaytech.com",
            "superVisorContact": "5208396263",
            "mccCode": "1761",
            "epiData": [
              {
                "device": "139",
                "deviceType": "Soft POS",
                "processor": "4",
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
                "selectedState": "NY",
                "processorData": [
                  {
                    "midFDBuy": "#(testBuypassData.midFDBuy)",
                    "midFDBuy1": "",
                    "groupIdFDBuy": "#(testBuypassData.groupIdFDBuy)",
                    "groupIdFDBuy1": "",
                    "termNoFDBuy": "#(testBuypassData.termNoFDBuy)",
                    "termNoFDBuy1": "",
                    "websiteFDBuy": "#(testBuypassData.websiteFDBuy)",
                    "websiteFDBuy1": "",
                    "EBTcash": "0",
                    "EBTfood": "0",
                    "EBTfood1": "0",
                    "EBTcash1": "0",
                    "surchargeIndicator": "0",
                    "surchargePercentage": "#(testBuypassData.surchargePercentage)",
                    "EbtNoFDBuy": "0",
                    "EbtNoFDBuy1": "0",
                    "label": "#(testBuypassData.label)",
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

    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * match response.status == true
    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * print 'storeInfo:', response.storeInfo
    
   # ✅ Save mpId globally for use in downstream scenarios
   * karate.set('sharedMpId', response.mpId)
    * print 'sharedMpId saved:', karate.get('sharedMpId')
 #-------------------------------------------------------------------------------
 
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

  #---- Use karate.jsonPath with confirmed exact column names from the DB------
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
    
 
    
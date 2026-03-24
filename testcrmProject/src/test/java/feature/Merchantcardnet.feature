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
    * def testCardNetData = read('classpath:data/FDCardnet.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param FDcardnet = true
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
"""
    {
  "legalName": "#(testCardNetData.legalName)",
  "dbaName": "#(testCardNetData.dbaName)",
  "firstName": "#(testCardNetData.firstName)",
  "lastName": "#(testCardNetData.lastName)",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
  "mobile": "#(testCardNetData.mobile)",
  "legalAddress": "#(testCardNetData.legalAddress)",
  "legalCity": "#(testCardNetData.legalCity)",
  "legalState": "NY",
  "legalCountry": "US",
  "legalZipCode": "#(testCardNetData.legalZipCode)",
  "legalTimezone": "EST",
  "role": "10",
  "userType": "4",
  "isTxnAllowed": "1",
  "selectedState": "NY",
  "programType": "1",
  "processor": "3",
  "rollUp": "0",
  "storeData": [
    {
      "storeName": "#('Store ' + random)",
      "storeAddress": "20987 N John Wayne Pkwy",
      "storeCity": "MARICOPA",
      "storeState": "AZ",
      "storeCountry": "US",
      "storeZipCode": "50001",
      "storeTimezone": "EST",
      "superVisorName": "#(shortSuperName)",
      "superVisorEmail": "office@valorpaytech.com",
      "superVisorContact": "5208396263",
      "mccCode": "1761",
      "epiData": [
        {
          "device": "139",
          "deviceType": "Soft POS",
          "processor": "3",
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
              "midFDCard": "RCTST0000057474",
              "midFDCard1": "",
              "groupIdFDCard": "30001",
              "groupIdFDCard1": "",
              "termNoFDCard": "11111111",
              "termNoFDCard1": "",
              "websiteFDCard": "www.test.com",
              "websiteFDCard1": "",
              "EBTcash": "0",
              "EBTcash1": "0",
              "EBTfood": "0",
              "EBTfood1": "0",
              "EbtNoFDCard": "",
              "EbtNoFDCard1": "",
              "surchargeIndicator": "0",
              "surchargePercentage": "",
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

    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * match response.status == true
    
     # ✅ Save mpId globally for use in downstream scenarios
    * karate.set('sharedMpId', response.mpId)
    * print 'sharedMpId saved:', karate.get('sharedMpId')

  # =====================================================================
  # SCENARIO 2: Create Merchant - Negative Flow (400 Bad Request)
  # =====================================================================
  Scenario: Create Merchant - Cardnet Surcharge Negative Flow (400 Bad Request)
    * def testData = read('classpath:data/negative-payload.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param FDcardnet = false
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName": "#(testCardNetData.legalName)",
        "dbaName": "#(testCardNetData.dbaName)",
        "firstName": "#(testCardNetData.firstName)",
        "lastName": "PORTAL",
        "ownerName": "MERCHANT PORTAL",
        "emailId": "#(dynamicEmail)",
        "userName": "#(dynamicUser)",
        "legalZipCode": "#(testCardNetData.legalZipCode)"
      }
      """
    When method post
    Then status 400

    * print 'Negative flow response:', response
    * print response.status
    * print response.message

  # =====================================================================
  # SCENARIO 3: Create Merchant with Invalid Endpoint - Negative Flow (404)
  # =====================================================================
  Scenario: Create Merchant - Cardnet Surcharge Negative Flow (404 Invalid Endpoint)
    * def testData = read('classpath:data/negative-payload.json')

    Given url baseUrl
    And path '/api/valor/create1'
    And param FDcardnet = false
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName": "#(testCardNetData.legalName)",
        "dbaName": "#(testCardNetData.dbaName)",
        "firstName": "#(testCardNetData.firstName)",
        "lastName": "PORTAL",
        "ownerName": "MERCHANT PORTAL",
        "emailId": "#(dynamicEmail)",
        "userName": "#(dynamicUser)",
        "legalZipCode": "#(testCardNetData.legalZipCode)"
      }
      """
    When method post
    Then status 404

    * print 'Negative flow response:', response
    * print response.status
    * print response.message

  # =====================================================================
  # SCENARIO 4: Create Merchant without Valid Access Token (401 Unauthorized)
  # =====================================================================
  Scenario: Create Merchant - Cardnet Surcharge Negative Flow (401 Unauthorized)
    * def testData = read('classpath:data/negative-payload.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param FDcardnet = false
    And header Authorization = 'Bearer INVALID_' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName": "#(testCardNetData.legalName)",
        "dbaName": "#(testCardNetData.dbaName)",
        "firstName": "#(testCardNetData.firstName)",
        "lastName": "PORTAL",
        "ownerName": "MERCHANT PORTAL",
        "emailId": "#(dynamicEmail)",
        "userName": "#(dynamicUser)",
        "legalZipCode": "#(testCardNetData.legalZipCode)"
      }
      """
    When method post
    Then status 401

    * print 'Negative flow response:', response
    * print response.status
    * print response.message

  # ====================================================================================
  # SCENARIO 5: Create Merchant with Invalid Dataset - Gateway Error Flow (502 or 504)
  # Uses karate.http() directly inside JS — NO helper feature file required.
  # Retries up to 3 times with a 3s delay. Test PASSES if 502 or 504 is received.
  # ====================================================================================
  Scenario: Create Merchant - Gateway Error Flow (502 or 504)
    * def testData = read('classpath:data/positive-payload.json')

    * def maxRetries  = 3
    * def retryDelay  = 3000
    * def finalStatus = 0
    * def finalResponse = null
    

    # ── Pre-resolve all testData fields into plain JS variables BEFORE the function ──
    # Inside a JS function, #(expression) syntax is NOT valid.
    # Pull every value out here so the function can reference them as plain vars.
    * def legalName          = testData.legalName
    * def dbaName            = testData.dbaName
    * def firstName          = testData.firstName
    * def mobile             = testData.mobile
    * def legalZipCode       = testData.legalZipCode
    * def surchargeEnabled   = testData.surchargeEnabled
    * def surchargePercent   = testData.surchargePercentage

    * def attemptRequest =
      """
      function() {
        var requestBody = {
          legalName:     legalName,
          dbaName:       dbaName,
          firstName:     firstName,
          lastName:      'PORTAL',
          ownerName:     'MERCHANT PORTAL',
          emailId:       dynamicEmail,
          userName:      dynamicUser,
          mobile:        mobile,
          legalAddress:  'Test Address',
          legalCity:     'CLIFFSIDE PARK',
          legalState:    'NJ',
          legalCountry:  'US',
          legalZipCode:  legalZipCode,
          role:          '10',
          legalTimezone: 'EST',
          userType:      '4',
          isTxnAllowed:  '1',
          businessType:  'Direct Marketing',
          selectedState: 'N33434J',
          processor:     '1',
          programType:   '1',
          rollUp:        '0',
          storeData: [{
            storeName:         'Store ' + random,
            storeAddress:      '4100 JOHNSTON ST',
            storeCity:         'LAFAYETTE',
            storeState:        'LA',
            storeCountry:      'US',
            storeZipCode:      '70503',
            storeTimezone:     'EST',
            superVisorName:    shortSuperName,
            superVisorEmail:   'office@valorpaytech.com',
            superVisorContact: '3377040344',
            mccCode:           '5812',
            epiData: [{
              device:        '139',
              deviceType:    'Soft POS',
              processor:     '1',
              epiLabel:      'VT',
              features: {
                tip:       { enabled: false, value: [5, 10, 15, 20] },
                surcharge: { enabled: surchargeEnabled, value: surchargePercent },
                tax:       { enabled: false, value: '0' }
              },
              selectedState: 'NJ',
              processorData: null
            }]
          }]
        };

        for (var attempt = 1; attempt <= maxRetries; attempt++) {
          karate.log('[Scenario 5] Attempt ' + attempt + ' of ' + maxRetries);

          var http = karate.http(baseUrl + '/api/valor/create');
          http.param('surchargetsys', 'true');
          http.header('Authorization', 'Bearer ' + accessToken);
          http.header('Content-Type', 'application/json');
          var res = http.post(requestBody);

          var status = res.status;
          finalResponse = res.body;
          karate.log('[Scenario 5] Response status: ' + status);

          if (status === 502 || status === 504) {
            karate.log('[Scenario 5] Gateway error ' + status + ' on attempt ' + attempt);
            finalStatus = status;
            if (attempt < maxRetries) {
              karate.log('[Scenario 5] Waiting ' + retryDelay + 'ms before retry...');
              java.lang.Thread.sleep(retryDelay);
            }
          } else {
            karate.log('[Scenario 5] Non-gateway status ' + status + ' — stopping retries.');
            finalStatus = status;
            return finalStatus;
          }
        }

        karate.log('[Scenario 5] All ' + maxRetries + ' attempts done. Final status: ' + finalStatus);
        return finalStatus;
      }
      """

    * def result = attemptRequest()
    * print '[Scenario 5] Final status after retries:', result
    * print '[Scenario 5] Final response body:', finalResponse

    # ✅ Test PASSES for both 502 and 504
    * assert result == 502 || result == 504
     
Feature: Merchant - Add Merchant for FD Buypass feature

  Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'Surcharge' + random
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('Supervisor' + random).substring(0, 25)

  # =====================================================================
  # SCENARIO 1: Add Merchant for FD Buypass - Positive Flow
  # =====================================================================
  Scenario: Create Merchant - Add Merchant for FD Buypass
    * def testBuypassData = read('classpath:data/FDbypass.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param FDbypass = ''
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

    # ✅ Save mpId globally for use in downstream scenarios
    * karate.set('sharedMpId', response.mpId)
    * print 'sharedMpId saved:', karate.get('sharedMpId')

  # =====================================================================
  # SCENARIO 2: Create Merchant - Negative Flow (400 Bad Request)
  # =====================================================================
  Scenario: Create Merchant - FD Buypass Negative Flow (400 Bad Request)
    * def testData4xx = read('classpath:data/FDbypassNegative.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param FDbypass = ''
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName": "#(testData4xx.legalName)",
        "dbaName": "#(testData4xx.dbaName)",
        "firstName": "#(testData4xx.firstName)",
        "lastName": "PORTAL",
        "ownerName": "MERCHANT PORTAL",
        "emailId": "#(dynamicEmail)",
        "userName": "#(dynamicUser)",
        "legalZipCode": "#(testData4xx.legalZipCode)"
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
  Scenario: Create Merchant - FD Buypass Negative Flow (404 Invalid Endpoint)
    * def testData4xx = read('classpath:data/FDbypassNegative.json')

    Given url baseUrl
    And path '/api/valor/create1'
    And param FDbypass = ''
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName": "#(testData4xx.legalName)",
        "dbaName": "#(testData4xx.dbaName)",
        "firstName": "#(testData4xx.firstName)",
        "lastName": "PORTAL",
        "ownerName": "MERCHANT PORTAL",
        "emailId": "#(dynamicEmail)",
        "userName": "#(dynamicUser)",
        "legalZipCode": "#(testData4xx.legalZipCode)"
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
  Scenario: Create Merchant - FD Buypass Negative Flow (401 Unauthorized)
    * def testDataB = read('classpath:data/FDbypassNegative.json')

    Given url baseUrl
    And path '/api/valor/create'
    And param FDbypass = ''
    And header Authorization = 'Bearer INVALID_' + accessToken
    And header Content-Type = 'application/json'
    And request
      """
      {
        "legalName": "#(testDataB.legalName)",
        "dbaName": "#(testDataB.dbaName)",
        "firstName": "#(testDataB.firstName)",
        "lastName": "PORTAL",
        "ownerName": "MERCHANT PORTAL",
        "emailId": "#(dynamicEmail)",
        "userName": "#(dynamicUser)",
        "legalZipCode": "#(testDataB.legalZipCode)"
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
  Scenario: Create Merchant - FD Buypass Gateway Error Flow (502 or 504)
    * def testDataC = read('classpath:data/FDbypass.json')

    * def maxRetries       = 3
    * def retryDelay       = 3000
    * def finalStatus      = 0
    * def finalResponse    = null

    # Pre-resolve all testData fields into plain JS variables BEFORE the function.
    # Inside a JS function, #(expression) syntax is NOT valid.
    * def legalName           = testDataC.legalName
    * def dbaName             = testDataC.dbaName
    * def firstName           = testDataC.firstName
    * def mobile              = testDataC.mobile
    * def legalZipCode        = testDataC.legalZipCode
    * def surchargePercentage = testDataC.surchargePercentage

    * def attemptRequest =
      """
      function() {
        var requestBody = {
          legalName:     legalName,
          dbaName:       dbaName,
          firstName:     firstName,
          lastName:      'EPX Store 6a',
          emailId:       dynamicEmail,
          userName:      dynamicUser,
          mobile:        mobile,
          legalAddress:  'Test Address',
          legalCity:     'CLIFFSIDE PARK',
          legalState:    'NY',
          legalCountry:  'US',
          legalZipCode:  legalZipCode,
          legalTimezone: 'EST',
          role:          '10',
          userType:      '4',
          isTxnAllowed:  '1',
          selectedState: 'NY_INVALID_99999',
          processor:     '4',
          programType:   '1',
          rollUp:        '0',
          storeData: [{
            storeName:         'Store ' + random,
            storeAddress:      '20987 N John Wayne Pkwy',
            storeCity:         'MARICOPA',
            storeState:        'AZ',
            storeCountry:      'US',
            storeZipCode:      '85138',
            storeTimezone:     'EST',
            superVisorName:    shortSuperName,
            superVisorEmail:   'office@valorpaytech.com',
            superVisorContact: '5208396263',
            mccCode:           '1761',
            epiData: [{
              device:        '139',
              deviceType:    'Soft POS',
              processor:     '4',
              epiLabel:      'VT',
              features: {
                tip:       { enabled: false, value: [5, 10, 15, 20] },
                surcharge: { enabled: false, value: surchargePercentage },
                tax:       { enabled: false, value: '0' }
              },
              selectedState: 'NY',
              processorData: null
            }]
          }]
        };

        for (var attempt = 1; attempt <= maxRetries; attempt++) {
          karate.log('[Scenario 5] Attempt ' + attempt + ' of ' + maxRetries);

          var http = karate.http(baseUrl + '/api/valor/create');
          http.param('FDbypass', '');
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

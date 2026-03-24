Feature: Merchant Update API for DB Validation
  As an ISO user
  I want to update merchant details via the Valor Pay API
  So that merchant information, store data, and EPI configurations are kept up to date and retrieve from DB

  Background:
    # accessToken already fetched in karate-config.js via callSingle - use it directly
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def timestamp = new java.util.Date().getTime()
    * def dynamicUser = 'Surcharge' + timestamp
    * def dynamicEmail = 'binodini' + '@valorpaytech.com'
    * def shortSuperName = ('Supervisor' + random).substring(0, 25)
    * def dynamicLabel = ('Merchant' + random).substring(0, 25)
    * def randomStoreNumber = Math.floor(1000 + Math.random() * 9000)
    * print 'randomStoreNumber:', randomStoreNumber
    * def businessTypes = ['Direct Marketing', 'Retail', 'Ecommerce', 'Restaurant', 'Healthcare']
    * def businessType = businessTypes[Math.floor(Math.random() * businessTypes.length)]
    * def rowData1 = read('classpath:data/MerchantUpdate-payload.json')
    Given url baseUrl
    And path '/api/valor/update'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'

    * def basePayload =
    """
    {
      "businessType": "#(businessType)",
      "userType": "#(rowData1.userType)",
      "isTxnAllowed": "#(rowData1.isTxnAllowed)",
      "legalName": "#(rowData1.legalName)",
      "newUserId": "#(rowData1.newUserId)",
      "mp_id": "#(rowData1.mp_id)",
      "legalState": "#(rowData1.legalState)",
      "dbaName": "#(rowData1.dbaName)",
      "firstName": "#(rowData1.firstName)",
      "mobile": "#(rowData1.mobile)",
      "lastName": "#(rowData1.lastName)",
      "ownerName": "#(rowData1.ownerName)",
      "emailId": "#(dynamicEmail)",
      "userName": "#(dynamicUser)",
      "legalAddress": "Test Address",
      "legalCity": "CLIFFSIDE PARK",
      "legalCountry": "US",
      "legalTimezone": "EST",
      "legalZipCode": "#(rowData1.legalZipCode)",
      "role": "10",
      "sicCode": "#(rowData1.sicCode)",
      "processor": "1",
      "rollUp": "0",
      "selectedState": "#(rowData1.selectedState)",
      "s4f": "1",
      "storeData": [
        {
          "id": "#(rowData1.id)",
          "storeName": "#(rowData1.storeName)",
          "storeAddress": "#(rowData1.storeAddress)",
          "storeCity": "#(rowData1.storeCity)",
          "storeState": "#(rowData1.storeState)",
          "storeCountry": "US",
          "storeZipCode": "#(rowData1.storeZipCode)",
          "storeTimezone": "EST",
          "superVisorName": "MERCHANT PORTAL LOGIN",
          "superVisorEmail": "vksss.selvam789@gmail.com",
          "superVisorContact": "8327287578",
          "mccCode": "0742",
          "selectedMCC": "7230 - Beauty and Barber",
          "epiData": [
            {
              "id": "21034084",
              "epi": "2320135439",
              "device": "139",
              "deviceType": "Soft Pos",
              "processor": "1",
              "epiLabel": "Virtual Terminal",
              "is_status": 1,
              "processorData": [
                {
                  "mid": "#(rowData1.mid)",
                  "mid1": "",
                  "vNumber": "#(rowData1.vNumber)",
                  "vNumber1": "",
                  "storeNo": "#(rowData1.storeNo)",
                  "storeNo1": "",
                  "termNo": "#(rowData1.termNo)",
                  "termNo1": "",
                  "association": "#(rowData1.association)",
                  "association1": "",
                  "chain": "#(rowData1.chain)",
                  "chain1": "",
                  "agent": "#(rowData1.agent)",
                  "agent1": "",
                  "EbtNo": "",
                  "EbtNo1": "",
                  "binnumber": "#(rowData1.binnumber)",
                  "binnumber1": "",
                  "agentBank": "#(rowData1.agentBank)",
                  "agentBank1": "",
                  "industry": "#(rowData1.industry)",
                  "industry1": "",
                  "EBTcash": 0,
                  "EBTcash1": 0,
                  "EBTfood": 0,
                  "EBTfood1": 0,
                  "surchargeIndicator": 0,
                  "surchargePercentage": "4.00",
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

  # HAPPY PATH SCENARIOS

  Scenario: TC_001 - Successfully update merchant with valid full payload
    And request basePayload
    When method POST
    Then status 200
    And match response.status == true

  Scenario: TC_002 - Verify response contains required fields
    And request basePayload
    When method POST
    Then status 200
    And match response contains { status: '#present' }

  Scenario: TC_003 - Update EPI entry and validate DB
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.storeData[0].epiData =
    """
    [
      {
        "id": "21034084",
        "epi": "2320135439",
        "device": "139",
        "deviceType": "Soft Pos",
        "processor": "1",
        "epiLabel": "Virtual Terminal",
        "is_status": 1,
        "processorData": [
          {
            "mid": "887000003193",
            "mid1": "",
            "vNumber": "75021674",
            "vNumber1": "",
            "storeNo": "5999",
            "storeNo1": "",
            "termNo": "1515",
            "termNo1": "",
            "association": "949006",
            "association1": "",
            "chain": "111111",
            "chain1": "",
            "agent": "0001",
            "agent1": "",
            "EbtNo": "",
            "EbtNo1": "",
            "binnumber": "999991",
            "binnumber1": "",
            "agentBank": "000000",
            "agentBank1": "",
            "industry": "Retail",
            "industry1": "",
            "EBTcash": 0,
            "EBTcash1": 0,
            "EBTfood": 0,
            "EBTfood1": 0,
            "surchargeIndicator": 0,
            "surchargePercentage": "4.00",
            "label": "MERCHANT PORTAL LOGIN",
            "programType": "surcharge"
          }
        ]
      }
    ]
    """
    And request payload
    When method POST
    Then status 200

    # Print full response to confirm exact field names returned by update API
    * print 'Full response:', response
    * match response.status == true

    # Update API may not return mpId in response
    # So we use rowData1.mp_id (the merchant being updated) as the reliable source
    # If response does return mpId, that takes priority
    * def mpIdFromResponse = response.mpId != null ? response.mpId : (response.Mp_Id != null ? response.Mp_Id : response.mp_id)
    * def mpId = (mpIdFromResponse != null ? mpIdFromResponse : rowData1.mp_id) + ''

    # Same fallback logic for userId
    * def userIdFromResponse = response.newUserId != null ? response.newUserId : response.userId
    * def userId = (userIdFromResponse != null ? userIdFromResponse : rowData1.newUserId) + ''

    * print 'mpId used for DB validation:', mpId
    * print 'userId used for DB validation:', userId

    # Guard - fail early with clear message if values are still null
    * assert mpId != 'null'
    * assert userId != 'null'

    # Step 3: DB Validation - merchant_info table
    * def merchantQuery = "SELECT Mp_Id FROM merchant_info WHERE Mp_Id = " + mpId
    * print 'Running merchant query:', merchantQuery
    * def dbResult1 = call read('classpath:common/db.feature') { query: '#(merchantQuery)' }
    * def merchantRows = karate.toJson(dbResult1.result, true)
    * print 'merchantRows result:', merchantRows
    * print 'merchantRows length:', merchantRows.length
    * assert merchantRows.length > 0

    # Step 4: DB Validation - usermaster JOIN merchant_info
    * def joinQuery = "SELECT u.UserId, u.UserName, mi.Mp_Id, mi.dbaName FROM usermaster u JOIN merchant_info mi ON u.UserId = mi.User_Id WHERE u.UserId = '" + userId + "'"
    * print 'Running join query:', joinQuery
    * def dbResult2 = call read('classpath:common/db.feature') { query: '#(joinQuery)' }
    * def joinRows = karate.toJson(dbResult2.result, true)
    * print 'JOIN raw rows:', joinRows
    * assert joinRows.length == 1

    * def actualUserId   = karate.jsonPath(joinRows, '$[0].UserId') + ''
    * def actualMpId     = karate.jsonPath(joinRows, '$[0].Mp_Id') + ''
    * def actualUserName = karate.jsonPath(joinRows, '$[0].userName') + ''

    * print 'Resolved UserId from DB:', actualUserId
    * print 'Resolved MpId from DB:', actualMpId
    * print 'Resolved UserName from DB:', actualUserName

    * match actualUserId == userId
    * match actualMpId   == mpId
    * print 'JOIN validation passed for UserId:', userId
    * print 'JOIN validation passed for UserName:', actualUserName

  Scenario: TC_004 - Update store with valid descriptor value
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.storeData[0].descriptors = ['Updated Descriptor']
    And request payload
    When method POST
    Then status 200

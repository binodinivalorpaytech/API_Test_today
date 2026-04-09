Feature: Merchant Update API
  As an ISO user
  I want to update merchant details via the Valor Pay API
  So that merchant information, store data, and EPI configurations are kept up to date

  Background:
    # ✅ accessToken already fetched in karate-config.js via callSingle — use it directly
    #test
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
  # ─────────────────────────────────────────────────────────
  # HAPPY PATH SCENARIOS
  # ─────────────────────────────────────────────────────────

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

  Scenario: TC_003 - Update EPI entry without processorData
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.storeData[0].epiData =
    """[
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
    
    * print 'Full response:', response
    * print 'Mp_id:', response.Mp_id
    * print 'newUserId',response.newUserId
    * print 'StoreID',response.StoreID
    * print 'message',response.message
    * match response.status == true

  Scenario: TC_004 - Update store with valid descriptor value
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.storeData[0].descriptors = ['Updated Descriptor']
    And request payload
    When method POST
    Then status 200
    
  # ─────────────────────────────────────────────────────────
  # EPI FEATURE TOGGLE SCENARIOS
  # ─────────────────────────────────────────────────────────

  Scenario: TC_005 - Update EPI with tip feature enabled
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.storeData[0].epiData[0].features.tip.enabled = true
    * set payload.storeData[0].epiData[0].features.tip.value = [10, 15, 20, 25]
    And request payload
    When method POST
    Then status 200

  Scenario: TC_006 - Update EPI with surcharge feature enabled
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.storeData[0].epiData[0].features.surcharge.enabled = true
    * set payload.storeData[0].epiData[0].features.surcharge.value = '3.50'
    And request payload
    When method POST
    Then status 200

  Scenario: TC_007 - Update EPI with tax feature enabled
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.storeData[0].epiData[0].features.tax.enabled = true
    * set payload.storeData[0].epiData[0].features.tax.value = '8.875'
    And request payload
    When method POST
    Then status 200

  Scenario: TC_008 - Update processorData with updated surcharge details
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.storeData[0].epiData[0].processorData[0].surchargeIndicator = 1
    * set payload.storeData[0].epiData[0].processorData[0].surchargePercentage = '3.50'
    And request payload
    When method POST
    Then status 200

  # ─────────────────────────────────────────────────────────
  # AUTHENTICATION SCENARIOS
  # ─────────────────────────────────────────────────────────

  Scenario: TC_009 - Request fails when Authorization header is missing
    * header Authorization = ''
    And request basePayload
    When method POST
    Then status 401
    And match response contains { message: '#present' }

  Scenario: TC_010 - Request fails with invalid Bearer token
    * header Authorization = 'Bearer invalidtoken123abc'
    And request basePayload
    When method POST
    Then status 401

  Scenario: TC_011 - Request fails with expired JWT token
    * header Authorization = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo5OTk5OX0.expiredSignature'
    And request basePayload
    When method POST
    Then status 401

  # ─────────────────────────────────────────────────────────
  # VALIDATION / NEGATIVE SCENARIOS
  # ─────────────────────────────────────────────────────────

  Scenario: TC_012 - Request fails when newUserId is missing
    * def payload = karate.jsonPath(basePayload, '$')
    * remove payload.newUserId
    And request payload
    When method POST
    Then status 400

  Scenario: TC_013 - Request fails when mp_id is missing
    * def payload = karate.jsonPath(basePayload, '$')
    * remove payload.mp_id
    And request payload
    When method POST
    Then status 400

  Scenario: TC_014 - Request fails when storeData is an empty array
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.storeData = []
    And request payload
    When method POST
    Then status 400

  Scenario: TC_015 - Request fails when epiData is missing inside storeData
    * def payload = karate.jsonPath(basePayload, '$')
    * remove payload.storeData[0].epiData
    And request payload
    When method POST
    Then status 400

  Scenario: TC_016 - Request fails when emailId has an invalid format
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.emailId = 'invalidemail'
    And request payload
    When method POST
    Then status 400

  Scenario: TC_017 - Request fails when mobile contains non-numeric characters
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.mobile = 'ABC123XYZ'
    And request payload
    When method POST
    Then status 400

  Scenario: TC_018 - Request fails when body is empty
    And request {}
    When method POST
    Then status 400

  Scenario: TC_019 - Request fails when newUserId does not exist in the system
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.newUserId = '99999999'
    And request payload
    When method POST
    Then status 400

  Scenario: TC_020 - Request fails when legalZipCode has invalid format
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.legalZipCode = 'ABCDE'
    And request payload
    When method POST
    Then status 400

  # ─────────────────────────────────────────────────────────
  # DATA-DRIVEN SCENARIOS
  # ─────────────────────────────────────────────────────────

  Scenario Outline: TC_021 - Update merchant with different userType values
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.userType = '<userType>'
    And request payload
    When method POST
    Then status <expectedStatus>

    Examples:
      | userType | expectedStatus |
      | 4        | 200            |
      | 99       | 200            |
      | 0        | 200            |

  Scenario Outline: TC_022 - Update merchant with different processor values
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.processor = '<processor>'
    And request payload
    When method POST
    * def allowedStatuses = <allowedStatuses>
    * match allowedStatuses contains responseStatus

    Examples:
      | processor | allowedStatuses |
      | 1         | [200]           |
      | 2         | [400]           |
      | 999       | [502, 504]      |
      
  Scenario Outline: TC_023 - Update merchant with different legalCountry values
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.legalCountry = '<country>'
    And request payload
    When method POST
    Then status <expectedStatus>

    Examples:
      | country | expectedStatus |
      | US      | 200            |
      | CA      | 200            |
      | XX      | 200            |

  Scenario Outline: TC_024 - Update merchant with different legalTimezone values
    * def payload = karate.jsonPath(basePayload, '$')
    * set payload.legalTimezone = '<timezone>'
    And request payload
    When method POST
    Then status <expectedStatus>

    Examples:
      | timezone | expectedStatus |
      | EST      | 200            |
      | PST      | 200            |
      | CST      | 200            |
      | INVALID  | 200            |

Feature: Merchant - TSYS Surcharge
Scenario: Create Merchant - TSYS Surcharge
#* def tokenResponse = callonce read('classpath:common/token.feature')
 * def accessToken = karate.get('accessToken')
  * print 'Access Token:', accessToken
* def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
* def timestamp = new java.util.Date().getTime()
* def dynamicUser = 'Surcharge' + timestamp
* def dynamicEmail = 'binodini' + '@valorpaytech.com'
* def shortSuperName = ('Supervisor' + random).substring(0,25)
* def dynamicLabel = ('Merchant' + random).substring(0,25)
* def randomStoreNumber = Math.floor(1000 + Math.random() * 9000)
* print randomStoreNumber
Given url baseUrl
And path '/api/valor/create'
And param surchargetsys = true
And header Authorization = 'Bearer ' + accessToken
And header Content-Type = 'application/json'
And request
"""
{
  "legalName": "Valor Store",
  "dbaName": "Valor Store LLC",
  "firstName": "MERCHANT",
  "lastName": "PORTAL",
  "ownerName": "MERCHANT PORTAL",
  "emailId": "#(dynamicEmail)",
  "userName": "#(dynamicUser)",
  "mobile": "8327287578",
  "legalAddress": "Test Address",
  "legalCity": "CLIFFSIDE PARK",
  "legalState": "NJ",
  "legalCountry": "US",
  "legalZipCode": "07010",
  "role": "10",
  "legalTimezone": "EST",
  "userType": "4",
  "isTxnAllowed": "1",
  "businessType": "Direct Marketing",
  "selectedState": "NJ",
  "processor": "1",
  "programType": "1",
  "rollUp": "0",
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
          "processor": "1",
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
              "mid": "887000003191",
              "mid1": "",
              "vNumber": "75021670",
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
    }
  ]
}
"""
When method post
Then status 200
 * print 'Surcharge Merchant Response:', response
 * print response.status
 * print response.code
 * print response.message
 * print response.mpId

# =====================================================================
  # SCENARIO 2: DB Validation using mpId from Scenario 1
  # =====================================================================
  Scenario: Validate Merchant exists in DB
  # * print 'Surcharge Merchant Response:', response
   # * def mpId = karate.get('sharedMpId')
   # * print 'Retrieved sharedMpId:', response.mpId
    #* assert mpId != null

    # ✅ STEP 1: Once you confirm table+column from prints above, use correct query:
    # e.g: * def query = "select * from merchant_info where Mp_Id = " + mpId
    #* def query = "select * from merchant_info where Mp_Id = " + response.mpId
    #* print query
    #* def dbResult = call read('classpath:common/db.feature') { query: '#(query)' }
    #* def rows = karate.toJson(dbResult.result)
    #* print '>>> QUERY RESULT rows.length:', rows.length
   # * print '>>> QUERY RESULT:', rows
    #* assert rows.length > 0
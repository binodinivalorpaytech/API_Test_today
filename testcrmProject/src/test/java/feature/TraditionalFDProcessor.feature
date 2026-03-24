Feature: Merchant - FD Traditional Processor

  Background:
    * def accessToken = karate.get('accessToken')
    * print 'Access Token:', accessToken
    * def random = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser = 'FDTraditional' + random 
    * def dynamicEmail = 'binodini@valorpaytech.com'
    * def shortSuperName = ('Supervisor' + random).substring(0,25)
    # test
    
  # =====================================================================
  # SCENARIO 1: Create Merchant - Positive Flow
  # =====================================================================
  Scenario: Create Merchant - FD Surcharge Positive Flow
       * def setData = read('classpath:traditional/FDpositive-payload.json')
    
    Given url baseUrl
    And path '/api/valor/create'
    And param traditionalFD = setData.FDtraditionalParam
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
  "legalCity": "CLIFFSIDE PARK",
  "legalState": "NJ",
  "legalCountry": "US",
  "legalZipCode": "#(setData.legalZipCode)",
  "role": "10",
  "legalTimezone": "EST",
  "userType": "4",
  "isTxnAllowed": "1",
  "businessType": "Direct Marketing)",
  "selectedState": "NJ",
  "processor": "2",
  "programType": "2",
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
          "deviceType": "Soft Pos",
          "processor": "2",
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
          "processorData": [
            {
              "surchargePercentage": "",
              "groupId": "",
              "groupId1": "40001",
              "midFD": "",
              "midFD1": "#(setData.midFD)",
              "termNoFD": "",
              "termNoFD1": "#(setData.termNoFD)",
              "EbtNoFD": "",
              "EbtNoFD1": "12345",
              "website": "",
              "website1": "https://vpuat.binskit.com",
              "mid3": "",
              "termNo3": "",
              "location_id": "",
              "client_key": "",
              "c_name": "",
              "label": "UNIVERSAL ROOFING SPECIALISTS",
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
    #* match response.status == true
    * print 'Full response:', response
    * print 'mpId:', response.mpId
    * print 'storeInfo:', response.storeInfo
/**
 * Author: Binodini Sahoo
 * Description: Merchant API Automation - Create Merchant FD Nashville
 * Created Date: 12-Mar-2026
 */

@ValorPay @CreateMerchant
Feature: Valor Pay - Create Merchant API (POST /api/valor/create?FDNashville=)

  Background:
    # ── Injected automatically by karate-config.js ─────────────────────────
    * def accessToken = accessToken
    * def baseUrl     = baseUrl

    # ── URL + headers set once, inherited by every scenario ────────────────
    * url baseUrl
    * def apiPath = '/api/valor/create'
    * header Authorization = 'Bearer ' + accessToken
    * header Accept        = 'application/json'
    * header Content-Type  = 'application/json'

    # ── Random suffix prevents duplicate-user failures across runs ──────────
    * def random       = java.lang.Math.floor(java.lang.Math.random() * 1000000)
    * def dynamicUser  = 'Merchant' + random
    * def dynamicEmail = 'binodini'+ '@valorpaytech.com'

    # ── Load JSON test data ─────────────────────────────────────────────────
    * def testDataNashville = karate.read('classpath:data/MerchantFDNasville.json')

    # ── Deep-copy via JSON round-trip — compatible with ALL Karate versions ──
    * def basePayload = JSON.parse(JSON.stringify(testDataNashville.basePayload))
    * set basePayload.userName = dynamicUser
    * set basePayload.emailId  = dynamicEmail

  # ============================================================
  #  POSITIVE TEST CASES
  # ============================================================

  @Positive @TC_POS_001 @Smoke
  Scenario: TC_POS_001 - Create merchant with all valid required and optional fields
    Given path apiPath
    And param FDNashville = ''
    And request basePayload
    When method POST
    Then status 200
    And match response.status == true
    * print 'TC_POS_001 | mpId:', response.mpId
    * print 'TC_POS_001 | storeInfo:', response.storeInfo

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

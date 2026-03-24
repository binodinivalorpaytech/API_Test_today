@ignore
Feature: Gateway POST helper - called feature, do not run directly

  # ─────────────────────────────────────────────────────────────────────
  # Called by Scenario 5 retry loop.
  # Expected args:
  #   requestPayload  - the full JSON request body (as a map)
  #   token           - the Bearer access token string
  # ─────────────────────────────────────────────────────────────────────

  Scenario:
    Given url baseUrl
    And path '/api/valor/create'
    And param surchargetsys = true
    And header Authorization = 'Bearer ' + token
    And header Content-Type = 'application/json'
    And request requestPayload
    When method post

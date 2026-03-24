Feature: Validate transaction in DB

Scenario: Validate transaction status

    * def query = "select * from transactions where epi_id = '2219263021'"
    * def dbResult = call read('classpath:common/db.feature') { query: '#(query)' }
    * def rows = dbResult.result
    * assert rows.length > 0
    * print 'First row:', rows[0]
    * match rows[0].response_code == '00'
    * match rows[0].is_txn_approved == true
    * match rows[0].txn_type == 'SALE'
    #test
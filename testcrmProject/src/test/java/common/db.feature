Feature: DB Utility

  Scenario:
    * def DbUtils = Java.type('utils.DbUtils')
    * def dbConn = new DbUtils(dbConfig.url, dbConfig.username, dbConfig.password)
    * def result = dbConn.readRows(query)
    * eval dbConn.close()
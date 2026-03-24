package utils;


import java.sql.*;
import java.util.*;

public class DbUtils {

    private Connection connection;

    public DbUtils(String url, String username, String password) throws Exception {
        Class.forName("org.mariadb.jdbc.Driver");
        connection = DriverManager.getConnection(url, username, password);
    }

    public List<Map<String, Object>> readRows(String query) throws Exception {
        List<Map<String, Object>> rows = new ArrayList<>();
        Statement stmt = connection.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        ResultSetMetaData meta = rs.getMetaData();
        int columnCount = meta.getColumnCount();

        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            for (int i = 1; i <= columnCount; i++) {
                row.put(meta.getColumnName(i), rs.getObject(i));
            }
            rows.add(row);
        }
        return rows;
    }

    public void close() throws Exception {
        if (connection != null) connection.close();
    }
}

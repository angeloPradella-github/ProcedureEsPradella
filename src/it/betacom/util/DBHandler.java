package it.betacom.util;

import java.sql.*;
import java.io.InputStream;
import java.io.IOException;
import java.util.Properties;

public class DBHandler {

    private static DBHandler instance;
    private Connection connection;
    
    private DBHandler() {
        try {
            // Dati dal file
            Properties props = new Properties();
            InputStream is = getClass().getClassLoader().getResourceAsStream("db_conf.properties");
            if (is == null) {
                throw new IOException("Errore aprtura file properties");
            }
            props.load(is);

            String url = props.getProperty("db.url");
            String dbName = props.getProperty("db.name");
            String username = props.getProperty("db.username");
            String password = props.getProperty("db.password");

            // Driver jdbc
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.connection = DriverManager.getConnection(url + dbName, username, password);
            
        } catch (ClassNotFoundException | SQLException | IOException e) {
            e.printStackTrace();
        }
    }

    public synchronized static DBHandler getInstance() throws SQLException {
        if (instance == null) {
            instance = new DBHandler();
        } 
        return instance;
    }
    
    public Connection getConnection() {
        return connection;
    }
}

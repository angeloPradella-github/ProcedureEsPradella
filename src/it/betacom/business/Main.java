package it.betacom.business;

import it.betacom.util.DBHandler;
import java.sql.*;

public class Main {
    public static void main(String[] args) {
        try {
        	//Connessione db
            DBHandler dbHandler = DBHandler.getInstance();
            Connection conn = dbHandler.getConnection();
            
            
            String query = "{ CALL get_age_autori_nazione(?) }";
            
            CallableStatement stmt = conn.prepareCall(query);
            stmt.setString(1, "Italia");  
            ResultSet rs = stmt.executeQuery();
            
            
            while (rs.next()) {
                String nomeA =rs.getString("nomeA");
                String cognomeA= rs.getString("cognomeA");
                int eta = rs.getInt("eta");
                System.out.println("Nome:" + nomeA + ", Cognome: " + cognomeA + ", Età: " + eta);
            }
        } catch (SQLException e) {
            System.out.println("Errore accesso a DB:");
            e.printStackTrace();
        }
    }
}

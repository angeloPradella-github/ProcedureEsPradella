package it.betacom.business;

import it.betacom.util.DBHandler;
import java.sql.*;
import java.util.ArrayList;

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
            
            ArrayList<String> authors = new ArrayList<>();
            
            while (rs.next()) {
                String nomeA =rs.getString("nomeA");
                String cognomeA= rs.getString("cognomeA");
                int eta = rs.getInt("eta");
                
                authors.add("Nome:" + nomeA + ", Cognome: " + cognomeA + ", Età: " + eta);
            }
            
            // stampa
            System.out.println("Autori italiani ancora vivi: ");
            for (String author : authors) {
                System.out.println(author);
            }
        } catch (SQLException e) {
            System.out.println("Errore accesso a DB:");
            e.printStackTrace();
        }
    }
}

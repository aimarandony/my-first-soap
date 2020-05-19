package com.soap.controllers;

import com.soap.config.Conexion;
import com.soap.models.Client;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author Aimar Berrocal Coaquira
 */

public class ClientController extends Conexion{
          
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
     public List<Client> Listar() throws SQLException{
        try {
            String sql = "SELECT * FROM CLIENTS";
            List<Client> lista = new ArrayList<>();
            
            con = conectar();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Client client = new Client(
                        rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4));
                
                lista.add(client);
            }
            return lista;
        } catch (SQLException ex) {
            Logger.getLogger(ClientController.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally{
            rs.close();
            ps.close();
            con.close();
        }
    }

    public Client ListarID(int id_client) throws SQLException{
        try {
            String sql = "SELECT * FROM CLIENTS WHERE id = "+id_client+"";
            
            Client client = null;
            
            con = conectar();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {                
                client = new Client(
                        rs.getInt(1),
                        rs.getString(2) ,
                        rs.getString(3),
                        rs.getString(4));
                
            }
            
            return client;
        } catch (SQLException ex) {
            Logger.getLogger(ClientController.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally{
            rs.close();
            ps.close();
            con.close();
        }
    }

    public boolean Insertar(Client client) throws SQLException {
        try {
            String sql = "INSERT INTO CLIENTS VALUES(null, ?, ?, ?)";
            
            boolean respuesta = false;
            
            con = conectar();
            
            ps = con.prepareStatement(sql);
            ps.setString(1, client.getName());
            ps.setString(2, client.getLastname());
            ps.setString(3, client.getDni());

            if (ps.executeUpdate() == 1) {                
                respuesta = true;
            }

            return respuesta;
        } catch (SQLException ex) {
            Logger.getLogger(ClientController.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally{
            ps.close();
            con.close();
        }
    }

    public boolean Actualizar(Client client) throws SQLException {
        try {
            String sql = "UPDATE CLIENTS SET name = ?, lastname = ?, dni = ? WHERE id = ?";
            
            boolean respuesta = false;
            
            con = conectar();
            
            ps = con.prepareStatement(sql);
            ps.setString(1, client.getName());
            ps.setString(2, client.getLastname());
            ps.setString(3, client.getDni());
            ps.setInt(4, client.getId());
            
            if (ps.executeUpdate() == 1) {                
                respuesta = true;
            }

            return respuesta;
        } catch (SQLException ex) {
            Logger.getLogger(ClientController.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally{
            ps.close();
            con.close();
        }
    }

    public boolean Eliminar(int id_client) throws SQLException {
        try {
            String sql = "DELETE FROM CLIENTS WHERE id = "+id_client+"";
            
            boolean respuesta = false;
            
            con = conectar();            
            ps = con.prepareStatement(sql);
            
            if (ps.executeUpdate() == 1) {                
                respuesta = true;
            }

            return respuesta;
        } catch (SQLException ex) {
            Logger.getLogger(ClientController.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally{
            ps.close();
            con.close();
        }
    }
    
}

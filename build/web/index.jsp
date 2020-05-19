<%-- 
    Document   : index
    Created on : 05/05/2020, 03:01:11 PM
    Author     : Aimar Berrocal Coaquira
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SOAP Practice - Berrocal</title>
        <link rel="icon" type="image/png" href="img/icon.png" />
        <link rel="stylesheet" href="https://bootswatch.com/4/superhero/bootstrap.min.css">
        <script src="https://kit.fontawesome.com/8719a7912f.js" crossorigin="anonymous"></script>
        <link href="css/codemirror.css" rel="stylesheet" type="text/css"/>
        <link href="css/ayu-mirage.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <style>
            img{
                width: 100%;
            }
        </style>
        <nav class="navbar navbar-dark bg-primary">
            <span class="navbar-brand">SOAP - CRUD CLIENTE - DATABASE</span>
            <ul class="navbar-nav ml-auto">
                <li class="nav-item active">
                    <a class="nav-link" href="https://github.com/aimarandony/my-first-soap" target="_blank"><i class="fab fa-github pr-1"></i> GITHUB</a>
                </li>
                <li class="nav-item active">
                    <span class="nav-link"><i class="fas fa-fire pr-1"></i> Aimar Berrocal</span>
                </li>
            </ul>
        </nav>

        <div class="container my-5">

            <div class="alert alert-dismissible alert-info">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <p style="margin: 0">
                    Proyecto SOAP - Creación de un Servicio SOAP, con base de datos MySQL. Recordar siempre agregar la librería de MySQL JDBC Driver
                </p>
            </div>
            
            <div class="alert alert-dismissible alert-info">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <p style="margin: 0">
                    IDE usado: Netbeans IDE 8.2
                </p>
            </div>
                        
            <div class="card">
                <div class="card-body">
                    <table class="table table-hover">
                        <thead class="thead-dark">
                            <tr>
                                <th colspan="2">Información</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="default">
                                <th>Address:</th>
                                <td>
                                    <a href="http://localhost:8084/SoapPractice/ClientService" target="_blank">
                                        http://localhost:8084/SoapPractice/ClientService
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <th>WSDL:</th>
                                <td>
                                    <a href="http://localhost:8084/SoapPractice/ClientService?wsdl" target="_blank">
                                        http://localhost:8084/SoapPractice/ClientService?wsdl
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <th>Implementation class:</th>
                                <td>com.soap.services.ClientService</td>
                            </tr>
                        </tbody>
                    </table> 
                </div>
            </div>

                        <div class="row">
                <div class="col-12 mt-3">
                    <div class="card">
                        <div class="card-header">
                            ◘ Base de Datos - MySQL
                        </div>
                        <div class="card-body">
                            <textarea class="txtarea" name="txtArea01">
create database BDSoapPractice;
use BDSoapPractice;

create table CLIENTS (
  id int not null auto_increment,
  name varchar(100), 
  lastname varchar(100),
  dni char(8),
  primary key (id)
);

insert into clients values 
(null,'Lucas','Kingston','78495612'),
(null,'Marcos','Tulio','76451245'),
(null,'Joel','Llano','78579484');

select * from clients;
                            </textarea>
                        </div>
                    </div>
                </div>                
            </div>

            <hr/>
            
            <div class="row">
                <div class="col-12 mt-3">
                    <div class="card">
                        <div class="card-header">
                            ◘ Paquete: com.soap.config || Clase: Conexión.java
                        </div>
                        <div class="card-body">
                            <textarea class="txtarea" name="txtArea01">
package com.soap.config;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    Connection conectar = null;
    public Connection conectar(){
        try{
            Class.forName("com.mysql.jdbc.Driver");
            conectar = DriverManager.getConnection("jdbc:mysql://localhost:3306/BDSoapPractice","root","");
        }catch (ClassNotFoundException | SQLException e){
            System.out.println("Error al conectar: "+e.getMessage());
        }
        return conectar;
    }
}
                            </textarea>
                        </div>
                    </div>
                </div>                
            </div>

            <hr/>

            <div class="row">
                <div class="col-12 mt-3">
                    <div class="card">
                        <div class="card-header">
                            ◘ Paquete: com.soap.controllers || Clase: ClientController.java
                        </div>
                        <div class="card-body">
                            <textarea class="txtarea" name="txtArea01">
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

public class ClientController extends Conexion{
          
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
     public List&lt;Client&gt; Listar() throws SQLException{
        try {
            String sql = "SELECT * FROM CLIENTS";
            List&lt;Client&gt; lista = new ArrayList&lt;&gt;();
            
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
                            </textarea>
                        </div>
                    </div>
                </div>                
            </div>

            <hr/>

            <div class="row">
                <div class="col-12 mt-3">
                    <div class="card">
                        <div class="card-header">
                            ◘ Paquete: com.soap.models || Clase: Client.java
                        </div>
                        <div class="card-body">
                            <textarea class="txtarea" name="txtArea01">
package com.soap.models;

public class Client {

    private int id;
    private String name;
    private String lastname;
    private String dni;

    public Client() {
    }

    public Client(int id, String name, String lastname, String dni) {
        this.id = id;
        this.name = name;
        this.lastname = lastname;
        this.dni = dni;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }    
}
                            </textarea>
                        </div>
                    </div>
                </div>                
            </div>

            <hr/>

            <div class="row">
                <div class="col-12 mt-3">
                    <div class="card">
                        <div class="card-header">
                            ◘ Paquete: com.soap.services || Clase: ClientService.java
                        </div>
                        <div class="card-body">
                            <textarea class="txtarea" name="txtArea01">
package com.soap.services;

import com.soap.controllers.ClientController;
import com.soap.models.Client;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.jws.WebService;
import javax.jws.WebMethod;
import javax.jws.WebParam;

@WebService(serviceName = "ClientService")
public class ClientService {
    
    ClientController clientController = new ClientController();

    //Obtener todos los Clientes
    @WebMethod(operationName = "findAll")
    public List&lt;Client&gt; findAll() {
        try {
            return clientController.Listar();
        } catch (SQLException ex) {
            Logger.getLogger(ClientService.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    //Obtener un Cliente por su id
    @WebMethod(operationName = "findById")
    public Client findById(@WebParam(name = "id") int id) {
        try {
            return clientController.ListarID(id);
        } catch (SQLException ex) {
            Logger.getLogger(ClientService.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    //Crear un nuevo Cliente
    @WebMethod(operationName = "create")
    public String create(@WebParam(name = "client") Client client) {
        try {
            if (clientController.Insertar(client)) {
                return "Cliente " + client.getName() + " ha sido creado correctamente.";
            }
            return "Error al crear el cliente";
        } catch (SQLException ex) {
            Logger.getLogger(ClientService.class.getName()).log(Level.SEVERE, null, ex);
            return "Error al realizar la petición";
        }
    }
    
    //Actualizar un Cliente por su id
    @WebMethod(operationName = "update")
    public Client update(@WebParam(name = "client") Client client) {
        try {
            Client clientUpdated = null;
            if (clientController.Actualizar(client)) {
                clientUpdated = clientController.ListarID(client.getId());
            }
            return clientUpdated;
        } catch (SQLException ex) {
            Logger.getLogger(ClientService.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
    
    //Eliminar un Cliente por su id
    @WebMethod(operationName = "delete")
    public String delete(@WebParam(name = "id") int id) {
        try {
            String msg = "El cliente no se ha podido eliminar";
            if (clientController.Eliminar(id)) {
                msg = "El cliente se ha eliminado correctamente";
            }
            return msg;
        } catch (SQLException ex) {
            Logger.getLogger(ClientService.class.getName()).log(Level.SEVERE, null, ex);
            return "Error al realizar la petición";
        }
    }
}
                            </textarea>
                        </div>
                    </div>
                </div>                
            </div>

        </div>
        <script src="js/codemirror.js" type="text/javascript"></script>
        <script src="js/mode-clike.js" type="text/javascript"></script>
        
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
        
        <script>

            var txtarea = document.getElementsByClassName("txtarea");

            for (var item of txtarea) {
                var editor = CodeMirror.fromTextArea(item, {
                    // muestro las líneas de código
                    lineNumbers: true,
                    // elijo el tema
                    theme: 'ayu-mirage',
                    // esto deshabilita la opción de reescribir
                    readOnly: true,

                    mode: "text/x-java"
                });
            }

        </script>
    </body>
</html>

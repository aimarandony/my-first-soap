# SOAP PRACTICE
> En este proyecto encontrarás un ejemplo de la creación de un servicio SOAP, y como conectarlo con una base de datos MySQL.

#### Consideraciones
> Recordar siempre agregar la librería de MySQL JDBC Driver 
> IDE usado: Netbeans IDE 8.2 
### ◘ Base de Datos - MySQL 
```
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
```

### ◘ Paquete: com.soap.config || Clase: Conexión.java 
```
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
```

### ◘ Paquete: com.soap.models || Clase: Client.java 
```
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
```

### ◘ Paquete: com.soap.controllers || Clase: ClientController.java 
```
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
```

### ◘ Paquete: com.soap.services || Clase: ClientService.java 
```
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
    public List<Client> findAll() {
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
```

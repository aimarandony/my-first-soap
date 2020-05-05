package com.soap.services;

import com.soap.models.Client;
import java.util.ArrayList;
import javax.jws.WebService;
import javax.jws.WebMethod;
import javax.jws.WebParam;

/**
 * @author Aimar Berrocal Coaquira
 */

@WebService(serviceName = "ClientService")
public class ClientService {

    ArrayList<Client> list = new ArrayList<>();
    int countId = 0;
    
    //Método para obtener el index de mi ArrayList por el id
    @WebMethod(operationName = "method01")
    public int findIndexOfId(int id){
        for (int i = 0; i < list.size(); i++) {
            if(id == list.get(i).getId()){
                return i;
            }
        }
        return -1;
    }
    
    //Método para llenar mi ArrayList con 3 Clientes
    @WebMethod(operationName = "method02")
    public String fillList() {
        if (list.isEmpty()) {
            list.add(new Client(1, "Lucas", "Kingston", "78495612"));
            list.add(new Client(2, "Marcos", "Tulio", "76451245"));
            list.add(new Client(3, "Joel", "Llano", "78579484"));
            countId = 3;
        }
        return "Metodo para llenar la lista de Clientes.";
    }

    //Obtener todos los Clientes
    @WebMethod(operationName = "findAll")
    public ArrayList<Client> findAll() {
        fillList();
        return list;
    }

    //Obtener un Cliente por su id
    @WebMethod(operationName = "findById")
    public Client findById(@WebParam(name = "id") int id) {
        fillList();
        Client client = list.get(findIndexOfId(id));
        return client;
    }

    //Crear un nuevo Cliente
    @WebMethod(operationName = "create")
    public Client create(@WebParam(name = "client") Client client) {
        fillList();
        client.setId(countId + 1);
        list.add(client);
        ++ countId;
        return client;
    }
    
    //Actualizar un Cliente por su id
    @WebMethod(operationName = "update")
    public Client update(@WebParam(name = "client") Client client){
        fillList();
        list.set(findIndexOfId(client.getId()), client);
        Client updatedClient = list.get(findIndexOfId(client.getId()));
        return updatedClient;
    }
    
    //Eliminar un Cliente por su id
    @WebMethod(operationName = "delete")
    public String delete(@WebParam(name = "id") int id){
        fillList();
        Client client = list.get(findIndexOfId(id));
        list.remove(findIndexOfId(id));
        return "El Cliente " + client.getName() + " se ha eliminado correctamente.";
    }
}

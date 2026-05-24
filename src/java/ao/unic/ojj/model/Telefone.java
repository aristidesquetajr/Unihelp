/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.model;

/**
 *
 * @author kashiki
 */
public class Telefone {

    private int id;
    private String numero;
    private int idUtilizador;

    public Telefone() {
    }

    public Telefone(String numero, int idUtilizador) {
        this.numero = numero;
        this.idUtilizador = idUtilizador;
    }

    public Telefone(int id, String numero, int idUtilizador) {
        this.id = id;
        this.numero = numero;
        this.idUtilizador = idUtilizador;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public int getIdUtilizador() {
        return idUtilizador;
    }

    public void setIdUtilizador(int idUtilizador) {
        this.idUtilizador = idUtilizador;
    }

    @Override
    public String toString() {
        return "Telefone{"
                + "id=" + id
                + ", numero='" + numero + '\''
                + ", idUtilizador=" + idUtilizador
                + '}';
    }
}

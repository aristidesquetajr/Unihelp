/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.model;

/**
 *
 * @author kashiki
 */
public class Estudante {

    private int id;
    private int idUtilizador;
    private String numeroEstudante;

    public Estudante() {
    }

    public Estudante(int idUtilizador, String numeroEstudante) {
        this.idUtilizador = idUtilizador;
        this.numeroEstudante = numeroEstudante;
    }

    public Estudante(int id, int idUtilizador, String numeroEstudante) {
        this.id = id;
        this.idUtilizador = idUtilizador;
        this.numeroEstudante = numeroEstudante;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdUtilizador() {
        return idUtilizador;
    }

    public void setIdUtilizador(int idUtilizador) {
        this.idUtilizador = idUtilizador;
    }

    public String getNumeroEstudante() {
        return numeroEstudante;
    }

    public void setNumeroEstudante(String numeroEstudante) {
        this.numeroEstudante = numeroEstudante;
    }

    @Override
    public String toString() {
        return "Estudante{"
                + "id=" + id
                + ", idUtilizador=" + idUtilizador
                + ", numeroEstudante='" + numeroEstudante + '\''
                + '}';
    }
}

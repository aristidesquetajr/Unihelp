/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.model;

/**
 *
 * @author kashiki
 */
public class Funcionario {

    private int id;
    private int idUtilizador;
    private String departamento;
    private String cargo;

    public Funcionario() {
    }

    public Funcionario(int idUtilizador, String departamento, String cargo) {
        this.idUtilizador = idUtilizador;
        this.departamento = departamento;
        this.cargo = cargo;
    }

    public Funcionario(int id, int idUtilizador, String departamento, String cargo) {
        this.id = id;
        this.idUtilizador = idUtilizador;
        this.departamento = departamento;
        this.cargo = cargo;
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

    public String getDepartamento() {
        return departamento;
    }

    public void setDepartamento(String departamento) {
        this.departamento = departamento;
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    @Override
    public String toString() {
        return "Funcionario{"
                + "id=" + id
                + ", idUtilizador=" + idUtilizador
                + ", departamento='" + departamento + '\''
                + ", cargo='" + cargo + '\''
                + '}';
    }
}

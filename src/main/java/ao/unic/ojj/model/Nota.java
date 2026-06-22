/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.model;

/**
 *
 * @author kashiki
 */
public class Nota {

    public enum Tipo {
        AVALIACAO, P1, P2, EXAME, RECURSO, ESPECIAL
    }

    private int id;
    private int idEstudante;
    private int idDisciplina;
    private int idPeriodoLetivo;
    private double valor;
    private Tipo tipo;

    public Nota() {
    }

    public Nota(int idEstudante, int idDisciplina, int idPeriodoLetivo,
            double valor, Tipo tipo) {
        this.idEstudante = idEstudante;
        this.idDisciplina = idDisciplina;
        this.idPeriodoLetivo = idPeriodoLetivo;
        this.valor = valor;
        this.tipo = tipo;
    }

    public Nota(int id, int idEstudante, int idDisciplina,
            int idPeriodoLetivo, double valor, Tipo tipo) {
        this.id = id;
        this.idEstudante = idEstudante;
        this.idDisciplina = idDisciplina;
        this.idPeriodoLetivo = idPeriodoLetivo;
        this.valor = valor;
        this.tipo = tipo;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdEstudante() {
        return idEstudante;
    }

    public void setIdEstudante(int idEstudante) {
        this.idEstudante = idEstudante;
    }

    public int getIdDisciplina() {
        return idDisciplina;
    }

    public void setIdDisciplina(int idDisciplina) {
        this.idDisciplina = idDisciplina;
    }

    public int getIdPeriodoLetivo() {
        return idPeriodoLetivo;
    }

    public void setIdPeriodoLetivo(int idPeriodoLetivo) {
        this.idPeriodoLetivo = idPeriodoLetivo;
    }

    public double getValor() {
        return valor;
    }

    public void setValor(double valor) {
        this.valor = valor;
    }

    public Tipo getTipo() {
        return tipo;
    }

    public void setTipo(Tipo tipo) {
        this.tipo = tipo;
    }

    public boolean isAprovado() {
        return this.valor >= 10.0;
    }

    @Override
    public String toString() {
        return "Nota{"
                + "id=" + id
                + ", idEstudante=" + idEstudante
                + ", idDisciplina=" + idDisciplina
                + ", idPeriodoLetivo=" + idPeriodoLetivo
                + ", valor=" + valor
                + ", tipo=" + tipo
                + '}';
    }

}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.model;

import java.util.Date;

/**
 *
 * @author kashiki
 */
public class Inscricao {

    public enum Estado {
        ACTIVO, CONCLUIDO, TRANCADO
    }

    private int id;
    private int idEstudante;
    private int idTurma;
    private Date dataInscricao;
    private Estado estado;

    public Inscricao() {
    }

    public Inscricao(int idEstudante, int idTurma, Date dataInscricao, Estado estado) {
        this.idEstudante = idEstudante;
        this.idTurma = idTurma;
        this.dataInscricao = dataInscricao;
        this.estado = estado;
    }

    public Inscricao(int id, int idEstudante, int idTurma,
            Date dataInscricao, Estado estado) {
        this.id = id;
        this.idEstudante = idEstudante;
        this.idTurma = idTurma;
        this.dataInscricao = dataInscricao;
        this.estado = estado;
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

    public int getIdTurma() {
        return idTurma;
    }

    public void setIdTurma(int idTurma) {
        this.idTurma = idTurma;
    }

    public Date getDataInscricao() {
        return dataInscricao;
    }

    public void setDataInscricao(Date dataInscricao) {
        this.dataInscricao = dataInscricao;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return "Inscricao{"
                + "id=" + id
                + ", idEstudante=" + idEstudante
                + ", idTurma=" + idTurma
                + ", dataInscricao=" + dataInscricao
                + ", estado=" + estado
                + '}';
    }
}

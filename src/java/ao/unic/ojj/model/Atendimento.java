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
public class Atendimento {

    public enum Estado {
        PENDENTE, CONFIRMADO, REJEITADO
    }

    private int id;
    private int idEstudante;
    private int idFuncionario;
    private Date dataAgendada;
    private String descricao;
    private Estado estado;
    private String motivoRejeicao;   // preenchido apenas quando REJEITADO

    public Atendimento() {
    }

    public Atendimento(int idEstudante, Date dataAgendada, String descricao) {
        this.idEstudante = idEstudante;
        this.dataAgendada = dataAgendada;
        this.descricao = descricao;
        this.estado = Estado.PENDENTE;
    }

    public Atendimento(int id, int idEstudante, int idFuncionario,
            Date dataAgendada, String descricao,
            Estado estado, String motivoRejeicao) {
        this.id = id;
        this.idEstudante = idEstudante;
        this.idFuncionario = idFuncionario;
        this.dataAgendada = dataAgendada;
        this.descricao = descricao;
        this.estado = estado;
        this.motivoRejeicao = motivoRejeicao;
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

    public int getIdFuncionario() {
        return idFuncionario;
    }

    public void setIdFuncionario(int idFuncionario) {
        this.idFuncionario = idFuncionario;
    }

    public Date getDataAgendada() {
        return dataAgendada;
    }

    public void setDataAgendada(Date dataAgendada) {
        this.dataAgendada = dataAgendada;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    public String getMotivoRejeicao() {
        return motivoRejeicao;
    }

    public void setMotivoRejeicao(String motivoRejeicao) {
        this.motivoRejeicao = motivoRejeicao;
    }

    public boolean isPendente() {
        return Estado.PENDENTE.equals(this.estado);
    }

    public boolean isConfirmado() {
        return Estado.CONFIRMADO.equals(this.estado);
    }

    public boolean isRejeitado() {
        return Estado.REJEITADO.equals(this.estado);
    }

    @Override
    public String toString() {
        return "Atendimento{"
                + "id=" + id
                + ", idEstudante=" + idEstudante
                + ", idFuncionario=" + idFuncionario
                + ", dataAgendada=" + dataAgendada
                + ", estado=" + estado
                + '}';
    }
}

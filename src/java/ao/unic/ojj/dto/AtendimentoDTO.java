/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.dto;

import java.util.Date;

import ao.unic.ojj.model.Atendimento;

/**
 *
 * @author kashiki
 */
public class AtendimentoDTO {

    private int idAtendimento;
    private String nomeEstudante;
    private String numeroEstudante;
    private String nomeFuncionario;
    private Date dataAgendada;
    private String descricao;
    private Atendimento.Estado estado;
    private String motivoRejeicao;

    public AtendimentoDTO() {
    }

    public int getIdAtendimento() {
        return idAtendimento;
    }

    public void setIdAtendimento(int idAtendimento) {
        this.idAtendimento = idAtendimento;
    }

    public String getNomeEstudante() {
        return nomeEstudante;
    }

    public void setNomeEstudante(String nomeEstudante) {
        this.nomeEstudante = nomeEstudante;
    }

    public String getNumeroEstudante() {
        return numeroEstudante;
    }

    public void setNumeroEstudante(String numeroEstudante) {
        this.numeroEstudante = numeroEstudante;
    }

    public String getNomeFuncionario() {
        return nomeFuncionario;
    }

    public void setNomeFuncionario(String nomeFuncionario) {
        this.nomeFuncionario = nomeFuncionario;
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

    public Atendimento.Estado getEstado() {
        return estado;
    }

    public void setEstado(Atendimento.Estado estado) {
        this.estado = estado;
    }

    public String getMotivoRejeicao() {
        return motivoRejeicao;
    }

    public void setMotivoRejeicao(String motivoRejeicao) {
        this.motivoRejeicao = motivoRejeicao;
    }

    public boolean isPendente() {
        return Atendimento.Estado.PENDENTE.equals(estado);
    }

    public boolean isConfirmado() {
        return Atendimento.Estado.CONFIRMADO.equals(estado);
    }

    public boolean isRejeitado() {
        return Atendimento.Estado.REJEITADO.equals(estado);
    }
}

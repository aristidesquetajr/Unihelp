/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.dto;

import java.util.Date;

import ao.unic.ojj.model.Inscricao;

/**
 *
 * @author kashiki
 */
public class InscricaoDetalheDTO {

    private int idInscricao;
    private Date dataInscricao;
    private Inscricao.Estado estado;
    private String nomeTurma;
    private String sala;
    private int anoAcademico;
    private String nomeCurso;
    private String anoLetivo;
    private int semestre;

    public InscricaoDetalheDTO() {
    }

    public int getIdInscricao() {
        return idInscricao;
    }

    public void setIdInscricao(int idInscricao) {
        this.idInscricao = idInscricao;
    }

    public Date getDataInscricao() {
        return dataInscricao;
    }

    public void setDataInscricao(Date dataInscricao) {
        this.dataInscricao = dataInscricao;
    }

    public Inscricao.Estado getEstado() {
        return estado;
    }

    public void setEstado(Inscricao.Estado e) {
        this.estado = e;
    }

    public String getNomeTurma() {
        return nomeTurma;
    }

    public void setNomeTurma(String nomeTurma) {
        this.nomeTurma = nomeTurma;
    }

    public String getSala() {
        return sala;
    }

    public void setSala(String sala) {
        this.sala = sala;
    }

    public int getAnoAcademico() {
        return anoAcademico;
    }

    public void setAnoAcademico(int anoAcademico) {
        this.anoAcademico = anoAcademico;
    }

    public String getNomeCurso() {
        return nomeCurso;
    }

    public void setNomeCurso(String nomeCurso) {
        this.nomeCurso = nomeCurso;
    }

    public String getAnoLetivo() {
        return anoLetivo;
    }

    public void setAnoLetivo(String anoLetivo) {
        this.anoLetivo = anoLetivo;
    }

    public int getSemestre() {
        return semestre;
    }

    public void setSemestre(int semestre) {
        this.semestre = semestre;
    }

    public boolean isActivo() {
        return Inscricao.Estado.ACTIVO.equals(estado);
    }

    public boolean isConcluido() {
        return Inscricao.Estado.CONCLUIDO.equals(estado);
    }

    public boolean isTrancado() {
        return Inscricao.Estado.TRANCADO.equals(estado);
    }
}

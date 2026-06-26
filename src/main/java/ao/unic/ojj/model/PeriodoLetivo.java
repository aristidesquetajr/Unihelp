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
public class PeriodoLetivo {

    private int id;
    private String anoLetivo;   // ex: "2025-2026"
    private int semestre;    // 1 ou 2
    private Date dataInicio;
    private Date dataFim;
    private boolean ativo;

    public PeriodoLetivo() {
    }

    public PeriodoLetivo(String anoLetivo, int semestre,
            Date dataInicio, Date dataFim, boolean ativo) {
        this.anoLetivo = anoLetivo;
        this.semestre = semestre;
        this.dataInicio = dataInicio;
        this.dataFim = dataFim;
        this.ativo = ativo;
    }

    public PeriodoLetivo(int id, String anoLetivo, int semestre,
            Date dataInicio, Date dataFim, boolean ativo) {
        this.id = id;
        this.anoLetivo = anoLetivo;
        this.semestre = semestre;
        this.dataInicio = dataInicio;
        this.dataFim = dataFim;
        this.ativo = ativo;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public Date getDataInicio() {
        return dataInicio;
    }

    public void setDataInicio(Date dataInicio) {
        this.dataInicio = dataInicio;
    }

    public Date getDataFim() {
        return dataFim;
    }

    public void setDataFim(Date dataFim) {
        this.dataFim = dataFim;
    }

    public boolean isAtivo() {
        return ativo;
    }

    public void setAtivo(boolean ativo) {
        this.ativo = ativo;
    }

    public String getNomeFormatado() {
        return semestre + "º Semestre " + anoLetivo;
    }

    @Override
    public String toString() {
        return "PeriodoLetivo{"
                + "id=" + id
                + ", anoLetivo='" + anoLetivo + '\''
                + ", semestre=" + semestre
                + ", ativo=" + ativo
                + '}';
    }

}

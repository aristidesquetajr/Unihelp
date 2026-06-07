/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.dto;

import ao.unic.ojj.model.Nota;

/**
 *
 * @author kashiki
 */
public class NotaDetalheDTO {

    private int idNota;
    private String nomeDisciplina;
    private String codigoDisciplina;
    private String anoLetivo;
    private int semestre;
    private double valor;
    private Nota.Tipo tipo;

    public NotaDetalheDTO() {
    }

    public int getIdNota() {
        return idNota;
    }

    public void setIdNota(int idNota) {
        this.idNota = idNota;
    }

    public String getNomeDisciplina() {
        return nomeDisciplina;
    }

    public void setNomeDisciplina(String nomeDisciplina) {
        this.nomeDisciplina = nomeDisciplina;
    }

    public String getCodigoDisciplina() {
        return codigoDisciplina;
    }

    public void setCodigoDisciplina(String codigoDisciplina) {
        this.codigoDisciplina = codigoDisciplina;
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

    public double getValor() {
        return valor;
    }

    public void setValor(double valor) {
        this.valor = valor;
    }

    public Nota.Tipo getTipo() {
        return tipo;
    }

    public void setTipo(Nota.Tipo tipo) {
        this.tipo = tipo;
    }

    public boolean isAprovado() {
        return this.valor >= 10.0;
    }
}

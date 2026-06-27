/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.dto;

import ao.unic.ojj.model.Turma;

/**
 *
 * @author kashiki
 */
public class TurmaDTO extends Turma {

    private String nomeCurso;
    private String nomePeriodo;

    public TurmaDTO(int id, String nome, int idCurso, int idPeriodoLetivo, String sala, int anoAcademico, String nomeCurso, String nomePeriodo) {
        super(id, nome, idCurso, idPeriodoLetivo, sala, anoAcademico);
        this.nomeCurso = nomeCurso;
        this.nomePeriodo = nomePeriodo;
    }

    public String getNomeCurso() {
        return nomeCurso;
    }

    public void setNomeCurso(String nomeCurso) {
        this.nomeCurso = nomeCurso;
    }

    public String getNomePeriodo() {
        return nomePeriodo;
    }

    public void setNomePeriodo(String nomePeriodo) {
        this.nomePeriodo = nomePeriodo;
    }
}

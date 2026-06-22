/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.model;

/**
 *
 * @author kashiki
 */
public class Turma {

    private int id;
    private String nome;
    private int idCurso;
    private int idPeriodoLetivo;
    private String sala;
    private int anoAcademico;   // 1, 2, 3, 4 ano do curso

    public Turma() {
    }

    public Turma(String nome, int idCurso, int idPeriodoLetivo,
            String sala, int anoAcademico) {
        this.nome = nome;
        this.idCurso = idCurso;
        this.idPeriodoLetivo = idPeriodoLetivo;
        this.sala = sala;
        this.anoAcademico = anoAcademico;
    }

    public Turma(int id, String nome, int idCurso, int idPeriodoLetivo,
            String sala, int anoAcademico) {
        this.id = id;
        this.nome = nome;
        this.idCurso = idCurso;
        this.idPeriodoLetivo = idPeriodoLetivo;
        this.sala = sala;
        this.anoAcademico = anoAcademico;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getIdCurso() {
        return idCurso;
    }

    public void setIdCurso(int idCurso) {
        this.idCurso = idCurso;
    }

    public int getIdPeriodoLetivo() {
        return idPeriodoLetivo;
    }

    public void setIdPeriodoLetivo(int idPeriodoLetivo) {
        this.idPeriodoLetivo = idPeriodoLetivo;
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

    @Override
    public String toString() {
        return "Turma{"
                + "id=" + id
                + ", nome='" + nome + '\''
                + ", idCurso=" + idCurso
                + ", idPeriodoLetivo=" + idPeriodoLetivo
                + ", sala='" + sala + '\''
                + ", anoAcademico=" + anoAcademico
                + '}';
    }
}

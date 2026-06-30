/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.dto;

import ao.unic.ojj.model.Inscricao;
import ao.unic.ojj.model.Utilizador;
import java.util.List;

/**
 *
 * @author kashiki
 */
public class EstudanteDetalheDTO {

    private int id;
    private String nome;
    private String email;
    private String numeroEstudante;
    private String nomeCurso;
    private String nomeTurma;
    private String sala;
    private int anoAcademico;
    private String anoLetivo;
    private Utilizador.Status status;
    private Inscricao.Estado estadoInscricao;
    private List<String> telefones;

    public EstudanteDetalheDTO() {
    }

    public EstudanteDetalheDTO(int id, String nome, String email, String numeroEstudante, String nomeCurso, String nomeTurma, String sala, int anoAcademico, String anoLetivo) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.numeroEstudante = numeroEstudante;
        this.nomeCurso = nomeCurso;
        this.nomeTurma = nomeTurma;
        this.sala = sala;
        this.anoAcademico = anoAcademico;
        this.anoLetivo = anoLetivo;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNumeroEstudante() {
        return numeroEstudante;
    }

    public void setNumeroEstudante(String numeroEstudante) {
        this.numeroEstudante = numeroEstudante;
    }

    public String getNomeCurso() {
        return nomeCurso;
    }

    public void setNomeCurso(String nomeCurso) {
        this.nomeCurso = nomeCurso;
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

    public String getAnoLetivo() {
        return anoLetivo;
    }

    public void setAnoLetivo(String anoLetivo) {
        this.anoLetivo = anoLetivo;
    }

    public List<String> getTelefones() {
        return telefones;
    }

    public void setTelefones(List<String> tel) {
        this.telefones = tel;
    }

    public Utilizador.Status getStatus() {
        return status;
    }

    public void setStatus(Utilizador.Status status) {
        this.status = status;
    }

    public Inscricao.Estado getEstadoInscricao() {
        return estadoInscricao;
    }

    public void setEstadoInscricao(Inscricao.Estado estadoInscricao) {
        this.estadoInscricao = estadoInscricao;
    }
}

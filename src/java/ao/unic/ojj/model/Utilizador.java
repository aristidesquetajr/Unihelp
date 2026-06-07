/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.model;

/**
 *
 * @author kashiki
 */
public class Utilizador {

    public enum Perfil {
        ADMIN, ESTUDANTE, FUNCIONARIO
    }

    public enum Status {
        ACTIVO, BLOQUEADO
    }

    private int id;
    private String nome;
    private String email;
    private String senha;
    private Perfil perfil;
    private Status status;

    public Utilizador() {
    }

    public Utilizador(String email, String senha) {
        this.email = email;
        this.senha = senha;
    }

    public Utilizador(String nome, String email, String senha,
            Perfil perfil, Status status) {
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.perfil = perfil;
        this.status = status;
    }

    public Utilizador(int id, String nome, String email, String senha,
            Perfil perfil, Status status) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.perfil = perfil;
        this.status = status;
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

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    public Perfil getPerfil() {
        return perfil;
    }

    public void setPerfil(Perfil perfil) {
        this.perfil = perfil;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Utilizador{"
                + "id=" + id
                + ", nome='" + nome + '\''
                + ", email='" + email + '\''
                + ", perfil=" + perfil
                + ", status=" + status
                + '}';
    }
}

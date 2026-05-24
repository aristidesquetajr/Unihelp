/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.model;

/**
 *
 * @author kashiki
 */
public class Curso {

    private int id;
    private String nome;
    private boolean ativo;

    public Curso() {
    }

    public Curso(String nome, boolean ativo) {
        this.nome = nome;
        this.ativo = ativo;
    }

    public Curso(int id, String nome, boolean ativo) {
        this.id = id;
        this.nome = nome;
        this.ativo = ativo;
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

    public boolean isAtivo() {
        return ativo;
    }

    public void setAtivo(boolean ativo) {
        this.ativo = ativo;
    }

    @Override
    public String toString() {
        return "Curso{"
                + "id=" + id
                + ", nome='" + nome + '\''
                + ", ativo=" + ativo
                + '}';
    }
}

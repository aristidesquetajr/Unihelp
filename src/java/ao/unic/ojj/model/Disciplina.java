/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.model;

/**
 *
 * @author kashiki
 */
public class Disciplina {

    private int id;
    private String nome;
    private String codigo;

    public Disciplina() {
    }

    public Disciplina(String nome, String codigo) {
        this.nome = nome;
        this.codigo = codigo;
    }

    public Disciplina(int id, String nome, String codigo) {
        this.id = id;
        this.nome = nome;
        this.codigo = codigo;
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

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    @Override
    public String toString() {
        return "Disciplina{"
                + "id=" + id
                + ", nome='" + nome + '\''
                + ", codigo='" + codigo + '\''
                + '}';
    }

}

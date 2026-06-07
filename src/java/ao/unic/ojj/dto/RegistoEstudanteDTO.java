/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.dto;

/**
 *
 * @author kashiki
 */
public class RegistoEstudanteDTO {

    private String nome;
    private String email;
    private String senha;
    private String confirmarSenha;
    private String numeroEstudante;
    private String telefone;

    public RegistoEstudanteDTO() {
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

    public String getConfirmarSenha() {
        return confirmarSenha;
    }

    public void setConfirmarSenha(String confirmarSenha) {
        this.confirmarSenha = confirmarSenha;
    }

    public String getNumeroEstudante() {
        return numeroEstudante;
    }

    public void setNumeroEstudante(String numeroEstudante) {
        this.numeroEstudante = numeroEstudante;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public boolean isCamposValidos() {
        return nome != null && !nome.isBlank()
                && email != null && !email.isBlank()
                && senha != null && !senha.isBlank()
                && numeroEstudante != null && !numeroEstudante.isBlank();
    }

    public boolean isSenhasIguais() {
        return senha != null && senha.equals(confirmarSenha);
    }
}

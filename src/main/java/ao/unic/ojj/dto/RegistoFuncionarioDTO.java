/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ao.unic.ojj.dto;

/**
 *
 * @author kashiki
 */
public class RegistoFuncionarioDTO {

    private String nome;
    private String email;
    private String senha;
    private String confirmarSenha;
    private String departamento;
    private String cargo;
    private String telefone;

    public RegistoFuncionarioDTO() {
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

    public String getDepartamento() {
        return departamento;
    }

    public void setDepartamento(String departamento) {
        this.departamento = departamento;
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
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
                && departamento != null && !departamento.isBlank()
                && cargo != null && !cargo.isBlank();
    }

    public boolean isSenhasIguais() {
        return senha != null && senha.equals(confirmarSenha);
    }
}

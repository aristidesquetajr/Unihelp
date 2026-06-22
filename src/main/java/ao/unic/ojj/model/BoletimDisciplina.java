package ao.unic.ojj.model;

public class BoletimDisciplina {

    private final String disciplina;
    private final String codigo;
    private final Double avaliacao;
    private final Double exame;
    private final Double recurso;
    private final Double media;

    public BoletimDisciplina(String disciplina, String codigo, Double avaliacao,
            Double exame, Double recurso, Double media) {
        this.disciplina = disciplina;
        this.codigo = codigo;
        this.avaliacao = avaliacao;
        this.exame = exame;
        this.recurso = recurso;
        this.media = media;
    }

    public String getDisciplina() {
        return disciplina;
    }

    public String getCodigo() {
        return codigo;
    }

    public Double getAvaliacao() {
        return avaliacao;
    }

    public Double getExame() {
        return exame;
    }

    public Double getRecurso() {
        return recurso;
    }

    public Double getMedia() {
        return media;
    }

    public boolean isAprovado() {
        return media != null && media >= 10.0;
    }
}

package ao.unic.ojj.model;

import java.util.List;

public class BoletimPeriodo {

    private final String legenda;
    private final int totalNotas;
    private final List<BoletimDisciplina> disciplinas;

    public BoletimPeriodo(String legenda, int totalNotas, List<BoletimDisciplina> disciplinas) {
        this.legenda = legenda;
        this.totalNotas = totalNotas;
        this.disciplinas = disciplinas;
    }

    public String getLegenda() {
        return legenda;
    }

    public int getTotalNotas() {
        return totalNotas;
    }

    public List<BoletimDisciplina> getDisciplinas() {
        return disciplinas;
    }
}

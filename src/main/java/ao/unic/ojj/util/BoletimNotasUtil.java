package ao.unic.ojj.util;

import ao.unic.ojj.dto.NotaDetalheDTO;
import ao.unic.ojj.model.BoletimDisciplina;
import ao.unic.ojj.model.BoletimPeriodo;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public final class BoletimNotasUtil {

    private BoletimNotasUtil() {
    }

    public static List<BoletimPeriodo> agruparPorPeriodoEDisciplina(List<NotaDetalheDTO> notas) {
        Map<String, List<NotaDetalheDTO>> notasPorPeriodo = notas.stream()
                .collect(Collectors.groupingBy(
                        BoletimNotasUtil::legendaPeriodo,
                        LinkedHashMap::new,
                        Collectors.toList()
                ));

        List<BoletimPeriodo> periodos = new ArrayList<>();
        for (Map.Entry<String, List<NotaDetalheDTO>> periodoEntry : notasPorPeriodo.entrySet()) {
            periodos.add(new BoletimPeriodo(
                    periodoEntry.getKey(),
                    periodoEntry.getValue().size(),
                    agruparDisciplinas(periodoEntry.getValue())
            ));
        }
        return periodos;
    }

    public static double mediaGeral(List<BoletimPeriodo> periodos) {
        return linhas(periodos).stream()
                .mapToDouble(BoletimDisciplina::getMedia)
                .average()
                .orElse(0);
    }

    public static long contarDisciplinas(List<BoletimPeriodo> periodos) {
        return linhas(periodos).size();
    }

    public static long contarEmRisco(List<BoletimPeriodo> periodos) {
        return linhas(periodos).stream()
                .filter(linha -> !linha.isAprovado())
                .count();
    }

    public static List<String> listarDisciplinas(List<NotaDetalheDTO> notas) {
        return notas.stream()
                .map(NotaDetalheDTO::getNomeDisciplina)
                .filter(nome -> nome != null && !nome.isBlank())
                .distinct()
                .sorted()
                .toList();
    }

    private static List<BoletimDisciplina> agruparDisciplinas(List<NotaDetalheDTO> notas) {
        Map<String, List<NotaDetalheDTO>> notasPorDisciplina = notas.stream()
                .collect(Collectors.groupingBy(
                        BoletimNotasUtil::chaveDisciplina,
                        LinkedHashMap::new,
                        Collectors.toList()
                ));

        List<BoletimDisciplina> disciplinas = new ArrayList<>();
        for (List<NotaDetalheDTO> notasDisciplina : notasPorDisciplina.values()) {
            NotaDetalheDTO primeiraNota = notasDisciplina.get(0);
            Double avaliacao = mediaPorTipos(notasDisciplina, "AVALIACAO");
            Double exame = mediaPorTipos(notasDisciplina, "P1", "P2");
            Double recurso = notaSecaPorTipos(notasDisciplina, "ESPECIAL", "RECURSO");

            disciplinas.add(new BoletimDisciplina(
                    primeiraNota.getNomeDisciplina(),
                    primeiraNota.getCodigoDisciplina(),
                    avaliacao,
                    exame,
                    recurso,
                    calcularMediaFinal(avaliacao, exame, recurso)
            ));
        }
        return disciplinas;
    }

    private static List<BoletimDisciplina> linhas(List<BoletimPeriodo> periodos) {
        return periodos.stream()
                .flatMap(periodo -> periodo.getDisciplinas().stream())
                .toList();
    }

    private static String legendaPeriodo(NotaDetalheDTO nota) {
        return nota.getAnoLetivo() + " - " + nota.getSemestre() + ".º semestre";
    }

    private static String chaveDisciplina(NotaDetalheDTO nota) {
        return nota.getNomeDisciplina() + "||" + nota.getCodigoDisciplina();
    }

    private static Double mediaPorTipos(List<NotaDetalheDTO> notas, String... tipos) {
        List<String> tiposPermitidos = List.of(tipos);
        return notas.stream()
                .filter(n -> n.getTipo() != null && tiposPermitidos.contains(n.getTipo().name()))
                .mapToDouble(NotaDetalheDTO::getValor)
                .average()
                .stream()
                .boxed()
                .findFirst()
                .orElse(null);
    }

    private static Double calcularMediaFinal(Double avaliacao, Double provas, Double recurso) {
        if (recurso != null) {
            return recurso;
        }

        double mediaAvaliacao = avaliacao == null ? 0 : avaliacao;
        double mediaProvas = provas == null ? 0 : provas;
        return (mediaAvaliacao * 0.6) + (mediaProvas * 0.4);
    }

    private static Double notaSecaPorTipos(List<NotaDetalheDTO> notas, String... tipos) {
        for (String tipo : tipos) {
            for (NotaDetalheDTO nota : notas) {
                if (nota.getTipo() != null && tipo.equals(nota.getTipo().name())) {
                    return nota.getValor();
                }
            }
        }
        return null;
    }
}

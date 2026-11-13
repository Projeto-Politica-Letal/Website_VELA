# R/prep/prep_analysis.R
# Prepares data for the Análises tab.

prep_analysis_data <- function(core_df) {
  # By state
  by_state <- core_df %>%
    count(uf, regiao, sort = TRUE, name = "n")

  # By macro group
  by_macro_grupo <- core_df %>%
    count(vitima_macro_grupo, tipo_acao, name = "n")

  # By victim group
  by_grupo <- core_df %>%
    count(vitima_tipo_grupo, sort = TRUE, name = "n") %>%
    slice_head(n = 12)

  # By instrument
  by_instrumento <- core_df %>%
    filter(instrumento != "Não informado") %>%
    count(instrumento_agr, sort = TRUE, name = "n") %>%
    slice_head(n = 10)

  # By gender
  by_sexo <- core_df %>%
    filter(sexo != "Não informado") %>%
    count(sexo, tipo_acao, name = "n")

  # By space
  by_espaco <- core_df %>%
    count(espaco, arena, name = "n")

  # By region
  by_regiao <- core_df %>%
    count(regiao, tipo_acao, name = "n")

  list(
    by_state       = by_state,
    by_macro_grupo = by_macro_grupo,
    by_grupo       = by_grupo,
    by_instrumento = by_instrumento,
    by_sexo        = by_sexo,
    by_espaco      = by_espaco,
    by_regiao      = by_regiao
  )
}

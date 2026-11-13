# R/prep/prep_core.R
# Cleans and standardises the raw BAP dataset using the real column names.
# All downstream prep scripts consume the output of prep_core_data().

prep_core_data <- function(raw_df) {
  df <- raw_df %>%
    # ---- Rename to clean snake_case ----------------------------------------
    rename(
      id_evento           = `ID_Evento`,
      id_episodio         = `ID_Episódio`,
      tipo_acao           = `Tipo_ação_vítima`,       # Assassinato / Tentativa / Ameaça
      vitima_nome         = `Vítima_Nome Civil_(Apelido/Nome Social)`,
      sexo                = `Sexo`,                   # Masculino / Feminino / SI
      vitima_posicao      = `Vítima_Posição_Grupo`,
      vitima_tipo_grupo   = `Vítima_Tipo_Grupo`,      # Partido político, Movimento social ...
      vitima_macro_grupo  = `Vítima_Tipo_Macro-Grupo`,# Atores institucionais / Ativistas / Outros
      status_cargo        = `Status_cargo`,
      nivel_cargo         = `Nível_cargo`,
      macro_disputa       = `Macrocategoria_Objeto_da_Disputa`,
      objeto_disputa      = `Objeto_da_Disputa`,
      ano                 = `Ano`,
      mes                 = `Mês`,
      dia                 = `Dia`,
      cidade              = `Cidade`,
      uf                  = `UF`,
      regiao              = `Região`,
      localidade          = `Localidade`,
      localidade_agr      = `Localidade_agregada`,
      espaco              = `Espaço`,
      arena               = `Arena`,
      participante        = `Participante/Cúmplice`,
      mandante            = `Mandante`,
      instrumento         = `Instrumento_1`,
      instrumento_agr     = `Agregado_Instrumento_1`,
      metodo              = `Método_1`
    ) %>%
    # ---- Type coercion -------------------------------------------------------
    mutate(
      ano    = suppressWarnings(as.integer(ano)),
      mes    = suppressWarnings(as.integer(mes)),
      dia    = suppressWarnings(as.integer(dia)),
      cidade = str_squish(cidade),
      uf     = str_squish(uf)
    ) %>%
    # ---- Standardise "SI" / NA to "Não informado" ----------------------------
    mutate(across(
      c(sexo, vitima_posicao, vitima_tipo_grupo, vitima_macro_grupo,
        status_cargo, nivel_cargo, macro_disputa, objeto_disputa,
        localidade, espaco, arena, instrumento, instrumento_agr, metodo,
        mandante, participante),
      ~ if_else(is.na(.) | str_squish(.) %in% c("SI", ""), "Não informado", str_squish(.))
    )) %>%
    # ---- Build event date ----------------------------------------------------
    mutate(
      mes = if_else(mes >= 1L & mes <= 12L, mes, NA_integer_),
      data_evento = case_when(
        !is.na(ano) & !is.na(mes) & !is.na(dia) ~ make_date(ano, mes, dia),
        !is.na(ano) & !is.na(mes)               ~ make_date(ano, mes, 1L),
        !is.na(ano)                              ~ make_date(ano, 1L, 1L),
        TRUE                                     ~ as.Date(NA)
      ),
      ano_mes = format(data_evento, "%Y-%m")
    ) %>%
    filter(!is.na(ano)) %>%
    mutate(case_id = row_number())

  df
}

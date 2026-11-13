# R/prep/prep_map.R
# Prepares the map dataset and extracts the unique filter values used in the
# map sidebar. Expects core_df to already have lat/lon columns from geocoding.

prep_map_data <- function(core_df) {

  # Colour palette by tipo_acao (three categories) — paleta oficial VELA
  pal_colors <- vela_tipo_colors()

  points <- core_df %>%
    filter(!is.na(lat), !is.na(lon)) %>%
    mutate(
      color = dplyr::recode(tipo_acao, !!!pal_colors, .default = vela_colors()$cinza_cl),
      # Popup: readable HTML card shown on marker click
      popup_html = paste0(
        "<div style='font-family:\"DM Sans\",sans-serif;min-width:220px'>",
        "<p style='margin:0 0 6px;font-size:1rem;font-weight:700;color:", vela_colors()$vinho, "'>",
          tipo_acao, "</p>",
        "<p style='margin:0 0 4px'><b>Ano:</b> ", ano,
          if_else(!is.na(mes), paste0(" / Mês: ", mes), ""), "</p>",
        "<p style='margin:0 0 4px'><b>Local:</b> ", cidade, " – ", uf, " (", regiao, ")</p>",
        "<p style='margin:0 0 4px'><b>Vítima (grupo):</b> ", vitima_tipo_grupo, "</p>",
        "<p style='margin:0 0 4px'><b>Vítima (macro):</b> ", vitima_macro_grupo, "</p>",
        "<p style='margin:0 0 4px'><b>Sexo:</b> ", sexo, "</p>",
        "<p style='margin:0 0 4px'><b>Instrumento:</b> ", instrumento, "</p>",
        "<p style='margin:0 0 4px'><b>Espaço:</b> ", espaco, " / ", arena, "</p>",
        if_else(mandante != "Não informado",
                paste0("<p style='margin:0 0 4px'><b>Mandante:</b> ", mandante, "</p>"),
                ""),
        "</div>"
      )
    )

  # Filter option lists for the sidebar
  filters <- list(
    years        = range(points$ano, na.rm = TRUE),
    tipo_acao    = sort(unique(points$tipo_acao)),
    vitima_macro = sort(unique(points$vitima_macro_grupo)),
    vitima_grupo = sort(unique(points$vitima_tipo_grupo)),
    sexo         = sort(unique(points$sexo)),
    uf           = sort(unique(points$uf)),
    regiao       = sort(unique(points$regiao)),
    instrumento  = sort(unique(points$instrumento))
  )

  list(points = points, filters = filters, pal_colors = pal_colors)
}

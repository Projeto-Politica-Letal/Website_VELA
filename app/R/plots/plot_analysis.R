# R/plots/plot_analysis.R

plot_analysis_states <- function(df) {
  plot_ly(
    data = df %>% arrange(n),
    x = ~n, y = ~reorder(uf, n),
    type = "bar", orientation = "h",
    marker = list(color = vela_colors()$vinho)
  ) %>%
    layout(
      xaxis = list(title = "Casos"),
      yaxis = list(title = ""),
      paper_bgcolor = "transparent", plot_bgcolor = "transparent",
      font = list(color = vela_colors()$offwhite)
    )
}

plot_analysis_instrumento <- function(df) {
  plot_ly(
    data = df %>% arrange(n),
    x = ~n, y = ~reorder(instrumento_agr, n),
    type = "bar", orientation = "h",
    marker = list(color = vela_colors()$dourado)
  ) %>%
    layout(
      xaxis = list(title = "Casos"),
      yaxis = list(title = ""),
      paper_bgcolor = "transparent", plot_bgcolor = "transparent",
      font = list(color = vela_colors()$offwhite)
    )
}

plot_analysis_sexo <- function(df) {
  colors_tipo <- vela_tipo_colors()
  plot_ly(
    data = df, x = ~sexo, y = ~n, color = ~tipo_acao,
    colors = colors_tipo, type = "bar"
  ) %>%
    layout(
      barmode = "stack",
      xaxis   = list(title = ""),
      yaxis   = list(title = "Casos"),
      paper_bgcolor = "transparent", plot_bgcolor = "transparent",
      font = list(color = vela_colors()$offwhite)
    )
}

plot_analysis_grupo <- function(df) {
  plot_ly(
    data = df %>% arrange(n),
    x = ~n, y = ~reorder(vitima_tipo_grupo, n),
    type = "bar", orientation = "h",
    marker = list(color = vela_colors()$cinza_cl)
  ) %>%
    layout(
      xaxis = list(title = "Casos"),
      yaxis = list(title = ""),
      paper_bgcolor = "transparent", plot_bgcolor = "transparent",
      font = list(color = vela_colors()$offwhite)
    )
}

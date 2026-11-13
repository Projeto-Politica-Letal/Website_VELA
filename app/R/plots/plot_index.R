# R/plots/plot_index.R

plot_index_annual <- function(df) {
  # Stacked bar by tipo_acao
  colors <- vela_tipo_colors()
  plot_ly(
    data = df, x = ~ano, y = ~n, color = ~tipo_acao,
    colors = colors, type = "bar"
  ) %>%
    layout(
      barmode = "stack",
      xaxis   = list(title = "", tickformat = "d"),
      yaxis   = list(title = "Casos"),
      legend  = list(orientation = "h", y = -0.2),
      paper_bgcolor = "transparent", plot_bgcolor = "transparent",
      font = list(color = vela_colors()$offwhite)
    )
}

plot_index_top_states <- function(df) {
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

plot_index_grupos <- function(df) {
  plot_ly(
    data = df %>% arrange(n),
    x = ~n, y = ~reorder(vitima_tipo_grupo, n),
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

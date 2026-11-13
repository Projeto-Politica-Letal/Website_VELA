# R/plots/plot_timeline.R
# Gráficos de linha no estilo do Figma (fundo creme, linhas finas).

plot_timeline_annual <- function(annual_series, annual_by_tipo, term_lookup) {
  ink   <- "#2b2b2b"
  tipos <- sort(unique(as.character(annual_by_tipo$tipo_acao)))

  p <- plot_ly()
  for (tipo in tipos) {
    sub <- annual_by_tipo[as.character(annual_by_tipo$tipo_acao) == tipo, ]
    col <- vela_tipo_col(tipo)
    # No Figma a linha de ameaças é branca; um contorno cinza ajuda a enxergar no fundo creme.
    p <- add_trace(
      p, data = sub, x = ~ano, y = ~n,
      type = "scatter", mode = "lines+markers", name = tipo,
      line   = list(color = col, width = 1.3),
      marker = list(color = col, size = 7, line = list(width = 1, color = "#cfcfcf"))
    )
  }

  # Linhas verticais no início de cada mandato, com o nome no topo
  xs     <- term_lookup$start_year - 0.5
  shapes <- lapply(xs, function(x) list(
    type = "line", xref = "x", yref = "paper", x0 = x, x1 = x, y0 = 0, y1 = 1,
    line = list(color = "rgba(0,0,0,0.12)", width = 1)
  ))
  notes <- lapply(seq_along(xs), function(i) list(
    x = xs[i], y = 1, xref = "x", yref = "paper", showarrow = FALSE,
    text = toupper(term_lookup$label[i]), xanchor = "left", yanchor = "bottom",
    font = list(size = 9, color = ink)
  ))

  p %>% layout(
    shapes = shapes, annotations = notes,
    xaxis  = list(title = "", tickformat = "d", showgrid = FALSE, zeroline = FALSE, tickfont = list(size = 10)),
    yaxis  = list(title = "", showgrid = FALSE, zeroline = FALSE, rangemode = "tozero", tickfont = list(size = 10)),
    legend = list(orientation = "h", x = 0, y = -0.15, font = list(size = 11)),
    margin = list(t = 40, l = 40, r = 10, b = 60),
    paper_bgcolor = "transparent", plot_bgcolor = "transparent",
    font = list(color = ink)
  )
}

plot_timeline_cumulative <- function(annual_series) {
  rust <- "#7b2f31"
  plot_ly(
    data = annual_series, x = ~ano, y = ~cum_n,
    type = "scatter", mode = "lines+markers",
    line   = list(color = rust, width = 1.3),
    marker = list(color = rust, size = 7)
  ) %>%
    layout(
      xaxis = list(title = "", tickformat = "d", showgrid = FALSE, zeroline = FALSE, tickfont = list(size = 10)),
      yaxis = list(title = "", showgrid = FALSE, zeroline = FALSE, rangemode = "tozero", tickfont = list(size = 10)),
      margin = list(t = 20, l = 40, r = 10, b = 40),
      paper_bgcolor = "transparent", plot_bgcolor = "transparent",
      font = list(color = "#2b2b2b")
    )
}

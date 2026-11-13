# R/plots/plot_map.R
# Mapa interativo (plotly scattergeo) no estilo do Figma:
# fundo escuro, contorno branco dos 27 estados e pontos coloridos por tipo de ação.
# Os contornos vêm de data/brasil_estados.csv (não precisa de sf nem geobr).

.vela_br_estados <- tryCatch(
  utils::read.csv("data/brasil_estados.csv"),
  error = function(e) { message("data/brasil_estados.csv não encontrado: mapa sem contorno dos estados."); NULL }
)

# Cor de cada tipo de ação (Figma): assassinato = ferrugem, tentativa = dourado, ameaça = verde.
vela_tipo_col <- function(x) {
  k <- tolower(as.character(x))
  ifelse(grepl("amea", k), "#4f9a3a",
         ifelse(grepl("tent", k), "#c28106", "#902f0e"))
}

plot_map_points <- function(df, pal_colors = NULL) {
  lv   <- sort(unique(as.character(df$tipo_acao)))
  cols <- if (length(lv) > 0) stats::setNames(vela_tipo_col(lv), lv) else NULL
  
  p <- plot_ly()
  
  # 1) contorno dos estados (embaixo dos pontos)
  if (!is.null(.vela_br_estados)) {
    p <- add_trace(
      p, type = "scattergeo", mode = "lines",
      lon = .vela_br_estados$lon, lat = .vela_br_estados$lat,
      line = list(color = "#ffffff", width = 1),
      hoverinfo = "skip", showlegend = FALSE
    )
  }
  
  # 2) pontos
  p <- add_trace(
    p, data = df, type = "scattergeo", mode = "markers",
    lat = ~lat, lon = ~lon,
    color = ~tipo_acao, colors = cols,
    marker = list(size = 9, opacity = 1, line = list(width = 1, color = "#ffffff")),
    text = ~paste0(
      "<b>", tipo_acao, "</b><br>",
      cidade, " – ", uf, "<br>",
      "Ano: ", ano, "<br>",
      "Vítima: ", vitima_tipo_grupo, "<br>",
      "Sexo: ", sexo, "<br>",
      "Instrumento: ", instrumento
    ),
    hoverinfo = "text"
  )
  
  p %>% layout(
    geo = list(
      scope          = "south america",
      showland       = FALSE, showocean = FALSE, showlakes = FALSE,
      showcoastlines = FALSE, showcountries = FALSE,
      showframe      = FALSE,
      bgcolor        = "rgba(0,0,0,0)",
      center         = list(lat = -14.2, lon = -51.9),
      projection     = list(type = "mercator", scale = 1),
      lataxis        = list(range = c(-34, 6), fixedrange = TRUE),
      lonaxis        = list(range = c(-75, -33), fixedrange = TRUE)
    ),
    showlegend    = FALSE,
    paper_bgcolor = "rgba(0,0,0,0)",
    font          = list(color = "#f7f5f0"),
    margin        = list(l = 0, r = 0, t = 0, b = 0)
  )
}
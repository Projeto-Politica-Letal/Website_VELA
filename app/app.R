# app.R (versão pública: Monitor + gráficos, lê monitor_data.rds)
source("global.R")
source("R/ui_vela.R")

vela_fmt <- function(x) format(round(as.numeric(x)), big.mark = ".", decimal.mark = ",", scientific = FALSE)

# Ranking de cidades e total, calculados em scripts/exporta_monitor.R
rank_cidades <- app_data$rank_cidades
n_total      <- app_data$n_total

# ==============================================================================
# SEÇÃO MONITOR (mapa + filtros)
# ==============================================================================
vela_monitor <- function() {
  f <- app_data$map$filters
  tags$section(
    id = "monitor", class = "vela-monitor",
    div(class = "vela-wrap",
        h2("Monitor"),
        span(class = "vela-tag", "[Última atualização 14 09 2026]"),
        div(class = "vela-monitor__grid",
            div(class = "vela-filters",
                h3("Filtros"),
                sliderInput("mapa_anos", "Período", min = f$years[1], max = f$years[2],
                            value = f$years, step = 1L, sep = ""),
                checkboxGroupInput("mapa_tipo", "Tipo de violência política letal",
                                   choices = f$tipo_acao, selected = f$tipo_acao),
                selectInput("mapa_uf",     "Estado (UF)", choices = c("Todos" = "all", f$uf)),
                selectInput("mapa_regiao", "Região",      choices = c("Todas" = "all", f$regiao)),
                selectInput("mapa_macro",  "Vítima",      choices = c("Todos" = "all", f$vitima_macro)),
                selectInput("mapa_sexo",   "Sexo",        choices = c("Todos" = "all", f$sexo)),
                div(class = "vela-count", textOutput("mapa_n_casos"))
            ),
            plotlyOutput("mapa_principal", height = "640px")
        ),
        div(class = "vela-legend",
            span(class = "a", "Assassinato"),
            span(class = "t", "Tentativa de assassinato"),
            span(class = "m", "Ameaça de assassinato"))
    )
  )
}

# ==============================================================================
# SEÇÃO GRÁFICOS (fundo creme)
# ==============================================================================
vela_charts <- function() {
  maxv <- max(rank_cidades$n)
  tags$section(
    id = "graficos", class = "vela-charts",
    div(class = "vela-wrap",
        div(class = "vela-charts__intro",
            h2("Conheça os principais dados sobre a violência política letal no Brasil"),
            p("Os gráficos abaixo apresentam análises produzidas pela equipe do VELA com base nos dados sistematizados")),
        div(class = "vela-chart",
            h3("Letalidade política por período eleitoral"),
            plotlyOutput("tl_annual", height = 380)),
        div(class = "vela-chart",
            h3("Acumulado de Eventos"),
            plotlyOutput("tl_cumulative", height = 380)),
        div(class = "vela-chart",
            h3("Cidades mais violentas para políticos e ativistas"),
            tags$ol(class = "vela-rank",
                    lapply(seq_len(nrow(rank_cidades)), function(i) {
                      r <- rank_cidades[i, ]
                      tags$li(
                        span(class = "pos", i),
                        div(class = "bar", style = sprintf("width:%.1f%%", 100 * r$n / maxv),
                            span(sprintf("%s (%s)", r$cidade, r$uf)), tags$b(r$n)))
                    })),
            p(class = "vela-chart__note", paste0("n = ", vela_fmt(n_total))))
    )
  )
}

# ==============================================================================
# UI (sem login, para o iframe ser público)
# ==============================================================================
ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    vela_head()   # fontes + vela.css
  ),
  div(class = "vela-page",
      vela_monitor(),
      vela_charts()
  )
)

# ==============================================================================
# SERVER
# ==============================================================================
# Deixa os gráficos do plotly transparentes e com a fonte do site
vela_plotly <- function(p, mode = c("light", "dark")) {
  mode <- match.arg(mode)
  ink  <- if (mode == "light") "#2b2b2b" else "#f7f5f0"
  p %>%
    plotly::layout(
      paper_bgcolor = "rgba(0,0,0,0)", plot_bgcolor = "rgba(0,0,0,0)",
      font = list(family = "Space Grotesk, sans-serif", color = ink)
    ) %>%
    plotly::config(displayModeBar = FALSE, scrollZoom = TRUE)
}

server <- function(input, output, session) {

  # ---- Mapa ------------------------------------------------------------------
  mapa_data <- reactive({
    req(app_data$map$points, input$mapa_anos)
    req(length(input$mapa_anos) == 2)
    df <- app_data$map$points %>%
      dplyr::filter(ano >= input$mapa_anos[1], ano <= input$mapa_anos[2])
    if (length(input$mapa_tipo) > 0)
      df <- dplyr::filter(df, tipo_acao %in% input$mapa_tipo)
    if (!is.null(input$mapa_uf)     && input$mapa_uf     != "all")
      df <- dplyr::filter(df, uf == input$mapa_uf)
    if (!is.null(input$mapa_regiao) && input$mapa_regiao != "all")
      df <- dplyr::filter(df, regiao == input$mapa_regiao)
    if (!is.null(input$mapa_macro)  && input$mapa_macro  != "all")
      df <- dplyr::filter(df, vitima_macro_grupo == input$mapa_macro)
    if (!is.null(input$mapa_sexo)   && input$mapa_sexo   != "all")
      df <- dplyr::filter(df, sexo == input$mapa_sexo)
    df
  })

  output$mapa_n_casos <- renderText(paste0(fmt_n(nrow(mapa_data())), " casos exibidos"))

  output$mapa_principal <- renderPlotly({
    plot_map_points(mapa_data(), app_data$map$pal_colors) %>% vela_plotly("dark")
  })

  # ---- Gráficos --------------------------------------------------------------
  output$tl_annual <- renderPlotly({
    req(app_data$timeline$annual_series, app_data$timeline$annual_by_tipo, app_data$timeline$term_lookup)
    plot_timeline_annual(app_data$timeline$annual_series,
                         app_data$timeline$annual_by_tipo,
                         app_data$timeline$term_lookup) %>% vela_plotly("light")
  })

  output$tl_cumulative <- renderPlotly({
    req(app_data$timeline$annual_series)
    plot_timeline_cumulative(app_data$timeline$annual_series) %>% vela_plotly("light")
  })
}

shinyApp(ui, server)

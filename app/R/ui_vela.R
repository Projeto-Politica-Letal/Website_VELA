# ==========================================================
# ui_vela.R - componentes de interface baseados no Figma
# Todas as funções começam com "vela_" para não conflitar com
# as que já existem no projeto (ex.: make_kpi_card).
# O Shiny carrega automaticamente os arquivos da pasta R/.
# ==========================================================

library(shiny)

# Carrega as fontes e o CSS (colocar uma vez dentro de fluidPage/tagList)
vela_head <- function() {
  tags$head(
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
    tags$link(rel = "preconnect", href = "https://fonts.googleapis.com"),
    tags$link(rel = "preconnect", href = "https://fonts.gstatic.com", crossorigin = NA),
    # Space Grotesk (PT/EN) e Archivo (substituta enquanto não há a licença da Breul Grotesk A)
    tags$link(
      rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700&family=Archivo:wdth,wght@112.5,100..900&display=swap"
    ),
    tags$link(rel = "stylesheet", href = "vela.css")
  )
}

# Trecho com destaque (ferrugem sobre faixa cinza)
vela_hl <- function(...) tags$span(class = "hl", ...)

# Número grande com um bloco cinza atrás de cada dígito
vela_bignum <- function(x, size = c("lg", "xl")) {
  size <- match.arg(size)
  chars <- strsplit(as.character(x), "")[[1]]
  tags$span(
    class = paste0("vela-bignum vela-bignum--", size),
    lapply(chars, function(ch) {
      tags$span(class = if (ch %in% c(".", ",")) "d sep" else "d", ch)
    })
  )
}

# ---------------- Menu ----------------
vela_header <- function(active = "inicio") {
  item <- function(id, label) {
    tags$a(href = paste0("#", id), class = if (id == active) "is-active", label)
  }
  tags$header(
    class = "vela-header",
    div(
      class = "vela-header__in",
      tags$a(
        class = "vela-logo", href = "#inicio",
        span(class = "vela-logo__name", "Vela"),
        span(class = "vela-logo__dot"),
        span(class = "vela-logo__tag", "Observatório da ", tags$b("violência política letal"))
      ),
      tags$nav(
        class = "vela-nav",
        item("inicio", "Início"),
        item("monitor", "Monitor"),
        item("sobre", "Sobre"),
        item("equipe", "Equipe"),
        item("repercussoes", "Repercussões")
      ),
      div(
        class = "vela-lang",
        tags$a(href = "#", class = "is-active", "PT"),
        tags$a(href = "#", title = "Em breve", onclick = "return false;", style = "opacity:.5;", "EN")
      )
    )
  )
}

# ---------------- Início ----------------
# Os valores podem vir do seu data frame (ex.: nrow(dados)) em vez de fixos.
vela_hero <- function(total = "1.228",
                      media = "61,4",
                      assassinatos = 760, tentativas = 358, ameacas = 110,
                      pct_institucionais = "63.1%", pct_ativistas = "35.7%",
                      estados = 27, cidades = 532,
                      anos = c(2003, 2023),
                      olhar = "olhar.png") {

  stat <- function(n, ...) {
    div(class = "vela-stat", vela_bignum(n, "lg"), div(class = "vela-stat__label", ...))
  }
  pct <- function(n, ...) {
    div(class = "vela-pct", div(class = "vela-pct__n", n), div(class = "vela-pct__label", ...))
  }

  tags$section(
    id = "inicio", class = "vela-hero",

    div(
      class = "vela-hero__main",
      vela_bignum(total, "xl"),
      div(class = "vela-hero__label",
          "casos de ", vela_hl("violência política letal"), " no Brasil")
    ),

    p(class = "vela-hero__lead",
      "Ao longo de vinte anos, entre ", tags$b(paste(anos[1], "e", anos[2])),
      ", houve uma média de ", tags$b(media), " casos de ",
      tags$b(vela_hl("violência política letal")), " por ano."),

    div(
      class = "vela-stats",
      stat(assassinatos, "casos de ", vela_hl("assassinatos políticos"), " no Brasil"),
      stat(tentativas,   "casos de ", vela_hl("tentativas de assassinato"), " no Brasil"),
      stat(ameacas,      "casos de ", vela_hl("ameaças de assassinato"), " no Brasil")
    ),

    div(
      class = "vela-pcts",
      pct(pct_institucionais, "dos casos de ", vela_hl("assassinatos políticos"),
          " no Brasil são de ", vela_hl("políticos institucionais")),
      pct(pct_ativistas, "dos casos de ", vela_hl("assassinatos políticos"),
          " no Brasil são de ", vela_hl("ativistas"))
    ),

    # faixa de olhares (imagem única, já pronta)
    tags$img(class = "vela-eyes", src = olhar, alt = "Olhares de vítimas de violência política letal"),

    p(class = "vela-hero__close",
      "Os casos afetaram ", tags$b("todos os ", estados, " estados"),
      " brasileiros e um total de ", tags$strong(cidades, " cidades"), ".")
  )
}

# ---------------- Exemplo de uso no app.R ----------------
# ui <- fluidPage(
#   vela_head(),
#   vela_header(),
#   vela_hero(),
#   # ... Monitor, Gráficos etc. (ver próxima etapa)
# )

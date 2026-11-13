# R/app_theme.R -----------------------------------------------------------
# Tema visual do VELA — Observatório da Violência Política Letal
# Paleta:   2B2B2B (preto) · 3A3A3A (cinza-escuro) · D8D8D8 (cinza-claro)
#           F7F5F0 (off-white) · 7A2F2F (vinho) · B89554 (dourado)
# Tipos:    Space Grotesk (títulos/subtítulos/corpo de destaque)
#           DM Sans (parágrafos, legendas, tabelas e dados)

app_theme <- function() {
  bslib::bs_theme(
    version      = 5,
    base_font    = bslib::font_google("DM Sans"),
    heading_font = bslib::font_google("Space Grotesk"),
    code_font    = bslib::font_google("DM Sans"),

    bg        = "#2B2B2B",  # preto (fundo)
    fg        = "#F7F5F0",  # off-white (texto)
    primary   = "#7A2F2F",  # vinho (destaques, links, abas ativas)
    secondary = "#B89554",  # dourado (acentos secundários)

    "navbar-bg" = "#1E1E1E",
    "border-radius" = "0.9rem"
  ) %>%
    bslib::bs_add_rules("
      .navbar-brand {
        font-family: 'Space Grotesk', sans-serif;
        font-weight: 700;
      }
      .nav-link {
        font-family: 'Space Grotesk', sans-serif;
      }
      .nav-tabs .nav-link.active {
        color: #7A2F2F !important;
        border-bottom: 3px solid #B89554;
      }
    ")
}

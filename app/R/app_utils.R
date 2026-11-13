# R/app_utils.R ----------------------------------------------------------
# Paleta oficial do VELA — use estas funções em vez de hex-codes soltos,
# assim toda mudança de cor futura acontece em um único lugar.
vela_colors <- function() {
  list(
    preto     = "#2B2B2B",
    cinza_esc = "#3A3A3A",
    cinza_cl  = "#D8D8D8",
    offwhite  = "#F7F5F0",
    vinho     = "#7A2F2F",
    dourado   = "#B89554"
  )
}
# Paleta por tipo de ação, usada em vários gráficos (index, timeline, analysis)
vela_tipo_colors <- function() {
  c(
    "Assassinato"               = "#7A2F2F",  # vinho
    "Tentativa de assassinato"  = "#B89554",  # dourado
    "Ameaça de assassinato"     = "#D8D8D8"   # cinza-claro
  )
}
safe_first <- function(x, default = NA) {
  if (length(x) == 0 || all(is.na(x))) return(default)
  x[[1]]
}
fmt_n <- function(x) {
  scales::comma(x, accuracy = 1, big.mark = ".", decimal.mark = ",")
}
make_kpi_card <- function(title, value, subtitle = NULL, featured = FALSE) {
  card_class <- trimws(paste("kpi-card", ifelse(featured, "kpi-card-featured", "")))
  div(
    class = card_class,
    div(class = "kpi-title", title),
    div(class = "kpi-value", value),
    if (!is.null(subtitle)) div(class = "kpi-subtitle", subtitle)
  )
}
null_to_unknown <- function(x, label = "Não informado") {
  x <- as.character(x)
  x[is.na(x) | x == ""] <- label
  x
}
top_n_keep_other <- function(df, var, n = 10, other_label = "Outros") {
  var <- rlang::ensym(var)

  top_levels <- df %>%
    count(!!var, sort = TRUE) %>%
    slice_head(n = n) %>%
    pull(!!var)

  df %>%
    mutate(
      !!var := if_else(!!var %in% top_levels, as.character(!!var), other_label)
    )
}

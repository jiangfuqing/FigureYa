# Auto-generated package installation script
# Extracted from R Markdown file

#install.packages("kableExtra")
require(kableExtra)
if (knitr:::is_html_output()) {
    cn = sub("\n", "<br>", colnames(res))
} else if (knitr:::is_latex_output()) {
    usepackage_latex('makecell')
    usepackage_latex('booktabs')
    cn = linebreak(colnames(res), align="c")
    kable(booktabs = T, escape = F, caption = "Example Table",
        col.names = cn) %>%
    kable_styling(c("striped", "scale_down")) %>%
    group_rows("Gender*", 1, 2) %>% 
    group_rows("Age", 3, 4) %>% 
    group_rows("Stage", 5, 13) %>% 
    footnote(general = "significant",
             #general = paste("P-value =", sg.p), 
             general_title = "*: ", 
             footnote_as_chunk = T, title_format = "italic")

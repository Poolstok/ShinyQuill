library(shiny)
library(bslib)
library(ShinyQuill)

ui <- page_fillable(
  theme = bs_theme(
    version = 5,
    preset="minty"
  ),
  h3("Quill.js WYSIWYG Editor"),
  QuillInput("TextEdit"),
  hr(),
  uiOutput("htmltext")
)

server <- function(input, output, session) {
  bs_themer()
  output$htmltext <- renderUI({
    HTML(input$TextEdit)
  })
}

shinyApp(ui, server)

library(shiny)
library(bslib)
library(ShinyQuill)

ui <- page_fillable(
  theme = bs_theme(
    version = 5,
    preset="minty"
  ),
  h3("Quill.js WYSIWYG Editor"),
  QuillInput(inputId="TextEdit",
             value = "<h1>Hello, <strong>World!</strong></h1>",
             configuration = list(
               placeholder = "Type your text here...",
               theme = "snow",
               modules = list(
                 toolbar = list(
                   list('bold', 'italic', 'underline'),
                   list('link', 'image')
                 )
               )
             )
  ),
  hr(),
  uiOutput("htmltext")
)

server <- function(input, output, session) {
  output$htmltext <- renderUI({
    HTML(input$TextEdit)
  })
}

shinyApp(ui, server)

tryCatch({
    detach("package:ShinyQuill", unload=TRUE)},
    error = function(e) {
        print("Package was not loaded")
    }
)
devtools::document()
devtools::install()

library(shiny)
library(ShinyQuill)

ui <- fluidPage(
    titlePanel("Sandbox App"),
    ShinyQuill::quillInput("editor", "Quill Editor", value = "Hello World!", toolbarOptions = SetQuillOptions(links = TRUE, images = T, videos = T, formulas = T)),
    uiOutput("text")
)

server <- function(input, output, session)
{
    output$text <- renderUI({
        HTML(input$editor)
    })
}

shinyApp(ui = ui, server = server)

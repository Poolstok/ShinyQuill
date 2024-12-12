tryCatch({
    detach("package:ShinyQuill", unload=TRUE)
    print("Package detached. Reinstalling package...")},
    error = function(e) {
        print("Package was not loaded before. Installing package  now...")
    }
)
devtools::document()
devtools::install()

library(shiny)
library(ShinyQuill)

ui <- fluidPage(
    useQuill(),
    titlePanel("Sandbox App"),
    quillInput("editor", "Quill Editor", value = "Hello World!", toolbarOptions = SetQuillOptions(links = TRUE, images = T, videos = T, formulas = T)),
    uiOutput("text")
)

server <- function(input, output, session)
{
    output$text <- renderUI({
        HTML(input$editor)
    })
}

shinyApp(ui = ui, server = server)

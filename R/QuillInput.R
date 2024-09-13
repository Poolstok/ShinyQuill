library(htmltools)
library(reactR)
library(base64enc)

#' Create a Quill Input Widget
#'
#' @param inputId The input ID.
#' @param value The initial value (default is an empty string).
#' @param configuration A list of configuration options passed to the JavaScript component.
#' @param options A list of options (can be empty if not used).
#' @return A Shiny input widget.
#' @export
#' Create a Quill Input Widget
#'
#' @param inputId The input ID.
#' @param value The initial value (default is an empty string).
#' @param configuration A list of configuration options passed to the JavaScript component.
#' @param options A list of options (can be empty if not used).
#' @return A Shiny input widget.
#' @export
QuillInput <- function(inputId, value = "", configuration = NULL, options = NULL) {
  # Ensure value is a character string
  value <- as.character(value)

  # Base64 encode the value to prevent escaping
  encoded_value <- base64encode(charToRaw(value))

  # Include inputId and encoded_value in the configuration
  configuration <- modifyList(
    list(inputId = inputId, encoded_value = encoded_value),
    if (is.null(configuration)) list() else configuration
  )

  createReactShinyInput(
    inputId = inputId,
    class = 'QuillInput',
    dependencies = htmlDependency(
      name = 'ShinyQuill',
      version = '1.0.0',
      src = c(file = 'www/ShinyQuill/QuillInput'),
      script = 'QuillInput.js',
      stylesheet = 'quill.snow.css',
      package = 'ShinyQuill'
    ),
    default = "",  # Set to empty string
    configuration = configuration,  # Pass encoded_value here
    container = htmltools::tags$div
  )
}

#' Update a Quill Input Widget
#'
#' This function updates a Quill input widget for use in Shiny applications.
#' @param session The Shiny session.
#' @param inputId The input ID.
#' @param value The initial value.
#' @param options A list of options passed to Quill.
#' @return A Quill input widget.
#' @export
updateQuillInput <- function(session, inputId, value, configuration = NULL) {
  message <- list(value = value)
  if (!is.null(configuration)) message$configuration <- configuration
  session$sendInputMessage(inputId, message);
}

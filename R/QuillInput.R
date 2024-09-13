#' Create a Quill Input Widget
#'
#' This function creates a Quill input widget for use in Shiny applications.
#'
#' @param inputId The input ID.
#'
#' @return A Quill input widget.
#' @importFrom reactR createReactShinyInput
#' @importFrom htmltools htmlDependency tags
#'
#' @export
QuillInput <- function(inputId, default = "") {
  reactR::createReactShinyInput(
    inputId,
    "QuillInput",
    htmltools::htmlDependency(
      name = "QuillInput",
      version = "1.0.2",
      src = "www/ShinyQuill/QuillInput",
      package = "ShinyQuill",
      script = "QuillInput.js"
    ),
    default,
    list(),
    htmltools::tags$span
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

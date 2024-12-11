includeQuill <- function()
{
  htmltools::htmlDependency(
    name = "includeQuill",
    version = "0.1.0",
    package = "ShinyQuill",
    src = c(href = "https://cdn.jsdelivr.net/npm/quill@2.0.3/dist"),
    script = "quill.js",
    stylesheet = "quill.snow.css"
  )
}

includeCustomFuncs <- function()
{
  htmltools::htmlDependency(
    name = "includeScripts",
    version = "0.1.0",
    package = "ShinyQuill",
    src = "www",
    script = "createQuill.js"
  )
}

CreateStyleArg <- function(width, height, resize = c("vertical", "horizontal", "both"))
{
  style <- paste0("width: ", width,
                  "; height:", height,
                  "; resize:", resize,
                  "; overflow: auto",
                  ";")
  return(style)
}

AddHeaders <- function(options, headers)
{
  if(length(headers) == 0 || is.null(headers)) return(options)

  options <- AddOption(options, list(list(header = headers)))
  return(options)
}

AddOption <- function(optionList, newOption)
{
  optionList[[length(optionList) + 1]] <- newOption
  return(optionList)
}

# TODO: this doesn't properly reflect in the HTML
AddFontBlock <- function(options, fonts, sizes)
{
  if(is.null(fonts) && is.null(sizes)) return(options)

  fontBlock <- list()
  if(!is.null(fonts)) fontBlock <- AddOption(fontBlock, list(font = fonts))
  if(!is.null(sizes)) fontBlock <- AddOption(fontBlock, list(size = sizes))

  options <- c(options, fontBlock)
  return(options)
}

AddTextDecorations <- function(options, bold, italic, underline, strike)
{
  decoOptions <- list()
  if(bold) decoOptions <- c(decoOptions, "bold")
  if(italic) decoOptions <- c(decoOptions, "italic")
  if(underline) decoOptions <- c(decoOptions, "underline")
  if(strike) decoOptions <- c(decoOptions, "strike")

  if(length(decoOptions) == 0) return(options)

  options <- AddOption(options, decoOptions)
  return(options)
}

AddColors <- function(options, colors, backgrounds)
{
  if(is.null(colors) && is.null(backgrounds)) return(options)

  colorBlock <- list()
  if(!is.null(colors))      colorBlock <- AddOption(colorBlock, list(color = colors))
  if(!is.null(backgrounds)) colorBlock <- AddOption(colorBlock, list(background = backgrounds))
  options <- AddOption(options, colorBlock)
  return(options)
}

AddIndentedElements <- function(options, listTypes, indent, unIndent)
{
  indentOptions <- list()
  for(type in listTypes)
  {
    indentOptions <- AddOption(indentOptions, list(list = type))
  }

  if(indent) indentOptions <- AddOption(indentOptions, list(indent = "+1"))
  if(unIndent) indentOptions <- AddOption(indentOptions, list(indent = "-1"))

  if(length(indentOptions) == 0) return(options)
  options <- AddOption(options, indentOptions)
  return(options)
}

AddSmallTexts <- function(options, subscript, superscript)
{
  smallOptions <- list()
  if(subscript) smallOptions <- AddOption(smallOptions, list(script = "sub"))
  if(superscript) smallOptions <- AddOption(smallOptions, list(script = "super"))

  if(length(smallOptions) == 0) return(options)
  options <- AddOption(options, smallOptions)
  return(options)
}

AddBlocks <- function(options, codeBlock, quoteBlock)
{
  blockOptions <- list()
  if(codeBlock) blockOptions <- AddOption(blockOptions, "code-block")
  if(quoteBlock) blockOptions <- AddOption(blockOptions, "blockquote")
  if(length(blockOptions) == 0) return(options)
  options <- AddOption(options, blockOptions)
  return(options)
}

# Bhuddist monks & jedis hate this function.
AddAttachments <- function(options, links, images, videos, formulas)
{
  attachOptions <- list()
  if(links) attachOptions <- AddOption(attachOptions, "link")
  if(images) attachOptions <- AddOption(attachOptions, "image")
  if(videos) attachOptions <- AddOption(attachOptions, "video")
  if(formulas) attachOptions <- AddOption(attachOptions, "formula")

  if(length(attachOptions) == 0) return(options)
  options <- AddOption(options, attachOptions)
  return(options)
}

#' @export
SetQuillOptions <- function(
    enableToolbar = TRUE,

    headers = list(1, 2, 3, FALSE),

    fonts = NULL, # Use a list if you want to use custom fonts
    sizes = NULL, # Use a list if you want to use custom sizes

    bold = TRUE,
    italic = TRUE,
    underline = TRUE,
    strikethrough = FALSE,

    colors = list(),
    backgrounds = list(),

    lists = c("ordered"), # options: bullet, ordered // bullet does not work properly for some reason (also not in base Quill?)

    subScript = TRUE,
    superScript = TRUE,

    blockQuote = FALSE,
    codeBlock = FALSE,

    indent = FALSE,
    unIndent = FALSE,

    links = TRUE,
    images = FALSE,
    videos = FALSE,
    formulas = FALSE
  )
{
  if(!enableToolbar)
  {
    return(jsonlite::toJSON(FALSE, auto_unbox = TRUE))
  }
  opts <- list()
  opts <- AddHeaders(opts, headers)
  opts <- AddFontBlock(opts, fonts, sizes)
  opts <- AddTextDecorations(opts, bold, italic, underline, strikethrough)
  opts <- AddColors(opts, colors, backgrounds)
  opts <- AddIndentedElements(opts, lists, indent, unIndent)
  opts <- AddSmallTexts(opts, subScript, superScript)
  opts <- AddBlocks(opts, codeBlock, blockQuote)
  opts <- AddAttachments(opts, links, images, videos, formulas)

  toolbarJSON <- jsonlite::toJSON(opts, auto_unbox = TRUE)

  return(toolbarJSON)
}

#' @export
quillInput <- function(id, label,
                       value = "", width = "100%", height = "150px", resize = "vertical",
                       toolbarOptions = SetQuillOptions(),
                       toolbarContainerId = NULL,
                       ...)
{
  style <- CreateStyleArg(width, height, resize)

  return(
    tagList(
      includeQuill(),
      includeCustomFuncs(),
      tags$label(label),
      tags$div(id = id, style = style),
      tags$script(HTML(sprintf("
        $(document).on('shiny:connected', function() {
          CreateQuill('%s', '%s', '%s');
        });", id, value, toolbarOptions)))
    )
  )
}

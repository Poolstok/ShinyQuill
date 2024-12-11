function CreateQuill(id, value, toolbarOptions) {
  const element = document.getElementById(id);
  console.log(toolbarOptions)

  if(typeof toolbarOptions === "string")
  {
    try {
      toolbarOptions = JSON.parse(toolbarOptions);
    }
    catch (e) {
      console.error("Unable to parse:", toolbarOptions);
      toolbarOptions = false;
    }
  }

  const editor = new Quill(element, {
    theme: 'snow',
    modules: {
      toolbar: toolbarOptions
    }
  });

  editor.clipboard.dangerouslyPasteHTML(value);
  // Ensure that shiny input is registered with existing content as value
  Shiny.setInputValue(id, value);

  editor.on("text-change", () => {
    Shiny.setInputValue(id, editor.root.innerHTML);
  });
}

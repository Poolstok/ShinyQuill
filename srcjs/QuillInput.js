// index.jsx
import React, { useEffect, useRef } from 'react';
import { reactShinyInput } from 'reactR';
import ReactQuill from 'react-quill';
import 'react-quill/dist/quill.snow.css'; // Import Quill's CSS

// Function to decode Base64 strings
function decodeBase64(str) {
  try {
    return atob(str);
  } catch (e) {
    console.error('Base64 decoding failed:', e);
    return '';
  }
}

const QuillInput = ({ configuration, setValue }) => {
  const editorRef = useRef(null);

  // Destructure configuration with defaults
  const {
    modules = {
      toolbar: [
        [{ header: [1, 2, false] }],
        ['bold', 'italic', 'underline'],
        ['link', 'image'],
        ['clean'],
      ],
    },
    formats = [
      'header',
      'bold',
      'italic',
      'underline',
      'link',
      'image',
      'clean',
    ],
    theme = 'snow',
    placeholder = 'Compose an epic...',
    inputId = null,
    encoded_value = "",  // Get the encoded_value from configuration
  } = configuration || {};

  // Set initial content using decoded HTML
  useEffect(() => {
    const editor = editorRef.current && editorRef.current.getEditor();
    if (editor && encoded_value) {
      // Decode the Base64 value to get the original HTML
      const decodedHTML = decodeBase64(encoded_value);
      console.log('Decoded HTML:', decodedHTML);

      // Convert the HTML string to Delta
      const delta = editor.clipboard.convert(decodedHTML);

      // Get current content as Delta
      const currentDelta = editor.getContents();

      // Compare and set content if different
      if (JSON.stringify(currentDelta) !== JSON.stringify(delta)) {
        editor.setContents(delta, 'silent'); // 'silent' to prevent triggering onChange
      }
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [encoded_value]);

  // Handle changes in the editor and send them back to Shiny
  const handleChange = (content, delta, source, editor) => {
    setValue(content);
  };

  return (
    <div id={inputId}>
      <ReactQuill
        ref={editorRef}
        onChange={handleChange}
        modules={modules}
        formats={formats}
        theme={theme}
        placeholder={placeholder}
        // Do not include 'value' or 'defaultValue' props to avoid conflicts
      />
    </div>
  );
};

reactShinyInput('.QuillInput', 'ShinyQuill.QuillInput', QuillInput);

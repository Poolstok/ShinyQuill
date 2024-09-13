// index.jsx
import React from 'react';
import { reactShinyInput } from 'reactR';
import ReactQuill from 'react-quill';
import 'react-quill/dist/quill.snow.css'; // Import Quill's CSS

const QuillInput = ({ configuration, value, setValue }) => {
  // You can pass additional configurations through the `configuration` prop
  const modules = configuration.modules || {
    toolbar: [
      [{ header: [1, 2, false] }],
      ['bold', 'italic', 'underline'],
      ['image', 'code-block'],
    ],
  };

  const formats = configuration.formats || [
    'header',
    'bold',
    'italic',
    'underline',
    'image',
    'code-block',
  ];

  const theme = configuration.theme || 'snow';

  const placeholder = configuration.placeholder || 'Compose an epic...';

  return (
    <ReactQuill
      value={value}
      onChange={setValue}
      modules={modules}
      formats={formats}
      theme={theme}
      placeholder={placeholder}
    />
  );
};

reactShinyInput('.QuillInput', 'ShinyQuill.QuillInput', QuillInput);

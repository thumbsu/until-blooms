import React, { useRef, useEffect } from 'react';

const src = 'https://utteranc.es';

const Comment = () => {
  const containerRef = useRef(null);

  useEffect(() => {
    const comment = document.createElement('script');
    const attributes = {
      src: `${src}/client.js`,
      repo: "thumbsu/until-blooms",
      'issue-term': 'title',
      label: 'comment',
      theme: 'github-dark-orange',
      crossOrigin: 'anonymous',
      async: 'true',
    };
    Object.entries(attributes).forEach(([key, value]) => {
      comment.setAttribute(key, value);
    });
    containerRef.current.appendChild(comment);
  }, []);

  return <div ref={containerRef} />;
};

export default Comment;
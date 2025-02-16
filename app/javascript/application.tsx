import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './components/App';

// Setup HMR
if (process.env.NODE_ENV === 'development') {
  const eventSource = new EventSource('http://localhost:8082/esbuild');
  eventSource.onmessage = () => {
    window.location.reload();
  };
}

// Mount React app
const container = document.getElementById('root');
if (container) {
  const root = createRoot(container);
  root.render(
    <React.StrictMode>
      <App />
    </React.StrictMode>
  );
} 
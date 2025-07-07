import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

const API_BASE_URL = 'http://localhost:4000/api';

function App() {
  const [originalUrl, setOriginalUrl] = useState('');
  const [urls, setUrls] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchUrls();
  }, []);

  const fetchUrls = async () => {
    try {
      const response = await axios.get(`${API_BASE_URL}/urls`);
      setUrls(response.data.data);
    } catch (err) {
      console.error('Error fetching URLs:', err);
    }
  };

  const shortenUrl = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const response = await axios.post(`${API_BASE_URL}/urls`, {
        url: { original_url: originalUrl }
      });
      
      setUrls([response.data.data, ...urls]);
      setOriginalUrl('');
    } catch (err) {
      setError(err.response?.data?.errors?.original_url?.[0] || 'Failed to shorten URL');
    } finally {
      setLoading(false);
    }
  };

  const copyToClipboard = (url) => {
    navigator.clipboard.writeText(url);
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>URL Shortener</h1>
        
        <form onSubmit={shortenUrl} className="url-form">
          <input
            type="url"
            value={originalUrl}
            onChange={(e) => setOriginalUrl(e.target.value)}
            placeholder="Enter URL to shorten"
            required
            className="url-input"
          />
          <button type="submit" disabled={loading} className="shorten-btn">
            {loading ? 'Shortening...' : 'Shorten'}
          </button>
        </form>

        {error && <div className="error">{error}</div>}

        <div className="urls-container">
          <h2>Your Shortened URLs</h2>
          {urls.map((url) => (
            <div key={url.id} className="url-card">
              <div className="url-info">
                <div className="original-url">
                  <strong>Original:</strong> {url.original_url}
                </div>
                <div className="short-url">
                  <strong>Short:</strong> 
                  <a href={url.short_url} target="_blank" rel="noopener noreferrer">
                    {url.short_url}
                  </a>
                  <button 
                    onClick={() => copyToClipboard(url.short_url)}
                    className="copy-btn"
                  >
                    Copy
                  </button>
                </div>
                <div className="clicks">
                  <strong>Clicks:</strong> {url.clicks}
                </div>
              </div>
            </div>
          ))}
        </div>
      </header>
    </div>
  );
}

export default App;
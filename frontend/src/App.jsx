import { useState, useEffect } from 'react';
import './App.css';           // ← import your CSS
import logo from './assets/serverli-logo.jpg';
export default function App() {
  const API = import.meta.env.VITE_API_URL;
  const [optionsMap, setOptionsMap]       = useState({});
  const [assumption, setAssumption]       = useState('');
  const [streamOptions, setStreamOptions] = useState([]);
  const [streamCount, setStreamCount]     = useState('');
  const [result, setResult]               = useState(null);
  const [error, setError]                 = useState('');
  useEffect(() => {
    fetch(`${API}/api/options`)
      .then(res => res.json())
      .then(setOptionsMap)
      .catch(() => setError('Failed to load options'));
  }, []);

  useEffect(() => {
    if (assumption && optionsMap[assumption]) {
      setStreamOptions(optionsMap[assumption]);
      setStreamCount('');
      setResult(null);
      setError('');
    }
  }, [assumption, optionsMap]);

  const handleCalculate = async () => {
    setError(''); setResult(null);
    try {
      const res = await fetch(
        `${API}/api/size?assumption=${assumption}&streams=${streamCount}`
      );
      if (!res.ok) throw new Error();
      const data = await res.json();
      setResult(data);
    } catch {
      setError('No configuration found or server error.');
    }
  };

  return (
    <div className="container">
      <h1 className="header">Video-Server Sizing</h1>
       <header className="app-header">
        <img src={logo} alt="Serverli Logo" className="logo" />
      </header>

      {error && <div className="error">{error}</div>}

      <div className="form-group">
        <label htmlFor="assumption">Server Type</label>
        <select
          id="assumption"
          value={assumption}
          onChange={e => setAssumption(e.target.value)}
        >
          <option value="">— Select type —</option>
          {Object.keys(optionsMap).map(key => (
            <option key={key} value={key}>
              {key.replace(/_/g, ' ')}
            </option>
          ))}
        </select>
      </div>

<div className="form-group">
  <label htmlFor="streams">Max Streams</label>
  <input
    type="number"
    id="streams"
    value={streamCount}
    disabled={!assumption}
    placeholder="Enter stream count"
    onChange={e => setStreamCount(e.target.value)}
  />
</div>


      <button
        className="button"
        disabled={!assumption || !streamCount}
        onClick={handleCalculate}
      >
        Calculate
      </button>

      {result && (
        <div className="result-card">
          <h2>Recommended Configuration</h2>
          <ul className="result-list">
            {Object.entries(result).map(([key, value]) => (
              <li key={key}>
                <strong>{key.replace(/_/g,' ')}:</strong> {value}
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}

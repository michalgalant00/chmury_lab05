import "./App.css";
// przypisanie wartości zmiennej środowiskowej do zmiennej w aplikacji
export const ver = process.env.APP_VERSION;

function App() {
  // jeżeli adresem ip będzie http://localhost to zamień go na 127.0.0.1
  const origin = window.location.origin;
  const address = origin == "http://localhost" ? "127.0.0.1" : origin;

  return (
    <div className="App">
      <header className="App-header">
        {"Hostname: " + window.location.hostname}
        <br></br>
        {"Adres: " + address}
        <br></br>
        {"Wersja: " + ver}
      </header>
    </div>
  );
}

export default App;

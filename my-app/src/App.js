// import "./App.css";
// export const ver = process.env.APP_VERSION;

// function App() {
//   const origin = window.location.origin;
//   const address = origin == "localhost" ? "127.0.0.1" : origin;

//   return (
//     <div className="App">
//       <header className="App-header">
//         {"Hostname: " + window.location.hostname}
//         <br></br>
//         {"Adres: " + address}
//         <br></br>
//         {"Wersja: " + ver}
//       </header>
//     </div>
//   );
// }

// export default App;

// ====================================
import "./App.css";

import React, { useState, useEffect } from "react";
import axios from "axios";

function getHostname() {
  // const os = require("os");
  return window.location.hostname;
}

function App() {
  const [ip, setIP] = useState("");
  const [hostname, setHostname] = useState("");
  const ver = process.env.APP_VERSION || "undefined";

  const getData = async () => {
    const res = await axios.get("https://api.ipify.org/?format=json");
    console.log(res.data);
    setIP(res.data.ip);
  };

  useEffect(() => {
    //passing getData method to the lifecycle method
    getData();

    //passing hostname
    setHostname(getHostname());
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <p>Example react app running on:</p>
        <p>IP: {ip}</p>
        <p>Hostname: {hostname}</p>
        <p>Version: {ver}</p>
      </header>
    </div>
  );
}

export default App;

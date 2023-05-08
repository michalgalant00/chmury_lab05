const express = require('express')
const os = require('os')

const PORT = process.env.PORT || 80

const app = express()

.get('/', (req, res) => {
    // res.write(`Server address: ${os.hostname()} (${os.networkInterfaces().eth0[0].address})\n`);
    // res.write(`Server address: ${os.hostname()} (${getIpAddress()})\n`); // dziala
    const hostname = os.hostname
    const ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress
    const version = process.env.VERSION || 'unknown'
    
    res.write(`Hostname: ${hostname}\n`)
    res.write(`Server address: ${ip}\n`)
    res.write(`Version: ${version}\n`)
})

.listen(PORT, () => {
    console.log(`listening on port ${PORT}`);
})

// function getIpAddress() {
//     const networkInterfaces = os.networkInterfaces();
//     const ipAddresses = [];
//     Object.keys(networkInterfaces).forEach((interfaceName) => {
//       const interfaces = networkInterfaces[interfaceName];
//       interfaces.forEach((interface) => {
//         if (interface.family === 'IPv4' && !interface.internal) {
//           ipAddresses.push(interface.address);
//         }
//       });
//     });
//     return ipAddresses.join(', ');
// }
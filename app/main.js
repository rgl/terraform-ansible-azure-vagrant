const http = require("http");

function createRequestListener(metadata) {
    return (request, response) => {
        const serverAddress = `${request.socket.localAddress}:${request.socket.localPort}`;
        const clientAddress = `${request.socket.remoteAddress}:${request.socket.remotePort}`;
        const message = `VM Name: ${metadata.compute.name}
Node.js Version: ${process.versions.node}
Server Address: ${serverAddress}
Client Address: ${clientAddress}
Request URL: ${request.url}
`;
        console.log(message);
        response.writeHead(200, {"Content-Type": "text/plain"});
        response.write(message);
        response.end();
    };
}

function main(metadata, port) {
    const server = http.createServer(createRequestListener(metadata));
    server.listen(port);
}

// see https://docs.microsoft.com/en-us/azure/virtual-machines/linux/instance-metadata-service#retrieving-all-metadata-for-an-instance
http.get(
    "http://169.254.169.254/metadata/instance?api-version=2021-02-01",
    {
        headers: {
            Metadata: "true"
        }
    },
    (response) => {
        let data = "";
        response.on("data", (chunk) => data += chunk);
        response.on("end", () => {
            const metadata = JSON.parse(data);
            main(metadata, process.argv[2]);
        });
    }
).on("error", (error) => console.log("Error fetching metadata: " + error.message));

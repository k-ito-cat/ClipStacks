import { readFileSync, unwatchFile, watchFile } from "node:fs";
import { createServer } from "node:http";
import { parseArgs } from "node:util";
import { renderMermaidSVG } from "beautiful-mermaid";

const { values } = parseArgs({
  options: {
    host: { type: "string", default: "127.0.0.1" },
    input: { type: "string" },
    port: { type: "string", default: "4173" },
  },
  strict: true,
});

if (!values.input) {
  throw new Error("--input is required");
}

const port = Number(values.port);

if (!Number.isInteger(port) || port < 0 || port > 65_535) {
  throw new Error("--port must be an integer between 0 and 65535");
}

const inputPath = values.input;
const clients = new Set();
let version = 0;
let svg = "";
let renderError = null;

const broadcast = () => {
  for (const client of clients) {
    client.write(`data: ${version}\n\n`);
  }
};

const render = () => {
  try {
    const source = readFileSync(inputPath, "utf8");
    svg = renderMermaidSVG(source);
    renderError = null;
  } catch (error) {
    renderError = error instanceof Error ? error.message : String(error);
  }

  version += 1;
  broadcast();
};

const page = `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Diagram preview</title>
    <style>
      :root { color-scheme: light dark; font-family: system-ui, sans-serif; }
      body { margin: 0; min-height: 100vh; display: grid; place-items: center; background: Canvas; }
      main { box-sizing: border-box; width: 100%; padding: 24px; }
      img { display: block; max-width: 100%; height: auto; margin: auto; }
      pre { max-width: 960px; margin: auto; padding: 16px; overflow: auto; color: #b42318; background: #fef3f2; border-radius: 8px; white-space: pre-wrap; }
    </style>
  </head>
  <body>
    <main>
      <img id="diagram" alt="Mermaid diagram preview" hidden>
      <pre id="error" role="alert" hidden></pre>
    </main>
    <script>
      const diagram = document.querySelector("#diagram");
      const error = document.querySelector("#error");
      let imageUrl;

      const refresh = async (version) => {
        const response = await fetch("/diagram.svg?v=" + encodeURIComponent(version), { cache: "no-store" });

        if (!response.ok) {
          error.textContent = await response.text();
          error.hidden = false;
          diagram.hidden = true;
          return;
        }

        const nextImageUrl = URL.createObjectURL(await response.blob());
        diagram.onload = () => {
          if (imageUrl) URL.revokeObjectURL(imageUrl);
          imageUrl = nextImageUrl;
          diagram.hidden = false;
          error.hidden = true;
        };
        diagram.src = nextImageUrl;
      };

      const events = new EventSource("/events");
      events.onmessage = (event) => refresh(event.data);
      events.onerror = () => {
        error.textContent = "Preview server disconnected";
        error.hidden = false;
      };
    </script>
  </body>
</html>`;

render();

const server = createServer((request, response) => {
  const url = new URL(request.url ?? "/", `http://${request.headers.host ?? "localhost"}`);

  if (request.method !== "GET") {
    response.writeHead(405, { Allow: "GET" }).end();
    return;
  }

  if (url.pathname === "/") {
    response
      .writeHead(200, {
        "Cache-Control": "no-store",
        "Content-Security-Policy": "default-src 'self'; connect-src 'self'; img-src 'self' blob:; script-src 'unsafe-inline'; style-src 'unsafe-inline'",
        "Content-Type": "text/html; charset=utf-8",
      })
      .end(page);
    return;
  }

  if (url.pathname === "/diagram.svg") {
    if (renderError) {
      response
        .writeHead(422, {
          "Cache-Control": "no-store",
          "Content-Type": "text/plain; charset=utf-8",
        })
        .end(renderError);
      return;
    }

    response
      .writeHead(200, {
        "Cache-Control": "no-store",
        "Content-Type": "image/svg+xml; charset=utf-8",
      })
      .end(svg);
    return;
  }

  if (url.pathname === "/events") {
    response.writeHead(200, {
      "Cache-Control": "no-cache",
      Connection: "keep-alive",
      "Content-Type": "text/event-stream",
    });
    clients.add(response);
    response.write(`data: ${version}\n\n`);
    request.on("close", () => clients.delete(response));
    return;
  }

  response.writeHead(404).end();
});

watchFile(inputPath, { interval: 250 }, (current, previous) => {
  if (current.mtimeMs !== previous.mtimeMs || current.size !== previous.size) {
    render();
  }
});

server.listen(port, values.host, () => {
  const address = server.address();
  const listeningPort = typeof address === "object" && address ? address.port : port;
  console.log(`Diagram preview: http://${values.host}:${listeningPort}`);
});

const shutdown = () => {
  unwatchFile(inputPath);
  for (const client of clients) client.end();
  server.close();
};

process.once("SIGINT", shutdown);
process.once("SIGTERM", shutdown);

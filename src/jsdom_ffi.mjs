import { JSDOM } from "jsdom";

export function init() {
  const docString = `<!DOCTYPE html>
  <html>
  <head>
  </head>
  <body>
  <main>
  </main>
  </body>
  </html>`;
  const jsdom = new JSDOM(docString);
  globalThis.document = jsdom.window.document;
}

import { readFileSync } from "node:fs";
import { renderMermaidASCII } from "beautiful-mermaid";

const inputPath = process.argv[2] ?? "docs/diagrams/er.mmd";
const source = readFileSync(inputPath, "utf8");

const output = renderMermaidASCII(source, {
  paddingX: 1,
  paddingY: 1,
  boxBorderPadding: 0,
  useAscii: false,
});
console.log(output);

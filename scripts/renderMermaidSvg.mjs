import { readFileSync, writeFileSync } from "node:fs";
import { parseArgs } from "node:util";
import { renderMermaidSVG } from "beautiful-mermaid";

const { values } = parseArgs({
  options: {
    input: { type: "string" },
    output: { type: "string" },
  },
  strict: true,
});

if (!values.input || !values.output) {
  throw new Error("--input and --output are required");
}

const source = readFileSync(values.input, "utf8");
const svg = renderMermaidSVG(source);

writeFileSync(values.output, svg);

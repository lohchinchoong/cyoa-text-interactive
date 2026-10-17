// Compiles story/*.ink -> src/story/*.json so the browser only needs the inkjs runtime.
import { readdir, readFile, writeFile, mkdir } from "node:fs/promises";
import { join, basename } from "node:path";
import { Compiler } from "inkjs/full";

const SRC = "story";
const OUT = "src/story";

await mkdir(OUT, { recursive: true });
const files = (await readdir(SRC)).filter((f) => f.endsWith(".ink"));
let failed = false;

for (const file of files) {
  const compiler = new Compiler(await readFile(join(SRC, file), "utf8"));
  let story;
  try {
    story = compiler.Compile();
  } catch {
    // Compiler throws after collecting errors; they are reported below.
  }
  for (const w of compiler.warnings) console.warn(`${file}: ${w}`);
  if (!story || compiler.errors.length) {
    for (const e of compiler.errors) console.error(`${file}: ${e}`);
    failed = true;
    continue;
  }
  const out = join(OUT, `${basename(file, ".ink")}.json`);
  await writeFile(out, story.ToJson());
  console.log(`ink: ${file} -> ${out}`);
}

if (failed) process.exit(1);

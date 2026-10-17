# DOS-style choose-your-own-adventure (Next.js + Ink): spec and build plan

## Context
The project folder `/Users/desmondloh/Projects/cyoa-text-interactive` is empty. The user wants a choose-your-own-adventure game that runs in the browser, styled like an old DOS text game and playable on mobile. Requirements:
- Stack: Next.js, TypeScript, Tailwind (monospace) and Ink/inkjs, deployed to Vercel's free tier with no unnecessary bloat.
- 2D anime-style graphics may come later, so leave a hook for them but build none of it now.
- Choices can be typed at a `C:\SCHOOL>` prompt, or tapped/clicked.
- Autosave only (resume after refresh), plus RESTART. No save slots.
- Sample story: a school day over 5 pages with 3 choices each, ending in 5 exam-score endings.

The design was approved in chat. After building, start the dev server and open it in Microsoft Edge (installed at /Applications/Microsoft Edge.app).

## Design (approved)
- **Static site.** Next.js App Router with `output: 'export'` and a single `/` route. No server functions, so it fits Vercel's free tier.
- **Ink compiled at build time.** `scripts/compile-ink.mjs` uses the compiler from `inkjs/full` (inkjs 2.4.x) to compile `story/*.ink` into `src/story/*.json`. It runs as the `predev`, `prebuild` and `pretest` scripts. The output is gitignored. The browser imports only the `inkjs` runtime.
- **Dependencies.**
  - Runtime: next, react, react-dom, inkjs.
  - Dev: typescript, tailwindcss v4, @tailwindcss/postcss, vitest, plus the @types packages.
  - No ESLint, no UI library, no state library.
- **Font.** VT323 loaded through `next/font/google`, so it's bundled with the site.

### Units
| File | Job |
|---|---|
| `src/lib/engine.ts` | Wraps inkjs `Story` with no React. `createEngine(json, savedState?)` provides `continue() → {lines, choices, tags, ended}`, `choose(i)` and `saveState()`. Tags such as `# image: x` are collected for future graphics. |
| `src/lib/commands.ts` | Pure `parseCommand(input, choiceCount)`. Returns `{type:'choose',index}`, `restart`, `help`, `cls`, or `{type:'error',msg}`. A number out of range gives "Invalid choice". Unknown text gives "Bad command or file name". |
| `src/lib/persistence.ts` | `loadSave(version)`, `writeSave(version, data)` and `clearSave()` against localStorage, every call in try/catch. A version mismatch returns null. The save holds `{v, inkState, transcript}`. |
| `src/components/Terminal.tsx` | `'use client'`. Holds the engine ref and transcript state. On mount it restores the autosave or starts fresh. Handles commands, autosaves after each step, scrolls to the bottom and keeps the prompt focused. |
| `src/components/ChoiceList.tsx` | `[n] text` choices as full-width `<button>`s with a large tap area. Clicking one sends the same handler as typing `n`. |
| `src/components/Prompt.tsx` | A form with the `C:\SCHOOL>` label, a text input (16px font, `inputMode="numeric"`, `autoComplete="off"`) and a blinking block cursor. Enter submits and echoes the input into the transcript. |
| `src/app/layout.tsx`, `page.tsx`, `globals.css` | Font, metadata, viewport and theme colour. A `100dvh` flex layout. `@theme` holds DOS colours (bg `#000`, fg `#AAAAAA`, bright `#FFFFFF`, accent `#55FF55`). A `.cursor` blink keyframe. The `.crt` class is reserved but empty. |

The story version is a constant `STORY_VERSION = 1` in `src/story/version.ts`. Bump it whenever an edit to the story would break old saves.

### Sample story `story/school.ink`
- `VAR score = 0`. Each page prints a `--- PAGE n/5 ---` header, then 3 choices that do `~ score += 0 / 10 / 20` (the order is shuffled per page so the best answer isn't always the same number).
- Pages:
  1. The alarm rings on exam week.
  2. Homeroom: a friend offers to share notes.
  3. Lunch: games club vs study group vs a nap.
  4. Free period: library, gaming, or helping a classmate.
  5. The night before: cram, sleep early, or binge a show.
- `=== results ===` routes on score: ≤10 goes to 0/100 FAIL!, ≤40 to 20/100 FAIL!, ≤60 to 50/100 Just Pass, ≤90 to 80/100 GOOD!, and 100 to 100/100 EXCELLENT! Each ending gets a short paragraph, then `-> END`.
- At the end the terminal shows `Type RESTART to play again.`

## Build steps
1. **Scaffold.** `npx create-next-app@latest . --ts --tailwind --app --src-dir --no-eslint --import-alias "@/*" --use-npm` (or the equivalent flag for "no linter"). Delete the boilerplate SVGs and page content. Run `git init`.
2. **Config.**
   - `next.config.ts`: `output: 'export'`, `images: { unoptimized: true }`.
   - `package.json` scripts: `compile:ink`, `predev`, `prebuild`, `pretest`, and `test: vitest run`.
   - `.gitignore`: add `src/story/*.json`.
3. **Ink pipeline.** `npm i inkjs`. Write `scripts/compile-ink.mjs`, which reads every `story/*.ink`, compiles it with `new Compiler(src).Compile()`, fails the build on compiler errors, and writes `src/story/<name>.json`.
4. **Story.** Write `story/school.ink` as described above and compile it.
5. **Tests (TDD).** `npm i -D vitest`. Write the tests first, then the code that makes them pass:
   - `commands.test.ts`: numbers, out-of-range input, keywords in any case, whitespace, junk text.
   - `persistence.test.ts`: round trip, version mismatch, storage that throws. Use a stubbed `localStorage`.
   - `engine.test.ts`: load the compiled school.json and play choice paths that reach each of the 5 endings, checking the ending text. Also check that restoring from `saveState()` resumes on the same choices.
6. **UI.** Write `layout.tsx`, `globals.css`, `Terminal`, `ChoiceList`, `Prompt` and `page.tsx`. Make sure the page is accessible: the transcript uses `role="log"` with `aria-live="polite"`, and choices are buttons.
7. **Docs.** Copy this spec into `docs/superpowers/specs/2026-10-17-dos-cyoa-design.md`. Add a short README covering how to write Ink, the npm scripts and how to deploy to Vercel. Make the first commit.

## Verification
- Run `npm test` and confirm everything passes, including all 5 endings reached by scripted paths.
- Run `npm run build` and confirm the static export lands in `out/` with no errors. Check the size of the first-load JavaScript.
- Run `npm run dev` in the background and open the site with `open -a "Microsoft Edge" http://localhost:3000`. Check these by hand, and with Claude in Chrome if needed:
  - typing `2` and tapping a choice both advance the story
  - `HELP`, `CLS` and `RESTART` work, and junk input gives "Bad command or file name"
  - a refresh resumes where you left off
  - at a mobile width (about 390px) the text isn't zoomed, choices are easy to tap and there's no horizontal scroll
- Leave the dev server running for the user to test.

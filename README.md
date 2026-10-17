# Exam Week: a DOS-style text adventure

A choose-your-own-adventure game that runs in the browser and looks like an old DOS game. It's built with Next.js, TypeScript, Tailwind CSS and [Ink](https://www.inklestudios.com/ink/)/inkjs. Players can type a choice number at the `C:\SCHOOL>` prompt or tap a choice. Progress autosaves in the browser.

## Scripts

| Command | What it does |
|---|---|
| `npm run dev` | Compiles the Ink story, then starts the dev server at http://localhost:3000 |
| `npm test` | Compiles the Ink story, then runs the unit tests (Vitest) |
| `npm run build` | Compiles the Ink story, then builds a static export into `out/` |
| `npm run compile:ink` | Compiles `story/*.ink` into `src/story/*.json` (the JSON is generated and gitignored) |

## Writing the story

- The story lives in `story/school.ink`. It's plain [Ink](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md).
- Choice text goes in `[brackets]` so it isn't repeated after the player picks it. The prompt shows what they picked instead.
- `# image: name` tags mark scenes for future 2D artwork. The engine collects them, and right now they only style page headings.
- `# ending: n` tags style the result line.
- Don't start a line with `-`, because Ink treats it as a gather.
- If a story change would break existing saves, bump `STORY_VERSION` in `src/story/version.ts`. Old saves are then discarded.

## Commands at the prompt

`1`, `2`, `3`… pick a choice (at an ending, `1` restarts) · `HELP` · `CLS` clears the screen · `RESTART`

## Deploying to Vercel (free tier)

1. Push the repo to GitHub and import it in Vercel. It detects Next.js automatically, so you don't need to change any settings.
2. `npm run build` compiles the Ink story and outputs a fully static site. No serverless functions are used.

## Layout

```
story/              Ink source
scripts/            compile-ink.mjs (build-time Ink compiler)
src/lib/            engine (inkjs wrapper), commands (prompt parser), persistence (autosave)
src/components/     Terminal, ChoiceList, Prompt
src/app/            Next.js layout, page, global styles
```

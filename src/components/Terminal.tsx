"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { ADVENTURES, type Adventure } from "@/story/adventures";
import { STORY_VERSION } from "@/story/version";
import { parseCommand } from "@/lib/commands";
import { createEngine, type Engine, type Step } from "@/lib/engine";
import { clearSave, loadSave, writeSave } from "@/lib/persistence";
import ChoiceList from "./ChoiceList";
import Prompt, { PROMPT } from "./Prompt";

type Kind = "text" | "heading" | "ending" | "echo" | "error" | "info";
type Entry = { kind: Kind; text: string };
type Save = { adventureId: string; inkState: string; transcript: Entry[] };

const KIND_STYLE: Record<Kind, string> = {
  text: "",
  heading: "mt-4 text-dos-bright",
  ending: "mt-2 text-dos-green",
  echo: "mt-2 text-dos-fg/70",
  error: "text-dos-red",
  info: "text-dos-yellow",
};

const HELP: Entry[] = [
  "Type the number of a choice and press Enter, or tap a choice.",
  "RESTART  Start the story again",
  "MENU     Return to the adventure menu",
  "CLS      Clear the screen",
  "HELP     Show this help",
].map((text) => ({ kind: "info", text }));

const END_HINT: Entry = { kind: "info", text: "Type 1 to play again or 2 for the menu." };

const MENU_SCREEN: Entry[] = [
  { kind: "heading", text: "SELECT AN ADVENTURE" },
  { kind: "info", text: "Type a number and press Enter, or tap an adventure." },
];

/** Story lines become transcript entries; ink tags pick the style. */
function toEntries(step: Step): Entry[] {
  const entries: Entry[] = step.lines.map(({ text, tags }) => ({
    kind: tags.some((t) => t.startsWith("ending")) ? "ending" : tags.some((t) => t.startsWith("image")) ? "heading" : "text",
    text,
  }));
  return step.ended ? [...entries, END_HINT] : entries;
}

export default function Terminal() {
  const engine = useRef<Engine | null>(null);
  // null while the menu is showing.
  const [adventure, setAdventure] = useState<Adventure | null>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  const screenRef = useRef<HTMLDivElement>(null);
  // True when the transcript was replaced by a new page rather than appended to.
  const freshScreen = useRef(true);
  const [transcript, setTranscript] = useState<Entry[]>([]);
  const [choices, setChoices] = useState<string[]>([]);
  const [ended, setEnded] = useState(false);

  /** Shows a new page on a clean screen and autosaves it. */
  const show = useCallback((adv: Adventure, step: Step, entries: Entry[]) => {
    freshScreen.current = true;
    setAdventure(adv);
    setTranscript(entries);
    setChoices(step.choices);
    setEnded(step.ended);
    writeSave(STORY_VERSION, {
      adventureId: adv.id,
      inkState: engine.current!.saveState(),
      transcript: entries,
    } satisfies Save);
  }, []);

  const start = useCallback(
    (adv: Adventure) => {
      engine.current = createEngine(adv.json);
      const step = engine.current.continue();
      show(adv, step, toEntries(step));
    },
    [show],
  );

  const showMenu = useCallback(() => {
    clearSave();
    engine.current = null;
    freshScreen.current = true;
    setAdventure(null);
    setTranscript(MENU_SCREEN);
    setChoices(ADVENTURES.map((a) => a.title));
    setEnded(false);
  }, []);

  // Resume the autosave, or show the menu. Runs client-side only (localStorage).
  useEffect(() => {
    const save = loadSave<Save>(STORY_VERSION);
    const adv = ADVENTURES.find((a) => a.id === save?.adventureId);
    if (save && adv) {
      try {
        engine.current = createEngine(adv.json, save.inkState);
        show(adv, engine.current.continue(), save.transcript);
        return;
      } catch {}
    }
    showMenu();
  }, [show, showMenu]);

  // A new page starts at the top; HELP/errors appended to a page scroll into view.
  useEffect(() => {
    const el = screenRef.current;
    if (!el) return;
    el.scrollTop = freshScreen.current ? 0 : el.scrollHeight;
    freshScreen.current = false;
  }, [transcript]);

  // Focus the prompt on devices with a mouse; on touch screens it would pop the keyboard over the story.
  useEffect(() => {
    if (window.matchMedia("(pointer: fine)").matches) inputRef.current?.focus();
  }, []);

  const handle = (input: string) => {
    const cmd = parseCommand(input, choices.length, ended);
    if (cmd.type === "none") return;
    const log = [...transcript, { kind: "echo" as const, text: `${PROMPT}${input.trim()}` }];

    switch (cmd.type) {
      case "choose": {
        if (!adventure || !engine.current) {
          start(ADVENTURES[cmd.index]);
          break;
        }
        const step = engine.current.choose(cmd.index);
        show(adventure, step, toEntries(step));
        break;
      }
      case "restart":
        if (adventure) start(adventure);
        else showMenu();
        break;
      case "menu":
        showMenu();
        break;
      case "cls":
        setTranscript([]);
        break;
      case "help":
        setTranscript([...log, ...HELP]);
        break;
      case "error":
        setTranscript([...log, { kind: "error", text: cmd.msg }]);
        break;
    }
  };

  return (
    <main className="crt mx-auto flex h-dvh max-w-3xl flex-col text-xl leading-snug sm:text-2xl">
      <header className="shrink-0 bg-dos-fg px-2 text-center text-dos-bg">{adventure?.header ?? "SCHOOL.EXE"}</header>

      <div ref={screenRef} className="min-h-0 flex-1 overflow-y-auto px-3 pt-2 pb-4 break-words">
        <div role="log" aria-live="polite">
          {transcript.map((entry, i) => (
            <p key={i} className={`whitespace-pre-wrap ${KIND_STYLE[entry.kind]}`}>
              {entry.text}
            </p>
          ))}
        </div>
        {ended ? (
          <ChoiceList key="end" choices={["RESTART", "MENU"]} onPick={handle} />
        ) : (
          <ChoiceList key={choices.join("|")} choices={choices} onPick={handle} />
        )}
      </div>

      <div className="shrink-0 border-t border-dos-fg/30 px-3 py-2 pb-[max(0.5rem,env(safe-area-inset-bottom))]">
        <Prompt onSubmit={handle} inputRef={inputRef} />
      </div>
    </main>
  );
}

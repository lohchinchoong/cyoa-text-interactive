import { Story } from "inkjs";

export type Line = { text: string; tags: string[] };
export type Step = { lines: Line[]; choices: string[]; ended: boolean };

export interface Engine {
  /** Runs the story until the next set of choices (or the end). */
  continue(): Step;
  /** Picks choice `index` (0-based) and continues. */
  choose(index: number): Step;
  /** Serialised ink state for autosave. */
  saveState(): string;
}

/** Thin, React-free wrapper over the inkjs runtime. */
export function createEngine(json: object | string, savedState?: string): Engine {
  const story = new Story(typeof json === "string" ? json : JSON.stringify(json));
  if (savedState) story.state.LoadJson(savedState);

  const engine: Engine = {
    continue() {
      const lines: Line[] = [];
      while (story.canContinue) {
        const text = story.Continue()!.trim();
        // Tags (e.g. `# image: classroom`) are kept for future artwork.
        if (text || story.currentTags?.length) lines.push({ text, tags: story.currentTags ?? [] });
      }
      const choices = story.currentChoices.map((c) => c.text);
      return { lines, choices, ended: choices.length === 0 };
    },
    choose(index) {
      story.ChooseChoiceIndex(index);
      return engine.continue();
    },
    saveState: () => story.state.ToJson(),
  };
  return engine;
}

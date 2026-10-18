import { describe, expect, it } from "vitest";
import { Story } from "inkjs";
import storyJson from "../story/secondary.json";
import { createEngine, type Step } from "./engine";

const COUNTERS = ["grades", "strikes", "society", "startup"] as const;
type Counters = Record<(typeof COUNTERS)[number], number>;
/** What picking a choice would do, found by playing it on a copy of the story. */
type Probe = { index: number; delta: Counters; ending?: string };
/** Picks a choice index; `look` probes the choices only when the strategy needs to. */
type Strategy = (look: () => Probe[], page: number, count: number) => number;

const tagValue = (step: Step, name: string) =>
  step.lines.flatMap((l) => l.tags).find((t) => t.startsWith(`${name}: `))?.slice(name.length + 2);

function counters(story: Story): Counters {
  return Object.fromEntries(COUNTERS.map((c) => [c, story.variablesState[c] as number])) as Counters;
}

const json = JSON.stringify(storyJson);

function probe(state: string, choiceCount: number): Probe[] {
  const before = new Story(json);
  before.state.LoadJson(state);
  const start = counters(before);
  return Array.from({ length: choiceCount }, (_, index) => {
    const story = new Story(json);
    story.state.LoadJson(state);
    story.ChooseChoiceIndex(index);
    const tags: string[] = [];
    while (story.canContinue) {
      story.Continue();
      tags.push(...(story.currentTags ?? []));
    }
    const after = counters(story);
    const delta = Object.fromEntries(COUNTERS.map((c) => [c, after[c] - start[c]])) as Counters;
    const ending = tags.find((t) => t.startsWith("ending: "))?.slice(8);
    return { index, delta, ending };
  });
}

/** Plays to an ending, checking every page on the way. */
function play(strategy: Strategy) {
  const engine = createEngine(storyJson);
  let step = engine.continue();
  const pages: number[] = [];
  while (!step.ended) {
    const at = step.lines.findIndex((l) => l.tags.some((t) => t.startsWith("page: ")));
    expect(at, `choices after page ${pages.at(-1) ?? 0} have no page heading`).toBeGreaterThanOrEqual(0);
    const page = Number(tagValue(step, "page"));
    const body = step.lines.slice(at + 1).map((l) => l.text).join(" ");
    expect(body.split(/\s+/).filter(Boolean).length, `page ${page} word count`).toBeGreaterThanOrEqual(30);
    expect(step.choices, `page ${page} choices`).toHaveLength(3);
    pages.push(page);
    const count = step.choices.length;
    step = engine.choose(strategy(() => probe(engine.saveState(), count), page, count));
  }
  return { ending: tagValue(step, "ending"), pages };
}

/** Picks the first choice matching a test, else the plain choice worth closest to `points`. */
function prefer(test: (p: Probe) => boolean, points: number | ((page: number) => number)): Strategy {
  return (look, page) => {
    const probes = look();
    const hit = probes.find(test);
    if (hit) return hit.index;
    const target = typeof points === "number" ? points : points(page);
    const plain = probes.filter((p) => !p.ending && !p.delta.strikes && !p.delta.society && !p.delta.startup);
    const pool = plain.length ? plain : probes;
    return pool.reduce((a, b) =>
      Math.abs(b.delta.grades - target) < Math.abs(a.delta.grades - target) ? b : a,
    ).index;
  };
}

const never = () => false;

describe("SECONDARY SCHOOL", () => {
  it("starts with its title and page 1", () => {
    const step = createEngine(storyJson).continue();
    expect(step.lines[0].text).toBe("SECONDARY SCHOOL");
    expect(tagValue(step, "page")).toBe("1");
  });

  it.each<[string, Strategy, string, boolean]>([
    ["top marks every page", prefer(never, 2), "prestigious", false],
    ["top marks, then coasting from page 26", prefer(never, (page) => (page <= 25 ? 2 : 1)), "good", false],
    ["middling every page", prefer(never, 1), "barely", false],
    ["slacking off in Sec 1", prefer(never, 0), "repeat", true],
    ["breaking every rule", prefer((p) => p.delta.strikes > 0, 1), "expelled", true],
    ["following the Order", prefer((p) => p.delta.society > 0 || p.ending === "vanished", 2), "vanished", true],
    ["building the app", prefer((p) => p.delta.startup > 0 || p.ending === "billionaire", 2), "billionaire", true],
  ])("%s ends with %s", (_, strategy, ending, early) => {
    const run = play(strategy);
    expect(run.ending).toBe(ending);
    expect(run.pages).toEqual(run.pages.map((_, i) => i + 1));
    if (early) expect(run.pages.length).toBeLessThan(40);
    else expect(run.pages).toHaveLength(40);
  });

  it("keeps every random playthrough well formed", () => {
    let seed = 42;
    const random = () => ((seed = (Math.imul(seed, 1664525) + 1013904223) >>> 0) / 2 ** 32);
    const endings = new Set<string>();
    for (let i = 0; i < 300; i++) {
      const run = play((_look, _page, count) => Math.floor(random() * count));
      expect(run.ending).toBeDefined();
      endings.add(run.ending!);
    }
    expect([...endings].every((e) =>
      ["prestigious", "good", "barely", "repeat", "expelled", "vanished", "billionaire"].includes(e),
    )).toBe(true);
  });
});

import { describe, expect, it } from "vitest";
import storyJson from "../story/school.json";
import { createEngine, type Step } from "./engine";

const text = (s: Step) => s.lines.map((l) => l.text).join("\n");

// Choice index (0-based) on each page that is worth 0, 10 and 20 points.
// Must match story/school.ink.
const POINTS: Record<number, number>[] = [
  { 0: 0, 10: 2, 20: 1 },
  { 0: 2, 10: 1, 20: 0 },
  { 0: 0, 10: 2, 20: 1 },
  { 0: 1, 10: 0, 20: 2 },
  { 0: 0, 10: 1, 20: 2 },
];

function play(pointsPerPage: number[]) {
  const engine = createEngine(storyJson);
  let step = engine.continue();
  let all = text(step);
  pointsPerPage.forEach((pts, page) => {
    expect(step.choices).toHaveLength(3);
    step = engine.choose(POINTS[page][pts]);
    all += "\n" + text(step);
  });
  return { step, all };
}

describe("engine", () => {
  it("starts on page 1 with three choices", () => {
    const step = createEngine(storyJson).continue();
    expect(text(step)).toContain("PAGE 1/5");
    expect(step.choices).toHaveLength(3);
    expect(step.ended).toBe(false);
    expect(step.lines.find((l) => l.text.includes("PAGE 1/5"))?.tags).toEqual([
      "image: bedroom",
    ]);
  });

  it.each([
    [[0, 0, 0, 0, 0], "SCORE: 0/100 - FAIL!"],
    [[10, 0, 0, 0, 0], "SCORE: 0/100 - FAIL!"],
    [[20, 20, 0, 0, 0], "SCORE: 20/100 - FAIL!"],
    [[20, 20, 10, 0, 0], "SCORE: 50/100 - JUST PASS"],
    [[20, 20, 20, 0, 0], "SCORE: 50/100 - JUST PASS"],
    [[20, 20, 20, 10, 0], "SCORE: 80/100 - GOOD!"],
    [[20, 20, 20, 20, 10], "SCORE: 80/100 - GOOD!"],
    [[20, 20, 20, 20, 20], "SCORE: 100/100 - EXCELLENT!"],
  ])("choices %j end with %s", (path, ending) => {
    const { step, all } = play(path);
    expect(step.ended).toBe(true);
    expect(step.choices).toEqual([]);
    expect(all).toContain(ending);
  });

  it("resumes from a saved state on the same choices", () => {
    const engine = createEngine(storyJson);
    engine.continue();
    const page2 = engine.choose(0);
    const restored = createEngine(storyJson, engine.saveState()).continue();
    expect(restored.lines).toEqual([]);
    expect(restored.choices).toEqual(page2.choices);
  });
});

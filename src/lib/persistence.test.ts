import { beforeEach, describe, expect, it, vi } from "vitest";
import { clearSave, loadSave, writeSave } from "./persistence";

function memoryStorage(): Storage {
  const data = new Map<string, string>();
  return {
    get length() {
      return data.size;
    },
    clear: () => data.clear(),
    getItem: (k) => data.get(k) ?? null,
    key: (i) => [...data.keys()][i] ?? null,
    removeItem: (k) => void data.delete(k),
    setItem: (k, v) => void data.set(k, String(v)),
  };
}

describe("persistence", () => {
  beforeEach(() => {
    vi.stubGlobal("localStorage", memoryStorage());
  });

  it("round-trips a save for the same story version", () => {
    writeSave(1, { inkState: "{}", transcript: ["hi"] });
    expect(loadSave(1)).toEqual({ inkState: "{}", transcript: ["hi"] });
  });

  it("discards a save from a different story version", () => {
    writeSave(1, { inkState: "{}" });
    expect(loadSave(2)).toBeNull();
  });

  it("returns null when nothing or garbage is stored", () => {
    expect(loadSave(1)).toBeNull();
    localStorage.setItem("cyoa-save", "not json");
    expect(loadSave(1)).toBeNull();
  });

  it("clears the save", () => {
    writeSave(1, { a: 1 });
    clearSave();
    expect(loadSave(1)).toBeNull();
  });

  it("never throws when storage is unavailable", () => {
    const broken = () => {
      throw new Error("blocked");
    };
    vi.stubGlobal("localStorage", {
      getItem: broken,
      setItem: broken,
      removeItem: broken,
    });
    expect(() => writeSave(1, {})).not.toThrow();
    expect(loadSave(1)).toBeNull();
    expect(() => clearSave()).not.toThrow();
  });
});

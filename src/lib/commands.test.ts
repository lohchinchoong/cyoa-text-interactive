import { describe, expect, it } from "vitest";
import { parseCommand } from "./commands";

describe("parseCommand", () => {
  it("maps a number to a zero-based choice index", () => {
    expect(parseCommand("1", 3)).toEqual({ type: "choose", index: 0 });
    expect(parseCommand("  3 ", 3)).toEqual({ type: "choose", index: 2 });
  });

  it("rejects numbers outside the current choices", () => {
    expect(parseCommand("0", 3)).toEqual({ type: "error", msg: "Invalid choice" });
    expect(parseCommand("4", 3)).toEqual({ type: "error", msg: "Invalid choice" });
    expect(parseCommand("1", 0)).toEqual({ type: "error", msg: "Invalid choice" });
  });

  it("recognises commands in any case", () => {
    expect(parseCommand("restart", 3)).toEqual({ type: "restart" });
    expect(parseCommand("HELP", 3)).toEqual({ type: "help" });
    expect(parseCommand(" Cls ", 3)).toEqual({ type: "cls" });
    expect(parseCommand("Menu", 3)).toEqual({ type: "menu" });
  });

  it("ignores blank input", () => {
    expect(parseCommand("   ", 3)).toEqual({ type: "none" });
  });

  it("answers anything else like DOS would", () => {
    expect(parseCommand("go north", 3)).toEqual({
      type: "error",
      msg: "Bad command or file name",
    });
    expect(parseCommand("1.5", 3).type).toBe("error");
  });

  it("treats 1 as RESTART and 2 as MENU once the story has ended", () => {
    expect(parseCommand("1", 0, true)).toEqual({ type: "restart" });
    expect(parseCommand("2", 0, true)).toEqual({ type: "menu" });
    expect(parseCommand("3", 0, true)).toEqual({ type: "error", msg: "Invalid choice" });
    expect(parseCommand("restart", 0, true)).toEqual({ type: "restart" });
  });
});

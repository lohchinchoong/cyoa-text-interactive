export type Command =
  | { type: "choose"; index: number }
  | { type: "restart" }
  | { type: "help" }
  | { type: "cls" }
  | { type: "none" }
  | { type: "error"; msg: string };

const KEYWORDS = { RESTART: "restart", HELP: "help", CLS: "cls" } as const;

/** Turns what the player typed at the prompt into a game command. */
export function parseCommand(input: string, choiceCount: number): Command {
  const raw = input.trim();
  if (!raw) return { type: "none" };

  if (/^\d+$/.test(raw)) {
    const n = Number(raw);
    return n >= 1 && n <= choiceCount
      ? { type: "choose", index: n - 1 }
      : { type: "error", msg: "Invalid choice" };
  }

  const keyword = KEYWORDS[raw.toUpperCase() as keyof typeof KEYWORDS];
  return keyword ? { type: keyword } : { type: "error", msg: "Bad command or file name" };
}

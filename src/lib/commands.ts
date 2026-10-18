export type Command =
  | { type: "choose"; index: number }
  | { type: "restart" }
  | { type: "menu" }
  | { type: "help" }
  | { type: "cls" }
  | { type: "none" }
  | { type: "error"; msg: string };

const KEYWORDS = { RESTART: "restart", MENU: "menu", HELP: "help", CLS: "cls" } as const;

/**
 * Turns what the player typed at the prompt into a game command.
 * Once the story has ended, the options shown are `[1] RESTART` and `[2] MENU`.
 */
export function parseCommand(input: string, choiceCount: number, ended = false): Command {
  const raw = input.trim();
  if (!raw) return { type: "none" };

  if (/^\d+$/.test(raw)) {
    const n = Number(raw);
    if (ended) {
      if (n === 1) return { type: "restart" };
      return n === 2 ? { type: "menu" } : { type: "error", msg: "Invalid choice" };
    }
    return n >= 1 && n <= choiceCount
      ? { type: "choose", index: n - 1 }
      : { type: "error", msg: "Invalid choice" };
  }

  const keyword = KEYWORDS[raw.toUpperCase() as keyof typeof KEYWORDS];
  return keyword ? { type: keyword } : { type: "error", msg: "Bad command or file name" };
}

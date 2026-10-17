"use client";

import { useEffect, useState } from "react";

type Props = {
  choices: string[];
  onPick: (input: string) => void;
};

const CHARS_PER_SECOND = 120;

/** Shows the first `count` characters; the rest stay invisible so the layout doesn't shift. */
function typed(text: string, count: number) {
  count = Math.max(0, count);
  return (
    <>
      {text.slice(0, count)}
      <span className="invisible">{text.slice(count)}</span>
    </>
  );
}

/**
 * Choices as tappable lines that type out one after another.
 * Tapping `[2]` is the same as typing 2, and works mid-animation.
 * Remount (via `key`) to replay the animation for a new set of choices.
 */
export default function ChoiceList({ choices, onPick }: Props) {
  const lines = choices.map((choice, i) => ({ num: `[${i + 1}]`, choice }));
  const total = lines.reduce((n, l) => n + l.num.length + l.choice.length, 0);
  const [shown, setShown] = useState(0);

  useEffect(() => {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      setShown(total);
      return;
    }
    const start = performance.now();
    const timer = setInterval(() => {
      const n = Math.floor(((performance.now() - start) / 1000) * CHARS_PER_SECOND);
      setShown(Math.min(n, total));
      if (n >= total) clearInterval(timer);
    }, 16);
    return () => clearInterval(timer);
  }, [total]);

  let offset = 0;
  return (
    <ol className="my-2">
      {lines.map(({ num, choice }, i) => {
        const visible = Math.max(0, shown - offset);
        offset += num.length + choice.length;
        return (
          <li key={i}>
            <button
              type="button"
              aria-label={`${i + 1}. ${choice}`}
              onClick={() => onPick(String(i + 1))}
              className="flex w-full gap-2 py-2 text-left text-dos-bright hover:bg-dos-fg hover:text-dos-bg focus-visible:bg-dos-fg focus-visible:text-dos-bg focus-visible:outline-none"
            >
              <span className="shrink-0 text-dos-yellow">{typed(num, visible)}</span>
              <span>{typed(choice, visible - num.length)}</span>
            </button>
          </li>
        );
      })}
    </ol>
  );
}

import { type Ref, useState } from "react";

export const PROMPT = "C:\\SCHOOL>";

type Props = {
  onSubmit: (input: string) => void;
  inputRef: Ref<HTMLInputElement>;
};

/** The DOS command line. Enter submits; the block cursor follows the text. */
export default function Prompt({ onSubmit, inputRef }: Props) {
  const [value, setValue] = useState("");

  return (
    <form
      className="flex items-center"
      onSubmit={(e) => {
        e.preventDefault();
        onSubmit(value);
        setValue("");
      }}
    >
      <label htmlFor="cmd" className="shrink-0 text-dos-bright">
        {PROMPT}
      </label>
      <div className="relative min-w-0 flex-1">
        <input
          id="cmd"
          ref={inputRef}
          value={value}
          onChange={(e) => setValue(e.target.value)}
          autoComplete="off"
          autoCapitalize="none"
          autoCorrect="off"
          spellCheck={false}
          enterKeyHint="go"
          aria-label="Command"
          // 16px+ text stops iOS Safari zooming in on focus.
          className="w-full bg-transparent pl-1 text-[length:inherit] text-dos-bright caret-transparent outline-none"
        />
        <span aria-hidden className="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-1">
          <span className="invisible whitespace-pre">{value}</span>
          <span className="cursor inline-block h-[1em] w-[0.55em] bg-dos-fg" />
        </span>
      </div>
    </form>
  );
}

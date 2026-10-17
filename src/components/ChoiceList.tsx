type Props = {
  choices: string[];
  onPick: (input: string) => void;
};

/** Choices as tappable lines; tapping `[2]` is the same as typing 2. */
export default function ChoiceList({ choices, onPick }: Props) {
  return (
    <ol className="my-2">
      {choices.map((choice, i) => (
        <li key={i}>
          <button
            type="button"
            onClick={() => onPick(String(i + 1))}
            className="flex w-full gap-2 py-2 text-left text-dos-bright hover:bg-dos-fg hover:text-dos-bg focus-visible:bg-dos-fg focus-visible:text-dos-bg focus-visible:outline-none"
          >
            <span className="text-dos-yellow">[{i + 1}]</span>
            <span>{choice}</span>
          </button>
        </li>
      ))}
    </ol>
  );
}

// Autosave in localStorage. Every call swallows errors (private mode, blocked
// storage) so the game still runs, just without resume.
const KEY = "cyoa-save";

export function loadSave<T>(version: number): T | null {
  try {
    const raw = localStorage.getItem(KEY);
    if (!raw) return null;
    const save = JSON.parse(raw) as { v: number; data: T };
    return save.v === version ? save.data : null;
  } catch {
    return null;
  }
}

export function writeSave(version: number, data: unknown): void {
  try {
    localStorage.setItem(KEY, JSON.stringify({ v: version, data }));
  } catch {}
}

export function clearSave(): void {
  try {
    localStorage.removeItem(KEY);
  } catch {}
}

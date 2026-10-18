import primary from "./primary.json";
import secondary from "./secondary.json";

export type Adventure = { id: string; title: string; header: string; json: object };

/** The adventures offered on the menu, in menu order. */
export const ADVENTURES: Adventure[] = [
  { id: "primary", title: "PRIMARY SCHOOL", header: "PRIMARY.EXE", json: primary },
  { id: "secondary", title: "SECONDARY SCHOOL", header: "SECONDARY.EXE", json: secondary },
];

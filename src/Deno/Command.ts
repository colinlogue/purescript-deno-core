import type { EffectFn2 } from "../purescript.d.ts";

export const _new: EffectFn2<Deno.CommandOptions, string | URL, Deno.Command> = (
  opts,
  command
) => {
  return new Deno.Command(command, opts);
};

import type { Fn1, Fn2 } from "../purescript.d.ts";

export const empty: Deno.CommandOptions = {};

export const args: Fn1<string[], Deno.CommandOptions> = (value) => ({
  args: value,
});

export const env: Fn1<Record<string, string>, Deno.CommandOptions> = (value) => ({
  env: value,
});

export const combine: Fn2<
  Deno.CommandOptions,
  Deno.CommandOptions,
  Deno.CommandOptions
> = (a, b) => ({ ...a, ...b });

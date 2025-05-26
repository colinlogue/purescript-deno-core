import type { Fn1, Fn2 } from "../../../../purescript.d.ts";

export const dir: Fn1<string, Deno.MakeTempOptions> = (value) => ({
  dir: value,
});

export const prefix: Fn1<string, Deno.MakeTempOptions> = (value) => ({
  prefix: value,
});

export const suffix: Fn1<string, Deno.MakeTempOptions> = (value) => ({
  suffix: value,
});

export const empty: Deno.MakeTempOptions = {};

export const combine: Fn2<
  Deno.MakeTempOptions,
  Deno.MakeTempOptions,
  Deno.MakeTempOptions
> = (a, b) => ({ ...a, ...b });

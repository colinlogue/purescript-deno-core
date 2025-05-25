import type { Fn1, Fn2 } from "../purescript.d.ts";

export const empty: Deno.CommandOptions = {};

export const args: Fn1<string[], Deno.CommandOptions> = (value) => ({
  args: value,
});

export const _cwd: Fn1<string | URL, Deno.CommandOptions> = (value) => ({
  cwd: value,
});

export const clearEnv: Fn1<boolean, Deno.CommandOptions> = (value) => ({
  clearEnv: value,
});

export const env: Fn1<Record<string, string>, Deno.CommandOptions> = (value) => ({
  env: value,
});

export const uid: Fn1<number, Deno.CommandOptions> = (value) => ({
  uid: value,
});

export const gid: Fn1<number, Deno.CommandOptions> = (value) => ({
  gid: value,
});

export const _stdin: Fn1<string, Deno.CommandOptions> = (value) => ({
  stdin: value as "piped" | "inherit" | "null",
});

export const _stdout: Fn1<string, Deno.CommandOptions> = (value) => ({
  stdout: value as "piped" | "inherit" | "null",
});

export const _stderr: Fn1<string, Deno.CommandOptions> = (value) => ({
  stderr: value as "piped" | "inherit" | "null",
});

export const windowsRawArguments: Fn1<boolean, Deno.CommandOptions> = (value) => ({
  windowsRawArguments: value,
});

export const combine: Fn2<
  Deno.CommandOptions,
  Deno.CommandOptions,
  Deno.CommandOptions
> = (a, b) => ({ ...a, ...b });
